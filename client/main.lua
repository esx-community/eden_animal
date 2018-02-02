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
 
ESX                             = nil
local PlayerData                = {}
local GUI                       = {}
GUI.Time                        = 0
 
local ped = {}
local model         = {}
local status  = 100
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)
 
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)
 
local ordre = false
local come = 0
local isAttached = false
local animation = {}
 
function OpenAnimal()
 
    local elements = {
           
           
        }
 
        if come == 1 then
            table.insert(elements, {label = _U('hunger') .. status .. '%', value = nil})
            table.insert(elements, {label = _U('givefood'), value = 'graille'})
            table.insert(elements, {label = _U('attachpet'), value = 'attached_animal'})
            if isInVehicle then
            table.insert(elements, {label = _U('getpeddown'), value = 'vehicules'})
            else
            table.insert(elements, {label = _U('getpedinside'), value = 'vehicules'})
            end
           
               if ordre then
				table.insert(elements, {label = _U('giveorders'), value = 'ordres'})
				end
			table.insert(elements, {label = _U('doghouse'), value = 'niche'})

 
        else
            table.insert(elements, {label = _U('callpet'), value = 'come_animal'})
        end
 
       
    ESX.UI.Menu.CloseAll()
 
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'eden_animal',
        {
            title    = _U('pet_management'),
            align    = 'top-left',
            elements = elements,
           
        },
       
        function(data, menu)
 
            if data.current.value == 'come_animal' and come == 0 then
 
                ESX.TriggerServerCallback('eden_animal:animalname', function(data)
                    if (data == "chien") then
                    	model = -1788665315
						come = 1
						ordre = true
                  		openchien()
                    elseif (data == "chat") then
	                    model = 1462895032
	                    come = 1
						ordre = true
	                    openchien()
                    elseif (data == "singe") then
	                    model = -1469565163
						ordre = false
	                    come = 1
	                    openchien()
                    elseif (data == "loup") then
	                    model = 1682622302
	                    come = 1
						ordre = true						
	                    openchien()
                    elseif (data == "lapin") then
	                    model = -541762431
	                    come = 1
						ordre = false						
	                    openchien()
                    elseif (data == "husky") then
	                    model = 1318032802
						come = 1
	                    openchien()	                  
                    elseif (data == "cochon") then
	                    model = -1323586730
	                    come = 1	
						ordre = false						
	                    openchien()
                    elseif (data == "caniche") then
	                    model = 1125994524
	                    come = 1
						ordre = false
	                    openchien()
                    elseif (data == "carlin") then
	                    model = 1832265812
						come = 1
						ordre = true
	                    openchien()
                    elseif (data == "retriever") then
	                    model = 882848737
	                    come = 1
						ordre = true
	                    openchien()
                    elseif (data == "berger") then
	                    model = 1126154828
	                    come = 1
						ordre = false
	                    openchien()
                    elseif (data == "westie") then
	                    model = -1384627013
	                    come = 1	
						ordre = false						
	                    openchien()
                    end
               
                end)
                menu.close()
            end
            if data.current.value == 'attached_animal' then
                if not IsPedSittingInAnyVehicle(ped) then    
 
	                if isAttached == false then
		                attached()
		                isAttached = true
	                else
		                detached()
		                isAttached = false
	                end
                   else   
                    ESX.showNotification(_U('dontattachhiminacar'))
                end
            end
            if data.current.value == 'ordres' then              
                ordres()
                menu.close()
            end
            if data.current.value == 'graille' then
                local inventory = ESX.GetPlayerData().inventory
                local count = 0
                local coords1 = GetEntityCoords(GetPlayerPed(-1))
                local coords2 = GetEntityCoords(ped)
                local distance = GetDistanceBetweenCoords(coords1.x,coords1.y,coords1.z,coords2.x,coords2.y,coords2.z,true)
                for i=1, #inventory, 1 do
                  if inventory[i].name == 'croquettes' then
                    count = inventory[i].count
                  end
                end
                    if distance < 5 then
                        if count >= 1 then
                            if status < 100 then
                            status = status + math.random(2, 15)
                            ESX.showNotification(_U('gavepetfood'))
                            TriggerServerEvent('eden_animal:startHarvest')
                                if status > 100 then
                                    status = 100
                                end
                            menu.close()
                            else
                                ESX.showNotification(_U('nomorehunger'))
                            end
 
                        else
                            ESX.showNotification(_U('donthavefood'))
                        end
                    else
                        ESX.showNotification(_U('hestoofar'))
                    end
            end
			
			if data.current.value == 'vehicules' then
                local coords    = GetEntityCoords(GetPlayerPed(-1))
                local vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))
                local coords2 = GetEntityCoords(ped)
                local distance = GetDistanceBetweenCoords(coords.x,coords.y,coords.z,coords2.x,coords2.y,coords2.z,true)
                if not isInVehicle then
                    if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then    
							if distance < 8 then
							attached ()
							Wait(200)
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
								
							TaskWarpPedIntoVehicle(ped,  vehicle,  -2)
							 menu.close()
							 else
							 ESX.showNotification(_U('toofarfromcar'))
							 end

						 else
							ESX.showNotification(_U('youneedtobeincar'))						
                    end
                else
                    if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then    
	                    SetEntityCoords(ped,coords.x, coords.y, coords.z,1,0,0,1)
	                    Wait(100)
	                    detached()
	                     isInVehicle = false
						 						 menu.close()
                    else
					ESX.showNotification(_U('yourstillinacar'))    
					end
                end
				
            end 
			
            
			if data.current.value == 'niche' then   
			
				local GroupHandle = GetPlayerGroup(PlayerId())
				local coords    = GetEntityCoords(GetPlayerPed(-1))
				SetGroupSeparationRange(GroupHandle, 1.9)
				SetPedNeverLeavesGroup(ped, false)
				TaskGoToCoordAnyMeans(ped, coords.x+40, coords.y, coords.z, 5.0, 0, 0, 786603, 0xbf800000)
				Wait(5000)
				DeleteEntity(ped)
				come = 0
                menu.close()
				
            end
	   end,
        function(data, menu)  
            menu.close()
        end
    )
