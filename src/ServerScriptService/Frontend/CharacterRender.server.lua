--?? Handles events and checks for character rendering on the client ??--

--// Services
local playerService     = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

--// Events
local handles = {
	[1]={Event=Instance.new("RemoteEvent"),EName="addedCharacter"},
	[2]={Event=Instance.new("RemoteEvent"),EName="movedCharacter"}
}

for i=1,#handles do
    handles[i].Event.Parent = replicatedStorage:WaitForChild("DataHandles")
    handles[i].Event.Name = handles[i].EName
end

---------------------- Events ----------------------
playerService.PlayerAdded:Connect(function (player)

	player.CharacterAdded:Connect(function (character)
		--## Firing all clients to add an character to render
		handles[1]:FireAllClients(player.Name)

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

handles[2].OnServerEvent:Connect(function (player,hCFrame)
	local character = workspace:WaitForChild(player.Name,10) or workspace:FindFirstChild(player.Name)
	if not character then return end

	local CF = character:WaitForChild("ServerValue")

	--## If CFrame value not equal to the cframe sent over datahandling
	if CF.Value ~= hCFrame then
		CF.Value = hCFrame
	end
end)