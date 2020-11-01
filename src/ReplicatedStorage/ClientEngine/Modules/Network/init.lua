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
	if Network._init == true then
		break;
	end

	if com.ClassName == "RemoteEvent" then
		Network.Events[com.Name] = com
	elseif com.ClassName == "RemoteFunction" then
		Network.Functions[com.Name] = com
	end
end

Network._init = true

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
	repeat runService.Stepped:Wait() until Network._init == true

	print(runService:IsServer())

	local event = Network.Events[name]

	assert(event ~= nil and runService:IsServer() ~= false,("[Network] - event %s does not exist"):format(name))

	event = CreateEvent(name)

	return event
end

function Network:GetFunction(name)
	repeat runService.Stepped:Wait() until Network._init == true

	local localFunction = Network.Functions[name]

	assert(localFunction ~= nil and runService:IsServer() ~= false,("[Network] - function %s does not exist"):format(name))

	localFunction = CreateFunction(name)

	return localFunction
end

return Network