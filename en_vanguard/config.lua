Config = {}

Config.Commands = { OpenEmergencyMenu = 'esm', }

Config.Jobs = { Police = 'police', Ambulance = 'ambulance', }
--Config.Jobs = { Police = 'police', Ambulance = 'ambulance', 'thirdjob', }


Config.GetVehicleList = function(job)
    if job == 'police' then
        return {
            { name = "Police Example",           model = "police",             grade = 0 },
            { name = "Police Example 1",         model = "police1",            grade = 1 },
            { name = "Police Example 2",         model = "police2",            grade = 2 },
            { name = "Police Example 3",         model = "police3",            grade = 3 }
        }
    elseif job == 'ambulance' then
        return {
            { name = "Ambulance",           model = "ambulance",         grade = 0 },
            { name = "FireTruk",           model = "firetruk",           grade = 1 }
--[[         }
    elseif job == 'thirdjob' then
        return {
            { name = 'placeholder', price = 0, grade = 0 },
            { name = 'placeholder', price = 0, grade = 0 },
            { name = 'placeholder', price = 0, grade = 0 },
            { name = 'placeholder', price = 0, grade = 0 } ]]
        }
    end
    return {}
end

Config.GetShopItems = function(job)
    if job == 'police' then
        return {
            { name = 'weapon_stungun', price = 0, metadata = {registered = true}, license = 'weapon', grade = 0 },
            { name = 'weapon_pistol_mk2', price = 0, metadata = {registered = true}, license = 'weapon', grade = 1 },
            { name = 'weapon_combatpdw', price = 0, metadata = {registered = true}, license = 'weapon', grade = 2 },
            { name = 'weapon_carbinerifle', price = 0, metadata = {registered = true}, license = 'weapon', grade = 3 },
            { name = 'weapon_heavysniper_mk2', price = 0, metadata = {registered = true}, license = 'weapon', grade = 4 },
            { name = 'ammo-9', price = 0, grade = 0 },
            { name = 'ammo-45', price = 0, grade = 0 },
            { name = 'ammo-rifle', price = 0, grade = 0 },
            { name = 'ammo-rifle2', price = 0, grade = 0 },
            { name = 'handcuffs', price = 0, grade = 0 },
            { name = 'weapon_flashlight', price = 0, grade = 0 },
            { name = 'armor', price = 0, grade = 0 },
            { name = 'radio', price = 0, grade = 0 },
            { name = 'heavyarmor', price = 0, grade = 0 },
            { name = 'bandage', price = 0, grade = 0 },
            { name = 'firstaid', price = 0, grade = 0 },
            { name = 'ifaks', price = 0, grade = 0 },
            { name = 'weapon_fireextinguisher', price = 0, grade = 0 }
        }
    elseif job == 'ambulance' then
        return {
            { name = 'radio', price = 0, grade = 0 },
            { name = 'firstaid', price = 0, grade = 0 },
            { name = 'weapon_flashlight', price = 0, grade = 0 },
            { name = 'weapon_fireextinguisher', price = 0, grade = 0 }
--[[         }
    elseif job == 'thirdjob' then
        return {
            { name = 'placeholder', price = 0, grade = 0 },
            { name = 'placeholder', price = 0, grade = 0 },
            { name = 'placeholder', price = 0, grade = 0 },
            { name = 'placeholder', price = 0, grade = 0 } ]]
        }
    end
    return {}
end

Config.ShopLocations = {
    {name = "Mission Row Police Department",    coords = vector3(445.72, -982.66, 30.69)},
    {name = "Sandy Shores Sheriffs Department", coords = vector3(1865.27, 3690.0, 34.24)},
    {name = "Paleto Bay Sheriffs Department",   coords = vector3(-447.54, 6013.42, 31.72)},
    {name = "Bolingbroke Prison",               coords = vector3(1849.22, 2585.99, 45.67)},
    {name = "Pillbox",                          coords = vector3(308.24, -591.73, 43.29)},
}

Config.SpawnLocations = {
    {name = "Mission Row Police Department",    coords = vector4(408.02, -984.28, 29.27, 56.39)},
    {name = "Sandy Shores Sheriffs Department", coords = vector4(1867.98, 3653.25, 33.89, 21.2)},
    {name = "Paleto Bay Sheriffs Department",   coords = vector4(-483.09, 6025.02, 31.34, 223.05)},
    {name = "Bolingbroke Prison",               coords = vector4(1854.84, 2615.15, 45.67, 185.27)},
    {name = "Pillbox",                          coords = vector4(290.3, -591.75, 43.17, 339.25)}
}

Config.DebugMode = false

return Config