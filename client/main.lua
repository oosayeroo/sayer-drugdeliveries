local QBCore = exports['qb-core']:GetCoreObject()

PlayerJob = {}
local OnSDelivery = false
local TargetZone = {}
local TargetPed = {}
local DropOffDone = 0
local SET = nil
local Delivered = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() --makes so you cannot go higher than the max level
    PlayerIdentifier = QBCore.Functions.GetPlayerData().citizenid
    local level = QBCore.Functions.GetPlayerData().metadata["sayerdeliverylevel"]
    local xp = QBCore.Functions.GetPlayerData().metadata["sayerdeliveryrep"]
    local max = #Config.Levels
    local Next = Config.Levels[level].NextLevel

    if level > max then
        TriggerServerEvent('sayer-drugdeliveries:SetLevel',max)
    end
    if xp > Next then
        TriggerServerEvent('sayer-drugdeliveries:SetXP',0)
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

CreateThread(function()
    for k,v in pairs(Config.Dealers) do
        if v.Enable then
            if v.MenuLocation then
                if v.MenuType == 'zone' then
                    for d,j in pairs(v.MenuLocation) do
                        TargetZone["DrugMenu"..k..d] =
	                    exports['qb-target']:AddBoxZone("DrugMenu"..k..d, j.Coords, 2.0, 2.0, {name = "DrugMenu"..k..d,heading = 0,debugPoly = v.DebugPoly,minZ=j.Coords-1,maxZ=j.Coords+1,}, {
	                    	options = {{ action = function() OpenDeliveryMenu(v.ShopItems, j.Emote) end,icon = "fas fa-cannabis",label = "Delivery"},},
	                    	distance = 2.5,
	                    })
                        if j.SpeechRecognise then
                            for p,m in pairs(j.SpeechRecognise) do
                                if Config.DebugCode then print("Before Export") end
                                exports["17mov_SpeechRecognition"]:NewAction({
                                    phrases = m.Phrase,
                                    allowRecognitionInReverse = m.AllowRecognitionInReverse,
                                    blockInVehicle = m.BlockInVehicle,
                                    actionType = "custom",
                                    actionFunction = function()
                                        if Config.DebugCode then print("ACTION RECOGNIZED") end
                                        if #(GetEntityCoords(PlayerPedId()) - vec3(j.Coords.x, j.Coords.y, j.Coords.z)) < 5.0 then
                                            if Config.DebugCode then print("GetDistance = true") end
                                            OpenDeliveryMenu(v.ShopItems, j.Emote)
                                        end
                                    end,
                                })
                                if Config.DebugCode then print("After Export") end
                            end
                        end
                    end
                elseif v.MenuType == 'ped' then
                    for d,j in pairs(v.MenuLocation) do
                        local model = ''
                        local entity = ''
                        model = j.Model

                        RequestModel(model)
                        while not HasModelLoaded(model) do
                          Wait(0)
                        end

                        entity = CreatePed(0, model, j.Coords.x,j.Coords.y,j.Coords.z-1,j.Coords.w, true, false)
                        SetEntityInvincible(entity,true)
                        FreezeEntityPosition(entity,true)
                        SetBlockingOfNonTemporaryEvents(entity,true)

                        TargetPed["DrugMenu"..k..d] =
                        exports['qb-target']:AddTargetEntity(entity,{
                            options = {{icon = "fas fa-clipboard",label = "Delivery Manager",action = function() OpenDeliveryMenu(v.ShopItems, j.Emote) end,},},
                            distance = 2.5,
                        })
                        if j.SpeechRecognise then
                            for p,m in pairs(j.SpeechRecognise) do
                                if Config.DebugCode then print("Before Export") end
                                exports["17mov_SpeechRecognition"]:NewAction({
                                    phrases = m.Phrase,
                                    allowRecognitionInReverse = m.AllowRecognitionInReverse,
                                    blockInVehicle = m.BlockInVehicle,
                                    actionType = "custom",
                                    actionFunction = function()
                                        if Config.DebugCode then print("ACTION RECOGNIZED") end
                                        if #(GetEntityCoords(PlayerPedId()) - vec3(j.Coords.x, j.Coords.y, j.Coords.z)) < 5.0 then
                                            if Config.DebugCode then print("GetDistance = true") end
                                            OpenDeliveryMenu(v.ShopItems, j.Emote)
                                        end
                                    end,
                                })
                                if Config.DebugCode then print("After Export") end
                            end
                        end
                    end
                end
            end
        end
    end
end)

