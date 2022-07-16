fx_version 'adamant'
games { 'gta5' };

server_script 	'@mysql-async/lib/MySQL.lua' 


client_script "after/cl_general.lua"   
client_script "after/cl_pmenu.lua"     
client_script "config.lua"
client_script "after/crypter/c.lua"

server_script "after/sv_general.lua"     
server_script "config.lua" 
   




