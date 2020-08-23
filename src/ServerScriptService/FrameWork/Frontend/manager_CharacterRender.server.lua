-- @@ Serverside rendering
-- @@ Handles character rendering for the server to the client

--// Modules
local modules = script.Parent.Parent.Backend.holder_modules
local utils = modules.helper_Utility
local network = modules.manager_Network

--// Services
local playerService = network:GetService("Players")
local replicatedStorage = network:GetService("ReplicatedStorage")

--// Objects
local networkFolder = replicatedStorage:WaitForChild("Networks") or utils.errorOut(script,"missing network folder",13)

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
		networks[1]:FireAllClients(player,player)

		--## Creating a CFrame value
		local CF = Instance.new("CFrameValue",character)
		CF.Name = "ServerValue"
		CF.Value = character.HumanoidRootPart.CFrame

		--## CFrame value changed
		CF:GetPropertyChangedSignal("Value"):Connect(function()
			character.HumanoidRootPart.CFrame = CF.Value
		end)
	end)
end)

networks[2].OnServerEvent:Connect(function (player,hCFrame)
	local character = workspace:WaitForChild(player.Name,10) or workspace:FindFirstChild(player.Name)
	if not character then return end

	local CF = character:WaitForChild("ServerValue")

	--## If CFrame value not equal to the cframe sent over datahandling
	if CF.Value ~= hCFrame then
		CF.Value = hCFrame
	end
end)