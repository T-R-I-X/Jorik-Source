-- Author
-- Date 10/17/20

-- Services
local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- Objects
local player = players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")
local gameUi = playerGui:WaitForChild("GameUI")

local tweenInfo = TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.In)

-- Values
local lastScreen = false

--- difine the shortcut keys
local guiKeys = {
	[Enum.KeyCode.B]="BagScreen";
	[Enum.KeyCode.P]="PlayerScreen";
	[Enum.KeyCode.T]="TradeScreen";
	[Enum.KeyCode.F]="CartelMarketScreen";
	[Enum.KeyCode.G]="FastTravelScreen";
	[Enum.KeyCode.M]="MapScreen";
	[Enum.KeyCode.K]="SkillScreen";
}
local abilityKeys = {
	[Enum.KeyCode.One]="Ability1";
	[Enum.KeyCode.Two]="Ability2";
	[Enum.KeyCode.Three]="Ability3";
	[Enum.KeyCode.Four]="Ability4";
	[Enum.KeyCode.Five]="Ability5";
	[Enum.KeyCode.Six]="Ability6";
}

------------------------ Private functions ------------------------
local function AbiltyKey(keyFrame)
	--- add this later
end

local function ScreenKey(keyFrame)
	--- if lastScreen and the name is equal tot he opening screen
	if lastScreen and lastScreen.Name == keyFrame then
		local oldPosition = lastScreen.Position
		local newPosition = UDim2.new(oldPosition.X,0,200,0)

		local tween = tweenService:Create(lastScreen,tweenInfo,{ Position = newPosition })
		tween:Play()
		tween.Completed:Wait()

		lastScreen.Visible = false
		lastScreen.Position = oldPosition
		lastScreen = false
		
		return;
	end
	
	--- if last screen and the name is not equal to the opening screen
	if lastScreen and lastScreen.Name ~= keyFrame then
		local oldPosition = lastScreen.Position
		local newPosition = UDim2.new(oldPosition.X,0,200,0)
		
		local tween = tweenService:Create(lastScreen,tweenInfo,{ Position = newPosition })
		tween:Play()
		tween.Completed:Wait()
		
		lastScreen.Visible = true
		lastScreen.Position = newPosition
		lastScreen = false
	end
	
	--- open the screen
	local frame = gameUi:WaitForChild(keyFrame)
	
	local originalPosition = frame.Position
	local newPosition = UDim2.new(originalPosition.X,0,200,0)
	
	frame.Visible = true
	frame.Position = newPosition
	
	local tween = tweenService:Create(frame,tweenInfo,{ Position = originalPosition })
	tween:Play()
	lastScreen = frame
	tween.Completed:Wait()
end

--- connecting the inputbegan event
userInputService.InputBegan:Connect(function(key,gameprocess)
	if gameprocess then return end
	
	if guiKeys[key.KeyCode] ~= nil then
		ScreenKey(guiKeys[key.KeyCode])
	elseif abilityKeys[key.KeyCode] ~= nil then
		print("Ability keys are disabled in this build")
	end
end)