-- @@ Client rendering
-- @@ Handles rendering on the client to the server

--// Services
local playerService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local replicatedFirst = game:GetService("ReplicatedFirst")
local runService = game:GetService("RunService")

--// Modules
local modules = replicatedStorage:WaitForChild("Modules")
local utils = require(modules.helper_Utility)

--// Objects
local addedEvent = replicatedStorage:WaitForChild("Networks").addedPlayer
local moveEvent = replicatedStorage:WaitForChild("Networks").movedCharacter

local localPlayer = playerService.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

--// Values
local db = false

---------------------- Functions ----------------------

--.. Renders the player character on client
local function addCharacter(player)
	local realCharacter = player.Character or player.CharacterAdded:Wait()
	realCharacter:WaitForChild("HumanoidRootPart")

	if not realCharacter then utils.errorOut(script,"missing character",27) return end

	--## Generating the fake character
	local fakeCharacter = replicatedStorage.FakeCharacter:Clone()
	fakeCharacter.Name = localPlayer.UserId
	fakeCharacter.Parent = character

	fakeCharacter:SetPrimaryPartCFrame(realCharacter.PrimaryPart.CFrame)

	--## Setting the HRP and Hitbox transparent on client
	realCharacter.HumanoidRootPart.Transparency = .5
	realCharacter.HitBox.Transparency = .5

	--## Welding the fake character primary to the real characters primary
	local characterWeld = Instance.new("Weld")

	characterWeld.Part1 = realCharacter.PrimaryPart
	characterWeld.Part0 = fakeCharacter.UpperTorso

	characterWeld.Parent = realCharacter.PrimaryPart
end

--.. checks already added players to see if the fake character is missing
local function checkCharacters()
	for _,player in pairs(playerService:GetPlayers()) do
		if not player.Character then utils.errorOut(script,"missing character",56) return end

		--## If not the fake character then add the character
		if not player.Character:FindFirstChild(player.UserId) and player.UserId ~= localPlayer.UserId then
			addCharacter(player)
		end
	end
end

---------------------- Events ----------------------
addedEvent.OnClientEvent:Connect(addCharacter)

---------------------- Position ----------------------
runService:BindToRenderStep("checkCharacters",Enum.RenderPriority.First.Value,checkCharacters)