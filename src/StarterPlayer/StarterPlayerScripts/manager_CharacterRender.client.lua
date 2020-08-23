-- @@ Client rendering
-- @@ Handles rendering on the client to the server

--// Services
local playerService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local replicatedFirst = game:GetService("ReplicatedFirst")
local runService = game:GetService("RunService")

--// Modules
local modules = replicatedFirst.holder_Modules
local utils = modules.helper_Utility

--// Objects
local addedEvent = replicatedStorage:WaitForChild("addedCharacter")
local moveEvent = replicatedStorage:WaitForChild("moveCharacter")

local localPlayer = playerService.LocalPlayer

--// Values
local db = false

---------------------- Functions ----------------------

--.. Renders the player character on client
local function addCharacter(player)
	if not player or not player.Character then return end

	local character = player.Character

	--## Generating the fake character
	local fakeCharacter = replicatedStorage.Assets.FakeCharacter:Clone()
	fakeCharacter.Name = player.UserId

	fakeCharacter.Parent = character
	fakeCharacter:SetPrimaryPartCFrame(character.PrimaryPart.CFrame)

	--## Setting the HRP and Hitbox transparent on client
	character.HumanoidRootPart.Transparency = 1
	character.HitBox.Transparency = 1

	--## Welding the fake character primary to the real characters primary
	local characterWeld = Instance.new("Weld")

	characterWeld.Part1 = fakeCharacter.PrimaryPart
	characterWeld.Part0 = character.PrimaryPart

	characterWeld.Parent = character.PrimaryPart
end

--.. checks already added players to see if the fake character is missing
local function checkCharacters()
	for _,player in pairs(playerService:GetPlayers()) do
		if not player.Character then return end

		--## If not the fake character then add the character
		if not player.Character:FindFirstChild(player.UserId) then
			addCharacter(player.Name)
		end
	end
end

--.. checks the real character CFrame
local function checkCFrame()
	wait(.5)
	if db then return end

	local character = workspace:WaitForChild(localPlayer.Name,5)
	local fakeCharacter = character:WaitForChild(localPlayer.UserId,5)

	if not character or not fakeCharacter then return utils.errorOut(script,"missing character(s)",79) end
	local CF = character:WaitForChild("ServerValue")

	--## If CFValue not equal to fakeCharacter Primary CFrame
	if CF.Value ~= fakeCharacter.PrimaryPart.CFrame then
		db = true

		moveEvent:FireServer(fakeCharacter.PrimaryPart.CFrame)

		wait(1)
		db = false
		return
	end
end
---------------------- Events ----------------------
addedEvent.OnClientEvent:Connect(addCharacter)

---------------------- Position ----------------------
runService:BindToRenderStep("checkCFrame",Enum.RenderPriority.First.Value,checkCFrame)
runService:BindToRenderStep("checkCharacters",Enum.RenderPriority.First.Value,checkCharacters)