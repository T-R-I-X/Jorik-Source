--Author .4thAxis/TheInfamousDoge_1x1
-- 10/12/2020

--[[
	Hashmap that holds all metadata of each object no matter the child of the class.
--]]

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local require = require(ReplicatedStorage:WaitForChild("Engine"))

--Classes--
local ShieldClass = require(script.ShieldClass)

-- Objects
local Assets = ReplicatedStorage:WaitForChild("Assets")
local Items = Assets:WaitForChild("Items")

local OrderedMetaData = {

	--//Shield//--
	["Wooden Shield"] = {
		GetClass = ShieldClass, --[[Shield class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		InventoryWeight = 40,
		Name = "Wooden Shield", --Corresponding name to the items Instance name.

		DamageResistance = {
			MinimumResistance = 5,
			HighestResistance = 15,
		},

		Animations = {
			Guard = {
				5825997502;
				5825997502
			};
		};
	};
}

function OrderedMetaData:GetItem(MetaObject) --Takes an OrderedMetaData object.
	local self = self[MetaObject]
	local ItemName = self.Name


	for _,Tool in ipairs(Assets:GetDescendants()) do
		if Tool.Name == ItemName then
			return Tool
		end
	end

	error(("Shield %s doesn't exist"):format(ItemName))
end

--//Attributes\\--

setmetatable({
	__newindex = function(Table,Element)
		error(("Attempt to set %s to a read only table %s"):format(Element,Table))
	end
}, OrderedMetaData)

return OrderedMetaData

