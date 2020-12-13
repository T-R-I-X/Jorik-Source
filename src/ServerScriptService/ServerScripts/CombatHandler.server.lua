-- Handles server damage for combat
--@@ Author Trix

wait(5)

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local debris = game:GetService("Debris")
local tweenService = game:GetService("TweenService")

--modules
local SystemsDirectory = require(replicatedStorage.Systems:WaitForChild("SystemsDirectory"))

local knit = require(SystemsDirectory.FetchModule("SystemsCoreFramework"))
knit.OnStart():await()

local networkService = require(knit.ClientModules:WaitForChild("NetworkController"))
local combatService = require(knit.ServerModules:WaitForChild("CombatService"))

---connecting damage event
networkService:GetEvent("Damage").OnServerEvent:Connect(combatService.Hit)