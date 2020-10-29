-- Author .Trix
-- Date 09/24/20 8:40pm

local module = {}

-- Services
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Objects 
local assetFolder = replicatedStorage:WaitForChild("Assets")
local itemFolder = assetFolder:WaitForChild("Items")

module.SpawnItem = function (player,position,itemType,itemName)
	-- basic function checks
	if not position or not itemName then
		return false,"Missing parameters"
	end
	
	if type(position) ~= "string" or type(itemName) ~= "string" then
		return false,"Value is not CFrame or string"
	end
	
	-- finding if the item and the item parent exist
	local itemParent = itemFolder:FindFirstChild(itemType)
	local itemHandle = itemParent:FindFirstChild(itemName)
	
	if not itemParent or not itemHandle then
		return false,"Couldn't find type or item"
	end
	
	-- creating the object and moving it to the player
	local calcPosition = CFrame.new(position.X+2,position.Y-2,position.Z)
	
	local clone = itemHandle:Clone()
	
	clone.Name = player.Name .. "-item"
	clone.Parent = workspace
	clone.Position = calcPosition
	
	local firstTick = tick()
	local lastTick;
	
	-- delete the object after a set time
	spawn(function ()
		while true do
			wait(.5)
			
			if firstTick >= 5 then
				break
			end
		end
		
		clone:Destroy()
	end)
	
	return true,clone
end

return module
