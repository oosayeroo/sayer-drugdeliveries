Config = {}
Config.DebugCode = false

Config.Phone = 'qs' --'qb'/'qs'/'gk' editable in unlocked client file
Config.Notify = 'qb' -- 'qb'/'okok'/'qs' supported ' editable in unlocked client file'

Config.MaxDeliveries = 5 --most amount of deliveries before having to go back and take job again
Config.DeliveryXP = 5 -- How much xp to get on delivery/ Level Amounts can be defined at the bottom of the Config file

Config.EnableVoiceRecognise = true --WIP but useable / uses 17mov's Speech Recognition script. turn put false if not using - found here https://store.17movement.net/package/5673280
Config.DeliveryPhrases = { --words you need to say when at customers door to enable the delivery
    "delivery",
    "got your drugs",
    "come collect your drugs",
    "package",
    "package for you",
}

Config.CustomShop = {
    HideLockedItems = false,
    ShowLevelRequired = true,
    InventoryLink = 'qb-inventory/html/images/',
}

Config.Dealers = { --add as many locations as you like
    {
        Enable = true,
        DebugPoly = false,
        MenuType = 'zone', --boxzone
        MenuLocation = { --location to open delivery menu
            {
                Coords = vector3(-1291.62, -280.4, 38.67),
                Emote = "knock",
                -- SpeechRecognise = {
                --     {Phrase = {"hey delivery guy","give delivery"},BlockInVehicle = true,AllowRecognitionInReverse = true},
                -- },
            },
            {
                Coords = vector3(-772.9, -187.67, 37.28),
                Emote = "knock",
                SpeechRecognise = false,
            },
            {
                Coords = vector3(683.28, -789.61, 24.5),
                Emote = "knock",
                SpeechRecognise = false,
            },
        },
        ShopItems = { --change these to fit your server 
        --ItemCode = the code of the item
        -- Price = amount it costs to buy item
        -- Level = the level you need to be able to buy item
        -- Currency = the item or account you want to but with
        -- IsItem = is Currency an item or an account like cash/bank/blackmoney etc
            [1] = {ItemCode = 'weed_nutrition',             Price = 100,    Level = 1,  Currency = "cash", IsItem = false},
            [2] = {ItemCode = 'weed_white-widow_seed',      Price = 240,    Level = 2,  Currency = "cash", IsItem = false},
            [3] = {ItemCode = 'weed_skunk_seed',            Price = 340,    Level = 3,  Currency = "cash", IsItem = false}, 
            [4] = {ItemCode = 'weed_purple-haze_seed',      Price = 980,    Level = 4,  Currency = "cash", IsItem = false},
            [5] = {ItemCode = 'weed_og-kush_seed',          Price = 20,     Level = 5,  Currency = "cash", IsItem = false},
            [6] = {ItemCode = 'weed_amnesia_seed',          Price = 610,    Level = 10, Currency = "cash", IsItem = false},
            [7] = {ItemCode = 'weed_ak47_seed',             Price = 430,    Level = 20, Currency = "cash", IsItem = false},
        },
    },
    {
        Enable = true,
        DebugPoly = false,
        MenuType = 'ped', --ped spawns (if this is ped then you must define the Model in each MenuLocation)
        MenuLocation = { --location to open delivery menu
            {
                Model = 'g_m_y_ballaeast_01',
                Coords = vector4(97.63, -1905.47, 21.08, 144.79),
                Emote = "idle3",
                -- SpeechRecognise = {
                --     {Phrase = {"hey delivery guy","give delivery"},BlockInVehicle = true,AllowRecognitionInReverse = true},
                -- },
            },
            {
                Model = 'g_m_y_famdnf_01',
                Coords = vector4(-35.73, -1447.07, 31.49, 165.95),
                Emote = "idle3",
                SpeechRecognise = false,
            },
            {
                Model = 'g_m_y_lost_02',
                Coords = vector4(945.77, -116.43, 74.35, 261.89),
                Emote = "idle3",
                SpeechRecognise = false,
            },
        },
        ShopItems = { 
            [1] = {ItemCode = 'weed_nutrition',             Price = 100,    Level = 1,  Currency = "cash", IsItem = false},
            [2] = {ItemCode = 'weed_white-widow_seed',      Price = 240,    Level = 2,  Currency = "cash", IsItem = false},
            [3] = {ItemCode = 'weed_skunk_seed',            Price = 340,    Level = 3,  Currency = "cash", IsItem = false}, 
            [4] = {ItemCode = 'weed_purple-haze_seed',      Price = 980,    Level = 4,  Currency = "cash", IsItem = false},
            [5] = {ItemCode = 'weed_og-kush_seed',          Price = 20,     Level = 5,  Currency = "cash", IsItem = false},
            [6] = {ItemCode = 'weed_amnesia_seed',          Price = 610,    Level = 10, Currency = "cash", IsItem = false},
            [7] = {ItemCode = 'weed_ak47_seed',             Price = 430,    Level = 20, Currency = "cash", IsItem = false},
        },
    },
}

