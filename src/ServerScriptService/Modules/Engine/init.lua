local loader = {}

-- Services
local runService = game:GetService("RunService")

-- Values
local PATH_TO_MODULES = script.Parent:WaitForChild("Modules")

function loader.load(moduleName, doClone)

	if PATH_TO_MODULES:FindFirstChild(moduleName) then
		return
			doClone and require(PATH_TO_MODULES[moduleName]:Clone())
			or require(PATH_TO_MODULES[moduleName])
	else
		if runService:IsClient() then
			local requested = PATH_TO_MODULES:WaitForChild(moduleName, 15)

			if not requested then error(("%s doesn't exist"):format("%s",moduleName)) end

			return
				doClone and require(requested:Clone())
				or require(requested)
		end
	end

	return nil
end

return loader