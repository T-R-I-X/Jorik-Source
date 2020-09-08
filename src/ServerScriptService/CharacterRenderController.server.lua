-- Character Render Service
-- .Trix
-- August 30, 2020

local CharacterRenderService = {}

-- Services
local players = game:GetService("Players")

-- Modules
local require = require(game:GetService("ReplicatedStorage"):WaitForChild("Nevermore"))
local netowrk = require("Netowrk")

-- Events


-- ## Fires when the player joins
players.PlayerAdded:Connect(function (player)
	player.CharacterAdded:Connect(function (character)
    	-- ## Firing all clients to add an character to render
	    CharacterRenderService:FireAllClientsEvent("AddPlayerToRender",player)

	    -- ## Creating a CFrame value
        local CF = Instance.new("CFrameValue")
        CF.Parent = character
	    CF.Name = "ServerValue"
    	CF.Value = character.PrimaryPart.CFrame

        -- ## Letting the everyone know that player was loaded
        snackBar:MakeSnackbar("(Loaded) " .. player.Name)

    	-- ## CFrame value changed
    	CF:GetPropertyChangedSignal("Value"):Connect(function()
			character.HumanoidRootPart.CFrame = CF.Value
	    end)
    end)
end)


CharacterRenderService:ConnectClientEvent("MovePlayerOnRender",function (player,hCFrame)
    local character = player.Character
    if not character then return end

    local CF = character:WaitForChild("ServerValue")

    -- ## If CFrame value not equal to the cframe sent over datahandling
    if CF.Value ~= hCFrame then
    	CF.Value = hCFrame
	end
end)