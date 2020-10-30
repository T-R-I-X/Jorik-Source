-- Easy module loader go brrr
--@@ Author .Trix

local loader = {}

-- Services
local runService = game:GetService("RunService")

-- Values
local PATH_TO_MODULES = script.Parent:WaitForChild("Modules")

function loader.load(moduleName, clone)

	if PATH_TO_MODULES:FindFirstChild(moduleName) then
		return
			clone and require(PATH_TO_MODULES[moduleName]:Clone())
			or require(PATH_TO_MODULES[moduleName])
	else
		if runService:IsClient() then
			local requested = PATH_TO_MODULES:WaitForChild(moduleName, 15)

			if not requested then error(("%s doesn't exist"):format(moduleName)) end

			return
				clone and require(requested:Clone())
				or require(requested)
		end
	end

	return nil
end

return loader