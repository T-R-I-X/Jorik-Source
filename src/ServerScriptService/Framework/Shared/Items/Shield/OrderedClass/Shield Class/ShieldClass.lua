--Author .4thAxis/TheInfamousDoge_1x1
--Promise spam by .Trix
-- 10/12/2020

local ShieldClass = {}
ShieldClass.__index = ShieldClass

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
function ShieldClass.new(MetaObject) --SwordClass.new({ ObjectMetaData })
	MetaObject = MetaObject or warn("Contructor takes a metaobject")

	return setmetatable(MetaObject,ShieldClass) 	--Add more specific stats that apply to the class here--
end

function ShieldClass:Equip(ToPlayer)
	local SwordCFrame = self.SetCFrame
	local ItemName = self.Name
	local Shield

	return promise.new(function(resolve,reject,cancel)

		-- looping through the item asset folder to find the specified object
		for _,Items in ipairs(Assets:GetDescendants()) do
			if Items.Name == ItemName then
				Shield = Items:Clone()
			end
		end

		if not Shield then
			reject("Tool does not exist")
		end

		Shield.CanCollide = false
		Shield.Anchored = false 
		Shield.Handle.Anchored = false

		Shield.Parent = ToPlayer.Parent
		Shield.Handle.CFrame = ToPlayer.CFrame * CFrame.fromEulerAnglesXYZ(math.rad(180),math.rad(-90),0) 
		local Weld = Instance.new("WeldConstraint")
		Weld.Part0 = ToPlayer
		Weld.Part1 = Shield.Handle
		Weld.Parent = Shield

		--	Tool.CFrame = ToPlayer.CFrame* self.SetCFrame * self.SetOrientation

		resolve(Shield)
	end)
end

function ShieldClass:Swing()
	print(self.Damage)
end

return ShieldClass
