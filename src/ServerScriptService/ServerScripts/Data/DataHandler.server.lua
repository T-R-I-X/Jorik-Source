-- Handles data events
--@@ Author .Trix

-- Services
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local httpService = game:GetService("HttpService")

-- Modules
local orderedEngine = require(replicatedStorage.Systems:WaitForChild("SystemsDirectory"))

local knit = require(orderedEngine.FetchModule("SystemsCoreFramework"))
knit.OnStart():await()

local toolMetaData = require(orderedEngine.FetchModule("ToolMetadata"))
local shieldMetaData = require(orderedEngine.FetchModule("ShieldMetadata"))

local dataService = require(knit.ServerModules:WaitForChild("DataService"))

---private functions---
local function EquipShield(itemName)
	local shield = shieldMetaData[itemName]
	
	assert(shield, "Missing shield")
	
	local shieldClass = shield.GetClass
	
	shieldClass:Equip()
end