--handles the equiping and data of shields
--@@ Author .Trix

local ShieldClass = {}
ShieldClass.__index = ShieldClass
ShieldClass.ClassName = "ShieldClass"

--services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Objects
local Assets = ReplicatedStorage:WaitForChild("Assets")

------------------------- Public functions -------------------------
function ShieldClass.new(MetaObject) --SwordClass.new({ ObjectMetaData })
	MetaObject = MetaObject or warn("Contructor takes a metaobject")

	return setmetatable(MetaObject,ShieldClass) --Add more specific stats that apply to the class here--
end

function ShieldClass:Equip(ToPlayer)
	local ItemName = self.Name
	local Shield

	-- looping through the item asset folder to find the specified object
	for _,Item in ipairs(Assets:GetDescendants()) do
		if Item.Name == ItemName then
			Shield = Item:Clone()
		end
	end

	assert(Shield ~= nil, ("Shield %s doesn't exist"):format(ItemName))
	
	---shield properties
	Shield.CanCollide = false
	Shield.Anchored = false
	Shield.Handle.Anchored = false

	Shield.Parent = ToPlayer.Parent
	Shield.Handle.CFrame = ToPlayer.CFrame * CFrame.fromEulerAnglesXYZ(math.rad(90),0,math.rad(-180)) * CFrame.new(0,-.5,.5)
	
	---creating the constraint the the user back
	local Weld = Instance.new("WeldConstraint")

	Weld.Part0 = ToPlayer
	Weld.Part1 = Shield.Handle
	Weld.Parent = Shield

	return Shield
end

return ShieldClass