-- @@ Network creator
-- @@ (creates networks for client and server to communicate)
local methods = {};

--// Services
local replicatedStorage = game:GetService("ReplicatedStorage")

--// Objects 
local networkFolder = replicatedStorage:WaitForChild("Networks",15)

