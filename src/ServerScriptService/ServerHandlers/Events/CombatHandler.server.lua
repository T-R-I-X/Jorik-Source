-- Author .Trix
-- Date 10/13/20

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local debris = game:GetService("Debris")
local tweenService = game:GetService("TweenService")

-- Module loader
local require = require(replicatedStorage:WaitForChild("Engine"))

local network = require("Network")
local raycast = require("Raybox")

------------------- Private functions -------------------
local function AddDamage(head,damage)
	if not head or not damage then return end
	
	local billboard = Instance.new("BillboardGui")
	billboard.Parent = head
	billboard.Size = UDim2.new(4,0,3,0)
	billboard.LightInfluence = 0
	billboard.AlwaysOnTop = true
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Parent = billboard
	textLabel.TextColor3 = Color3.new(1, 0.364706, 0.0470588)
	textLabel.Size = UDim2.new(1,0,1,0)
	textLabel.Text = damage
	textLabel.BackgroundTransparency = 1
	textLabel.TextScaled = true
	
	billboard.StudsOffset = Vector3.new(math.random(-2,4),math.random(-2,3),math.random(-2,4))
	
	local tweenInfo = TweenInfo.new(8,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
	local tween = tweenService:Create(textLabel,tweenInfo,{ Position=UDim2.new(0,0,-1,0), TextTransparency=1 })
	
	tween:Play()
	
	debris:AddItem(billboard,8)
end

--- connecting damage event
network:GetEvent("Damage").OnServerEvent:Connect(function(client,item,holdingDamage,damage)
	local character = client.Character
	local humanoid = character.Humanoid
	local humanoidRoot = character.HumanoidRootPart
			
	spawn(function()
		local hitbox = raycast:Initialize(item, {character})
		hitbox:PartMode(true)
		hitbox:DebugMode(false)
		
		hitbox:HitStart()
		hitbox.OnHit:Connect(function(hit)
			if not hit or not hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
				hitbox:HitStop()	
				network:GetEvent("PlaySound"):FireAllClients("Swing",item)
				
				return
			end
			
			local targetCharacter = hit.Parent
			local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
			local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
		
			local targetPlayer = players:GetPlayerFromCharacter(targetCharacter)
		
			if targetHumanoid.Health > 0 and targetPlayer then
				targetHumanoid:TakeDamage(damage + holdingDamage)
				
				AddDamage(targetCharacter:FindFirstChild("Head"),damage+holdingDamage)
				hitbox:HitStop()
				network:GetEvent("PlaySound"):FireAllClients("Hit",item)
				
				return;
			elseif targetHumanoid.Health > 0 then
				targetHumanoid:TakeDamage(damage + holdingDamage)
							
				AddDamage(targetCharacter:FindFirstChild("Head"),damage+holdingDamage)
				hitbox:HitStop()
				network:GetEvent("PlaySound"):FireAllClients("Hit",item)
				
				return;
			else
				hitbox:HitStop()
				network:GetEvent("PlaySound"):FireAllClients("Swing",item)
				
				return;
			end
		end)
		
		wait(.5)
		hitbox:HitStop()
		network:GetEvent("PlaySound"):FireAllClients("Swing",item)	
	end)
end)
