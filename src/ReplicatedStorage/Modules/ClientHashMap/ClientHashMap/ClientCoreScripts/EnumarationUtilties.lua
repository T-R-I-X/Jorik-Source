--[[
Author .4thAxis/TheInfamousDoge_1x1

	Module holds all client data related methods.
]]
local Client = {}

function Client.New(Player)
	return setmetatable({Player},Client)
end

function Client:FetchData(Request)

end

return Client