end


local inanimation = false
function ordres()
 ESX.TriggerServerCallback('eden_animal:animalname', function(data)
    local elements = {     
        }
 
        if not inanimation then
			if (data == "chien") then
					table.insert(elements, {label = _U('sitdown'), value = 'assis'})
					table.insert(elements, {label = _U('getdown'), value = 'coucher'})
			end
			if (data == "chat") then
					table.insert(elements, {label = _U('getdown'), value = 'coucher2'})
			end			
			if (data == "loup") then
					table.insert(elements, {label = _U('getdown'), value = 'coucher3'})
			end							
			if (data == "carlin") then
					table.insert(elements, {label = _U('sitdown'), value = 'assis2'})	
			end
			if (data == "retriever") then
					table.insert(elements, {label = _U('sitdown'), value = 'assis3'})	
			end
				else   
					table.insert(elements, {label = _U('getup'), value = 'debout'})
        end
         
 
       
    ESX.UI.Menu.CloseAll()
 
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'ordres',
        {
            title    = _U('pet_orders'),
            align    = 'top-left',
            elements = elements,
           
        },
        function(data, menu)

					
					if data.current.value == 'assis' then							-- [chien ]
							RequestAnimDict('creatures@rottweiler@amb@world_dog_sitting@base')
							while not HasAnimDictLoaded('creatures@rottweiler@amb@world_dog_sitting@base') do
								Wait(0)
							end
							TaskPlayAnim( ped, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base' ,8.0, -8, -1, 1, 0, false, false, false ) 
							inanimation = true
							menu.close()						
					end				
					if data.current.value == 'coucher' then						-- [chien ]
									RequestAnimDict('creatures@rottweiler@amb@sleep_in_kennel@')
									while not HasAnimDictLoaded('creatures@rottweiler@amb@sleep_in_kennel@') do
										Wait(0)
									end
									TaskPlayAnim( ped, 'creatures@rottweiler@amb@sleep_in_kennel@', 'sleep_in_kennel' ,8.0, -8, -1, 1, 0, false, false, false )        
									inanimation = true
									menu.close()   
					end
					if data.current.value == 'coucher2' then						-- [chat ]
									RequestAnimDict('creatures@cat@amb@world_cat_sleeping_ground@idle_a')
									while not HasAnimDictLoaded('creatures@cat@amb@world_cat_sleeping_ground@idle_a') do
										Wait(0)
									end
									TaskPlayAnim( ped, 'creatures@cat@amb@world_cat_sleeping_ground@idle_a', 'idle_a' ,8.0, -8, -1, 1, 0, false, false, false )        
									inanimation = true
									menu.close()   
					end		
					if data.current.value == 'coucher3' then						-- [loup ]
									RequestAnimDict('creatures@coyote@amb@world_coyote_rest@idle_a')
									while not HasAnimDictLoaded('creatures@coyote@amb@world_coyote_rest@idle_a') do
										Wait(0)
									end
									TaskPlayAnim( ped, 'creatures@coyote@amb@world_coyote_rest@idle_a', 'idle_a' ,8.0, -8, -1, 1, 0, false, false, false )        
									inanimation = true
									menu.close()   
					end		
					if data.current.value == 'assis2' then						-- [carlin ]
									RequestAnimDict('creatures@carlin@amb@world_dog_sitting@idle_a')
									while not HasAnimDictLoaded('creatures@carlin@amb@world_dog_sitting@idle_a') do
										Wait(0)
									end
									TaskPlayAnim( ped, 'creatures@carlin@amb@world_dog_sitting@idle_a', 'idle_b' ,8.0, -8, -1, 1, 0, false, false, false )        
									inanimation = true
									menu.close()   
					end			
					if data.current.value == 'assis3' then						-- [retriever ]
									RequestAnimDict('creatures@retriever@amb@world_dog_sitting@idle_a')
									while not HasAnimDictLoaded('creatures@retriever@amb@world_dog_sitting@idle_a') do
										Wait(0)
									end
									TaskPlayAnim( ped, 'creatures@retriever@amb@world_dog_sitting@idle_a', 'idle_c' ,8.0, -8, -1, 1, 0, false, false, false )        
									inanimation = true
									menu.close()   
					end						
			
            if data.current.value == 'debout' then
                ClearPedTasks(ped)
                inanimation = false
                menu.close()
            end        
           
                              
        end,
        function(data, menu)          
            menu.close()
        end
    )
	end) 
