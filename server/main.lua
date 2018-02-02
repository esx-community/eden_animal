ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("eden_animal:animalname", function(_source , cb)
	local source        = _source
	local xPlayer        = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll(
        'SELECT * FROM users WHERE identifier = @identifier',
        {
            ['@identifier'] = xPlayer.identifier
        },
        function(result)
                cb(result[1].animal)
        end
    )
end)

RegisterServerEvent("eden_animal:dead")
AddEventHandler("eden_animal:dead", function()
    local _source        = source
    local xPlayer        = ESX.GetPlayerFromId(_source)
	
	MySQL.Async.execute(
		'UPDATE users SET animal = "(NULL)" WHERE identifier = @identifier',
		{
			['@identifier']    = xPlayer.identifier
		}
	)     
end)

RegisterServerEvent('eden_animal:startHarvest')
AddEventHandler('eden_animal:startHarvest', function()
	local _source = source
	local xPlayer        = ESX.GetPlayerFromId(_source)
		xPlayer.removeInventoryItem('croquettes', 1)

end)

RegisterServerEvent('eden_animal:takeanimal')
AddEventHandler('eden_animal:takeanimal',function(animalname, price)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

		if xPlayer.get('money') >= price then

			xPlayer.removeMoney(price)
			MySQL.Async.execute(
				'UPDATE users SET animal = @animalname WHERE identifier = @identifier',
				{
					['@identifier']    = xPlayer.identifier,
					['@animalname']    = animalname
				}
			)
			TriggerClientEvent('esx:showNotification', _source, (_U('youbought') .. animalname .. _U('for') .. price))

		else
			TriggerClientEvent('esx:showNotification', _source, _U('yourpoor'))
		end

end)

