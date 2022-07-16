
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('Neo:insertlunettes')
AddEventHandler('Neo:insertlunettes', function(type, name, lunettes,variation, Nom1, Nom2)
  local ident = GetPlayerIdentifier(source)
  maskx = {[Nom1]=tonumber(lunettes),[Nom2]=tonumber(variation)} 
	MySQL.Async.execute('INSERT INTO neo_clothe (identifier, type, nom, clothe) VALUES (@identifier, @type, @nom, @clothe)',
	{ 
	['@identifier']   = ident,
    ['@type']   = type,
    ['@nom']   = name,
    ['@clothe'] = json.encode(maskx)
	}, function(rowsChanged) 
	end)
end) 

RegisterServerEvent('Neo:inserttenue')
AddEventHandler('Neo:inserttenue', function(type, name, clothe)
  local ident = GetPlayerIdentifier(source)
	MySQL.Async.execute('INSERT INTO neo_clothe (identifier, type, nom, clothe) VALUES (@identifier, @type, @nom, @clothe)',
	{ 
	['@identifier']   = ident,
    ['@type']   = type,
    ['@nom']   = name,
    ['@clothe'] = json.encode(clothe)
	}, function(rowsChanged) 
	end)
end) 

RegisterServerEvent('Neo:changenom')
AddEventHandler('Neo:changenom', function(id, Actif)   
	MySQL.Sync.execute('UPDATE neo_clothe SET nom = @nom WHERE id = @id', {
		['@id'] = id,   
		['@nom'] = Actif        
	})
end) 

RegisterServerEvent('Neo:deleteitem')
AddEventHandler('Neo:deleteitem', function(supprimer)
    MySQL.Async.execute('DELETE FROM neo_clothe WHERE id = @id', { 
            ['@id'] = supprimer 
    }) 
end)

ESX.RegisterServerCallback('Checkmoney', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= price then
		cb(true)
		xPlayer.removeMoney(tonumber(price))
		TriggerClientEvent('esx:showNotification', source, "~g~Vous avez effectuer un payement de ~s~(~b~~h~$"..tonumber(price).."~h~~s~)")  
	else 
		TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez d'argent.")  
		cb(false)
	end
end)


RegisterServerEvent('Neo:giveitem')
AddEventHandler('Neo:giveitem', function(id, target)   
	local xaplayertarget = GetPlayerIdentifier(target)
	MySQL.Sync.execute('UPDATE neo_clothe SET identifier = @identifier WHERE id = @id', {
		['@id'] = id, 
		['@identifier'] = xaplayertarget        
	})
end) 

 
ESX.RegisterServerCallback('Neo:getalltenues', function(source, cb)
	MySQL.Async.fetchAll('SELECT id, clothe, nom, type FROM neo_clothe', {}, function(result)
		cb(result)
	end)
end) 

ESX.RegisterServerCallback('Neo:getpeelomask', function(source, cb)
	local identifier = GetPlayerIdentifier(source)
	local masque = {}
	MySQL.Async.fetchAll('SELECT * FROM neo_clothe WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result) 
		for i = 1, #result, 1 do  
			table.insert(masque, {      
                type      = result[i].type,  
				clothe      = result[i].clothe,
				id      = result[i].id,
				nom      = result[i].nom,

			})
		end  
		cb(masque) 
	end)  
end)    
