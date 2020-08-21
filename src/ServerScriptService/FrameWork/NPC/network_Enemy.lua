local methods = {}

--// Services
local playerService = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

--// Values
local spawnedEnemys = 0

--// Objects
local utilModule = require(script.Parent.Parent:WaitForChild("Backend").Utils)
local dataManager = require(script.Parent.Parent.Backend.DataManager)

local spawnedFolder = workspace:WaitForChild("Temporary"):WaitForChild("SpawnedMobs")

--// Events
local addCharacterEvent = replicatedStorage:WaitForChild("DataHandlers"):WaitForChild("addedCharacter")

local handles = {
    [1] = {Event = Instance.new("RemoteEvent"), EName = "RenderMob"}
}

for i = 1, #handles do
    handles[i].Event.Parent = replicatedStorage.DataHandlers
    handles[i].Event.Name = handles[i].EName
end

----------------- Methods -----------------

--.. returns the default enemy properties
methods.new = function()
    return {
        defaultHealth = 50,
        defualtMaxDamage = 5,
        defualtMinDamage = 1,
        defualtHitPercent = 0.25,
        defaultMaxSight = 100,
        changeDefault = function(self, key, value)
            if self[key] ~= nil and tonumber(value) then
                self[key] = value

                return true
            else
                return false
            end
        end
    }
end

--.. Finds what character is closest to the enemyHRP
methods.findCharacter = function(enemyHumanoidRootPart)
    local enemyInfo = dataManager:getEnemy(enemyHumanoidRootPart.Parent.Name)

    --## Looping through all the players to check what player is the closest to the HRP
    for _, player in pairs(playerService:GetPlayers()) do
        local character = workspace:FindFirstChild(player.Name)

        --## If character exist check magnitude to see if the player is in sight
        if character then
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            if (enemyHumanoidRootPart.Position - humanoidRootPart.Position).Magnitude <= enemyInfo["defaultMaxSight"] then
                return {
                    foundCharacter = true,
                    humanoidRootPart = humanoidRootPart
                }
            end
        end
    end

    return {
        foundCharacter = false
    }
end

--.. Spawns an enemy with only the hit box
methods.spawnEnemy = function(enemyType)
    --## Creating the character
    local character = serverStorage:WaitForChild("Assets"):WaitForChild("Character"):Clone()
    character.Parent = workspace:WaitForChild("Temporary"):WaitForChild("SpawnedMobs")
    character.Name = tostring(enemyType)

    spawnedEnemys = spawnedEnemys + 1
    character.Name = tostring(enemyType) .. spawnedEnemys

    --## Firing all clients so they render the character
    addCharacterEvent:FireAllClients(character.Name)
end

--.. removes the enemy from the spawned mobs folder
methods.destroyEnemy = function(enemyName)
    --## checking if the enemy is spawned
    local character = spawnedFolder:WaitForChild(enemyName, 10)
    if not character then
        return
    end

    spawnedEnemys = spawnedEnemys - 1

    --## destroying the character server side so all clients update
    character:Destroy()
end

--.. does damage to the enemy (this is only server so it can't be abused Jayy)
function methods:takeDamage(self, enemyName, damage)
    local newName = utilModule.splitNumberFromString(enemyName)
    local enemyInfo = dataManager:getEnemy(newName)

    if tonumber(damage) <= 0 or not tostring(enemyName) then
        return script:GetFullName(), "@@ Invalid enemy or damage"
    end

    --## checking if the enemy is spawned
    local character = spawnedFolder:WaitForChild(enemyName, 10)
    if not character then
        return
    end

    local missPercent = math.random(1, 10) / enemyInfo.defualtHitPercent
    local breakPercent = math.random(1, 10) / enemyInfo.defualtHitPercent

    --## if break percentage < 5 subtract the defense from the damage
    if breakPercent < 5 and enemyInfo.defaultDefense > 0 then
        damage = damage - enemyInfo.defaultDefense
    end

    if missPercent > 5 then
        return "Miss"
    end

    local humanoid = character:WaitForChild("Humanoid")

    if (humanoid.Health - damage) <= 0 then
        self.destroyEnemy(enemyName)
    else
        humanoid:TakeDamage(damage)
    end
end

--.. heals damage done to the enemy (this is also only server so it can't be abused Jayy)
methods.healDamage = function(enemyName)
    local newName = utilModule.splitNumberFromString(enemyName)

    local enemyInfo = dataManager:getEnemy(newName)

    --## If enemy name not a string
    if not tostring(enemyName) then
        return script:GetFullName(), "@@ Enemy name not a string"
    end

    local spawnedFolder = workspace:WaitForChild("Temporary"):WaitForChild("SpawnedMobs")

    --## checking if the enemy is spawned
    local character = spawnedFolder:WaitForChild(enemyName, 10)
    if not character then
        return
    end

    local humanoid = character:WaitForChild("Humanoid")

    while humanoid.Health < enemyInfo.defaultHealth do
        wait(1.25)

        local randomHeal = math.random(5, 25) / .25

        if (randomHeal + humanoid.Health) >= enemyInfo.defaultHealth then
            humanoid.Health = enemyInfo.defaultHealth
        else
            humanoid.Health = humanoid.Health + randomHeal
        end
    end
end

return methods