local QBCore = exports['qb-core']:GetCoreObject()

function GetPlayer(playerId)
    local player = QBCore.Functions.GetPlayer(playerId)
    return player
end

function GetCharacterId(player)
    if player and player.PlayerData then
        return player.PlayerData.citizenid
    end
    return nil
end

function IsPlayerInGroup(player, filter)
    
    if not player or not player.PlayerData or not player.PlayerData.job then
        return false
    end
    
    local type_filter = type(filter)
    
    if type_filter == 'string' then
        if player.PlayerData.job.name == filter then
            return player.PlayerData.job.name, player.PlayerData.job.grade.level
        end
    else
        local tableType
        if table.type then
            tableType = table.type(filter)
        else
            if type(filter) == 'table' then
                local isArray = true
                local count = 0
                for _ in pairs(filter) do count = count + 1 end
                for i=1, count do if filter[i] == nil then isArray = false; break end end
                tableType = isArray and 'array' or 'hash'
            else
                return false
            end
        end
        
        if tableType == 'hash' then
            for jobName, gradeLevel in pairs(filter) do
            end
            
            local requiredGrade = filter[player.PlayerData.job.name]
            if requiredGrade then
                
                if player.PlayerData.job.grade.level >= requiredGrade then
                    return player.PlayerData.job.name, player.PlayerData.job.grade.level

                end
            end
        elseif tableType == 'array' then
            for i = 1, #filter do
                if player.PlayerData.job.name == filter[i] then
                    return player.PlayerData.job.name, player.PlayerData.job.grade.level
                end
            end
        end
    end

    return false
end

function DoesPlayerHaveItem(player, items, removeItem)
    
    if not player then
        return false
    end
    
    local playerId = player.source or player.PlayerData.source
    
    if not playerId then
        return false
    end
    
    for i = 1, #items do
        local item = items[i]
        local itemName = item.name or item
        local hasItem = exports['qb-core']:GetCoreObject().Functions.GetPlayer(playerId).Functions.GetItemByName(itemName)
        
        if hasItem and hasItem.amount > 0 then            
            if removeItem or (type(item) == 'table' and item.remove) then
                exports['qb-core']:GetCoreObject().Functions.GetPlayer(playerId).Functions.RemoveItem(itemName, 1)
            end
            
            return itemName
        else
        end
    end
    
    return false
end