end          






function attached ()
    local playerPed = GetPlayerPed(-1)
    local GroupHandle = GetPlayerGroup(PlayerId())
    SetGroupSeparationRange(GroupHandle, 1.9)
    SetPedNeverLeavesGroup(ped, false)
    FreezeEntityPosition(ped, true)          
end  
function detached ()
    local playerPed = GetPlayerPed(-1)
    local GroupHandle = GetPlayerGroup(PlayerId())                
    SetGroupSeparationRange(GroupHandle, 999999.9)
    SetPedNeverLeavesGroup(ped, true)
    SetPedAsGroupMember(ped, GroupHandle)
    FreezeEntityPosition(ped, false)               
end
 
 
 
local bool = false
AddEventHandler('playerSpawned', function()
    if bool == false then
        -- chien
            RequestModel( -1788665315 )
        while ( not HasModelLoaded( -1788665315 ) ) do
            Citizen.Wait( 1 )
        end
        -- chat
            RequestModel( 1462895032 )
        while ( not HasModelLoaded( 1462895032 ) ) do
            Citizen.Wait( 1 )
        end
        -- singe
            RequestModel( -1469565163 )
        while ( not HasModelLoaded( -1469565163 ) ) do
            Citizen.Wait( 1 )
        end
        -- loup
            RequestModel( 1682622302 )
        while ( not HasModelLoaded( 1682622302 ) ) do
            Citizen.Wait( 1 )
        end
        -- lapin
            RequestModel( -541762431 )
        while ( not HasModelLoaded( -541762431 ) ) do
            Citizen.Wait( 1 )
        end
        -- husky
            RequestModel( 1318032802 )
        while ( not HasModelLoaded( 1318032802 ) ) do
            Citizen.Wait( 1 )
        end
        -- cochon
            RequestModel( -1323586730 )
        while ( not HasModelLoaded( -1323586730 ) ) do
            Citizen.Wait( 1 )
        end
        -- caniche
            RequestModel( 1125994524 )
        while ( not HasModelLoaded( 1125994524 ) ) do
            Citizen.Wait( 1 )
        end
        -- carlin
            RequestModel( 1832265812 )
        while ( not HasModelLoaded( 1832265812 ) ) do
            Citizen.Wait( 1 )
        end
        -- retriever
            RequestModel( 882848737 )
        while ( not HasModelLoaded( 882848737 ) ) do
            Citizen.Wait( 1 )
        end
        -- berger
            RequestModel( 1126154828 )
        while ( not HasModelLoaded( 1126154828 ) ) do
            Citizen.Wait( 1 )
        end
        -- westie
            RequestModel( -1384627013 )
        while ( not HasModelLoaded( -1384627013 ) ) do
            Citizen.Wait( 1 )
        end
  end
end)
 
 
function openchien ()
    local playerPed = GetPlayerPed(-1)
    local LastPosition = GetEntityCoords(GetPlayerPed(-1))
    local GroupHandle = GetPlayerGroup(PlayerId())
        RequestAnimDict('rcmnigel1c')
        while not HasAnimDictLoaded('rcmnigel1c') do
       		Wait(0)
        end
        TaskPlayAnim( GetPlayerPed(-1), 'rcmnigel1c', 'hailing_whistle_waive_a' ,8.0, -8, -1, 120, 0, false, false, false )
   		SetTimeout(5000, function() -- 5 secondes
        ped = CreatePed(28, model, LastPosition.x +1, LastPosition.y +1, LastPosition.z -1, 1, 1)                   
        SetPedAsGroupLeader(playerPed, GroupHandle)
        SetPedAsGroupMember(ped, GroupHandle)
        SetPedNeverLeavesGroup(ped, true)               
        SetPedCanBeTargetted(ped, false)          
        SetEntityAsMissionEntity(ped, true,true)    
        status = math.random(40, 90)      
    end)
