fx_version 'cerulean'
game 'gta5'

author 'Ali'
description 'RP score system'
version '1.1.0'

lua54 'yes'

shared_script '@es_extended/imports.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

client_script 'client.lua'
