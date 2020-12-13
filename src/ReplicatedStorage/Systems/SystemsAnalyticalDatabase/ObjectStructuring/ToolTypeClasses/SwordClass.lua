--Author .4thAxis | Trix
-- 10/12/2020

local SwordClass = {}
SwordClass.__index = SwordClass

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Objects
local Assets = ReplicatedStorage:WaitForChild("Assets")

------------------------- Public functions -------------------------

function SwordClass.new(MetaObject) --SwordClass.new({ ObjectMetaData })
	MetaObject = MetaObject or warn("Contructor takes a metaobject")

	return setmetatable(MetaObject,SwordClass) 	--Add more specific stats that apply to the class here--
end

function SwordClass:Equip(ToPlayer)
	local ItemName = self.Name
	local Tool

	-- looping through the item asset folder to find the specified object
	for _,Items in ipairs(Assets:GetDescendants()) do
		if Items.Name == ItemName then
			Tool = Items:Clone()
		end
	end

	if not Tool then
		error(("Tool %s doesn't exist"):format(ItemName))
	end

	-- setting the tool properties and welding it to the player hand
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

	return Tool
end

function SwordClass:Swing()
	print(self.Damage)
end

return SwordClass