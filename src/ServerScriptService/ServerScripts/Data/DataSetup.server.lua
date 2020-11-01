-- Handles startup data init
--@@ Author Trix

-- Services
local players = game:GetService("Players")
local serverScriptService = game:GetService("ServerScriptService")
local runService = game:GetService("RunService")

-- Modules
local engine = require(serverScriptService:WaitForChild("ServerEngine"))

local dataManager = engine.load("DataManager")

---------------------- Private functions ----------------------
local function NewInstance(instanceType,instanceName,instanceParent)
	local instance = Instance.new(instanceType)
	instance.Name = instanceName
	instance.Parent = instanceParent

	return instance
end

local function Load(player)
	local dataDecoded,dataEncoded = dataManager:GetData(player)

	--- indpendant stas
	local leaderstats = player:WaitForChild("leaderstats")

	local abilityStamina = NewInstance("IntValue","abilitystamina",leaderstats)
	local stamina = NewInstance("IntValue","stamina",leaderstats)

	local backupStamina = NewInstance("IntValue","max",stamina)
	local backupAbility = NewInstance("IntValue","max",abilityStamina)

	abilityStamina.Value = 100
	stamina.Value = 150

	backupStamina.Value = 150
	backupAbility.Value = 100

	--- data dependant stats
	local dataValue = NewInstance("StringValue","Data",leaderstats)

	dataValue.Value = dataDecoded
end

--- connecting the PlayerAdded event to a function to load data
for _,player in ipairs(players:GetPlayers()) do
	if player.ClassName == "Player" then
		Load(player)
	end
end

players.PlayerAdded:Connect(Load)