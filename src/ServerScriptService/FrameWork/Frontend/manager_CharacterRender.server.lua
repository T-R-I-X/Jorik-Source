-- @@ Serverside rendering
-- @@ Handles character rendering for the server to the client

--// Modules
local modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")
local utils = require(modules.helper_Utility)
local network = require(script.Parent.Parent.Backend.manager_Network)

--// Services
local playerService = network:GetService("Players")
local replicatedStorage = network:GetService("ReplicatedStorage")

--// Objects
local networkFolder = replicatedStorage:WaitForChild("Networks",10) or utils.errorOut(script,"missing network folder",13)

--// Events
local networks = {
	addedPlayer = Instance.new("RemoteEvent"),
	movedCharacter = Instance.new("RemoteEvent")
}

--## Setting properties of the events
for remoteName,event in pairs(networks) do 
    event.Name = remoteName
    event.Parent = networkFolder
end

---------------------- Events ----------------------
playerService.PlayerAdded:Connect(function (player)
	player.CharacterAdded:Connect(function (character)
		--## Firing all clients to add an character to render 
		networks.addedPlayer:FireAllClients(player)

		--## Creating a CFrame value
		local CF = Instance.new("CFrameValue",character)
		CF.Name = "ServerValue"
		CF.Value = character.PrimaryPart.CFrame

		--## CFrame value changed
		CF:GetPropertyChangedSignal("Value"):Connect(function()
			character.HumanoidRootPart.CFrame = CF.Value
		end)
	end)
end)

networks.movedCharacter.OnServerEvent:Connect(function (player,hCFrame)
	local character = workspace:WaitForChild(player.Name,10) or workspace:FindFirstChild(player.Name)
	if not character then return end

	local CF = character:WaitForChild("ServerValue")

	--## If CFrame value not equal to the cframe sent over datahandling
	if CF.Value ~= hCFrame then
		CF.Value = hCFrame
	end
end)