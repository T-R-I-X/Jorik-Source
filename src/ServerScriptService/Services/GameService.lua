---handles simple game utilities
--@@ Author .Trix

--services
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

--modules
local SystemsDirectory = require(replicatedStorage.Systems:WaitForChild("SystemsDirectory"))
local knit = require(SystemsDirectory.FetchModule("SystemsCoreFramework"))
---creating the knit service
local GameService = knit.CreateService({
	Name="GameService";
	Client={ }
})

function GameService:getBuild()
	if runService:IsStudio() then
		return "studio"
	else
		return ("%d"):format(game.PlaceVersion)
	end
end


function GameService:getBuildWithServerType()
	return GameService.getBuild() .. "-" .. GameService.getServerType()
end


function GameService:getServerType()
	if game.PrivateServerId ~= "" then
		if game.PrivateServerOwnerId ~= 0 then
			return "vip"
		else
			return "reserved"
		end
	else
		return "standard"
	end
end

---client methods---
function GameService.Client:getBuild()
	return GameService:getBuild()
end


function GameService.Client:getServerType()
	return GameService:getServerType()
end


function GameService.Client:getBuildWithServerType()
	return GameService:getBuildWithServerType()
end


return GameService