fx_version 'cerulean'
game 'gta5'

author 'Ali'
description 'Script pour gérer les scores RP des joueurs'
version '1.0.0'

lua54 'yes'

shared_script '@es_extended/imports.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}


client_scripts {
    'client.lua'
}