--Author .4thAxis
--10/14/2020
--[[
	Core module to manage Weapons
	Goal here is to keep polymorphic functions and abstraction.
]]

local WeaponManger = {}
WeaponManger.__index = WeaponManger

local orderedEngine = require(game.ReplicatedStorage.Systems:WaitForChild("SystemsDirectory"))
local knit = require(orderedEngine.FetchModule("SystemsCoreFramework"))knit.OnStart():await()

local Network = require(knit.ClientModules.NetworkController)

function WeaponManger.New(ClientReferences) -- .New({ Player,Character,Humanoid, Weapon Animations })
	ClientReferences = ClientReferences or error("Function takes client references")

	return setmetatable(ClientReferences,WeaponManger)
end

function WeaponManger:StartAnimation(IsBlocking) -- :ProcessAnimation(bool)
	if not self.Item then return end
	if not IsBlocking then IsBlocking = false end

	local Player = self.Player
	local Character = self.Character
	local Humanoid = self.Humanoid

	local AnimationsToChooseFrom = self.AnimationsToChooseFrom --Swing Animation Table
	local AnimationInstance = Instance.new("Animation")
	local IsYield = false
	local Animation
	local SetSpeed
	local Hold

	if not IsBlocking then
		local ChoosenAnimation = "rbxassetid://"..AnimationsToChooseFrom[math.random(1,#AnimationsToChooseFrom)]
		AnimationInstance.AnimationId = ChoosenAnimation

		Animation = Humanoid:LoadAnimation(AnimationInstance)
	end

	Animation:Play()

	Animation:GetMarkerReachedSignal("Playback"):Connect(function(Speed)
		Animation:AdjustSpeed(Speed)
		SetSpeed = Speed
	end)

	Animation:GetMarkerReachedSignal("Holding"):Connect(function(HoldInterval)
		Animation:AdjustSpeed(0)
		local TrackAnimationsCache = {}

		--check to make sure we aint runnin more duplicates of the same animation.
		while wait() do
			for i,v in ipairs(Humanoid:GetPlayingAnimationTracks()) do
				if v.Priority == Enum.AnimationPriority.Action then
					if TrackAnimationsCache[#TrackAnimationsCache] ~= v then

						TrackAnimationsCache[#TrackAnimationsCache+1] = v
						if #TrackAnimationsCache > 2 then

							Animation:AdjustSpeed(SetSpeed)
						end
					end
				end
			end
		end
	end)

	return Animation
end

function WeaponManger:EndAnimation(PlayingAnimation,HoldingDamage,damage) --:EndAnimation( AnimationInstance, int )
	if not self.Item then return end
	PlayingAnimation:AdjustSpeed(1) --Later will change this
	PlayingAnimation:GetMarkerReachedSignal("Damage"):Connect(function()

		local event = Network:GetEvent("Damage")
		--print(damage,HoldingDamage)
		event:FireServer(self.Item,HoldingDamage,damage)
	end)

	--PlayingAnimation:Destroy() clean up here soon
end

return WeaponManger
