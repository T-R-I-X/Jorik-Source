-- Author .Trix
-- Date 10/15/20

local Network = { Events={ }; Functions={ }; }

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

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

-------------------------- Private function --------------------------
local function CreateEvent(eventName)
	local requested = Instance.new("RemoteEvent")

	requested.Name = eventName
	requested.Parent = communicationFolder

	Network.Events[eventName] = requested

	return requested
end

local function CreateFunction(functionName)
	local requested = Instance.new("RemoteFunction")

	requested.Name = functionName
	requested.Parent = communicationFolder

	Network.Functions[functionName] = requested

	return requested
end


-------------------------- Public function --------------------------
function Network:GetEvent(name)
	local event = Network.Events[name]

	assert(event ~= nil and not runService:IsServer(),("[Network] - %s does not exist"):format(name))

	event = CreateEvent(name)

	return event
end

function Network:GetFunction(name)
	local localFunction = Network.Functions[name]

	assert(localFunction ~= nil and not runService:IsServer(),("[Network] - %s does not exist"):format(name))

	localFunction = CreateFunction(name)

	return localFunction
end

return Network