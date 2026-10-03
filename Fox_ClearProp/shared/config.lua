Config = {}

-- auto = detecta VORP/RSG automaticamente.
-- Também aceita: 'vorp', 'rsg' ou 'standalone'.
Config.Framework = 'auto'

Config.Command = {
    enabled = true,
    name = 'toalha'
}

Config.Item = {
    enabled = true,
    name = 'toalha',
    consume = false,
    closeInventory = true,

    -- No RSG o item pode ser adicionado ao Shared.Items automaticamente.
    rsg = {
        label = 'Toalha',
        weight = 100,
        image = 'toalha.png',
        unique = false,
        shouldClose = true,
        description = 'Uma toalha para limpar o personagem.'
    }
}

Config.Prop = {
    model = 's_balledragcloth01x',
    bone = 231,
    offset = { x = 0.0, y = 0.0, z = 0.0 },
    rotation = { x = 0.0, y = 0.0, z = 0.0 }
}

Config.Animation = {
    dict = 'amb_misc@world_human_wash_wading@wash_off@female_b@wip_base',
    name = 'wip_base',
    blendIn = 8.0,
    blendOut = -8.0,
    duration = -1,
    flag = 0
}

Config.Timing = {
    washDelay = 2500,
    cleanupDelay = 1000
}

Config.Debug = false
