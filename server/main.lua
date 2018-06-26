ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('eden_animal:getPet', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local userPets = result[1].pet

		if userPets ~= nil then
			cb(userPets)
		else
			cb('')
		end
	end)
end)

RegisterServerEvent('eden_animal:petDied')
AddEventHandler('eden_animal:petDied', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('UPDATE users SET pet = "(NULL)" WHERE identifier = @identifier',
	{
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('eden_animal:consumePetFood')
AddEventHandler('eden_animal:consumePetFood', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('croquettes', 1)
end)

ESX.RegisterServerCallback('eden_animal:buyPet', function(source, cb, pet, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= price then
		xPlayer.removeMoney(price)
		MySQL.Async.execute('UPDATE users SET pet = @pet WHERE identifier = @identifier',
		{
			['@identifier'] = xPlayer.identifier,
			['@pet']        = pet
		})
		TriggerClientEvent('esx:showNotification', source, (_U('you_bought', pet, price)))
		cb(true)
	else
		TriggerClientEvent('esx:showNotification', source, _U('your_poor'))
		cb(false)
	end
end)