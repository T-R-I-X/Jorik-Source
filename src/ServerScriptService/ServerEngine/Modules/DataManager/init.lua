-- Handles all data usage
--@@ Author Trix

local DataManager = { }
local Profiles = { }

-- Services
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local serverEngine = require(script.Parent.Parent)

local profileService = serverEngine.load("ProfileService")

--- data template
-- this will be used for every new player
local template = {
    -- currency
    coins=0;
    cartelcoins=0;

    -- equips
    equips = {

    };

    abilities = {

    };

    cosmetics = {

    };

    -- statistics
    level = 1;
    experience = 0;
    class = "Warrior"
}

--- setting up the player manager
-- this will manage the player profile
local playerManager = profileService.GetProfileStore(
    "PlayerData",
    template
)

----------------- Public Functions -----------------
function DataManager:GetData(player)
    local data = Profiles[player.UserId]

    if data ~= nil then return data end

    local profile = playerManager:LoadProfileAsync(
        "User_" .. player.UserId,
        "ForceLoad"
    )

    if profile ~= nil then
        profile:Reconcile()

        profile:ListenToRelease(function()
            Profiles[player.UserId] = nil

            player:Kick()
        end)

        if player:IsDescendantOf(players) == true then
            Profiles[player.UserId] = profile
        else
            profile:Release()
        end
    else
        player:Kick()
    end

    print(profile)
    return profile
end

function DataManager:GetKey(player,key)
    local data = Profiles[player.UserId]

    if data == nil then 
        data = DataManager:GetData(player)
    end

    local keyData = data[key]

    assert(keyData ~= false,("%s doesn't exist in the player data"):format(key))

    return keyData
end

function DataManager:SetKey(player,key,value)
    local keyData = DataManager:GetKey(player,key)

    keyData = value

    return keyData
end

function DataManager:AddToKey(player,key,value)
    local keyData = DataManager:GetKey(player,key)

    assert(type(keyData) == "number", ("Key %s is not a number"):format(key))

    keyData = keyData + value

    return keyData
end

function DataManager:SubtractFromKey(player,key,value)
    local keyData = DataManager:GetKey(player,key)

    assert(type(keyData) == "number", ("Key %s is not a number"):format(key))

    keyData = keyData - value

    return keyData
end

return DataManager