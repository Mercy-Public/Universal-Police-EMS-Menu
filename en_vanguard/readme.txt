Commands

OpenEmergencyMenu: Default: 'esm'
Job Roles
Police: Default job is 'police'
Ambulance: Default job is 'ambulance'
You can add additional jobs by uncommenting the relevant sections in the config (thirdjob).
Vehicle List Configuration
The Config.GetVehicleList function returns a list of available vehicles based on the job role:

Police:
Various police vehicles are assigned based on grades (0-3), with corresponding vehicles.
Ambulance:
Ambulance and fire truck available for different grades.
You can add more vehicles to each job by modifying the entries under each job type.

Shop Items Configuration
The Config.GetShopItems function returns items available in shops based on the job role:

Police:
Weapons, ammunition, handcuffs, armor, radio, bandages, and first aid kits, among other items, are available.
Ambulance:
Items such as the radio, first aid kits, and a flashlight are included.

Shop and Spawn Locations
Predefined shop and spawn locations for emergency jobs:

Police:
Mission Row Police Department, Sandy Shores, Paleto Bay, Bolingbroke Prison
Ambulance:
Pillbox hospital
Coordinates for shop and spawn locations can be adjusted under Config.ShopLocations and Config.SpawnLocations.
