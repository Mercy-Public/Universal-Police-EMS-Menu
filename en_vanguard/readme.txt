Features

Vehicle Spawning: Allows players to spawn vehicles at specific locations such as police stations or ambulance centers. 
Config.GetVehicleList = function(job)
-<>-<>-<>-<>-<>-<>-<>-<>-<>-
Job Item Management: Automatically assigns job-specific items, such as police tools or medical equipment, based on the player's job (police, ambulance, etc.).
Config.GetShopItems = function(job)

Config.ShopLocations = {
    {name = "Mission Row Police Department",    coords = vector3(445.72, -982.66, 30.69)},
    {name = "Sandy Shores Sheriffs Department", coords = vector3(1865.27, 3690.0, 34.24)},
    {name = "Paleto Bay Sheriffs Department",   coords = vector3(-447.54, 6013.42, 31.72)},
    {name = "Bolingbroke Prison",               coords = vector3(1849.22, 2585.99, 45.67)},
    {name = "Pillbox",                          coords = vector3(308.24, -591.73, 43.29)},
}

added to support direct control over shop locations

-<>-<>-<>-<>-<>-<>-<>-<>-<>-
Customizable Spawn Points: The config file allows you to easily configure various spawn points and stations.
Config.SpawnLocations
-<>-<>-<>-<>-<>-<>-<>-<>-<>-

### Installation
To install the script, follow these simple steps:

1. Download the script files.
2. Place the Mercy_Vanguard_001 file into your server’s resource directory.
3. Add the following line to your server configuration file (server.cfg): `ensure Mercy_Vanguard_001`
4. Customize the spawn locations and job items in the `config.lua` file to suit your server's needs.

### Configuration

The script comes with a customizable config file (`config.lua`). Here are some of the key settings you can adjust:

* **Spawn Locations**: You can add or modify spawn points for vehicle spawning. Each spawn point is identified by its name and coordinates.
* **Job-Specific Items**: You can define items for each job role. For example, police officers might get radios and handcuffs, while ambulance workers could receive first aid kits and defibrillators.

### Example Configurations

In the configuration file, you can define the spawn locations and items like this:

For spawn locations: `Station 1: Located at coordinates (-1061.95, -1420.94, 4.63, 344.18)` `Sandy Shores: Located at coordinates (1795.77, 3614.49, 34.28, 295.3)`

For items:

* **Police**: Includes items like a radio and handcuffs.
* **Ambulance**: Includes items like first aid kits and defibrillators.




--------------------



09/30/2024


Config.ShopLocations = {
    {name = "Mission Row Police Department",    coords = vector3(445.72, -982.66, 30.69)},
    {name = "Sandy Shores Sheriffs Department", coords = vector3(1865.27, 3690.0, 34.24)},
    {name = "Paleto Bay Sheriffs Department",   coords = vector3(-447.54, 6013.42, 31.72)},
    {name = "Bolingbroke Prison",               coords = vector3(1849.22, 2585.99, 45.67)},
    {name = "Pillbox",                          coords = vector3(308.24, -591.73, 43.29)},
}

added to support direct control over shop locations


Fixed Labels not showing for items

Pending fix for weapon labels