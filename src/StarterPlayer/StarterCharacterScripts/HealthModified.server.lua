---handles the character regen and billboard gui
--@@ Author .Trix

wait(.2)
local healthScript = script.Parent:FindFirstChild("Health")

if healthScript then
	healthScript:Destroy()
end

--services
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local httpService = game:GetService("HttpService")
local tweenService = game:GetService("TweenService")

--objects
local character = script.Parent

local humanoid = character:WaitForChild("Humanoid")

local assets = replicatedStorage:WaitForChild("Assets")
local gui = assets:WaitForChild("Gui")

local player = players:GetPlayerFromCharacter(character)
local dataValue = player:WaitForChild("leaderstats"):WaitForChild("Data")

local tweenInfo = TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.In)

local playerInfo

local healthConnection
local valueConnection

--values
local REGEN_RATE = 1/100 -- Regenerate this fraction of MaxHealth per second.
local REGEN_STEP = 1 -- Wait this long between each regeneration step.

--------------------------------------------------------------------------------
local function load()
	playerInfo = gui:WaitForChild("PlayerIndicator"):Clone()
	playerInfo.Parent = character:WaitForChild("Head")
	
	repeat game:GetService("RunService").Stepped:Wait() until #dataValue.Value > 1
	
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	
	local mainFrame = playerInfo.Main
	local playerFrame = mainFrame.PlayerName
	local healthFrame = mainFrame.HealthFrame
	local levelFrame = mainFrame.LevelFrame
	
	local playerLabel = playerFrame.LabelBackground.TextLabel
	local healthLabel = healthFrame.LabelBackground.TextLabel
	local levelLabel = levelFrame.LabelBackground.TextLabel
	
	local healthBar = healthFrame.LabelBackground.BarFrame
	
	---setting player label text
	playerLabel.Text = player.Name
	
	---setting level label text
	local dataDecoded = httpService:JSONDecode(dataValue.Value)
	
	levelLabel.Text = dataDecoded.level
	
	valueConnection = dataValue.Changed:Connect(function()
		local dataDecoded = httpService:JSONDecode(dataValue.Value)
		
		levelLabel.Text = dataDecoded.level
	end)
	
	---setting the health label text and health bar tween
	healthBar.Size = UDim2.new(1,0,humanoid.Health / humanoid.MaxHealth,0)
	healthLabel.Text = ("%s / %s"):format(humanoid.Health, humanoid.MaxHealth)
	
	healthConnection = humanoid.HealthChanged:Connect(function()
		local tween = tweenService:Create(
			healthBar,
			tweenInfo, 
			{
				Size=UDim2.new(humanoid.Health / humanoid.MaxHealth,0,1 ,0) 
			})
		
		tween:Play()
		
		healthLabel.Text = ("%s / %s"):format(humanoid.Health, humanoid.MaxHealth)
	end)
end

load()

---regenerate
while true do
	while humanoid.Health < humanoid.MaxHealth do
		local dt = wait(REGEN_STEP)
		humanoid:TakeDamage(-1)
	end
	
	humanoid.HealthChanged:Wait()
end

