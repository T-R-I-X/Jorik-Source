local player = game.Players:GetPlayerFromCharacter(script.Parent)
local vhead = script.Parent:WaitForChild("Head")
local player_humanoid = script.Parent:WaitForChild("Humanoid")

repeat wait() player = game.Players:GetPlayerFromCharacter(script.Parent) until player
if player.CharacterAppearanceId ~= 0 and player.CharacterAppearanceId ~= player.UserId then
	local name = game.Players:GetNameFromUserIdAsync(player.CharacterAppearanceId)

	local model = Instance.new("Model")
	model.Name = name

	local head = Instance.new("Part")
	head.Size = Vector3.new(2, 1, 1)
	head.Name = "Head"
	head.Parent = model

	local weld = Instance.new("Weld")
	weld.Part0 = vhead
	weld.Part1 = head
	weld.Parent = head

	local humanoid = Instance.new("Humanoid")
	humanoid.Parent = model

	local mesh = vhead:findFirstChild("Mesh")
	if mesh then
		mesh:clone().Parent = head
	end
	head.BrickColor = vhead.BrickColor

	local bc = script.Parent:WaitForChild("Body Colors"):clone()
	head.BrickColor = bc.HeadColor
	bc.Parent = model
	vhead.Transparency = 1
	
	model.Parent = player.Character
	
	player_humanoid.Changed:connect(function()
		humanoid.MaxHealth = player_humanoid.MaxHealth
		humanoid.Health = player_humanoid.Health
	end)
end
