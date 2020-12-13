--services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local debris = game:GetService("Debris")
local tweenService = game:GetService("TweenService")

--modules
local SystemsDirectory = require(replicatedStorage.Systems:WaitForChild("SystemsDirectory"))
local knit = require(SystemsDirectory.FetchModule("SystemsCoreFramework"))knit.OnStart():await()

local network = require(knit.ClientModules.NetworkController)
local raycast = require(knit.ClientModules.RaycastController)
local ambient = require(knit.ServerModules.AmbientService)

---creating the knit service
local Combat = knit.CreateService({
	Name = "CombatService";
	Client = { }
});

---server methods---
function Combat.Hit(client, item, holdingDamage, damage)
	local character = client.Character
	local humanoid = character.Humanoid
	local humanoidRoot = character.HumanoidRootPart

	if not humanoid or not humanoidRoot then return end

	---creating the hitbox within the item
	local hitbox = raycast:Initialize(item, { character })
	hitbox:PartMode(true)

	hitbox:HitStart()

	---everytime the hitbox gets hit this gets fired
	hitbox.OnHit:Connect(function(hit)
		hitbox:HitStop()
		
		---checking if the damage and holdingDamage
		local baseDamage = Combat:CheckDamage(damage,holdingDamage)
		
		---if not hit part or hit has humanoid then stop finding a hit part
		if not hit or not hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
			return;
		end
		
		---difining target properties
		local targetCharacter = hit.Parent
		local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
		local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
		local targetPlayer = players:GetPlayerFromCharacter(targetCharacter)
		
		---creating effects and taking damage
		Combat:TakeDamage(targetCharacter, baseDamage)
		ambient.DamageBillboard(targetCharacter, baseDamage)
		network:GetEvent("PlaySound"):FireAllClients("Swing", item)
	end)

	wait(.5)
	hitbox:HitStop()
	network:GetEvent("PlaySound"):FireAllClients("Swing", item)
end

function Combat:TakeDamage(character,damage)
	if not character or not damage then return end
	
	local targetHumanoid = character:FindFirstChild("Humanoid")
	
	if targetHumanoid and targetHumanoid.Health > 0 then
		targetHumanoid:TakeDamage(damage)
		
		if targetHumanoid.Health == 0 then
			---add ambient death with 3d particles -- Betttt
			
			network:GetEvent("PlaySound"):FireAllClients("Death",character)
		end
	end
end

function Combat:CheckDamage(damage, holdingDamage)
	print(damage,holdingDamage)
	return ( holdingDamage >= 1 and math.floor(holdingDamage + .05) ) or damage
	--if holdingDamage >= 1 then
	--	holdingDamage = math.floor(holdingDamage + .05)

	--	damage = damage + holdingDamage
	--end
	
	--return damage
end

return Combat