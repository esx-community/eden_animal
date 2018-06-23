local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- internal variables
ESX = nil
local GUI  = {}
GUI.Time = 0
local ped = {}
local model = {}
local status = 100
local objCoords = nil
local balle = false
local object = {}
local inanimation = false
local come = 0
local isAttached = false
local animation = {}
local getball = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	DoRequestModel(-1788665315) -- chien
	DoRequestModel(1462895032) -- chat
	DoRequestModel(1682622302) -- loup
	DoRequestModel(-541762431) -- lapin
	DoRequestModel(1318032802) -- husky
	DoRequestModel(-1323586730) -- cochon
	DoRequestModel(1125994524) -- caniche
	DoRequestModel(1832265812) -- carlin
	DoRequestModel(882848737) -- retriever
	DoRequestModel(1126154828) -- berger
	DoRequestModel(-1384627013) -- westie
end)

function OpenPetMenu()
	local elements = {}
	if come == 1 then
		table.insert(elements, {label = _U('hunger') .. status .. '%', value = nil})
		table.insert(elements, {label = _U('givefood'), value = 'graille'})
		table.insert(elements, {label = _U('attachpet'), value = 'attached_animal'})
		if isInVehicle then
			table.insert(elements, {label = _U('getpeddown'), value = 'vehicules'})
		else
			table.insert(elements, {label = _U('getpedinside'), value = 'vehicules'})
		end
		table.insert(elements, {label = _U('giveorders'), value = 'give_orders'})
	else
		table.insert(elements, {label = _U('callpet'), value = 'come_animal'})
	end
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pet_menu',
	{
		title    = _U('pet_management'),
		align    = 'bottom-right',
		elements = elements,
	}, function(data, menu)
		if data.current.value == 'come_animal' and come == 0 then
			ESX.TriggerServerCallback('eden_animal:getPet', function(animalName)
				if animalName == "chien" then
					model = -1788665315
					come = 1
					openchien()
				elseif animalName == "chat" then
					model = 1462895032
					come = 1
					openchien()
				elseif animalName == "loup" then
					model = 1682622302
					come = 1
					openchien()
				elseif animalName == "lapin" then
					model = -541762431
					come = 1
					openchien()
				elseif animalName == "husky" then
					model = 1318032802
					come = 1
					openchien()
				elseif animalName == "cochon" then
					model = -1323586730
					come = 1
					openchien()
				elseif animalName == "caniche" then
					model = 1125994524
					come = 1
					openchien()
				elseif animalName == "carlin" then
					model = 1832265812
					come = 1
					openchien()
				elseif animalName == "retriever" then
					model = 882848737
					come = 1
					openchien()
				elseif animalName == "berger" then
					model = 1126154828
					come = 1
					openchien()
				elseif animalName == "westie" then
					model = -1384627013
					come = 1
					openchien()
				else
					print('eden_animal: unknown pet ' .. animalName)
				end
			end)
			menu.close()
		elseif data.current.value == 'attached_animal' then
			if not IsPedSittingInAnyVehicle(ped) then
				if isAttached == false then
					attached()
					isAttached = true
				else
					detached()
					isAttached = false
				end
				else
				ESX.ShowNotification(_U('dontattachhiminacar'))
			end
		elseif data.current.value == 'give_orders' then
			GivePetOrders()
		elseif data.current.value == 'graille' then
			local inventory = ESX.GetPlayerData().inventory
			local coords1   = GetEntityCoords(GetPlayerPed(-1))
			local coords2   = GetEntityCoords(ped)
			local distance  = GetDistanceBetweenCoords(coords1.x,coords1.y,coords1.z,coords2.x,coords2.y,coords2.z,true)

			local count = 0
			for i=1, #inventory, 1 do
				if inventory[i].name == 'croquettes' then
					count = inventory[i].count
				end
			end
			if distance < 5 then
				if count >= 1 then
					if status < 100 then
						status = status + math.random(2, 15)
						ESX.ShowNotification(_U('gavepetfood'))
						TriggerServerEvent('eden_animal:consumePetFood')
						if status > 100 then
							status = 100
						end
						menu.close()
					else
						ESX.ShowNotification(_U('nomorehunger'))
					end
				else
					ESX.ShowNotification(_U('donthavefood'))
				end
			else
				ESX.ShowNotification(_U('hestoofar'))
			end
		elseif data.current.value == 'vehicules' then
			local coords   = GetEntityCoords(GetPlayerPed(-1))
			local vehicle  = GetVehiclePedIsUsing(GetPlayerPed(-1))
			local coords2  = GetEntityCoords(ped)
			local distance = GetDistanceBetweenCoords(coords.x,coords.y,coords.z,coords2.x,coords2.y,coords2.z,true)
			if not isInVehicle then
				if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
					if distance < 8 then
						attached()
						Citizen.Wait(200)
						if IsVehicleSeatFree(vehicle, 1) then
							SetPedIntoVehicle(ped, vehicle, 1)
							isInVehicle = true
						elseif IsVehicleSeatFree(vehicle, 2) then
							isInVehicle = true
							SetPedIntoVehicle(ped, vehicle, 2)
						elseif IsVehicleSeatFree(vehicle, 0) then
							isInVehicle = true
							SetPedIntoVehicle(ped, vehicle, 0)
						end

						menu.close()
					else
						ESX.ShowNotification(_U('toofarfromcar'))
					end

				else
					ESX.ShowNotification(_U('youneedtobeincar'))
				end
			else
				if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
					SetEntityCoords(ped,coords.x, coords.y, coords.z,1,0,0,1)
					Citizen.Wait(100)
					detached()
					isInVehicle = false
					menu.close()
				else
					ESX.ShowNotification(_U('yourstillinacar'))
				end
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function GivePetOrders()
	ESX.TriggerServerCallback('eden_animal:getPet', function(pet)
		local elements = {}
		if not inanimation then
			if pet ~= "chat" then
				table.insert(elements, {label = _U('balle'), value = 'balle'})
			end

			table.insert(elements, {label = _U('pied'), value = 'pied'})
			table.insert(elements, {label = _U('doghouse'), value = 'niche'})

			if pet == "chien" then
				table.insert(elements, {label = _U('sitdown'), value = 'assis'})
				table.insert(elements, {label = _U('getdown'), value = 'coucher'})
			elseif pet == "chat" then
				table.insert(elements, {label = _U('getdown'), value = 'coucher2'})
			elseif pet == "loup" then
				table.insert(elements, {label = _U('getdown'), value = 'coucher3'})
			elseif pet == "carlin" then
				table.insert(elements, {label = _U('sitdown'), value = 'assis2'})
			elseif pet == "retriever" then
				table.insert(elements, {label = _U('sitdown'), value = 'assis3'})
			end
		else
			table.insert(elements, {label = _U('getup'), value = 'debout'})
		end
		

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give_orders',
		{
			title    = _U('pet_orders'),
			align    = 'bottom-right',
			elements = elements,
		}, function(data, menu)
			if data.current.value == 'niche' then
				local GroupHandle = GetPlayerGroup(PlayerId())
				local coords      = GetEntityCoords(GetPlayerPed(-1))
				SetGroupSeparationRange(GroupHandle, 1.9)
				SetPedNeverLeavesGroup(ped, false)
				TaskGoToCoordAnyMeans(ped, coords.x+40, coords.y, coords.z, 5.0, 0, 0, 786603, 0xbf800000)
				Citizen.Wait(5000)
				DeleteEntity(ped)
				come = 0
				menu.close()
			elseif data.current.value == 'pied' then
				local coords1 = GetEntityCoords(GetPlayerPed(-1))
				TaskGoToCoordAnyMeans(ped, coords1.x, coords1.y, coords1.z, 5.0, 0, 0, 786603, 0xbf800000)
				menu.close()
			elseif data.current.value == 'balle' then
				object = GetClosestObjectOfType(GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z, 190.0, GetHashKey('w_am_baseball'))
				if DoesEntityExist(object) then
					balle = true
					objCoords = GetEntityCoords(object)
					TaskGoToCoordAnyMeans(ped, objCoords.x, objCoords.y, objCoords.z, 5.0, 0, 0, 786603, 0xbf800000)
					local GroupHandle = GetPlayerGroup(PlayerId())
					SetGroupSeparationRange(GroupHandle, 1.9)
					SetPedNeverLeavesGroup(ped, false)
					menu.close()
				else
					ESX.ShowNotification(_U('noball'))
				end
			elseif data.current.value == 'assis' then -- [chien ]
				DoRequestAnimSet('creatures@rottweiler@amb@world_dog_sitting@base')
				TaskPlayAnim(ped, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base' ,8.0, -8, -1, 1, 0, false, false, false)
				inanimation = true
				menu.close()
			elseif data.current.value == 'coucher' then -- [chien ]
				DoRequestAnimSet('creatures@rottweiler@amb@sleep_in_kennel@')
				TaskPlayAnim(ped, 'creatures@rottweiler@amb@sleep_in_kennel@', 'sleep_in_kennel' ,8.0, -8, -1, 1, 0, false, false, false)
				inanimation = true
				menu.close()
			elseif data.current.value == 'coucher2' then -- [chat ]
				DoRequestAnimSet('creatures@cat@amb@world_cat_sleeping_ground@idle_a')
				TaskPlayAnim(ped, 'creatures@cat@amb@world_cat_sleeping_ground@idle_a', 'idle_a' ,8.0, -8, -1, 1, 0, false, false, false)
				inanimation = true
				menu.close()
			elseif data.current.value == 'coucher3' then -- [loup ]
				DoRequestAnimSet('creatures@coyote@amb@world_coyote_rest@idle_a')
				TaskPlayAnim(ped, 'creatures@coyote@amb@world_coyote_rest@idle_a', 'idle_a' ,8.0, -8, -1, 1, 0, false, false, false)
				inanimation = true
				menu.close()
			elseif data.current.value == 'assis2' then -- [carlin ]
				DoRequestAnimSet('creatures@carlin@amb@world_dog_sitting@idle_a')
				TaskPlayAnim(ped, 'creatures@carlin@amb@world_dog_sitting@idle_a', 'idle_b' ,8.0, -8, -1, 1, 0, false, false, false)
				inanimation = true
				menu.close()
			elseif data.current.value == 'assis3' then -- [retriever ]
				DoRequestAnimSet('creatures@retriever@amb@world_dog_sitting@idle_a')
				TaskPlayAnim(ped, 'creatures@retriever@amb@world_dog_sitting@idle_a', 'idle_c' ,8.0, -8, -1, 1, 0, false, false, false)
				inanimation = true
				menu.close()
			elseif data.current.value == 'debout' then
				ClearPedTasks(ped)
				inanimation = false
				menu.close()
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30)
		if balle then
			local coords1 = GetEntityCoords(GetPlayerPed(-1))
			local coords2 = GetEntityCoords(ped)
			local distance  = GetDistanceBetweenCoords(objCoords.x, objCoords.y, objCoords.z,coords2.x,coords2.y,coords2.z,true)
			local distance2 = GetDistanceBetweenCoords(coords1.x,coords1.y,coords1.z,coords2.x,coords2.y,coords2.z,true)

			if distance < 0.5 then
				AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 17188), 0.120, 0.010, 0.010, 5.0, 150.0, 0.0, true, true, false, true, 1, true)
				TaskGoToCoordAnyMeans(ped, coords1.x, coords1.y, coords1.z, 5.0, 0, 0, 786603, 0xbf800000)
				balle = false
				getball = true
			end
		end

		if getball then
			local coords1 = GetEntityCoords(GetPlayerPed(-1))
			local coords2 = GetEntityCoords(ped)
			local distance2 = GetDistanceBetweenCoords(coords1.x,coords1.y,coords1.z,coords2.x,coords2.y,coords2.z,true)

			if distance2 < 1.5 then
				DetachEntity(object,false,false)
				Citizen.Wait(50)
				SetEntityAsMissionEntity(object)
				DeleteEntity(object)
				GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BALL"), 1, false, true)
				local GroupHandle = GetPlayerGroup(PlayerId())
				SetGroupSeparationRange(GroupHandle, 999999.9)
				SetPedNeverLeavesGroup(ped, true)
				SetPedAsGroupMember(ped, GroupHandle)
				getball = false
			end
		end
	end
