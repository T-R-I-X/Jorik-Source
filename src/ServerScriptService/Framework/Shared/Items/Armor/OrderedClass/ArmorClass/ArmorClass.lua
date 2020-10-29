--Author .4thAxis/TheInfamousDoge_1x1 and .Trix
--Promise spam by .Trix
-- 10/12/2020

local ArmorClass = {}
ArmorClass.__index = ArmorClass

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local require = require(ReplicatedStorage:WaitForChild("Engine"))

--local orderedMetadata = require("OrderedMetadata")
local promise = require("Promise")
local maid = require("Maid")

-- Objects
local Assets = ReplicatedStorage:WaitForChild("Assets")

------------------------- Public functions -------------------------
function ArmorClass.new(MetaObject) --SwordClass.new({ ObjectMetaData })
	MetaObject = MetaObject or warn("Contructor takes a metaobject")

	return setmetatable(MetaObject,ArmorClass) 	--Add more specific stats that apply to the class here--
end

function ArmorClass:Equip(ToPlayer)
	local ItemName = self.Name
	local Armor

	return promise.new(function(resolve,reject,cancel)

		-- looping through the item asset folder to find the specified object
		for _,Items in ipairs(Assets:GetDescendants()) do
			if Items.Name == ItemName then
				Armor = Items:Clone()
				break;
			end
		end

		if not Armor then
			reject("Armor does not exist")
		end

		for _,Part in ipairs(Armor:GetDescendants()) do
			if Part.ClassName == "MeshPart" or Part.ClassName == "Part" then
				Part.CanCollide = false
				Part.Anchored = false
			end
		end					

		Armor.Parent = ToPlayer

		resolve(Armor)
	end)
end

return ArmorClass
