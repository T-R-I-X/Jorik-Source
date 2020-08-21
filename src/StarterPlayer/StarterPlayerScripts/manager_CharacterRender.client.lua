--?? Handles rendering characters on client ??--

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

--.. renders the player character on client
local function addCharacter(player)
	if not player or not player:IsA("Player") then return end

	local character = player.Character or player.Character:Wait()
	if not character then return end

	--## Fake character
	local fakeCharacter = replicatedStorage.FakeCharacter:Clone()
	fakeCharacter.Name = player.UserId

	fakeCharacter.Parent = character
	fakeCharacter:SetPrimaryPartCFrame(character.PrimaryPart.CFrame)

	--## Character
	character.HumanoidRootPart.Transparency = 1
	character.HitBox.Transparency = 1

	local characterWeld = Instance.new("Weld")
	characterWeld.Part1 = fakeCharacter.PrimaryPart
	characterWeld.Part0 = character.PrimaryPart
	characterWeld.Parent = character.PrimaryPart
end

--.. checks already added players to see if the fake character is missing
local function checkCharacters()
	for _,player in pairs(playerService:GetPlayers()) do
		if not player.Character then return end

		if not player.Character:FindFirstChild(player.UserId) then
			addCharacter(player.Name)
		end
	end
end

--.. checks the real character CFrame
local function checkCFrame()
	local character = workspace:WaitForChild(localPlayer.Name,10) or workspace:FindFirstChild(localPlayer.Name)
	if not character then return end

	local fakeCharacter = character:WaitForChild(localPlayer.UserId,10)

	character.Humanoid:MoveTo(fakeCharacter.HumanoidRootPart.Position)
end
---------------------- Events ----------------------
addedEvent.OnClientEvent:Connect(addCharacter)

---------------------- Position ----------------------
runService:BindToRenderStep("checkCFrame",Enum.RenderPriority.First.Value,checkCFrame)

	wait(.5)
	if db then return end

	local character = workspace:WaitForChild(localPlayer.Name,10)
	if not character then return utils.errorOut(script,"missing character",79) end

	local fakeCharacter = character:WaitForChild(localPlayer.UserId,10)
	local CF = character:WaitForChild("ServerValue")

	if CF.Value ~= fakeCharacter.PrimaryPart.CFrame then
		db = true

		moveEvent:FireServer(fakeCharacter.PrimaryPart.CFrame)

		wait(1)
		db = false
		return
	end
