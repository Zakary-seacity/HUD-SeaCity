ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("carfill:checkmoney")
AddEventHandler("carfill:checkmoney", function(costs,loc)
    local src = source
    local target = ESX.GetPlayerFromId(src)

    if not costs
    then
        costs = 0
    end

    if target.getAccount('bank').money >= costs then
        target.removeAccountMoney('bank', costs)
        TriggerClientEvent("RefuelCarServerReturn", src)
    else
        exports['mythic_notify']:DoHudText('error', 'İhtiyacın var $' .. costs .. ' + Vergi')
    end
end)

ESX.RegisterUsableItem('compass', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('carHud:compass', source, xPlayer.getInventoryItem('compass').count)
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
    local source = tonumber(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  
    if item.name == 'compass' and item.count < 1 then
      TriggerClientEvent('carHud:compass1', source)
    end
  end)

  local vehiclesKHM = {}

Citizen.CreateThread(function()
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "vehicles.json")
    vehiclesKHM = json.decode(loadFile)
end)


RegisterServerEvent("hud:server:vehiclesKHM")
AddEventHandler("hud:server:vehiclesKHM", function(plate,kmh)
    if plate and kmh and type(vehiclesKHM) == 'table' then
        vehiclesKHM[plate] = kmh
        SaveResourceFile(GetCurrentResourceName(), "vehicles.json", json.encode(vehiclesKHM), -1)
        TriggerClientEvent("hud:client:vehiclesKHM", -1, plate,kmh)
    end
end)

RegisterServerEvent("hud:server:requestTable")
AddEventHandler("hud:server:requestTable", function()
    TriggerClientEvent("hud:client:vehiclesKHMTable", source, vehiclesKHM)
end)
