local loader = {}

-- Services
local runService = game:GetService("RunService")

-- Values
local PATH_TO_MODULES = script.Parent:WaitForChild("Modules")

function loader.load(moduleName, doClone)

	if script:FindFirstChild(moduleName) then
		return
			doClone and require(script[moduleName]:Clone())
			or require(script[moduleName])
	else
		if runService:IsClient() then
			local requested = script:WaitForChild(moduleName, 15)

			if not requested then error("%s doesn't exist"):format("%s",moduleName) end

			return
				doClone and require(requested:Clone())
				or require(requested)
		end
	end

	return nil
end

return loader