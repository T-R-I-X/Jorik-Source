-- Character Render Service
-- .Trix
-- August 30, 2020

local CharacterRenderService = {Client = {}}

-- Services
local players = game:GetService("Players")



function CharacterRenderService:Start()

    players.PlayerAdded:Connect(function (player)
    	player.CharacterAdded:Connect(function (character)
	    	--## Firing all clients to add an character to render
		    CharacterRenderService:FireAllClientsEvent("AddPlayerToRender",player)

		    --## Creating a CFrame value
            local CF = Instance.new("CFrameValue")
            CF.Parent = character
		    CF.Name = "ServerValue"
    		CF.Value = character.PrimaryPart.CFrame

    		--## CFrame value changed
    		CF:GetPropertyChangedSignal("Value"):Connect(function()
    			character.HumanoidRootPart.CFrame = CF.Value
		    end)
	    end)
    end)


    CharacterRenderService:ConnectClientEvent("MovePlayerOnRender",function (player,hCFrame)
	    local character = player.Character
	    if not character then return end

    	local CF = character:WaitForChild("ServerValue")

    	--## If CFrame value not equal to the cframe sent over datahandling
    	if CF.Value ~= hCFrame then
    		CF.Value = hCFrame
    	end
    end)
end

function CharacterRenderService:Init()
    self._addPlayer = CharacterRenderService:RegisterClientEvent("AddPlayerToRender")
    self._movePlayer = CharacterRenderService:RegisterClientEvent("MovePlayerOnRender")
end


return CharacterRenderService