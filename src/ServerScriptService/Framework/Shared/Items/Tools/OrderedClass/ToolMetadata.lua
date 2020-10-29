--Author .4thAxis/TheInfamousDoge_1x1
-- 10/12/2020

--[[
	Hashmap that holds all metadata of each object no matter the child of the class.
--]]

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local require = require(ReplicatedStorage:WaitForChild("Engine"))

local promise = require("Promise")

--Classes--
local swordClass = require("SwordClass")
local armorClass = require("ArmorClass")

-- Objects
local Assets = ReplicatedStorage:WaitForChild("Assets")
local Items = Assets:WaitForChild("Items")

local OrderedMetaData = {
	
	--//Swords//--
	["Golden Relic Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 25,
		InventoryWeight = 10,
		Name = "Golden Relic Sword", --Corresponding name to the items Instance name.
		Animations = {

			Swings = {
				5825997502;
				5825997502
			};

			Idle = 5826016074;
			Walk = 5826028514;
		};	
	};

	["Old Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Name = "Old Sword", --Corresponding name to the items Instance name.
		Animations = {

			Swings = {
				5825997502;
				5826008112;
			},

			idle=5826016074;
			walk=5826028514;
		};	
	};

	["Angelic Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
							     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Name = "Angelic Sword", --Corresponding name to the items Instance name.
		Animations = {
			
			Swings = {
				5825997502;
				5826008112;
			};
			
			idle=5826016074;
			walk=5826028514;
		};	
	};

	["Bone Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Name = "Bone Sword", --Corresponding name to the items Instance name.
		Animations = {
			
			Swings = {
				5825997502;
				5826008112;
			};
			
			idle=5826016074;
			walk=5826028514;
		};	
	};


	["Double Glass Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Name = "Double Glass Sword", --Corresponding name to the items Instance name.
		Animations = {
			
			Swings = {
				5825997502;
				5826008112;
			};
			
			idle=5826016074;
			walk=5826028514;		
		};	
	};

	["Elven Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Name = "Elven Sword", --Corresponding name to the items Instance name.
		Animations = {
			
			Swings = {
				5825997502;
				5826008112;
			};
			
			idle=5826016074;
			walk=5826028514;
		};	
	};


	["Glass Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Name = "Glass Sword", --Corresponding name to the items Instance name.
		Animations = {
			
			Swings = {
				5825997502;
				5826008112;
			};

			idle=5826016074;
			walk=5826028514;
		};
	};

	["Old Pirate Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Name = "Old Pirate Sword", --Corresponding name to the items Instance name.
		Animations = {
			Swings = {
				5825997502;
				5826008112;
			};
			
			idle=5826016074;
			walk=5826028514;
		};	
	};

	["Orcish Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Name = "Orcish Sword", --Corresponding name to the items Instance name.
		Animations = {
			Swings = {
				5825997502;
				5826008112;
			};
			
			idle=5826016074;
			walk=5826028514;
		};	
	};
	
	["Tester Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Name = "Tester Sword", --Corresponding name to the items Instance name.
		Animations = {
			Swings = {
				5825997502;
				5826008112;
			};
		
			idle=5826016074;
			walk=5826028514;
		};	
	};
	
	---//Hammers//---
	
	["Nature Hammer"] = {
		GetClass = swordClass,
		Damage = 10,
		InventoryWeight = 10,
		Name = "Nature Hammer",
		Animations = {
			Swings = {
				5826043627;
				5826056260;
			};
		
			idle=5826128651;
			walk=5826110872;
		}
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

