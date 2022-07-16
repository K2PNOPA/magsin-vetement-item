ESX = nil
local currentsho, currentactionmenu


shoplunettes = {   
	Base = {},
	Data = {currentMenu = "Action"},
    Events = {
		onSelected = function(self, _, Neo, PMenu, Data, menuData, currentMenu, currentButton, currentBtn, currentSlt, result, slide)
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1) 
			if self.Data.currentMenu == "Action" and Neo.name ~= "Sauvegarder la tenue actuelle ...."  and Neo.name ~= "Publier/liste des tenue" then 
				ESX.TriggerServerCallback('Checkmoney', function(cb)
					if cb then 
						TriggerEvent('skinchanger:getSkin', function(skin)
							save()
							TriggerServerEvent("Neo:insertlunettes", Neo.nom3, Neo.nom, skin[Neo.nom1], skin[Neo.nom2], Neo.nom1, Neo.nom2) 
						end)
					end
				end, Neo.price)
			elseif self.Data.currentMenu == "Publier/liste des tenue" and Neo.name ~= "Publier de votre tenue actuelle" then 
				ESX.TriggerServerCallback('Checkmoney', function(cb)
					if cb then 
						save()
						TriggerServerEvent("Neo:inserttenue", "peelotenue", Neo.name, Neo.skins) 
					end    
				end, Neo.price)
			end 
			if Neo.name == "Sauvegarder la tenue actuelle ...." then 
				ESX.TriggerServerCallback('Checkmoney', function(cb)
					if cb then 
						savetenue()
					end
				end, Neo.price)
			elseif Neo.name == "Publier/liste des tenue" then 
				shoplunettes.Menu["Publier/liste des tenue"].b = {} 
				table.insert(shoplunettes.Menu["Publier/liste des tenue"].b, {name = "Publier de votre tenue actuelle"})
				ESX.TriggerServerCallback('Neo:getalltenues', function(Vetement)
					for k, v in pairs(Vetement) do  
						if v.type == "peelopublic" then 
							table.insert(shoplunettes.Menu["Publier/liste des tenue"].b, {name = v.nom, price = 45, skins = json.decode(v.clothe)})
						end
					end
					OpenMenu('Publier/liste des tenue')
				end)
			elseif Neo.name == "Publier de votre tenue actuelle" then 
				local result = KeyboardInput('Nom', '', 30)
				if result ~= nil then 
					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent("Neo:inserttenue", "peelopublic", ""..result.."", skin) 
						ESX.ShowNotification('Vous avez (~b~Publier~s~) votre tenue [~y~'..result..'~s~] ')
					end)
				end
			end 
		end, 
		onOpened = function()
			setheader(Config.header[currentshop])
			SetEntityInvincible(GetPlayerPed(-1), true) 
			FreezeEntityPosition(GetPlayerPed(-1), true) 	
		end,    
		onExited = function(self, _, btn, PMenu, Data, menuData, currentMenu, currentButton, currentBtn, currentSlt, result, slide)
			SetEntityInvincible(GetPlayerPed(-1), false) 
			FreezeEntityPosition(GetPlayerPed(-1), false) 	
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end,
		onButtonSelected = function(currentMenu, currentBtn, menuData, newButtons, self)
            if currentMenu == "Action" then 
                for k,v in pairs(shoplunettes.Menu["Action"].b) do 
                    if currentBtn - 1 == v.iterator then       
                        TriggerEvent('skinchanger:change',  newButtons.nom1, v.iterator)
                    end 
                end
            end
			if currentMenu == "Publier/liste des tenue" then 
				if newButtons.name == "Publier de votre tenue actuelle" then 
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
				else
				for k,v in pairs(shoplunettes.Menu["Publier/liste des tenue"].b) do 
					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerEvent('skinchanger:loadClothes', skin, { 
								["pants_2"] = newButtons.skins["pants_2"], 
								["pants_1"] = newButtons.skins["pants_1"], 
								["tshirt_2"] = newButtons.skins["tshirt_2"], 
								["tshirt_1"] = newButtons.skins["tshirt_1"], 
								["torso_1"] = newButtons.skins["torso_1"], 
								["torso_2"] = newButtons.skins["torso_2"],
								["shoes_1"] = newButtons.skins["shoes_1"],
								["shoes_2"] = newButtons.skins["shoes_2"]})
						end)
					end
				end
            end
        end,
        onSlide = function(menuData, btn, currentButton, currentSlt, slide, PMenu)
            local currentMenu = menuData.currentMenu
            local slide = btn.slidenum
            if currentMenu == "Action" and btn.name ~= "Sauvegarder la tenue actuelle ...." and btn.name ~= "Publier/liste des tenue" then 
                bags = slide - 1    
                TriggerEvent('skinchanger:change', btn.nom2, bags) 
            end
        end,
	}, 
	Menu = { 
		["Action"] = {
            Arrowsonly = " ",
			b = {}  
		},
		["Publier/liste des tenue"] = {
            Arrowsonly = " ",
			b = {}  
		},
	} 
}   
menuvetement = {   
	Base = {},
	Data = {currentMenu = "Action"},
    Events = {
		onSelected = function(self, _, Neo, PMenu, Data, menuData, currentMenu, currentButton, currentBtn, currentSlt, result, slide)
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			if self.Data.currentMenu == "Action vetement" then 
				if Neo.slidename == "Utiliser" then 
					TriggerEvent('skinchanger:getSkin', function(skin)
						local caca = json.decode(Neo.value)
						local type  = caca[Neo.infoData2] 
						local var = caca[Neo.infoData3]
						if not on then
							save() 
							on = true
							changerdevetemnt(Neo.infoData)
							TriggerEvent('skinchanger:loadClothes', skin, {[Neo.infoData2] = type, [Neo.infoData3] = var})  
						else
							on = false
							changerdevetemnt(Neo.infoData)
							if Neo.decals == nil then
								TriggerEvent('skinchanger:loadClothes', skin, {[Neo.infoData2] = 0, [Neo.infoData3] = 0}) 
							elseif Neo.decals == "Torse" then 
								TriggerEvent('skinchanger:loadClothes', skin, {['torso_1'] = 15, ['torso_2'] = 0, ['arms'] = 15}) 	
							elseif Neo.decals ~= nil and Neo.decals ~= "Torse" then 
								TriggerEvent('skinchanger:loadClothes', skin, {[Neo.infoData2] = Neo.decals, [Neo.infoData3] = 0})  
							end
						end
					end)
				elseif Neo.slidename == "Rénomer" then 
					local result = KeyboardInput('Nom', Neo.name, 20)
					if result ~= nil then 
						TriggerServerEvent('Neo:changenom', Neo.id, result)
						changeprinsmenu()
						ESX.ShowNotification('Vous avez changer le nom [~y~'..Neo.name..'~s~] en [~b~'..result..'~s~]')
					end 
				elseif Neo.slidename == "Effacer" then 
					TriggerServerEvent('Neo:deleteitem', Neo.id)
					changeprinsmenu()
				elseif Neo.slidename == "Donner" then 
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer ~= -1 and closestDistance < 3 then
							TriggerServerEvent('Neo:giveitem', Neo.id, GetPlayerServerId(closestPlayer))
							changeprinsmenu()
						else
							ESX.ShowNotification('~r~Personne a proximté')
						end
				end
			elseif self.Data.currentMenu == "Action" and Neo.ids == 456154 then 
				if Neo.slidename == "Utiliser" then 
					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerEvent('skinchanger:loadClothes', skin, { 
								["pants_2"] = Neo.skins["pants_2"], 
								["pants_1"] = Neo.skins["pants_1"], 
								["tshirt_2"] = Neo.skins["tshirt_2"], 
								["tshirt_1"] = Neo.skins["tshirt_1"], 
								["torso_1"] = Neo.skins["torso_1"], 
								["torso_2"] = Neo.skins["torso_2"],
								["shoes_1"] = Neo.skins["shoes_1"],
								["shoes_2"] = Neo.skins["shoes_2"]})
						end)
					save()
					elseif Neo.slidename == "Rénomer" then 
						local result = KeyboardInput('Nom', Neo.name, 20)
						if result ~= nil then 
							TriggerServerEvent('Neo:changenom', Neo.id, result)
						end 
						changeprinsmenu()
						ESX.ShowNotification('Vous avez changer le nom [~y~'..Neo.name..'~s~] en [~b~'..result..'~s~]')
					elseif Neo.slidename == "Effacer" then 
						TriggerServerEvent('Neo:deleteitem', Neo.id)
						changeprinsmenu()
					elseif Neo.slidename == "Donner" then 
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer ~= -1 and closestDistance < 3 then
							TriggerServerEvent('Neo:giveitem', Neo.id, GetPlayerServerId(closestPlayer))
							CloseMenu(true)
						else
							ESX.ShowNotification('~r~Personne a proximté')
						end
				end
			end 
			if Neo.askX == true and Neo.ids ~= 456154 then 
				menuvetement.Menu["Action vetement"].b = {} 
				ESX.TriggerServerCallback('Neo:getpeelomask', function(Vetement)
					for k, v in pairs(Vetement) do  
						if v.type == Neo.infoData then  
							table.insert(menuvetement.Menu["Action vetement"].b, {name = v.nom, slidemax = {"Utiliser", "Donner", "Rénomer", "Effacer"}, id = v.id, menu = 1, value = v.clothe, infoData = Neo.infoData, infoData2 = Neo.infoData2, infoData3 = Neo.infoData3, decals = Neo.decals})
						end
					end
					OpenMenu('Action vetement')
				end)
			end 
		end, 
		onSlide = function(menuData, Neo, currentButton, currentSlt, slide, PMenu)
            local currentMenu = menuData.currentMenu
            if currentMenu == "Action" and Neo.ids ~= 456154 then 
				if Neo.slidename ~= nil then  
					currentactionmenu = Neo.slidename
					changeprinsmenu()
				end
            end
        end,
	}, 
	Menu = { 
		["Action"] = {
            Arrowsonly = " ",
			b = {} 
		},
		["Action vetement"] = {
            Arrowsonly = " ",
			b = {} 
		}
	} 
}   


