local network = {}
local services = {}

-- @@ Network manager
-- @@ Handles everything the framework needs

--.. Grabs a service and stores it so only one script uses get service
function network:GetService(serviceName)
    --## Checking if serviceName has an entry in services table
    if services[serviceName] ~= nil then
        return services[serviceName]
    end

    --## Creating a entry in the services table for the serviceName
    local tempService = game:GetService(serviceName)
    services[serviceName] = tempService

    return tempService
end

--// Services
local replicatedStorage = network:GetService("ReplicatedStorage")

--// Modules
local modules = replicatedStorage:WaitForChild("Modules")
local utils = require(modules.helper_Utility)

local instances = { 
    Assets=Instance.new("Folder"),
    Networks=Instance.new("Folder")
}

--## Setting all instances properties
for instanceName,instance in pairs(instances) do
    instance.Name = instanceName
    instance.Parent = replicatedStorage
end

-------------------------- Functions --------------------------

--.. Creates a network that client or server can use
function network:CreateNetwork(typeOf,networkName)
    if not typeOf or not networkName then utils.errorOut(script,"missing params",37) return false end

    --## Creating the network 
    tempInstance = Instance.new(typeOf)
    tempInstance.Name = networkName
    tempInstance.Parent = instances["Networks"]

    return true
end

--.. Destroys a pre existing network
function network:Destroy(networkName, typeOf)
    if not networkName then utils.errorOut(script,"missing params",50) return false end

    if typeOf then
        for _,networker in pairs(instances["Networks"]:GetChildren()) do
            if networker.Name == networkName and networker.ClassName == typeOf then
                networker:Destroy()

                return true
            end
        end

        utils.errorOut(script,"couldn't find network with type",61)
        return false
    else
        if instances["Networks"][networkName] ~= nil then
            instances["Networks"][networkName]:Destroy()

            return true
        else
            utils.errorOut(script,"couldn't find network with name",69)
            return false
        end
    end
end

--.. Fires a event network
network.FireEvent = function(player,eventName, ...)
    local args = {...}

    if not player or not eventName or not args then utils.errorOut(script,"missing params",79)  return end

    local event = instances["Networks"][eventName]

    if event and event.ClassName == "RemoteEvent" or event.ClassName == "BindableEvent" then
        event:FireClient(player, args)
        return true
    else
        utils.errorOut(script,"network isn't an event or missing network",87)
        return false
    end
end


return network