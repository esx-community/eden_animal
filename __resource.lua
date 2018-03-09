resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'eden animal'

version '1.1.0'

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}