function changeprinsmenu()
	CloseMenu(true)
	menuvetement.Menu["Action"].b = {} 
	if currentactionmenu == "Tenue" then 
		table.insert(menuvetement.Menu["Action"].b, {name = "Selection", slidemax = {"Tenue", "Vetement", "Accessoire"}})
		ESX.TriggerServerCallback('Neo:getpeelomask', function(Vetement)
			for k, v in pairs(Vetement) do  
				if v.type == "peelotenue" then 
					table.insert(menuvetement.Menu["Action"].b, {name = v.nom, skins = json.decode(v.clothe), ids = 456154, slidemax = {"Utiliser", "Donner", "Rénomer", "Effacer"}, askX = true, id = v.id})
				end 
			end 
			CreateMenu(menuvetement)
		end)
	elseif currentactionmenu == "Vetement" then 
		table.insert(menuvetement.Menu["Action"].b, {name = "Selection", slidemax = {"Vetement", "Accessoire", "Tenue"}})
		table.insert(menuvetement.Menu["Action"].b, {name = "Torse", ask = "→", askX = true, infoData = "peelotorse", infoData2 = "torso_1", infoData3 = "torso_2", decals = "Torse"})
		table.insert(menuvetement.Menu["Action"].b, {name = "T-shirt", ask = "→", askX = true, infoData = "peelotshirt", infoData2 = "tshirt_1", infoData3 = "tshirt_2", decals = 15})
		table.insert(menuvetement.Menu["Action"].b, {name = "Pantalon", ask = "→", askX = true, infoData = "peelopantalon", infoData2 = "pants_1", infoData3 = "pants_2", decals = 14})
		table.insert(menuvetement.Menu["Action"].b, {name = "Chaussures", ask = "→", askX = true, infoData = "peelochaussures", infoData2 = "shoes_1", infoData3 = "shoes_2", decals = 34})
	elseif currentactionmenu == "Accessoire" then
		table.insert(menuvetement.Menu["Action"].b, {name = "Selection", slidemax = {"Accessoire", "Tenue", "Vetement"}})
		table.insert(menuvetement.Menu["Action"].b, {name = "Chaines", ask = "→", askX = true, infoData = "peelochaine", infoData2 = "chain_1", infoData3 = "chain_2"})
		table.insert(menuvetement.Menu["Action"].b, {name = "Calques", ask = "→", askX = true, infoData = "peeloCalques", infoData2 = "decals_1", infoData3 = "decals_2"})
		table.insert(menuvetement.Menu["Action"].b, {name = "Masque", ask = "→", askX = true, infoData = "peelomasque", infoData2 = "mask_1", infoData3 = "mask_2"})
		table.insert(menuvetement.Menu["Action"].b, {name = "Sac", ask = "→", askX = true, infoData = "peelosac", infoData2 = "bags_1", infoData3 = "bags_2"})
		table.insert(menuvetement.Menu["Action"].b, {name = "Chapeau", ask = "→", askX = true, infoData = "peelochapeau", infoData2 = "helmet_1", infoData3 = "helmet_2", decals = 11})
		table.insert(menuvetement.Menu["Action"].b, {name = "Lunettes", ask = "→", askX = true, infoData = "peelolunettes", infoData2 = "glasses_1", infoData3 = "glasses_2"})
		table.insert(menuvetement.Menu["Action"].b, {name = "Gants", ask = "→", askX = true, infoData = "peelogant", infoData2 = "arms", infoData3 = "arms_2", decals = 15})
	end
	if currentactionmenu ~= "Tenue" then 
	CreateMenu(menuvetement)
	end
