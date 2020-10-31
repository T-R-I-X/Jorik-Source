-- Handles all data usage
--@@ Author Trix

local DataManager = { }

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local serverEngine = require(script.Parent.Parent)

local profileService = serverEngine.load("ProfileService")