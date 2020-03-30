fx_version 'bodacious'
games { 'gta5' }


client_scripts {
    
    "client.lua"
}

shared_scripts {
    "config.lua"
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "server.lua"
    
}
