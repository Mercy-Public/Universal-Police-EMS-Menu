local QBCore = exports['qb-core']:GetCoreObject()
-- 🔲 🔲 --
local function IsAuthorized(job)
    return job == Config.Jobs.Police or job == Config.Jobs.Ambulance
    --return job == Config.Jobs.Police or job == Config.Jobs.Ambulance or job == Config.Jobs.thirdjob

end
-- 🔲 🔲 --
local function GetVehicleList(job)
    return Config.GetVehicleList(job)
end
-- 🔲 🔲 --
local function DeleteCurrentVehicle()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
        lib.notify({
            title = 'Vehicle Deleted',
            description = 'Your previous vehicle has been stored.',
            type = 'success'
        })
    end
end
-- 🔲 🔲 --
local function HandleExistingVehicle()
    local input = lib.inputDialog('Vehicle Spawn', {
        {type = 'select', label = 'You are currently in a vehicle. What would you like to do?', options = {
            {label = 'Depot Current Vehicle', value = 'delete'},
            {label = 'Leave Current Vehicle', value = 'leave'}
        }}
    })

    if not input or #input == 0 then return false end

    if input[1] == 'delete' then
        DeleteCurrentVehicle()
        return true
    elseif input[1] == 'leave' then
        return true
    end

    return false
end
-- 🔲 🔲 --
local function SpawnVehicle(model, location)
    if not location or type(location) ~= "vector4" then
        print("Error: Invalid location for vehicle spawn")
        return
    end

    local playerPed = PlayerPedId()
    local currentVehicle = GetVehiclePedIsIn(playerPed, false)

    if currentVehicle ~= 0 then
        if not HandleExistingVehicle() then
            return
        end
    end

    QBCore.Functions.SpawnVehicle(model, function(vehicle)
        if not vehicle then
            lib.notify({
                title = 'Vehicle Spawn Failed',
                description = 'Unable to spawn the vehicle.',
                type = 'error'
            })
            return
        end
        
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleEngineOn(vehicle, true, true, false)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        local plate = QBCore.Functions.GetPlate(vehicle)
        TriggerEvent("vehiclekeys:client:SetOwner", plate)
        SetEntityHeading(vehicle, location.w)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        SetVehicleEngineOn(vehicle, true, true, false)
        
        lib.notify({
            title = 'Vehicle Spawned',
            description = 'You are now in the driver seat.',
            type = 'success'
        })

        local playerCoords = GetEntityCoords(PlayerPedId())
        if #(playerCoords - vector3(location.x, location.y, location.z)) > 5.0 then
            lib.showTextUI('[E] - Depart Immediately', {
                position = "top-center",
                icon = 'car',
                style = {
                    borderRadius = 0,
                    backgroundColor = '#8B0000',
                    color = 'white'
                }
            })
            
            Citizen.CreateThread(function()
                local startTime = GetGameTimer()
                while GetGameTimer() - startTime < 5000 do
                    if IsControlJustReleased(0, 38) then 
                        lib.hideTextUI()
                        break
                    end
                    Citizen.Wait(0)
                end
                lib.hideTextUI()
            end)
        end
    end, vector3(location.x, location.y, location.z), true)
end
-- 🔲 🔲 --
local function IsNearSpawnLocation()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for _, location in ipairs(Config.SpawnLocations) do                           -- 🔲 🔲 -- Change this for vehicle distance access from vector
        if #(playerCoords - vector3(location.coords.x, location.coords.y, location.coords.z)) < 150.0 then
            return true
        end
    end
    return false
end
-- 🔲 🔲 --
local function IsNearShopLocation()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for _, location in ipairs(Config.ShopLocations) do
                                  -- 🔲 🔲 -- Change this for shop distance access from vector
        if #(playerCoords - location.coords) < 10.0 then
            return true
        end
    end
    return false
end

-- 🔲 🔲 --
local function OpenSpawnLocationMenu(model)
    if not IsNearSpawnLocation() then
        lib.notify({
            title = 'Cannot Spawn Vehicle',
            description = 'You must be near a designated spawn location to spawn a vehicle.',
            type = 'error'
        })
        return
    end

    local options = {
        {
            title = "Current Location",
            description = "Spawn vehicle at your current location",
            onSelect = function()
                local playerCoords = GetEntityCoords(PlayerPedId())
                local heading = GetEntityHeading(PlayerPedId())
                SpawnVehicle(model, vector4(playerCoords.x, playerCoords.y, playerCoords.z, heading))
            end
        }
    }

    for _, location in ipairs(Config.SpawnLocations) do
        table.insert(options, {
            title = location.name,
            description = "Spawn vehicle at " .. location.name,
            onSelect = function()
                SpawnVehicle(model, location.coords)
            end
        })
    end

    lib.registerContext({
        id = 'spawn_location_menu',
        title = 'Select Spawn Location',
        options = options
    })

    lib.showContext('spawn_location_menu')
end
-- 🔲 🔲 --
local function OpenVehicleMenu(job)
    local vehicles = GetVehicleList(job)
    local options = {}
    local PlayerData = QBCore.Functions.GetPlayerData()
    local playerGrade = PlayerData.job.grade.level

    for _, vehicle in ipairs(vehicles) do
        if playerGrade >= vehicle.grade then
            table.insert(options, {
                title = vehicle.name,
                description = "Select " .. vehicle.name,
                onSelect = function()
                    OpenSpawnLocationMenu(vehicle.model)
                end
            })
        end
    end

    lib.registerContext({
        id = 'vehicle_spawn_menu',
        title = job:gsub("^%l", string.upper) .. ' Vehicle Selection',
        options = options
    })

    lib.showContext('vehicle_spawn_menu')