function OpenDeliveryMenu(Items,Emote)
    exports['qb-menu']:openMenu({
        {header = "| Dealer |",isMenuHeader = true, },
        {header = "Open Shop",                  txt = "Buy From Dealer",params = {event = "sayer-drugdeliveries:OpenShop",args = {list = Items}}},
        {header = "Start Delivery",             txt = "Start a Delivery",params = {event = "sayer-drugdeliveries:DeliveryMenu", args = {anim = Emote}}},
        {header = "Cancel Delivery",            txt = "Cancel a Delivery",params = {event = "sayer-drugdeliveries:CancelDelivery"}},
        {header = "Close (ESC)",isMenuHeader = true, },
    })
end

RegisterNetEvent('sayer-drugdeliveries:OpenShop', function(args)
    OpenZoneShop(args.list)
end)

RegisterNetEvent("sayer-drugdeliveries:DeliveryMenu", function(args)
    local delmenu = exports['qb-input']:ShowInput({
        header = "How Many Deliveries to do?",
		submitText = "Start Delivery",
        inputs = {
            {text = "Amount(#)",name = "amount", type = "number", isRequired = true },
        }
    })
    if delmenu ~= nil then
        if delmenu.amount == nil then return end
        TriggerEvent("sayer-drugdeliveries:StartDelivery", delmenu.amount, args.anim)
        if Config.DebugCode then print("Deliveries Accepted = "..delmenu.amount.."!") end
    end
end)

RegisterNetEvent('sayer-drugdeliveries:CancelDelivery', function()
    SET = nil
    OnSDelivery = false
    print(OnSDelivery)
    DropOffDone = 0
    DestroySZone('delivery_zone')
    SDDNotify(nil,'Delivery Cancelled', 'success',2000)
end)

