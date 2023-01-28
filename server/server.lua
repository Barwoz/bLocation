ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('barwoz:location')
AddEventHandler('barwoz:location', function(Nom, Vehicule, Price)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local car = Vehicule
    local bankMoney = xPlayer.getAccount("bank").money

    if bankMoney >= tonumber(Price) then 
        xPlayer.removeAccountMoney("bank", tonumber(Price))
        TriggerClientEvent('barwoz:spawnCar', _src, car)
        Wait(500)
        TriggerClientEvent('esx:showAdvancedNotification', _src, 'Banque', 'Conseiller', "Un prélèvement de ~r~"..Price.." ~s~a été effectué sur votre compte pour ~r~une location ~s~!", 'CHAR_BANK_MAZE', 1)
    else 
        Wait(500) 
        TriggerClientEvent('esx:showAdvancedNotification', _src, 'Banque', 'Conseiller', "Vous n'avez pas suffisament d'argent sur votre compte bancaire ~s~!", 'CHAR_BANK_MAZE', 1)
    end
end)