end
-- 🔲 🔲 --
local function OpenShopMenu(job)
    local items = Config.GetShopItems(job)
    local options = {}
    local PlayerData = QBCore.Functions.GetPlayerData()
    local playerGrade = PlayerData.job.grade.level

    for _, item in ipairs(items) do
        if playerGrade >= item.grade then

            local itemDetails = exports.ox_inventory:Items()[item.name]

            local itemLabel = itemDetails and itemDetails.label or item.name

            table.insert(options, {
                title = itemLabel,
                description = "Get " .. itemLabel,
                onSelect = function()
                    TriggerServerEvent('emergency:server:giveItem', item.name)
                end
            })
        end
    end

    lib.registerContext({
        id = 'shop_menu',
        title = job:gsub("^%l", string.upper) .. ' Shop',
        options = options
    })

    lib.showContext('shop_menu')
end


-- 🔲 🔲 --
local function IsNearShopLocation()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for _, location in ipairs(Config.ShopLocations) do
                                  -- 🔲 🔲 -- Change this for shop distance from vector
        if #(playerCoords - location.coords) < 10.0 then
            return true
        end
    end
    return false
end
-- 🔲 🔲 --
local function openMainMenu()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if not IsAuthorized(PlayerData.job.name) then
        lib.notify({
            title = 'Unauthorized',
            description = 'You are not authorized to use this menu.',
            type = 'error'
        })
        return
    end

    lib.registerContext({
        id = 'main_menu',
        title = 'Emergency Services Menu',
        options = {
            {
                title = "Police and Medical Actions",
                description = "Access police and medical actions",
                menu = 'emergency_actions'
            },
            {
                title = "Spawn Vehicle",
                description = "Open vehicle spawn menu",
                onSelect = function()
                    if IsNearSpawnLocation() then
                        OpenVehicleMenu(PlayerData.job.name)
                    else
                        lib.notify({
                            title = 'Too Far',
                            description = 'You must be near a designated location to spawn vehicles.',
                            type = 'error'
                        })
                    end
                end
            },
            {
                title = "Depot Vehicle",
                description = "Store your current vehicle",
                onSelect = function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    if vehicle ~= 0 then
                        DeleteCurrentVehicle()
                    else
                        lib.notify({
                            title = 'No Vehicle',
                            description = 'You are not in a vehicle to depot.',
                            type = 'error'
                        })
                    end
                end
            },
            {
                title = "Shop",
                description = "Access job-specific shop",
                onSelect = function()
                    if IsNearShopLocation() then
                        OpenShopMenu(PlayerData.job.name)
                    else
                        lib.notify({
                            title = 'Too Far',
                            description = 'You must be near a designated shop location to access the shop.',
                            type = 'error'
                        })
                    end
                end
            }
        }
    })

    lib.showContext('main_menu')
end
-- 🔲 🔲 --
local function setupEmergencyActionsMenu()
    lib.registerContext({
        id = 'emergency_actions',
        title = 'Emergency Services Menu',
        menu = 'main_menu',
        options = {
            {
                title = "Cuff Player",
                description = "Restrain a player",
                onSelect = function()
                    TriggerEvent("police:client:CuffPlayer")
                end
            },
            {
                title = "Escort Player",
                description = "Escort a player",
                onSelect = function()
                    TriggerEvent("police:client:EscortPlayer")
                end
            },
            {
                title = "Place In Vehicle",
                description = "PIV",
                onSelect = function()
                    TriggerEvent("police:client:PutPlayerInVehicle")
                end
            },
            {
                title = "Take Out Of Vehicle",
                description = "TOOV",
                onSelect = function()
                    TriggerEvent("police:client:SetPlayerOutVehicle")
                end
            },
            {
                title = "Search Player",
                description = "Search a player's inventory",
                onSelect = function()
                    TriggerEvent("police:client:SearchPlayer")
                end
            },
            {
                title = "Check Status",
                description = "Check a player's medical status",
                onSelect = function()
                    TriggerEvent("hospital:client:CheckStatus")
                end
            },
            {
                title = "Revive Player",
                description = "Revive an unconscious player",
                onSelect = function()
                    TriggerEvent("hospital:client:RevivePlayer")
                end
            },
            {
                title = "Place Object",
                description = "Place a traffic object",
                menu = 'place_object_menu'
            },
            {
                title = "Remove Object",
                description = "Remove a placed object",
                onSelect = function()
                    TriggerEvent("police:client:deleteObject")
                end
            }
        }
    })
end
-- 🔲 🔲 --
local function setupPlaceObjectMenu()
    lib.registerContext({
        id = 'place_object_menu',
        title = 'Place Object',
        menu = 'emergency_actions',
        options = {
            { title = "Cone", description = "Place a traffic cone",
                onSelect = function()
                    TriggerEvent("police:client:spawnCone")
                end
            },
            {
                title = "Barrier", description = "Place a barrier",
                onSelect = function()
                    TriggerEvent("police:client:spawnBarrier")
                end
            },
        }
    })
end
-- 🔲 🔲 --
RegisterCommand(Config.Commands.OpenEmergencyMenu, function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if IsAuthorized(PlayerData.job.name) then
        setupEmergencyActionsMenu()
        setupPlaceObjectMenu()
        openMainMenu()
    else
        lib.notify({
            title = 'Unauthorized',
            description = 'You are not authorized to use this menu.',
            type = 'error'
        })
    end
end, false)

-- 🔲 🔲 -- Optional

--[[ AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    print('Resource ' .. resourceName .. ' started. Use /' .. Config.Commands.OpenEmergencyMenu .. ' to open the Emergency Services Menu if you are authorized.')
end) ]]