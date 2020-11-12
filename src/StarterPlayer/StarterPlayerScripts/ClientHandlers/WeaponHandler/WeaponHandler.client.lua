--Author .4thAxis/TheInfamousDoge_1x1
--10/14/20

--[[
	Typically most client scripts will require functional driven programming.
	Script may need to be re-editted in the near future.
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local engine = require(ReplicatedStorage:WaitForChild("ClientEngine"))

local ClientHashMap = engine.load("ClientHashMap")
local OrderedMetaData = engine.load("ToolMetadata")
local Network = engine.load("Network")

local WeaponManger = ClientHashMap.WeaponManager
local WeaponMetaData = OrderedMetaData["Glass Sword"] --What Weapon

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:wait()
local Humanoid = Character:WaitForChild("Humanoid")

local UserInputService = game:GetService("UserInputService")
local Mouse = Player:GetMouse()


do --Client Input

	local Weapon = WeaponManger.New({
		Player = Player,
		Character = Character,
		Humanoid = Humanoid,
		AnimationsToChooseFrom = WeaponMetaData.Animations.Swings,
		Item = Character:WaitForChild("Sword",5)
	})

	local DownDebounce = false --For Mouse Down
	local UpDebounce = false --For Mouse Up

	local IsHoldingLeft = false
	local startedDown = 0
	local HoldDamage
	local CurrentSwing --The current animation that is playing.

	local function MouseHeldTime()
		while wait() do
			if IsHoldingLeft then
				HoldDamage = tick() - startedDown --Additional Damage

				if tick() - startedDown >= 3 then
					print(HoldDamage)
					break
				end
			else
				--Client stopped holding mouse
				HoldDamage = tick() - startedDown
				print(HoldDamage)
				break
			end
		end
	end

	local function SetCall(Block)  --An auxilary function to handle Weapon methods.
		CurrentSwing = Weapon:StartAnimation()

		repeat wait(.01); until not IsHoldingLeft
		Weapon:EndAnimation(CurrentSwing,HoldDamage,WeaponMetaData.Damage)
	end

	--//Left Click//--
	Mouse.Button1Down:Connect(function()
		if not DownDebounce then
			DownDebounce = true
			IsHoldingLeft = true --Since the mouse is down now.

			startedDown = tick()
			coroutine.resume(coroutine.create(MouseHeldTime)) --Track how long mouse is held.

			SetCall()

			wait(.4)
			DownDebounce = false
		end
	end)

	Mouse.Button1Up:Connect(function()
		if not UpDebounce then
			UpDebounce = true
			IsHoldingLeft = false --Since the mouse is up now.

			wait(.4)

			UpDebounce = false
		end
	end)

	--//Right Click//--
	Mouse.Button2Down:Connect(function()
		if not DownDebounce then
			DownDebounce = true
			IsHoldingLeft = true --Since the mouse is down now.

			wait(.8)

			DownDebounce = false
		end
	end)

	Mouse.Button2Up:Connect(function()
		if not UpDebounce then
			UpDebounce = true
			IsHoldingLeft = false --Since the mouse is up now.

			wait(.8)

			UpDebounce = false
		end
	end)
end