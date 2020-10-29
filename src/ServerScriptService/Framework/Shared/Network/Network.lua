-- Author .Trix
-- Date 10/15/20

local Network = { Events={ }; Functions={ }; }

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Objects
local communicationFolder = replicatedStorage:WaitForChild("Assets"):WaitForChild("Communication")

--- cache all events and functions 
for _,com in ipairs(communicationFolder:GetDescendants()) do
	if com.ClassName == "RemoteEvent" then
		Network.Events[com.Name] = com
	elseif com.ClassName == "RemoteFunction" then
		Network.Functions[com.Name] = com
	end
end

-------------------------- Public function --------------------------
function Network:GetEvent(name)
	local event = Network.Events[name]
	
	assert(event ~= nil,("[Network] - %s does not exist"):format(name))
	
	return event
end

function Network:GetFunction(name)
	local localFunction = Network.Functions[name]
	
	assert(localFunction ~= nil,("[Network] - %s does not exist"):format(name))
	
	return localFunction	
end

return Network