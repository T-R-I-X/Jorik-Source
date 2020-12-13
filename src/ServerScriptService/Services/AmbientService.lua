--services
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local debris = game:GetService("Debris")

--modules
local SystemsDirectory = require(replicatedStorage.Systems:WaitForChild("SystemsDirectory"))
local knit = require(SystemsDirectory.FetchModule("SystemsCoreFramework"))

---creating the knit service
local Ambient = knit.CreateService({
	Name="AmbientService";
	Client={ }
})

---server methods---
function Ambient.DamageBillboard(character, damage)
	if not character or not damage then return end
	
	local head = character:FindFirstChild("Head")
	
	if not head then return end
	
	---getting the damage billboard for assets folder
	local DamageIndicator = replicatedStorage.Assets.Gui.DamageIndicator:Clone()
	DamageIndicator.StudsOffset = Vector3.new(math.random(-2,4),math.random(-2,2.5),math.random(-2,4))
	
	---setting damage billboard properties
	DamageIndicator.Adornee = head
	DamageIndicator.Parent = head
	
	---setting textlabel properties
	local textLabel = DamageIndicator.Main.TextLabel
	textLabel.Text = (-damage)

	---creating the tween
	local tweenInfo = TweenInfo.new(8,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
	
	local tween = tweenService:Create(textLabel,tweenInfo,{
		Position = UDim2.new(0,0,-1,0),
		TextTransparency = 1,
		Rotation = 160 
	})

	tween:Play()
	
	---adding the item to debris service for cleanup
	debris:AddItem(DamageIndicator,damage/2)
end

return Ambient
