-- Handles startup data init
--@@ Author Trix

-- Services
local players = game:GetService("Players")
local serverScriptService = game:GetService("ServerScriptService")
local httpService = game:GetService("HttpService")

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

	--- throwing this in a seprate thread so it doesn't stop other players from loading while it might yield
	spawn(function()
		local dataDecoded = dataManager:GetData(player)
		local leaderstats = player:FindFirstChild("leaderstats")

		assert(leaderstats ~= true, ("[DataSetup] - %s already has data loaded"):format(player.Name))

		--- indpendant stats
		leaderstats = NewInstance("Folder","leaderstats",player)

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

		local eqiupWeapon = dataDecoded["equips"]--["weapon"]
		local equipArmor = dataDecoded["equips"]--["armor"]
		local changed = false

		if eqiupWeapon == nil or equipArmor == nil then
			dataManager:SetKey(player,"equips", { ["weapon"]="Glass Sword"; ["armor"]="Cloth Armor" } )

			changed = true
		end

		if changed == true then
			dataDecoded = dataManager:GetData(player)
		end

		dataValue.Value = httpService:JSONEncode(dataDecoded)
	end)
end

--- connecting the PlayerAdded event to a function to load data
for _,player in ipairs(players:GetPlayers()) do
	Load(player)
end

players.PlayerAdded:Connect(Load)