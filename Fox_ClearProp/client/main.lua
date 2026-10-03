local towelObject = nil
local isUsing = false
local useEvent = 'Fox_ClearProp:client:use'

local function debugPrint(message)
    if Config.Debug then
        print(('[%s] %s'):format(GetCurrentResourceName(), message))
    end
end

local function loadAnimDict(animDict)
    if not DoesAnimDictExist(animDict) then
        debugPrint(('Animation dictionary not found: %s'):format(animDict))
        return false
    end

    RequestAnimDict(animDict)

    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(animDict) do
        if GetGameTimer() > timeout then
            debugPrint(('Timed out loading animation dictionary: %s'):format(animDict))
            return false
        end
        Wait(0)
    end

    return true
end

local function loadModel(modelHash)
    if not IsModelValid(modelHash) then
        debugPrint(('Invalid prop model hash: %s'):format(modelHash))
        return false
    end

    RequestModel(modelHash)

    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(modelHash) do
        if GetGameTimer() > timeout then
            debugPrint(('Timed out loading prop model: %s'):format(modelHash))
            return false
        end
        Wait(0)
    end

    return true
end

local function deleteTowel()
    if towelObject and DoesEntityExist(towelObject) then
        DetachEntity(towelObject, true, true)
        SetEntityAsMissionEntity(towelObject, true, true)
        DeleteObject(towelObject)

        if DoesEntityExist(towelObject) then
            DeleteEntity(towelObject)
        end
    end

    towelObject = nil
end

local function washPlayer(playerPed)
    Citizen.InvokeNative(0x6585D955A68452A5, playerPed)
    Citizen.InvokeNative(0x523C79AEEFCC4A2A, playerPed, 10, 'ALL')
    Citizen.InvokeNative(0x8FE22675A5A45817, playerPed)
    Citizen.InvokeNative(0xE3144B932DFDFF65, playerPed, 0.0, -1, 1, 1)
end

local function putPropInHand(playerPed)
    local modelHash = GetHashKey(Config.Prop.model)
    if not loadModel(modelHash) then
        return false
    end

    local coords = GetEntityCoords(playerPed)
    towelObject = CreateObject(modelHash, coords.x, coords.y, coords.z, true, true, true)

    SetModelAsNoLongerNeeded(modelHash)

    if not towelObject or towelObject == 0 or not DoesEntityExist(towelObject) then
        towelObject = nil
        return false
    end

    SetEntityAsMissionEntity(towelObject, true, true)

    AttachEntityToEntity(
        towelObject,
        playerPed,
        Config.Prop.bone,
        Config.Prop.offset.x,
        Config.Prop.offset.y,
        Config.Prop.offset.z,
        Config.Prop.rotation.x,
        Config.Prop.rotation.y,
        Config.Prop.rotation.z,
        false,
        false,
        true,
        false,
        0,
        true,
        false,
        false
    )

    return true
end

local function useTowel()
    if isUsing then
        return
    end

    isUsing = true

    local playerPed = PlayerPedId()
    if IsEntityDead(playerPed) then
        isUsing = false
        return
    end

    deleteTowel()

    if not putPropInHand(playerPed) then
        isUsing = false
        return
    end

    if not loadAnimDict(Config.Animation.dict) then
        deleteTowel()
        isUsing = false
        return
    end

    TaskPlayAnim(
        playerPed,
        Config.Animation.dict,
        Config.Animation.name,
        Config.Animation.blendIn,
        Config.Animation.blendOut,
        Config.Animation.duration,
        Config.Animation.flag,
        0.0,
        false,
        false,
        false
    )

    while IsEntityPlayingAnim(playerPed, Config.Animation.dict, Config.Animation.name, 3) do
        Wait(50)
    end

    Wait(Config.Timing.washDelay)

    washPlayer(playerPed)
    ClearPedTasksImmediately(playerPed)

    Wait(Config.Timing.cleanupDelay)

    deleteTowel()
    RemoveAnimDict(Config.Animation.dict)
    isUsing = false
end

RegisterNetEvent(useEvent, function()
    CreateThread(useTowel)
end)


if Config.Command.enabled and Config.Command.name ~= '' then
    RegisterCommand(Config.Command.name, function()
        CreateThread(useTowel)
    end, false)
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    isUsing = false
    ClearPedTasks(PlayerPedId())
    deleteTowel()
end)
