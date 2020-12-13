--handles starting the framework on client
--@@ Author .Trix

--services
local replicatedStorage = game:GetService("ReplicatedStorage")

--modules
local orderedEngine = require(replicatedStorage.Systems:WaitForChild("SystemsDirectory"))
local core = require(orderedEngine.FetchModule("SystemsCoreFramework"))

---looping through the controller folder and starting the modules
for _,v in ipairs(replicatedStorage:WaitForChild("Controllers"):GetDescendants()) do
	if (v:IsA("ModuleScript")) then
		print(("[CLIENT] - %s loaded"):format(v.Name))
		
		---require can yield so I throw it in a seprate thread
		spawn(function() require(v) end)
	end
end

---difining the client modules within core framework
core.ClientModules = replicatedStorage:WaitForChild("Controllers")

---starting the core framework 
core.Start():Catch(function(...)
	error(...)
end)

---awaiting for the core framework to finish
core.OnStart():await()

print("[CLIENT] - started")