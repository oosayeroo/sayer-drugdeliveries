local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('sayer-drugdeliveries:DropOffDeliveryDoor', function(SET,amount,price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local totalPayment = 0
    local itemPrice = price * amount
    local level = Player.PlayerData.metadata['sayerdeliverylevel']
    local multiply = 1
    
    if Config.Levels[level].CashBoost then
        multiply = Config.Levels[level].CashBoost
    end

    local item = SET.ItemCode
    totalPayment = itemPrice*multiply

    if Player.Functions.RemoveItem(item, amount) then
        Player.Functions.AddMoney('cash', totalPayment)
    end

end)

RegisterNetEvent('sayer-drugdeliveries:FinishPurchase', function(item,amount,price,currency,isitem)
    local Player = QBCore.Functions.GetPlayer(source)
    local totalprice = 0
    local fullamount = tonumber(amount)
    totalprice = math.ceil(price*fullamount)
    if isitem == true then
        for k,v in pairs(Player.PlayerData.items) do
            if k ~= nil then
                if v.name == currency then
                    if v.amount >= totalprice then
                        if Player.Functions.RemoveItem(currency,totalprice) then
                            Player.Functions.AddItem(item,fullamount)
                            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add")
                        end
                    else
                        TriggerClientEvent('QBCore:Notify', source, "You Need "..totalprice.." "..currency.." to be able to purchase this!", 'error')
                    end
                end
            end
        end
    else
        local curmoney = Player.Functions.GetMoney(currency)
        if curmoney >= totalprice then
            Player.Functions.RemoveMoney(currency,totalprice)
            Player.Functions.AddItem(item,amount)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add")
        else
            print("You Suck")
            TriggerClientEvent('QBCore:Notify', source, "You Need "..totalprice.." "..currency.." to be able to purchase this!", 'error')
        end
    end
end)

RegisterNetEvent('sayer-drugdeliveries:GiveDeliveryItem', function(item,amount)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem(item,amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add")
end)

RegisterNetEvent('sayer-drugdeliveries:CleanMoney', function(isItem,item,amount)
    local Player = QBCore.Functions.GetPlayer(source)
    local itemvalue = nil
    local randomvalue = 0
    local fullvalue = 0
    local DataWorth = 0
    if isItem then
        itemvalue = Config.Cleaning[item].Currency.ValuePerOne
        if itemvalue == 'UseInfo' then
            for k,v in pairs(Player.PlayerData.items) do
                if Player.PlayerData.items[k] ~= nil then
                    if v.name == item then
                        DataWorth = DataWorth + math.ceil(v.info.worth*amount)
                        Player.Functions.RemoveItem(item,amount)
                        Player.Functions.AddMoney('cash',DataWorth)
                        TriggerClientEvent('QBCore:Notify', source, "You Have Cleaned "..amount.." "..QBCore.Shared.Items[item].label.." for $"..DataWorth.." !", 'success')
                    end
                end
            end
        else
            randomvalue = math.random(itemvalue.Min,itemvalue.Max)
            fullvalue = randomvalue*amount
            Player.Functions.RemoveItem(item,amount)
            Player.Functions.AddMoney('cash',fullvalue)
            TriggerClientEvent('QBCore:Notify', source, "You Have Cleaned "..amount.." "..QBCore.Shared.Items[item].label.." for $"..fullvalue.." !", 'success')
        end
    else
        itemvalue = Config.Cleaning[item].Currency.ValuePerOne
        randomvalue = math.random(itemvalue.Min,itemvalue.Max)
        fullvalue = randomvalue*amount
        Player.Functions.RemoveMoney(item,amount)
        Player.Functions.AddMoney('cash',fullvalue)
        TriggerClientEvent('QBCore:Notify', source, "You Have Cleaned "..amount.." "..QBCore.Shared.Items[item].label.." for $"..fullvalue.." !", 'success')
    end
end)
    

QBCore.Functions.CreateCallback('sayer-drugdeliveries:itemchecker', function(source, cb, SET)
    local src = source
    local hasItems = false
    local itemcount = 0
    local player = QBCore.Functions.GetPlayer(source)
    for k, v in ipairs(SET) do
        if player.Functions.GetItemByName(v.name) and player.Functions.GetItemByName(v.name).amount >= v.amount then
            itemcount = itemcount + 1
            if itemcount == #SET then
                cb(true)
            end
        else
            cb(false)
            return
        end
    end
end)

RegisterNetEvent('sayer-drugdeliveries:SetLevel', function(level)
    local Player = QBCore.Functions.GetPlayer(source)
    local CurLevel = Player.PlayerData.metadata['sayerdeliverylevel']
    Player.Functions.SetMetaData('sayerdeliverylevel', level)
end)

RegisterNetEvent('sayer-drugdeliveries:SetXP', function(xp)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.SetMetaData('sayerdeliveryrep', xp)
end)

RegisterNetEvent('sayer-drugdeliveries:AddXP', function(xp)
    local Player = QBCore.Functions.GetPlayer(source)
    local EXP = Player.PlayerData.metadata['sayerdeliveryrep']
    local level = Player.PlayerData.metadata['sayerdeliverylevel']

    if level <= #Config.Levels then
        if (EXP+xp) >= Config.Levels[level].NextLevel then
            Player.Functions.SetMetaData('sayerdeliverylevel', (level+1))
            Player.Functions.SetMetaData('sayerdeliveryrep', 0)
            TriggerClientEvent('QBCore:Notify', source, "Your Delivery Level Has Increased", 'success')
        else
            Player.Functions.SetMetaData('sayerdeliveryrep', (EXP+xp))
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "Your Delivery Level Cant Increase More!", 'error')
    end
end)