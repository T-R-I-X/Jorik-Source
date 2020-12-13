--Author .4thAxis/TheInfamousDoge_1x1 and .Trix
-- 10/12/2020

local ArmorClass = {}
ArmorClass.__index = ArmorClass

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

	-- looping through the item asset folder to find the specified object
	for _,Items in ipairs(Assets:GetDescendants()) do
		if Items.Name == ItemName then
			Armor = Items:Clone()
			break;
		end
	end

	if Armor == nil then
		error(("Armor %s doesn't exist"):format(ItemName))
	end

	for _,Part in ipairs(Armor:GetDescendants()) do
		if Part.ClassName == "MeshPart" or Part.ClassName == "Part" then

			---shield properties
			Part.CanCollide = false
			Part.Anchored = false
			Part.Name = ItemName
			
			Part.CFrame = ToPlayer.CFrame * CFrame.fromEulerAnglesXYZ(math.rad(90),0,math.rad(-180)) * CFrame.new(0,-.5,.5)

			---creating the constraint the the user part
			local Weld = Instance.new("WeldConstraint")

			Weld.Part0 = ToPlayer
			Weld.Part1 = Part
			Weld.Parent = Part
		end
	end
	
	Armor.Parent = ToPlayer

	return Armor
end

return ArmorClass
