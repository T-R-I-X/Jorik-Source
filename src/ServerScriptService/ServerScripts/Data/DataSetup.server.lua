-- Handles startup data init
--@@ Author Trix

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local httpService = game:GetService("HttpService")

-- Modules
local SystemsDirectory = require(ReplicatedStorage.Systems:WaitForChild("SystemsDirectory"))

local knit = require(SystemsDirectory.FetchModule("SystemsCoreFramework"))
knit.OnStart():await()

local ToolMetaData = require(SystemsDirectory.FetchModule("ToolMetadata"))
local ShieldMetaData = require(SystemsDirectory.FetchModule("ShieldMetadata"))

local DataService = require(knit.ServerModules:WaitForChild("DataService"))

---------------------- Private functions ----------------------
local function NewInstance(instanceType,instanceName,instanceParent)
	local instance = Instance.new(instanceType)
	instance.Name = instanceName
	instance.Parent = instanceParent

	return instance
end

local function Load(player)

	--- throwing this in a seprate thread so it doesn't stop other Players from loading while it might yield
	coroutine.wrap(function()
		local DataDecoded = DataService:GetData(player)
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

		local eqiupWeapon = DataDecoded["equips"].weapon--["weapon"]
		local equipArmor = DataDecoded["equips"].armor--["armor"]
		local equipShield = DataDecoded["equips"].shield
		
		local changed = false

		if not eqiupWeapon or not equipArmor or not equipShield then
			
			DataService:SetKey(player,"equips", { 
				weapon = "Glass Sword",
				armor = "Cloth Armor", 
				shield = "Wooden Shield" 
			});

			changed = true
		end

		if changed then
			DataDecoded = DataService:GetData(player)
		end

		dataValue.Value = httpService:JSONEncode(DataDecoded)
		
		local Tool = ToolMetaData[DataDecoded.equips.weapon]
		local shield = ShieldMetaData[DataDecoded.equips.shield]
		
		Tool = Tool or error("Tool %s not found"):format(DataDecoded.equips.weapon)
		shield = shield or error("Shield %s not found"):format(DataDecoded.equips.shield)
		
		
		local SwordClass = Tool.GetClass
		local Sword = SwordClass.new(Tool)
		
		local shieldClass = shield.GetClass
		local shield = shieldClass.new(shield)
		
		shield:Equip(player.Character:WaitForChild("UpperTorso"))
		Sword:Equip(player.Character:WaitForChild("RightHand"))
	end)()
end

--- connecting the PlayerAdded event to a function to load data
for _,player in ipairs(Players:GetPlayers()) do
	Load(player)
end

Players.PlayerAdded:Connect(Load)