wait(5)

-- Author .Trix
-- Date 10/13/20

-- Services
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

-- Modules
local require = require(replicatedStorage:WaitForChild("Engine"))

local dataManager = require("DataManager")
dataManager.init()

---------------------- Private functions ---------------------- 
local function NewInstance(instanceType,instanceName,instanceParent)
	local instance = Instance.new(instanceType)
	instance.Name = instanceName
	instance.Parent = instanceParent
	
	return instance
end
	
local function Load(player)
	local dataDecoded
	
	repeat runService.Stepped:Wait() until dataManager._init == true 
	
	dataManager:GetData(player,"slot1"):Then(function(dataEncoded,dataDecoded)
		dataDecoded = dataDecoded
	end):Catch(function(...)
		warn(...)
	end)
	
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
end

--- connecting the PlayerAdded event to a function to load data 
players.PlayerAdded:Connect(Load)

for _,player in ipairs(players:GetPlayers()) do
	if player.ClassName == "Player" then
		Load(player)
	end
end