-- Author .Trix
-- Date 10/22/20

-- Service
local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")

-- Objects
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Values
local runId = "assetid://5861847205"
local debounce = false

-------------- Private functions --------------
local function newInstance(instanceType,instanceName,instanceParent)
	local instance = Instance.new(instanceType)
	instance.Name = instanceName
	instance.Parent = instanceParent
	
	return instance
end

--- run
function run(start)
	local track
	local animation = script:FindFirstChild("RunAnimation")
	
	if debounce then return end
	debounce = true
	
	if not animation then
		animation = newInstance("Animation","RunAnimation",script)
		
		animation.AnimationId = runId
	end
	
	if start then
		local humanoid = character:WaitForChild("Humanoid")
		
		track = humanoid:LoadAnimation(animation)
		
		track:Play()
	else
		track:Stop()
		
		animation:Destroy()
	end
	
	wait(.3)
	debounce = false
end

---- connecting function to the specific key 
userInputService.InputBegan:Connect(function(key,gp)
	if gp then return end
	
	if key.KeyCode == Enum.KeyCode.LeftShift then
		run(true)
	end
end)

userInputService.InputEnded:Connect(function(key,gp)
	if gp then return end
	
	if key.KeyCode == Enum.KeyCode.LeftShift then
		run(false)
	end
end)