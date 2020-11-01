-- Author .Trix
-- Date 10/12/20

-- Services
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local httpService = game:GetService("HttpService")
local runService = game:GetService("RunService")

-- Objects
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local leaderstats = player:WaitForChild("leaderstats")

local playerGui = player:WaitForChild("PlayerGui")

local gameUi = playerGui:WaitForChild("GameUI")
local hotBar = gameUi:WaitForChild("HotBar")

local bars = {
	["health"] = hotBar:WaitForChild("HealthFrame");
	["level"] = hotBar:WaitForChild("LevelFrame");
	["stamina"] = hotBar:WaitForChild("StaminaFrame");
	["ability"] = hotBar:WaitForChild("AbilityStamina");
}

local barTween = TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)

--- wait for data to load
local dataValue = leaderstats:WaitForChild("slot")

repeat runService.Heartbeat:Wait() until #dataValue.Value > 1

--- health hotBar
local healthLabel = bars["health"]:WaitForChild("HealthLabel")
local healthBar = bars["health"]:WaitForChild("Backdrop"):WaitForChild("BarFrame")
local humanoid = character:WaitForChild("Humanoid")

local function UpdateHealth()
	local maxHealth = humanoid.MaxHealth
	local currentHealth = humanoid.Health

	healthLabel.Text = currentHealth .. " / " .. maxHealth

	local newSize = UDim2.new(currentHealth / maxHealth,0,1,0)

	local tween = tweenService:Create(healthBar,barTween,{ Size = newSize })

	tween:Play()
end

UpdateHealth()
humanoid:GetPropertyChangedSignal("Health"):Connect(UpdateHealth)

--- stamina hotBar
local staminaLabel = bars["stamina"]:WaitForChild("HealthLabel")
local staminaBar = bars["stamina"]:WaitForChild("Backdrop"):WaitForChild("BarFrame")
local staminaValue = leaderstats:WaitForChild("stamina")

local function UpdateStamina()
	staminaLabel.Text = staminaValue.Value .. " / " .. staminaValue.max.Value

	local newSize = UDim2.new(staminaValue.Value / staminaValue.max.Value,0,1,0)

	local tween = tweenService:Create(staminaBar,barTween,{ Size = newSize })

	tween:Play()
end

UpdateStamina()
staminaValue:GetPropertyChangedSignal("Value"):Connect(UpdateStamina)

--- abilitystamina hotBar
local abilityLabel = bars["ability"]:WaitForChild("HealthLabel")
local abilityBar = bars["ability"]:WaitForChild("Backdrop"):WaitForChild("BarFrame")
local abilityValue = leaderstats:WaitForChild("abilitystamina")

local function UpdateAbilityStamina()
	abilityLabel.Text = abilityValue.Value .. " / " .. abilityValue.max.Value

	local newSize = UDim2.new(abilityValue.Value / abilityValue.max.Value,0,1,0)

	local tween = tweenService:Create(abilityBar,barTween,{ Size = newSize })

	tween:Play()
end

UpdateAbilityStamina()
abilityValue:GetPropertyChangedSignal("Value"):Connect(UpdateStamina)

--- data handling
local function DecodeData()
	local data = httpService:JSONDecode(dataValue.Value)

	return data
end

--- level hotBar
local levelLabel = bars["level"]:WaitForChild("LevelLabel")
local expLabel = bars["level"]:WaitForChild("StatLabel")
local expBar = bars["level"]:WaitForChild("Backdrop"):WaitForChild("BarFrame")

local function UpdateLevel(decoded)
	local levelValue = decoded.level
	local expValue = decoded.exp

	local nxpValue =	levelValue * 100

	levelLabel.Text = "level." .. levelValue
	expLabel.Text = expValue .. " / " .. nxpValue

	local newSize = UDim2.new(expValue / nxpValue,0,1,0)

	local tween = tweenService:Create(expBar,barTween,{ Size = newSize })

	tween:Play()
end

UpdateLevel(DecodeData())
dataValue:GetPropertyChangedSignal("Value"):Connect(function()
	local dataDecoded = DecodeData()

	UpdateLevel(dataDecoded)
end)