fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'oosayeroo'  
description 'sayer-drugdeliveries OPEN SOURCE'
version '2.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
	'client/main.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}