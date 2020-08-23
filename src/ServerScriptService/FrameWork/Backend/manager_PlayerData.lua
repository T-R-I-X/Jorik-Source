local methods = {}
local data = {}

-- @@  Playerdata manager
-- @@  Manages all player data in the game

--// Modules
local modules = script.Parent.manager_Network
local utils = modules.helper_Modules
local network = modules.manager_Network

--// Services
local playerService = network:GetService("Players")
local serverStorage = network:GetService("ServerStorage")
