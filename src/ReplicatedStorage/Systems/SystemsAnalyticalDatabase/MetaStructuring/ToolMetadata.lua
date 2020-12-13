--Author .4thAxis/TheInfamousDoge_1x1
-- 10/12/2020

--[[
	Hashmap that holds all metadata of each object no matter the child of the class.
--]]

local Systems = game.ReplicatedStorage.Systems
local SystemsDirectory = require(Systems.SystemsDirectory)
-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Classes--
local swordClass = require(SystemsDirectory.FetchModule("SwordClass"))

-- Objects
local Assets = ReplicatedStorage:WaitForChild("Assets")

local OrderedMetaData = {

	--//Swords//--
	["Golden Relic Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 25,
		InventoryWeight = 10,
		Boost = 4.5,
		Rarity="Rare",
		SellValue = 800,
		Name = "Golden Relic Sword", --Corresponding name to the items Instance name.
		Animations = {
			Swings = {
				5825997502;
				5825997502
			};
			
			stun=5938644379;
			
			Idle = 5826016074;
			Walk = 5826028514;
		};
	};

	["Old Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Rarity="Common",
		Boost = 1,
		SellValue = 1,
		Name = "Old Sword", --Corresponding name to the items Instance name.
		Animations = {
			Swings = {
				5825997502;
				5826008112;
			},
			
			stun=5938644379;
			
			idle=5826016074;
			walk=5826028514;
		};
	};

	["Angelic Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
							     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Boost = 6.8,
		Rarity="Mythic",
		SellValue = 40000,
		Name = "Angelic Sword", --Corresponding name to the items Instance name.
		Animations = {
			Swings = {
				5825997502;
				5826008112;
			};
			
			stun=5938644379;
			
			idle=5826016074;
			walk=5826028514;
		};
	};

	["Bone Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Rarity="UnCommon",
		Boost = 2,
		SellValue = 25,
		Name = "Bone Sword", --Corresponding name to the items Instance name.
		Animations = {
			Swings = {
				5825997502;
				5826008112;
			};
			
			stun=5938644379;
			
			idle=5826016074;
			walk=5826028514;
		};
	};


	["Double Glass Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Rarity="Legendary",
		Boost = 5.2,
		SellValue = 15500,
		Name = "Double Glass Sword", --Corresponding name to the items Instance name.
		Animations = {
			Swings = {
				5825997502;
				5826008112;
			};
			
			stun=5938644379;
			
			idle=5826016074;
			walk=5826028514;
		};
	};

	["Elven Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Rarity="Rare",
		Boost = 3.45,
		SellValue = 500,
		Name = "Elven Sword", --Corresponding name to the items Instance name.
		Animations = {
			Swings = {
				5825997502;
				5826008112;
			};
			
			stun=5938644379;
			
			idle=5826016074;
			walk=5826028514;
		};
	};


	["Glass Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Rarity="UnCommon",
		SellValue = 60,
		Boost = 1.25,
		Name = "Glass Sword", --Corresponding name to the items Instance name.
		Animations = {

			Swings = {
				5825997502;
				5826008112;
			};
			
			stun=5938644379;
			
			idle=5826016074;
			walk=5826028514;
		};
	};

	["Old Pirate Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Rarity="Common",
		SellValue = 5,
		Boost = 1.13,
		Name = "Old Pirate Sword", --Corresponding name to the items Instance name.
		Animations = {
			Swings = {
				5825997502;
				5826008112;
			};
			
			stun=5938644379;
			
			idle=5826016074;
			walk=5826028514;
		};
	};

	["Orcish Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Rarity="Rare",
		SellValue = 1500,
		Boost = 3.8,
		Name = "Orcish Sword", --Corresponding name to the items Instance name.
		Animations = {
			Swings = {
				5825997502;
				5826008112;
			};
			
			stun=5938644379;
			
			idle=5826016074;
			walk=5826028514;
		};
	};

	["Tester Sword"] = {
		GetClass = swordClass, --[[Swords class, all sword like tools inherit the methods of SwordClass--
										     Retrive specific class methods]]
		Damage = 5,
		InventoryWeight = 5,
		Boost = 1,
		Rarity="Mythic",
		SellValue = 0,
		Name = "Tester Sword", --Corresponding name to the items Instance name.
		Animations = {
			Swings = {
				5825997502;
				5826008112;
			};
			
			stun=5938644379;
			
			idle=5826016074;
			walk=5826028514;
		};
	};

	---//Hammers//---

	["Nature Hammer"] = {
		GetClass = swordClass,
		Damage = 10,
		Boost = 2.4,
		InventoryWeight = 10,
		Rarity="UnCommon",
		SellValue = 80,
		
		Name = "Nature Hammer",

		Animations = {
			Swings = {
				5826043627;
				5826056260;
			};
			
			stun=5938642794;

			idle=5826128651;
			walk=5826110872;
		}
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

	error(("Tool %s doesn't exist"):format(ItemName))
end

--//Attributes\\--

setmetatable({
	__newindex = function(Table,Element)
		error(("Attempt to set %s to a read only table %s"):format(Element,Table))
	end
},OrderedMetaData)

return OrderedMetaData

