-- @@ "Lazy" loads a module
-- @@ (all scripts use this to not require the same thing multiple times because that is gay ngl)

local modules = {}

--// Services
local repliactedStorage = game:GetService("ReplicatedStorage")

--// Objects
local moduleFolder = repliactedStorage:WaitForChild("Modules")

setmetatable(modules, {
    __index = function(t, moduleName)
        if not moduleName then return end
        if not moduleFolder then return end

        --## If modules table has moduleName then return table value
        if modules[moduleName] ~= nil then
            return modules[moduleName]
        end

        --## Requiring the module and define the module in the modules table
        local requiredModule = require(moduleFolder[moduleName])
        modules[moduleName] = requiredModule

        return requiredModule
    end;
})