-- Handles all data usage
--@@ Author Trix

local Profiles = { }

-- Services
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

--modules
local SystemsDirectory = require(replicatedStorage.Systems:WaitForChild("SystemsDirectory"))
local knit = require(SystemsDirectory.FetchModule("SystemsCoreFramework"))
local profileService = require(script.Parent.ProfileService)

---data template
---this will be used for every new player
local template = {
	--currency
	coins=0;
	cartelcoins=0;

	--equips
	equips = {
	
	};
	
	--inventories
	abilities = {

	};

	cosmetics = {

	};
	
	inventory = {
		"Glass Sword"
	};

	--statistics
	level = 1;
	experience = 0;
	class = "Warrior"
}

---creating the knit service
local DataService = knit.CreateService({
	Name="DataService";
	Client={ }
})

--- setting up the player manager
local playerManager = profileService.GetProfileStore(
    "PlayerData",
    template
)

----------------- Public Functions -----------------
function DataService:GetData(player)
	local data = Profiles[player.UserId]
	
	if data ~= nil then return data.Data end

	local profile = playerManager:LoadProfileAsync(
		"Test1_" .. player.UserId,
		"ForceLoad"
	)
	
	if profile ~= nil then
		profile:Reconcile()
		
		profile:ListenToRelease(function()
			Profiles[player.UserId] = nil
			
			player:Kick("Data release: Please rejoin")
		
			return
		end)

		if player:IsDescendantOf(players) == true then
			Profiles[player.UserId] = profile	
		else
			profile:Release()		
		end	
	else
		player:Kick("Data issue: Please rejoin")
		
		return		
	end
	
	players.PlayerRemoving:Connect(function(player)
		if Profiles[player.UserId] ~= nil then
			Profiles[player.UserId] = nil
		end
	end)
	
	return profile.Data
end

function DataService:GetKey(player,key)
	local data = Profiles[player.UserId]

	repeat runService.Stepped:Wait() until data ~= nil
	
	local keyData = data[key]
	
	assert(keyData ~= false,("%s doesn't exist in the player data"):format(key))

	return keyData
end

function DataService:SetKey(player,key,value)
	Profiles[player.UserId].Data[key] = value
	
	return DataService:GetKey(key)
end

function DataService:AddToKey(player,key,value)
	local keyData = DataService:GetKey(key)

	assert(type(keyData) == "number", ("Key %s is not a number"):format(key))
	
	keyData = keyData + value

	return keyData
end

function DataService:SubtractFromKey(player,key,value)
	local keyData = DataService:GetKey(key)
	
	assert(type(keyData) == "number", ("Key %s is not a number"):format(key))
	
	keyData = keyData - value

	return keyData
end

return DataService