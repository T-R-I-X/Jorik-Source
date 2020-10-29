--Author .4thAxis/TheInfamousDoge_1x1
-- 10/12/2020

--[[
	Hashmap that holds all metadata of each object no matter the child of a class.
--]]

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local require = require(ReplicatedStorage:WaitForChild("Engine"))

local promise = require("Promise")
local armorClass = require("ArmorClass")

-- Objects
local Assets = ReplicatedStorage:WaitForChild("Assets")
local Items = Assets:WaitForChild("Items")

local OrderedMetaData = {

	--[[
	Armors
	]]
	["Iron Armor"] = {
		GetClass = armorClass, --[[Armor class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Defense = 10,
		InventoryWeight = 20,

		Name = "Iron Armor"--Corresponding name to the items Instance name
	};
}

function OrderedMetaData:GetItem(MetaObject) --Takes an OrderedMetaData object.
	local self = self[MetaObject]
	local ItemName = self.Name

	return promise.new(function(resolve,reject,cancel)
		for _,Tool in ipairs(Assets:GetDescendants()) do
			if Tool.Name == ItemName then
				resolve(Tool)
			end
		end

		reject("Tool doesn't exist in table")
	end)
end


--//Attributes\\--

setmetatable({
	__newindex = function(Table,Element)
		error("Attempt to set"..Element.."to a read only table"..Table)
	end
},OrderedMetaData)

return OrderedMetaData

