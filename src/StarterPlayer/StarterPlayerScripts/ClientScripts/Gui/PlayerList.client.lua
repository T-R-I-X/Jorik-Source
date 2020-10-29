-- Author .Trix
-- Date 10/17/20

-- Services
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local require = require(replicatedStorage:WaitForChild("Engine"))

local network = require("Network")

-- Objects
local player = players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")

local gameUi = playerGui:WaitForChild("GameUI")
local playerScreen = gameUi:WaitForChild("PlayerScreen")
local mainFrame = playerScreen:WaitForChild("Screen")
local scrollFrame = mainFrame:WaitForChild("PlayerShow")

----------------- Private functions -----------------
local function CreateSlot(playerObject)
	if scrollFrame:FindFirstChild(playerObject.Name) then return end
	
	
end