end)

function attached()
	local playerPed = GetPlayerPed(-1)
	local GroupHandle = GetPlayerGroup(PlayerId())
	SetGroupSeparationRange(GroupHandle, 1.9)
	SetPedNeverLeavesGroup(ped, false)
	FreezeEntityPosition(ped, true)
end

function detached()
	local playerPed = GetPlayerPed(-1)
	local GroupHandle = GetPlayerGroup(PlayerId())
	SetGroupSeparationRange(GroupHandle, 999999.9)
	SetPedNeverLeavesGroup(ped, true)
	SetPedAsGroupMember(ped, GroupHandle)
	FreezeEntityPosition(ped, false)
end

function openchien()
	local playerPed = GetPlayerPed(-1)
	local LastPosition = GetEntityCoords(GetPlayerPed(-1))
	local GroupHandle = GetPlayerGroup(PlayerId())

	DoRequestAnimSet('rcmnigel1c')

	TaskPlayAnim(GetPlayerPed(-1), 'rcmnigel1c', 'hailing_whistle_waive_a' ,8.0, -8, -1, 120, 0, false, false, false)
	Citizen.SetTimeout(5000, function()
		ped = CreatePed(28, model, LastPosition.x +1, LastPosition.y +1, LastPosition.z -1, 1, 1)
		SetPedAsGroupLeader(playerPed, GroupHandle)
		SetPedAsGroupMember(ped, GroupHandle)
		SetPedNeverLeavesGroup(ped, true)
		SetPedCanBeTargetted(ped, false)
		SetEntityAsMissionEntity(ped, true,true)
		status = math.random(40, 90)
		Citizen.Wait(5)
		attached()
		Citizen.Wait(5)
		detached()
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(math.random(60000, 120000))
		if come == 1 then
			status = status - 1
		end
		if status == 0 then
			TriggerServerEvent('eden_animal:petDied')
			DeleteEntity(ped)
			ESX.ShowNotification(_U('pet_dead'))
			come = 3
			status = "die"
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsControlJustPressed(0, Keys['F9']) and GetLastInputMethod(2) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'pet_menu') then
			OpenPetMenu()
		end
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.PetShop.Pos.x, Config.Zones.PetShop.Pos.y, Config.Zones.PetShop.Pos.z)

	SetBlipSprite (blip, Config.Zones.PetShop.Sprite)
	SetBlipDisplay(blip, Config.Zones.PetShop.Display)
	SetBlipScale  (blip, Config.Zones.PetShop.Scale)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('pet_shop'))
	EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coord = GetEntityCoords(GetPlayerPed(-1), true)
		if GetDistanceBetweenCoords(coord, Config.Zones.PetShop.Pos.x, Config.Zones.PetShop.Pos.y, Config.Zones.PetShop.Pos.z, false) < 5 then
			DisplayHelpText(_U('enterkey'))
			if IsControlJustPressed(0, Keys['E']) then
				OpenPetShop()
			end
		end
	end
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function OpenPetShop()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'pet_shop',
	{
		title    = _U('pet_shop'),
		align 	 = 'bottom-right',
		elements = {
			{label = _U('dog') .. ' - <span style="color:green;">$50000</span>', value = "chien", price = 50000},
			{label = _U('cat') .. ' - <span style="color:green;">$15000</span>', value = "chat", price = 15000},
			{label = _U('bunny') .. ' - <span style="color:green;">$25000</span>', value = "lapin",	price = 25000},
			{label = _U('husky') .. ' - <span style="color:green;">$35000</span>', value = "husky", price = 35000},
			{label = _U('pig') .. ' - <span style="color:green;">$10000</span>', value = "cochon", price = 10000},
			{label = _U('poodle') .. ' - <span style="color:green;">$50000</span>', value = "caniche", price = 50000},
			{label = _U('pug') .. ' - <span style="color:green;">$10000</span>', value = "carlin", price = 5000},
			{label = _U('retriever') .. ' - <span style="color:green;">$10000</span>', value = "retriever", price = 10000},
			{label = _U('asatian') .. ' - <span style="color:green;">$55000</span>', value = "berger", price = 55000},
			{label = _U('westie') .. ' - <span style="color:green;">$50000</span>', value = "westie", price = 50000}
		}
	}, function(data, menu)
		ESX.TriggerServerCallback('eden_animal:buyPet', function(boughtPed)
			if boughtPed then
				menu.close()
			end
		end, data.current.value, data.current.price)
	end, function(data, menu)
		menu.close()
	end)
end

function DoRequestModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end
end

function DoRequestAnimSet(anim)
	RequestAnimDict(anim)
	while not HasAnimDictLoaded(anim) do
		Citizen.Wait(1)
	end
end