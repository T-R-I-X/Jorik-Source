--holds all image data for objects
--@@ Author .Trix

--services
local replicatedStorage = game:GetService("ReplicatedStorage")

--modules
local toolOrdered = require(script.Parent:WaitForChild("ToolOrdered"))
local armorOrdered = require(script.Parent:WaitForChild("ArmorOrdered"))
local shieldOrdered = require(script.Parent:WaitForChild("ShieldOrdered"))

local OrderedMetaData = {

	---Image infomation for every object

	["Glass Sword"] = {
		Information = toolOrdered["Glass Sword"],
		ImageId = 0000000
	};
}

setmetatable({
	__newindex = function(Table,Element)
		error(("Attempt to set %s to a read only table %s"):format(Element,Table))
	end
}, OrderedMetaData)

return OrderedMetaData