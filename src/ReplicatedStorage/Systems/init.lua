-- Written by 4thAxis
-- 11/10/2020

--[[
 Directory Module
 Cataloging structural system which returns files by input
]]

local SystemsDirectory = {}
local Modules = { unpack(script:GetDescendants()) } -- Add more paths inside the table, must get unpacked if a table.


function SystemsDirectory.FetchModule(ModuleRequest) -- .FetchedModule( Module:string )
	ModuleRequest = ( type(ModuleRequest) == "string" and ModuleRequest ) or error("Invalid module request.")

	for _,ModuleFile in ipairs(Modules) do

		if ModuleFile:IsA("ModuleScript") and ModuleFile.Name == ModuleRequest then
			return ModuleFile or warn("Error fetching module: "..ModuleRequest)
		end

	end
end


function SystemsDirectory.FetchModules(...) -- .FetchModule( Modules:string )
	local ModuleRequests = ( #{...} ~= 0 and {...} ) or error("FetchModule takes atleast 1 module to fetch.") -- Will re-write this later, creating 2 tables extraneously.

	local FetchedModules = {}
	for Request = 1, #ModuleRequests do

		for _,ModuleFile in ipairs(Modules) do

			if ModuleFile.Name == ModuleRequests[Request] then

				FetchedModules[#FetchedModules + 1] = ModuleFile or warn("Error fetching module: ",ModuleRequests[Request])
			end
		end

	end

	return unpack(FetchedModules)
end

return SystemsDirectory












--local loader = {}

---- Services
--local runService = game:GetService("RunService")

---- Values
--local PATH_TO_MODULES = script:WaitForChild("Modules")

--function loader.load(moduleName, clone)

--	if PATH_TO_MODULES:FindFirstChild(moduleName) then

--		return ( clone and require(PATH_TO_MODULES[moduleName]:Clone()) ) or require(PATH_TO_MODULES[moduleName])
--	elseif runService:IsClient() then

--		local requested = PATH_TO_MODULES:WaitForChild(moduleName, 15)

--		requested = requested or error(("%s doesn't exist"):format(moduleName))
--		return ( clone and require(requested:Clone()) ) or require(requested)
--	end

--	return nil
--end

--return loader