end 

RegisterCommand('vtm', function() 
	currentactionmenu = "Tenue"
	changeprinsmenu()
	setheader("Menu vetement")
end)



function changerdevetemnt(info)
	if info == "peelosac" then 
		ESX.Streaming.RequestAnimDict("anim@heists@ornate_bank@grab_cash", function()
			TaskPlayAnim(PlayerPedId(), 'anim@heists@ornate_bank@grab_cash', 'intro', 8.0, -8, 1200, 49, 0, 0, 0, 0)
		end)
		Citizen.Wait(800)
	elseif info == "peelomasque" or info == "peelochapeau" then 
		ESX.Streaming.RequestAnimDict("mp_masks@standard_car@ds@", function()
			TaskPlayAnim(PlayerPedId(), "mp_masks@standard_car@ds@", "put_on_mask", 8.0, 1.0, 500, 49, 0, 0, 0, 0 )
		end)
		Citizen.Wait(800)
	elseif info == "peelopantalon" or info == "peelochaussures" then 
		local lib, anim = 'clothingshoes', 'try_shoes_positive_a'
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8, 1200, 49, 0, 0, 0, 0)
		end)
		Citizen.Wait(1000)
		ClearPedTasks(PlayerPedId())
	elseif info == "peelolunettes" then 
		local lib, anim = 'clothingspecs', 'try_glasses_positive_a'
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8, 1200, 49, 0, 0, 0, 0)
		end)
		Citizen.Wait(1000)
		ClearPedTasks(PlayerPedId())
	elseif info == "peeloCalques" then 
		local lib, anim = 'clothingspecs', 'try_glasses_positive_a'
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8, 1200, 49, 0, 0, 0, 0)
		end)
		Citizen.Wait(1000)
		ClearPedTasks(PlayerPedId())
	elseif info == "peelochaine" then 
		local lib, anim = 'clothingspecs', 'try_glasses_positive_a'
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8, 1200, 49, 0, 0, 0, 0)
		end)
		Citizen.Wait(1000)
		ClearPedTasks(PlayerPedId())
	elseif info == "peelochapeau" then 
		local lib, anim = 'missfbi4', 'takeoff_mask'
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8, 1200, 49, 0, 0, 0, 0)
		end)
		Citizen.Wait(850)
		ClearPedTasks(PlayerPedId())
	end