local function getRandomItems(items)
    local level = QBCore.Functions.GetPlayerData().metadata['sayerdeliverylevel']
    local validItems = {}

    for _, item in ipairs(items) do
        if QBCore.Shared.Items[item.ItemCode] ~= nil then
            if level >= item.LevelNeeded then
                table.insert(validItems, item)
            end
        else
            print("^4SAYER-DRUGDELIVERIES^7:Cannot Find ..^4"..item.ItemCode.."^7.. In ^4Shared/Items.lua")
        end
    end

    if #validItems > 0 then
        return validItems[math.random(1, #validItems)]
    else
        return nil
    end
end


RegisterNetEvent('sayer-drugdeliveries:StartDelivery', function(amount,emote)
    number = tonumber(amount)
    SET = getRandomItems(Config.DeliveryItems)
    local Amount = 0
    if SET.Min == SET.Max then
        Amount = SET.Min
    else
        Amount = math.random(SET.Min,SET.Max)
    end
    local Price = math.random(SET.RewardEach.Min,SET.RewardEach.Max)
    if not OnSDelivery then
        Delivered = false
        if number < Config.MaxDeliveries then
            local prob = Config.DeliveryLocations[math.random(1, #Config.DeliveryLocations)]
            TriggerEvent('animations:client:EmoteCommandStart', {emote})
                QBCore.Functions.Progressbar('del_start', 'Getting Delivery Details...', 5000, false, true, 
                {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                SDDNotify(nil,'You Started a delivery! It should appear in your emails soon!', 'primary', 7500)
                Wait(2000)
                SendDeliveryEmail(SET,Amount,Price)
                TriggerServerEvent('sayer-drugdeliveries:GiveDeliveryItem',SET.ItemCode,Amount)
                exports['qb-target']:AddBoxZone("drug_delivery_zone", prob.Coords, 2, 2, {name="delivery_zone",heading=0,debugpoly = false,}, {
                    options = {{action = function() DropOffDeliveryDoor(number, SET, Amount,Price) end,icon = "fas fa-cannabis",label = "Deliver",item = SET.ItemCode},},
                    distance = 2.5
                })
                if Config.EnableVoiceRecognise then
                    exports["17mov_SpeechRecognition"]:NewAction({
                        phrases = {"Delivery","Got Your Delivery","Collect"},
                        allowRecognitionInReverse = true,
                        blockInVehicle = true,
                        actionType = "custom",
                        actionFunction = function()
                            if Config.DebugCode then print("ACTION RECOGNIZED") end
                            if #(GetEntityCoords(PlayerPedId()) - vec3(prob.Coords.x, prob.Coords.y, prob.Coords.z)) < 8.0 then
                                if Config.DebugCode then print("GetDistance = true") end
                                if QBCore.Functions.HasItem(SET.ItemCode) then
                                    DropOffDeliveryDoor(number, SET, Amount,Price)
                                else
                                    QBCore.Functions.Notify('You Dont have the right item to deliver','error')
                                end
                            end
                        end,
                    })
                end
                SetNewWaypoint(prob.Coords)
                OnSDelivery = true
            end)
        else
            SDDNotify(nil,'You Cannot Do That Many Deliveries', 'error',5000)
        end
    else
        SDDNotify(nil,'You are already busy', 'error',5000)
        if Config.DebugCode then print("onSDelivery = "..OnSDelivery.."!") end
    end
end)

function SendDeliveryEmail(ItemList,amount,price)
    local item = ItemList
    local msg = ""
    msg = " : " .. QBCore.Shared.Items[item.ItemCode].label .. " x" .. amount .. " for $" .. price .." each!"
    if Config.Phone == 'qb' then
        TriggerServerEvent('qb-phone:server:sendNewMail', {sender = 'Delivery',subject = 'Delivery Items = ',message = msg,})
    elseif Config.Phone == 'qs' then
        TriggerServerEvent('qs-smartphone:server:sendNewMail', {sender = 'Delivery',subject = 'Delivery Items = ',message = msg,button = {}})
    elseif Config.Phone == 'gk' then
        TriggerServerEvent('gksphone:NewMail', {sender = 'Delivery',subject = 'Delivery Items = ',message = msg,})
    end
end

function ContDelivery(number)
    Delivered = false
    if DropOffDone < number then
        local prob = Config.DeliveryLocations[math.random(1, #Config.DeliveryLocations)]
        SET = getRandomItems(Config.DeliveryItems)
        local Amount = 0
        if SET.Min == SET.Max then
            Amount = SET.Min
        else
            Amount = math.random(SET.Min,SET.Max)
        end
        local Price = 0
        if SET.RewardEach.Min == SET.RewardEach.Max then
            Price = SET.RewardEach.Min
        else
            Price = math.random(SET.RewardEach.Min,SET.RewardEach.Max)
        end
        SendDeliveryEmail(SET,Amount,Price)
        TriggerServerEvent('sayer-drugdeliveries:GiveDeliveryItem',SET.ItemCode,Amount)
        exports['qb-target']:AddBoxZone("drug_delivery_zone", prob.Coords, 2, 2, {name="drug_delivery_zone",heading=0,debugpoly = false,}, {
            options = {{action = function() DropOffDeliveryDoor(number, SET,Amount,Price) end,icon = "fas fa-box",label = "Deliver",item = SET.ItemCode},},
            distance = 2.5
        })
        if Config.EnableVoiceRecognise then
            exports["17mov_SpeechRecognition"]:NewAction({
                phrases = Config.DeliveryPhrases,
                allowRecognitionInReverse = true,
                blockInVehicle = true,
                actionType = "custom",
                actionFunction = function()
                    if Config.DebugCode then print("ACTION RECOGNIZED") end
                    if #(GetEntityCoords(PlayerPedId()) - vec3(prob.Coords.x, prob.Coords.y, prob.Coords.z)) < 8.0 then
                        if Config.DebugCode then print("GetDistance = true") end
                        if QBCore.Functions.HasItem(SET.ItemCode) then
                            DropOffDeliveryDoor(number, SET, Amount,Price)
                        else
                            QBCore.Functions.Notify('You Dont have the right item to deliver','error')
                        end
                    end
                end,
            })
        end
        SetNewWaypoint(prob.Coords)
        SDDNotify(nil,'Customer House GPS Set!', 'success',5000)
    else
        SDDNotify(nil,'You Have Done All Deliveries', 'success',5000)
        DropOffDone = 0
        OnSDelivery = false
    end
end

function DropOffDeliveryDoor(number, SET,amount,price)
    if QBCore.Functions.HasItem(SET.ItemCode,amount) then
        if not Delivered then
            TriggerEvent('animations:client:EmoteCommandStart', {"knock"})
            QBCore.Functions.Progressbar('falar_empregada', 'Knocking Door...', 5000, false, true, 
                {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
                SDDNotify(nil,'Delivery Successful', 'success', 7500)
                TriggerServerEvent('sayer-drugdeliveries:DropOffDeliveryDoor', SET,amount,price)
                TriggerServerEvent('sayer-drugdeliveries:AddXP',Config.DeliveryXP)
                local random = math.random(1,100)
                if random < Config.CleanChancePerDropOff then
                    CleanMoney()
                end
                DropOffDone = DropOffDone+1
                if Config.DebugCode then print("DropOffDone = "..DropOffDone) end
                Delivered = true
                DestroySZone('drug_delivery_zone')
                Wait(2000)
                ContDelivery(number)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            end)
        else
            SDDNotify(nil,'Youve Already Delivered','error',5000)
        end
    end
end

function OpenZoneShop(itemlist)
    local LVL = QBCore.Functions.GetPlayerData().metadata['sayerdeliverylevel']
    local XP = QBCore.Functions.GetPlayerData().metadata['sayerdeliveryrep']
    local Needed = Config.Levels[LVL].NextLevel
    local Next = (Needed - XP)
    local columns = {
        {header = "Dealer Shop", isMenuHeader = true}, 
        {header = "Current Level = "..LVL.."! </br> Current XP = "..XP.."! </br> XP Needed For Level "..(LVL+1).." = "..Next.." !", isMenuHeader = true},
    }
    if Config.CustomShop.HideLockedItems then
        for k, v in ipairs(itemlist) do
            if QBCore.Shared.Items[v.ItemCode] ~= nil then
                if LVL >= v.Level then
                    local item = {}
                    item.header = "<img src=nui://"..Config.CustomShop.InventoryLink..QBCore.Shared.Items[v.ItemCode].image.." width=35px style='margin-right: 10px'> " .. QBCore.Shared.Items[v.ItemCode].label
                    local text = ""
                    if v.IsItem then
                        text = text .. "- Purchase for : " .. v.Price .. " "..v.Currency.." <br>"
                    else
                        text = text .. "- Purchase for : $" .. v.Price .. " "..v.Currency.." <br>"
                    end
                    item.text = text
                    item.params = {event = 'sayer-drugdeliveries:PurchaseMenu',args = {type = v.ItemCode, price = v.Price, currency = v.Currency,isitem = v.IsItem, level = v.Level}}
                    table.insert(columns, item)
                end
            else
                print('^1SAYER-DRUGDELIVERIES: ^7Cannot Find ^4'..v.ItemCode..' ^7From ^4ShopItems ^7In ^4Shared/Items.lua')
            end
        end
    else
        for k, v in ipairs(itemlist) do
            if QBCore.Shared.Items[v.ItemCode] ~= nil then
                local item = {}
                if Config.CustomShop.ShowLevelRequired then
                    item.header = "<img src=nui://"..Config.CustomShop.InventoryLink..QBCore.Shared.Items[v.ItemCode].image.." width=35px style='margin-right: 10px'> " .. QBCore.Shared.Items[v.ItemCode].label.."! |Level = "..v.Level
                else
                    item.header = "<img src=nui://"..Config.CustomShop.InventoryLink..QBCore.Shared.Items[v.ItemCode].image.." width=35px style='margin-right: 10px'> " .. QBCore.Shared.Items[v.ItemCode].label
                end
                local text = ""
                if v.IsItem then
                    text = text .. "- Purchase for : " .. v.Price .. " "..v.Currency.." <br>"
                else
                    text = text .. "- Purchase for : $" .. v.Price .. " "..v.Currency.." <br>"
                end
                item.text = text
                if LVL >= v.Level then
                    item.params = {event = 'sayer-drugdeliveries:PurchaseMenu',args = {type = v.ItemCode, price = v.Price, currency = v.Currency,isitem = v.IsItem, level = v.Level}}
                else
                    item.params = {event = 'sayer-drugdeliveries:NeedHigherLevel',args = {needed = v.LVLNeeded,level = LVL}}
                end
                table.insert(columns, item)
            else
                print('^1SAYER-DRUGDELIVERIES: ^7Cannot Find ^4'..v.ItemCode..' ^7From ^4ShopItems ^7In ^4Shared/Items.lua')
            end
        end
    end

    exports['qb-menu']:openMenu(columns)
end

RegisterNetEvent("sayer-drugdeliveries:PurchaseMenu", function(args)
    local delmenu = exports['qb-input']:ShowInput({
        header = "How Many "..QBCore.Shared.Items[args.type].label.." would you like to purchase?",
		submitText = "Buy!",
        inputs = {
            {text = "Amount(#)",name = "amount", type = "number", isRequired = true },
        }
    })
    if delmenu ~= nil then
        if delmenu.amount == nil then return end
        TriggerEvent("sayer-drugdeliveries:ClientCheck",args.type,tonumber(delmenu.amount),args.price,args.currency,args.isitem)
        if Config.DebugCode then print("After Buy Item") end
        if Config.DebugCode then print(delmenu.amount) end
        if Config.DebugCode then print("Item Purchased = "..args.type.."!") end
    end
end)

RegisterNetEvent('sayer-drugdeliveries:ClientCheck',function(daitem,daamount,daprice,dacurrency,daisitem)
    TriggerServerEvent("sayer-drugdeliveries:FinishPurchase",daitem,daamount,daprice,dacurrency,daisitem)
end)

RegisterNetEvent('sayer-drugdeliveries:NeedHigherLevel', function(args)
    QBCore.Functions.Notify('You need to be Level '..args.needed..' to buy this item', 'error')
end)

function CleanMoney()
    for k,v in pairs(Config.Cleaning) do
        if v.Enable then
            local currency = v.Currency
            local needed = 0
            if currency.isItem then
                needed = math.random(currency.MaxClean.Min,currency.MaxClean.Max)
                if currency.ValuePerOne == 'UseInfo' then
                    needed = 1
                end
                if QBCore.Functions.HasItem(k,needed) then
                    TriggerServerEvent('sayer-drugdeliveries:CleanMoney',true,k,needed)
                end
            else
                needed = math.random(currency.MaxClean.Min,currency.MaxClean.Max)
                if HasMoney(k,needed) then
                    TriggerServerEvent('sayer-drugdeliveries:CleanMoney',false,k,needed)
                end
            end
        end
    end
end
   
function HasMoney(type,amount)
    local ped = QBCore.Functions.GetPlayerData()
    local account = ped.money[type]
    if account ~= nil and account >= amount then
        return true
    else
        return false
    end
end

function DestroySZone(zone)
    exports['qb-target']:RemoveZone(zone)
end

function SDDNotify(title,msg,type,time)
    if Config.Notify == 'qb' then
        QBCore.Functions.Notify(msg,type,time)
    elseif Config.Notify == 'okok' then
        exports['okokNotify']:Alert(title, msg, time, type, false)
    elseif Config.Notify == 'qs' then
        exports['qs-notify']:Alert(msg, time, type)
    end
end

AddEventHandler('onResourceStop', function(t) if t ~= GetCurrentResourceName() then return end
	for k in pairs(TargetZone) do exports['qb-target']:RemoveZone(k) end
    for k in pairs(TargetPed) do exports['qb-target']:RemoveTargetEntity(k) end
end)
