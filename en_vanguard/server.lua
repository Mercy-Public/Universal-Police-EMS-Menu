local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('emergency:server:giveItem', function(itemName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local job = Player.PlayerData.job.name
    if job ~= 'police' and job ~= 'ambulance' then
    --if job ~= 'police' and job ~= 'ambulance' and job ~= 'thirdjob' then

        print("Unauthorized access attempt by: " .. Player.PlayerData.citizenid)
        return
    end
    
    local items = Config.GetShopItems(job)
    local itemData = nil
    for _, item in ipairs(items) do
        if item.name == itemName then
            itemData = item
            break
        end
    end
    
    if not itemData then
        print("Invalid item request by: " .. Player.PlayerData.citizenid)
        return
    end
    
    if Player.PlayerData.job.grade.level < itemData.grade then
        TriggerClientEvent('QBCore:Notify', src, "You don't have the required job grade for this item.", 'error')
        return
    end
    
    if Player.Functions.AddItem(itemName, 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], "add")
        TriggerClientEvent('QBCore:Notify', src, "You received 1x " .. itemName, 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, "Your inventory is full.", 'error')
    end
end)