fx_version 'adamant'
lua54 'yes'

games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name "Fox_ClearProp"
description "Fox_ClearProp - limpa a sujeira do personagem usando uma toalha com animação"
author "SR.IGAMER TV | FOX"
version "1.0.0"

shared_scripts {
    'shared/*.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua'
}
