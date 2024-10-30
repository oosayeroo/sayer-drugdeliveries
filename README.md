Discord - https://discord.gg/3WYz3zaqG5
preview - 

Add to your shared/items.lua
```lua
--sayer-drugdeliveries
    ['drug_package_01']                 = {['name'] = 'drug_package_01',                   ['label'] = 'Drug Package',              ['weight'] = 1000,         ['type'] = 'item',         ['image'] = 'drug_package.png',            ['unique'] = false,         ['useable'] = true,     ['shouldClose'] = true,       ['combinable'] = nil,   ['description'] = 'package of different drugs'},
    ['drug_package_02']                 = {['name'] = 'drug_package_02',                   ['label'] = 'Drug Package',              ['weight'] = 1000,         ['type'] = 'item',         ['image'] = 'drug_package.png',            ['unique'] = false,         ['useable'] = true,     ['shouldClose'] = true,       ['combinable'] = nil,   ['description'] = 'package of different drugs'},
    ['drug_package_03']                 = {['name'] = 'drug_package_03',                   ['label'] = 'Drug Package',              ['weight'] = 1000,         ['type'] = 'item',         ['image'] = 'drug_package.png',            ['unique'] = false,         ['useable'] = true,     ['shouldClose'] = true,       ['combinable'] = nil,   ['description'] = 'package of different drugs'},
```

# Add to your qb-core/server/player.lua
```lua
--delivery
    PlayerData.metadata['sayerdeliveryrep'] = PlayerData.metadata['sayerdeliveryrep'] or 0
    PlayerData.metadata['sayerdeliverylevel'] = PlayerData.metadata['sayerdeliverylevel'] or 1
    
```