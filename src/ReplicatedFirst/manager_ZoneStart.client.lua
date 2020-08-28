-- @@ Zone creator
-- @@ Creates all zones within the zone folder

--// Services
local playerService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local modules = replicatedStorage:WaitForChild("Modules")
local utils = require(modules.helper_Utility)
local zones = require(modules.manager_Zones)

--// Objects
local zoneFolder = workspace:WaitForChild("Zones")
local localPlayer = playerService.LocalPlayer

--// Values
local debug = true
local lastEntered;

--## Registering all parts as their own zone
for _,Part in pairs(zoneFolder:GetChildren()) do
    if debug == true then
        Part.Transparency = 0.7
    else
        Part.Transparency = 1
    end

    local newZone = zones.new({Part})

    newZone.PlayerLeft:Connect(function()
        utils.errorOut(script,"left ".. Part.Name,31)
    end)

    newZone.PlayerEntered:Connect(function()
        if lastEntered == Part.Name then return end
        utils.errorOut(script,"entered ".. Part.Name,35)
    end)
end

zones:Start()