end
 
 
Citizen.CreateThread(function()
    while true do      
        Wait(math.random(60000, 120000))
        if come == 1 then
            status = status - 1
        end
        if status == 0 then
            TriggerServerEvent('eden_animal:dead')
            DeleteEntity(ped)
            ESX.showNotification(_U('pet_dead'))
            come = 3
            status = "die"
        end
    end
end)
 
-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if IsControlPressed(0, Keys['F7']) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'eden_animal') and (GetGameTimer() - GUI.Time) > 150 then
            OpenAnimal()
            GUI.Time = GetGameTimer()
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
		Wait(0)
			local coord = GetEntityCoords(GetPlayerPed(-1), true)
			if GetDistanceBetweenCoords(coord, Config.Zones.PetShop.Pos.x,Config.Zones.PetShop.Pos.y,Config.Zones.PetShop.Pos.z, false) < 5 then
					DisplayHelpText(_U('enterkey'))
					if IsControlJustPressed(0, Keys['E'])  then
						buy_animal()
					end	
			end
	end
end)
--function
function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function buy_animal()
    local value = value
    local price = price
    local elements = {}
    table.insert(elements, {label = _U('dog') .. '- <span style="color:green;">$50000</span>',             					value = "chien",	price = 50000})		
    table.insert(elements, {label = _U('cat') .. '- <span style="color:green;">$15000</span>',             					value = "chat", price = 15000})
    table.insert(elements, {label = _U('monkey') .. '- <span style="color:green;">$8000</span>',             					value = "singe", price = 8000})
    table.insert(elements, {label = _U('wolf') .. '- <span style="color:green;">$30000</span>',             					value = "loup", price = 30000})
    table.insert(elements, {label = _U('bunny') .. '- <span style="color:green;">$25000</span>',             					value = "lapin",	price = 25000})
    table.insert(elements, {label = _U('husky') .. '- <span style="color:green;">$35000</span>',             					value = "husky", price = 35000})
    table.insert(elements, {label = _U('pig') .. '- <span style="color:green;">$10000</span>',             					value = "cochon", price = 10000})
    table.insert(elements, {label = _U('poodle') .. '- <span style="color:green;">$50000</span>',             					value = "caniche", price = 50000})
    table.insert(elements, {label = _U('pug') .. '- <span style="color:green;">$5000</span>',             					value = "carlin", price = 5000})
    table.insert(elements, {label = _U('retriever') .. '- <span style="color:green;">$10000</span>',             					value = "retriever", price = 10000})
    table.insert(elements, {label = _U('asatian') .. '- <span style="color:green;">$55000</span>',             					value = "berger", price = 55000})
    table.insert(elements, {label = _U('westie') .. '- <span style="color:green;">$50000</span>',             					value = "westie", price = 50000})
    
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'animalerie',
    {
        title    = _U('pet_shop2'),
        align 	 = 'top-left',
        elements = elements
    },
    function(data, menu)
       
            TriggerServerEvent('eden_animal:takeanimal', data.current.value, data.current.price)
            menu.close()

    end)
end