Config.DeliveryItems = { -- i would recommend using items that players cant use anywhere apart from within this script to avoid exploits
    {ItemCode = 'drug_package_01',      Min = 1,    Max = 2,    LevelNeeded = 1,    RewardEach = {Min = 10,Max = 20}}, 
    {ItemCode = 'drug_package_02',      Min = 1,    Max = 2,    LevelNeeded = 5,    RewardEach = {Min = 30,Max = 40}},
    {ItemCode = 'drug_package_03',      Min = 1,    Max = 3,    LevelNeeded = 10,    RewardEach = {Min = 50,Max = 60}},
    --EXAMPLE
    --{
    --    ItemCode = the code of the item     
    --    Min = the minumum amount you can deliver at once
    --    Max = the max amount you can deliver at once
    --    LevelNeeded = the level you must hold to deliver this item   
    --    RewardEach = {
    --        Min = mininum value per item
    --        Max = max value per item
    --    },  
}

Config.CleanChancePerDropOff = 20 -- in % (20 = 20% chance of cleaning your items from below)
Config.Cleaning = { -- you can add more options as long as you follow one of these 3 templates
    ['dirtymoney'] = { --itemcode or name of the account(cash/bank/blackmoney) to clean
        Enable = true, --quickly enable or disable certain cleaning
        Currency = { 
            isItem = true, --is currency an item or account like blackmoney?
            ValuePerOne = {Min=5,Max=10}, --value of 1 (is multplied by the variable below this one) / can also be 'UseInfo'
            MaxClean = {Min=1,Max=3}, --how many to clean at one time (per customer drop off)
        },
    },
    ['blackmoney'] = {
        Enable = false,
        Currency = {
            isItem = false,
            ValuePerOne = {Min=5,Max=10},
            MaxClean = {Min=1,Max=3},
        },
    },
    ['markedbills'] = {
        Enable = true,
        Currency = {
            isItem = true,
            ValuePerOne = 'UseInfo', --uses the info of the item (for example when markd bills are given it has a value generated within the item metadata) this will use that info
            MaxClean = {Min=1,Max=3},
        },
    },
}

Config.DeliveryLocations = {
    --mirror park
    {Coords = vector3(996.89, -729.57, 57.82), Label = "Mirror Park",},
    {Coords = vector3(886.75, -608.18, 58.45), Label = "Mirror Park",},
    {Coords = vector3(987.37, -433.07, 64.05), Label = "Mirror Park",},
    {Coords = vector3(1265.74, -458.04, 70.52), Label = "Mirror Park",},
    {Coords = vector3(1265.77, -648.59, 68.12), Label = "Mirror Park",},
    --east LS
    {Coords = vector3(1193.62, -1656.51, 43.03), Label = "Fudge Lane",},
    {Coords = vector3(1230.57, -1590.88, 53.77), Label = "Fudge Lane",},
    {Coords = vector3(1259.38, -1761.87, 49.66), Label = "Amarillo Vista",},
    {Coords = vector3(1312.29, -1697.32, 58.23), Label = "Amarillo Vista",},
    --southside LS
    {Coords = vector3(489.6, -1714.04, 29.71), Label = "Jamestown St",},
    {Coords = vector3(495.43, -1823.42, 28.87), Label = "Jamestown St",},
    {Coords = vector3(368.62, -1895.68, 25.18), Label = "Jamestown St",},
    {Coords = vector3(76.29, -1948.18, 21.17), Label = "Grove St",},
    {Coords = vector3(46.11, -1864.32, 23.28), Label = "Grove St",},
    {Coords = vector3(-20.47, -1858.84, 25.41), Label = "Grove St",},
    {Coords = vector3(-64.49, -1449.57, 32.52), Label = "Forum Dr",},
    {Coords = vector3(16.6, -1443.79, 30.95), Label = "Forum Dr",},
    {Coords = vector3(240.75, -1687.73, 29.7), Label = "Brouge Ave",},
    {Coords = vector3(250.03, -1730.87, 29.67), Label = "Brouge Ave",},
    {Coords = vector3(216.48, -1717.33, 29.68), Label = "Brouge Ave",},
    {Coords = vector3(443.4, -1707.26, 29.71), Label = "R Lowenstein Blvd",},
    {Coords = vector3(419.11, -1735.52, 29.61), Label = "R Lowenstein Blvd",},
    {Coords = vector3(320.64, -1759.8, 29.64), Label = "R Lowenstein Blvd",},
    --west side LS
    {Coords = vector3(-1057.73, -1540.7, 5.05), Label = "Melanoma St",},
    {Coords = vector3(-1114.79, -1577.69, 4.54), Label = "Melanoma St",},
    {Coords = vector3(-1129.99, -1496.7, 4.43), Label = "Goma St",},
    {Coords = vector3(-1063.6, -1160.36, 2.75), Label = "Invention Ct",},
    --vinewood/rockford
    {Coords = vector3(-842.22, -25.1, 40.4), Label = "Portola Dr",},
    {Coords = vector3(-930.31, 19.48, 48.53), Label = "Caesars Pl",},
    {Coords = vector3(-998.18, 158.21, 62.32), Label = "Steele Way",},
    {Coords = vector3(-913.04, 108.23, 55.71), Label = "Steele Way",},
    {Coords = vector3(-881.33, 363.79, 85.36), Label = "Sth Milton Dr",},
    {Coords = vector3(-884.57, 518.04, 92.44), Label = "Sth Milton Dr",},
    {Coords = vector3(-947.92, 567.74, 101.51), Label = "Sth Milton Dr",},
    {Coords = vector3(-1308.14, 449.0, 100.97), Label = "Mad Wayne Thunder Dr",},
    {Coords = vector3(-1215.84, 457.88, 92.06), Label = "Mad Wayne Thunder Dr",},
    {Coords = vector3(-1052.21, 432.54, 77.26), Label = "Mad Wayne Thunder Dr",},
    {Coords = vector3(-1291.88, 650.51, 141.5), Label = "North Sheldon Ave",},
    {Coords = vector3(-1218.53, 665.22, 144.53), Label = "North Sheldon Ave",},
    {Coords = vector3(-1117.8, 761.45, 164.29), Label = "North Sheldon Ave",},
    {Coords = vector3(-596.79, 851.48, 211.48), Label = "Milton Rd",},
    {Coords = vector3(-495.63, 738.56, 163.03), Label = "Milton Rd",},
    {Coords = vector3(-446.16, 686.33, 153.12), Label = "Kimble Hill Dr",},
    {Coords = vector3(-232.3, 588.2, 190.54), Label = "Kimble Hill Dr",},
    {Coords = vector3(85.01, 561.71, 182.77), Label = "Whispymound Dr",},
    {Coords = vector3(224.04, 513.43, 140.92), Label = "Wild Oats Dr",},
    {Coords = vector3(79.83, 486.17, 148.2), Label = "Wild Oats Dr",},
    {Coords = vector3(-7.91, 467.87, 145.85), Label = "Wild Oats Dr",},
}

Config.Levels = { 
    --Level System = 
    --[1] = the level,
    -- NextLevel = amount of xp to gain to reach next level/ xp resets to 0 on levelup,
    -- CashBoost = percentage increase in money reward. 1 = normal money/ 2 = double money/ 1.50 = 50% extra
    [1] = {NextLevel = 100,CashBoost=false},
    [2] = {NextLevel = 200,CashBoost=false},
    [3] = {NextLevel = 300,CashBoost=false},
    [4] = {NextLevel = 400,CashBoost=false},
    [5] = {NextLevel = 500,CashBoost=false}, 
    [6] = {NextLevel = 600,CashBoost=false},
    [7] = {NextLevel = 700,CashBoost=false},
    [8] = {NextLevel = 800,CashBoost=false},
    [9] = {NextLevel = 900,CashBoost=false},
    [10] = {NextLevel = 1000,CashBoost=1.10}, --10% boost to money reward starts
    [11] = {NextLevel = 1100,CashBoost=1.10},
    [12] = {NextLevel = 1200,CashBoost=1.10},
    [13] = {NextLevel = 1300,CashBoost=1.10},
    [14] = {NextLevel = 1400,CashBoost=1.10},
    [15] = {NextLevel = 1500,CashBoost=1.10},
    [16] = {NextLevel = 1600,CashBoost=1.10},
    [17] = {NextLevel = 1700,CashBoost=1.10},
    [18] = {NextLevel = 1800,CashBoost=1.10},
    [19] = {NextLevel = 1900,CashBoost=1.10},
    [20] = {NextLevel = 2000,CashBoost=1.20}, --20% boost to money reward starts
    [21] = {NextLevel = 2100,CashBoost=1.20},
    [22] = {NextLevel = 2200,CashBoost=1.20},
    [23] = {NextLevel = 2300,CashBoost=1.20},
    [24] = {NextLevel = 2400,CashBoost=1.20},
    [25] = {NextLevel = 2500,CashBoost=1.20},
    [26] = {NextLevel = 2600,CashBoost=1.20},
    [27] = {NextLevel = 2700,CashBoost=1.20},
    [28] = {NextLevel = 2800,CashBoost=1.20},
    [29] = {NextLevel = 2900,CashBoost=1.20},
    [30] = {NextLevel = 3000,CashBoost=1.30}, --30% boost to money reward starts
    [31] = {NextLevel = 3100,CashBoost=1.30},
    [32] = {NextLevel = 3200,CashBoost=1.30},
    [33] = {NextLevel = 3300,CashBoost=1.30},
    [34] = {NextLevel = 3400,CashBoost=1.30},
    [35] = {NextLevel = 3500,CashBoost=1.30},
    [36] = {NextLevel = 3600,CashBoost=1.30},
    [37] = {NextLevel = 3700,CashBoost=1.30},
    [38] = {NextLevel = 3800,CashBoost=1.30},
    [39] = {NextLevel = 3900,CashBoost=1.30},
    [40] = {NextLevel = 4000,CashBoost=1.40}, --40% boost to money reward starts
    [41] = {NextLevel = 4100,CashBoost=1.40},
    [42] = {NextLevel = 4200,CashBoost=1.40},
    [43] = {NextLevel = 4300,CashBoost=1.40},
    [44] = {NextLevel = 4400,CashBoost=1.40},
    [45] = {NextLevel = 4500,CashBoost=1.40},
    [46] = {NextLevel = 4600,CashBoost=1.40},
    [47] = {NextLevel = 4700,CashBoost=1.40},
    [48] = {NextLevel = 4800,CashBoost=1.40},
    [49] = {NextLevel = 4900,CashBoost=1.40},
    [50] = {NextLevel = 5000,CashBoost=1.50}, --50% boost to money reward starts
    [51] = {NextLevel = 5100,CashBoost=1.50},
    [52] = {NextLevel = 5200,CashBoost=1.50},
    [53] = {NextLevel = 5300,CashBoost=1.50},
    [54] = {NextLevel = 5400,CashBoost=1.50},
    [55] = {NextLevel = 5500,CashBoost=1.50},
    [56] = {NextLevel = 5600,CashBoost=1.50},
    [57] = {NextLevel = 5700,CashBoost=1.50},
    [58] = {NextLevel = 5800,CashBoost=1.50},
    [59] = {NextLevel = 5900,CashBoost=1.50},
    [60] = {NextLevel = 6000,CashBoost=1.60},  --60% boost to money reward starts
    [61] = {NextLevel = 6100,CashBoost=1.60},
    [62] = {NextLevel = 6200,CashBoost=1.60},
    [63] = {NextLevel = 6300,CashBoost=1.60},
    [64] = {NextLevel = 6400,CashBoost=1.60},
    [65] = {NextLevel = 6500,CashBoost=1.60},
    [66] = {NextLevel = 6600,CashBoost=1.60},
    [67] = {NextLevel = 6700,CashBoost=1.60},
    [68] = {NextLevel = 6800,CashBoost=1.60},
    [69] = {NextLevel = 6900,CashBoost=1.60},
    [70] = {NextLevel = 7000,CashBoost=1.70},  --70% boost to money reward starts
    [71] = {NextLevel = 7100,CashBoost=1.70},
    [72] = {NextLevel = 7200,CashBoost=1.70},
    [73] = {NextLevel = 7300,CashBoost=1.70},
    [74] = {NextLevel = 7400,CashBoost=1.70},
    [75] = {NextLevel = 7500,CashBoost=1.70},
    [76] = {NextLevel = 7600,CashBoost=1.70},
    [77] = {NextLevel = 7700,CashBoost=1.70},
    [78] = {NextLevel = 7800,CashBoost=1.70},
    [79] = {NextLevel = 7900,CashBoost=1.70},
    [80] = {NextLevel = 8000,CashBoost=1.80},  --80% boost to money reward starts
    [81] = {NextLevel = 8100,CashBoost=1.80},
    [82] = {NextLevel = 8200,CashBoost=1.80},
    [83] = {NextLevel = 8300,CashBoost=1.80},
    [84] = {NextLevel = 8400,CashBoost=1.80},
    [85] = {NextLevel = 8500,CashBoost=1.80},
    [86] = {NextLevel = 8600,CashBoost=1.80},
    [87] = {NextLevel = 8700,CashBoost=1.80},
    [88] = {NextLevel = 8800,CashBoost=1.80},
    [89] = {NextLevel = 8900,CashBoost=1.80},
    [90] = {NextLevel = 9000,CashBoost=1.90},  --90% boost to money reward starts
    [91] = {NextLevel = 9100,CashBoost=1.90},
    [92] = {NextLevel = 9200,CashBoost=1.90},
    [93] = {NextLevel = 9300,CashBoost=1.90},
    [94] = {NextLevel = 9400,CashBoost=1.90},
    [95] = {NextLevel = 9500,CashBoost=1.90},
    [96] = {NextLevel = 9600,CashBoost=1.90},
    [97] = {NextLevel = 9700,CashBoost=1.90},
    [98] = {NextLevel = 9800,CashBoost=1.90},
    [99] = {NextLevel = 9900,CashBoost=1.90},
    [100] = {NextLevel = 0,CashBoost=2.0}, -- --100% boost to money reward starts
}