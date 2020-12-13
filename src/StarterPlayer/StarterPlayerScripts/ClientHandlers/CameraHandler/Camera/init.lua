--handles the client functions of camera
--@@ Author .Trix

local Camera = { }
Camera._index = Camera

--services
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

--presets
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local tweenInfo = TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)

local currentCamera = workspace.CurrentCamera
local cameraCFrame = Instance.new("CFrameValue")
cameraCFrame.Name = "CFCamera"
cameraCFrame.Parent = currentCamera

local doubledY = 0
local doubledX = 0

local baseX = -math.rad(20)
local baseY = -math.rad(20)

local maxY = math.rad(90)
local maxX = math.rad(80)
local fullXY = math.rad(720)

local zoomIncrement = 4
local baseZoom = 8
local zoomCFrame = CFrame.new(0, 0, baseZoom)

local override = false ---if the camera controller is overridden
local lockCameraPosition = false ---locks the camera position unless override is true

local gyro
local boxoutline
local target
local ring

---------------------- Private functions ----------------------		
local function RayPlane(planepoint, planenormal, origin, direction)
			return -((origin-planepoint):Dot(planenormal)) / (direction:Dot(planenormal))	
end

local function raycastDownIgnoreCancollideFalse(ray, ignoreList)
	local hitPart, hitPosition, hitDown, hitMaterial = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList, true)

	-- edit: ignore water and dropped items
	while hitPart and not (hitPart.CanCollide and hitMaterial ~= Enum.Material.Water) do
		ignoreList[#ignoreList + 1] = hitPart
		hitPart, hitPosition, hitDown, hitMaterial = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList, true)
	end

	return hitPart, hitPosition, hitDown, hitMaterial
end

local function updateCamera(step)
	local primary = character.PrimaryPart

	if not character or not primary then return end
	
	local characterCFrame do
		if lockCameraPosition then
			characterCFrame = CFrame.new(character.PrimaryPart.Position) + Vector3.new(0, 0.25 + 0.05 * baseZoom, 0) + (CFrame.new(Vector3.new(), currentCamera.CFrame.RightVector) * CFrame.Angles(0, math.rad(10), 0)).LookVector * 1.75
		else
			characterCFrame = CFrame.new(character.PrimaryPart.Position) + Vector3.new(0, 0.25 + 0.05 * baseZoom, 0)
		end
	end

	if not override then
		local intendedCFrame = (characterCFrame * CFrame.Angles(0, baseY, 0) * CFrame.Angles(baseX, 0, 0)) * zoomCFrame

		local ignoreList = {workspace.CurrentCamera}
		
		if workspace:FindFirstChild("placeFolders") then
			table.insert(ignoreList, workspace.placeFolders)
		end

		local direction = intendedCFrame.Position - characterCFrame.Position

		local ray = Ray.new(characterCFrame.Position, direction)
		local hitPart, hitPosition = raycastDownIgnoreCancollideFalse(ray, ignoreList)

		--tween(camera,{"CFrame"},intendedCFrame,0.1)
		cameraCFrame.Value = CFrame.new(hitPosition - direction.unit, characterCFrame.p)
		
		if gyro == nil then
			gyro = Instance.new("BodyGyro")
			gyro.Parent = primary
		end
		
		local mouse = player:GetMouse()
		local head = character:FindFirstChild("Head")
		
		if not mouse.Target or target and target.Parent.Name == mouse.target.Parent.Name then return end

		if not head then return end
		
		if mouse.Target.Parent:FindFirstChild("Humanoid") then
			target = mouse.Target
			
			if (target.Parent.HumanoidRootPart.Position - primary.Position).magnitude >= 20 then return end
				
			if boxoutline and not boxoutline.Parent == target or boxoutline then
				boxoutline:Destroy()
			end
			
			boxoutline = Instance.new("SelectionBox")
			boxoutline.Adornee = target.Parent.HumanoidRootPart
			boxoutline.LineThickness = .03
			boxoutline.Color3 = Color3.new(1, 0.00784314, 0.00784314)
			boxoutline.SurfaceColor3 = Color3.new(0.0666667, 0.627451, 1)
			boxoutline.SurfaceTransparency = .6
			boxoutline.Parent = target
		end
end

	currentCamera.Focus = currentCamera.CFrame
end

local function onInputBegan(inputObject, Absorbed)
	if Absorbed then
		return false
	end

	if inputObject.KeyCode == Enum.KeyCode.ButtonR3 then
		baseZoom = baseZoom - 7
		
		if baseZoom < player.CameraMinZoomDistance then
			baseZoom = player.CameraMaxZoomDistance
		end
		
		if not lockCameraPosition then
			zoomCFrame = CFrame.new(0, 0, baseZoom)	
		end
	end

	if inputObject.KeyCode == Enum.KeyCode.Left then
		while inputObject.UserInputState ~= Enum.UserInputState.Cancel and inputObject.UserInputState ~= Enum.UserInputState.End do
			runService.RenderStepped:wait()
			
			baseY = (baseY + 0.04) % fullXY
		end
	elseif inputObject.KeyCode == Enum.KeyCode.Right then
		while inputObject.UserInputState ~= Enum.UserInputState.Cancel and inputObject.UserInputState ~= Enum.UserInputState.End do
			runService.RenderStepped:wait()
			
			baseY = (baseY - 0.04) % fullXY
		end
	elseif inputObject.KeyCode == Enum.KeyCode.I then
		baseZoom = math.clamp(baseZoom - 7, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)

		if not lockCameraPosition then
			zoomCFrame = CFrame.new(0, 0, baseZoom)
		end
	elseif inputObject.KeyCode == Enum.KeyCode.O then
		baseZoom = math.clamp(baseZoom + 7, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)

		if not lockCameraPosition then
			zoomCFrame = CFrame.new(0, 0, baseZoom)
		end
	end
end

local function onInputChanged(inputObject, absorbed)

	if absorbed then
		return false
	end

	
	if inputObject.UserInputType == Enum.UserInputType.MouseWheel then
		baseZoom = math.clamp(baseZoom - ( inputObject.Position.Z)   , player.CameraMinZoomDistance, player.CameraMaxZoomDistance)

		-- update the zoomCFrame
		if not lockCameraPosition then
			zoomCFrame = CFrame.new(0, 0, baseZoom)
		end
	end
end

local function onCharacterAdded(newCharacter)
	character = newCharacter

	if lockCameraPosition then
		userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	else
		userInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
end

function Camera.new()
	if player.Character then
		onCharacterAdded(player.Character)
	end

	player.CharacterAdded:connect(onCharacterAdded)

	userInputService.InputBegan:connect(onInputBegan)
	userInputService.InputChanged:connect(onInputChanged)

	runService:BindToRenderStep("CRenderUpdate", --[[Enum.RenderPriority.Camera.Value - 1]] 1, updateCamera)
end

return Camera