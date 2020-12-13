--handles starting the framework on server
--@@ Author .Trix

--services
local replicatedStorage = game:GetService("ReplicatedStorage")

--modules
local SystemsDirectory = require(replicatedStorage.Systems:WaitForChild("SystemsDirectory"))
local core = require(SystemsDirectory.FetchModule("SystemsCoreFramework"))

---looping through the services folder and starting the modules
for _,v in ipairs(script.Parent.Parent:WaitForChild("Services"):GetDescendants()) do
	if (v:IsA("ModuleScript")) then
		print(("[SERVER] - %s loaded"):format(v.Name))
		
		---require can yield so I throw it in a new thread
		spawn(function() require(v) end)
	end
end

---difine paths to modules within the coreframework
core.ServerModules = script.Parent.Parent:WaitForChild("Services")
core.ClientModules = replicatedStorage:WaitForChild("Controllers")

---starting the core framework
core.Start():Catch(function(...)
	error(...)
end)

---awaiting the start promise to resolve
core.OnStart():await()
print("[SERVER] - started")