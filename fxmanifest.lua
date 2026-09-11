fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'cLo_oDy'
description 'Nopixel V Achievement System'
version '1.0.0'

ui_page 'html/index.html'

shared_script 'config.lua'

client_script 'client.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/assets/*'
}

dependency 'oxmysql'

escrow_ignore {
    'config.lua'
}