end

function save()
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('esx_skin:save', skin)
	end)
end


function savetenue()
	TriggerEvent('skinchanger:getSkin', function(skin)
		local math = math.random(1, 9200)
		TriggerServerEvent("Neo:inserttenue", "peelotenue", "Tenue N°"..math.."", skin) 
		ESX.ShowNotification('Vous avez acheter/(~b~engeristrer~s~) votre tenue [~y~'..math..'~s~] ')
	end)
end


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end    
    while true do 
       time = 500
	   posplayer = GetEntityCoords(GetPlayerPed(-1), false)
        for k, v in pairs(Config.shops) do
            if (GetDistanceBetweenCoords(posplayer, v.pos, true) < 1.2) then
				currentshop = Config.shops[k].shop
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_TALK~ pour accéder au ~b~magasin de "..currentshop.."~w~.")
				if IsControlJustPressed(1,51) then 	
					save()
					shoplunettes.Menu["Action"].b = {} 
					if currentshop ~= "Main" then 
						TriggerEvent('skinchanger:getData', function(components, maxVals)
							for i=0, maxVals[Config.info[currentshop].nom1], 1 do  
								if Config.info[currentshop].slidemax == "Texture" then 
									table.insert(shoplunettes.Menu["Action"].b, {name = ""..currentshop.." N°" .. i , price = Config.price[currentshop] , slidemax = GetNumberOfPedTextureVariations(PlayerPedId(),  Config.info[currentshop].var, i) - 1, iterator = i, nom = ""..currentshop.." "..i.."", nom1 = Config.info[currentshop].nom1, nom2 = Config.info[currentshop].nom2, nom3 = Config.info[currentshop].nom3 })
								elseif Config.info[currentshop].slidemax == "Prop" then 
									table.insert(shoplunettes.Menu["Action"].b, {name = ""..currentshop.." N°" .. i , price = Config.price[currentshop] , slidemax = GetNumberOfPedPropTextureVariations(PlayerPedId(),  Config.info[currentshop].var, i) - 1, iterator = i, nom = ""..currentshop.." "..i.."", nom1 = Config.info[currentshop].nom1, nom2 = Config.info[currentshop].nom2, nom3 = Config.info[currentshop].nom3 })
								elseif Config.info[currentshop].slidemax ~= "Prop" or onfig.info[currentshop].slidemax ~= "Texture" then
									table.insert(shoplunettes.Menu["Action"].b, {name = ""..currentshop.." N°" .. i , price = Config.price[currentshop] , slidemax = Config.info[currentshop].slidemax, iterator = i, nom = ""..currentshop.." "..i.."", nom1 = Config.info[currentshop].nom1, nom2 = Config.info[currentshop].nom2, nom3 = Config.info[currentshop].nom3 })
								end 
							end 
						end)	
					else
						table.insert(shoplunettes.Menu["Action"].b, {name = "Sauvegarder la tenue actuelle ....", price = 45, askX = true})
						table.insert(shoplunettes.Menu["Action"].b, {name = "Publier/liste des tenue", ask = "→", askX = true})
					end
					CreateMenu(shoplunettes)
				end
            end
			if (GetDistanceBetweenCoords(posplayer, v.pos, true) < 20) then
				time = 1
				if v.color == nil then 
					DrawMarker(6, v.pos, 0.0, 0.0, 180.0, 0.0,0.0,0.0, 0.9, 0.9, 0.9, 93, 173, 226, 120, false, false, false, false) 
				else
					DrawMarker(6, v.pos, 0.0, 0.0, 180.0, 0.0,0.0,0.0, 0.9, 0.9, 0.9, v.color.r, v.color.g, v.color.b, 120, false, false, false, false) 
				end
			end
        end  
		Wait(time)
    end
end)

