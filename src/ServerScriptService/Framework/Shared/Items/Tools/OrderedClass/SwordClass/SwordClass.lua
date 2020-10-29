--Author .4thAxis/TheInfamousDoge_1x1
--Promise spam by .Trix
-- 10/12/2020

local SwordClass = {}
SwordClass.__index = SwordClass

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

function SwordClass.new(MetaObject) --SwordClass.new({ ObjectMetaData })
	MetaObject = MetaObject or warn("Contructor takes a metaobject")
	
	return setmetatable(MetaObject,SwordClass) 	--Add more specific stats that apply to the class here--
end

function SwordClass:Equip(ToPlayer)
	local SwordCFrame = self.SetCFrame
	local ItemName = self.Name
	local Tool
	
	return promise.new(function(resolve,reject,cancel)
		
		-- looping through the item asset folder to find the specified object
		for _,Items in ipairs(Assets:GetDescendants()) do
			if Items.Name == ItemName then
				Tool = Items:Clone()
			end
		end
		
		if not Tool then
			reject("Tool does not exist")
		end
		
		Tool.CanCollide = false
		Tool.Anchored = false 
		Tool.Handle.Anchored = false
		
		Tool.Name = "Sword"
		Tool.Parent = ToPlayer.Parent
		Tool.Handle.CFrame = ToPlayer.CFrame
		
		local Weld = Instance.new("WeldConstraint")
		Weld.Part0 = ToPlayer
		Weld.Part1 = Tool.Handle
		Weld.Parent = Tool
		
	--	Tool.CFrame = ToPlayer.CFrame* self.SetCFrame * self.SetOrientation
		
		resolve(Tool)
	end)
end

function SwordClass:Swing()
	print(self.Damage)
end

return SwordClass
