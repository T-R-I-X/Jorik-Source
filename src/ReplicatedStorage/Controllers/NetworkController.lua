local Network

--services
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

--modules
local orderedEngine = require(replicatedStorage.Systems:WaitForChild("SystemsDirectory"))
local knit = require(orderedEngine.FetchModule("SystemsCoreFramework"))
--objects
local communicationFolder = replicatedStorage:WaitForChild("Assets"):WaitForChild("Communication")

---creating the knit controller or service
if not Network and runService:IsClient() then
	Network = knit.CreateController({
		Name="NetworkController";
		Events={ };
		Functions={ }
	})
elseif not Network then
	Network = knit.CreateService({
		Name="NetworkService";
		Events={ };
		Functions={ }
	})
end

---cache all events and functions
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
	
	if event == nil and runService:IsServer() then
		event = CreateEvent(name)
	end
	
	assert(event ~= nil,("[Network] - event %s does not exist"):format(name))

	return event
end


function Network:GetFunction(name)
	local localFunction = Network.Functions[name]
	
	if localFunction == nil and runService:IsServer() then
		localFunction = CreateFunction(name)
	end
	
	assert(localFunction ~= nil,("[Network] - function %s does not exist"):format(name))

	return localFunction
end

return Network