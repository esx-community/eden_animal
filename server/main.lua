ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('eden_animal:animalname', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = xPlayer.identifier
	}, function(result)
		cb(result[1].pet)
	end)
end)

RegisterServerEvent("eden_animal:dead")
AddEventHandler("eden_animal:dead", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('UPDATE users SET pet = "(NULL)" WHERE identifier = @identifier',
	{
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('eden_animal:startHarvest')
AddEventHandler('eden_animal:startHarvest', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('croquettes', 1)
end)

ESX.RegisterServerCallback('eden_animal:buyPet', function(source, cb, animalname, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= price then
		xPlayer.removeMoney(price)
		MySQL.Async.execute('UPDATE users SET pet = @animalname WHERE identifier = @identifier',
		{
			['@identifier']    = xPlayer.identifier,
			['@animalname']    = animalname
		})
		TriggerClientEvent('esx:showNotification', source, (_U('you_bought', animalname, price)))
		cb(true)
	else
		TriggerClientEvent('esx:showNotification', source, _U('your_poor'))
		cb(false)
	end
end)