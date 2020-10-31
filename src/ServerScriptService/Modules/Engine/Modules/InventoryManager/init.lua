-- Author .Trix
-- Date 10/13/20

local InventoryManager = { }

-- Services
local players = game:GetService("Players")
local replicatedStorage  = game:GetService("ReplicatedStorage")

-- Modules
local require = require(replicatedStorage:WaitForChild("Engine"))

local promise = require("Promise")
local maid = require("Maid")
local dataManager = require("DataManager")

--------------------- Private functions ---------------------
local function RemoveWhiteSpace(dataTable)
	for index,value in ipairs(dataTable) do
		if value == nil then
			table.remove(dataTable,index)
		end
	end
	
	return dataTable
end

local function GetInventory(player)
	local slotString
	
	--- get the current slot from dataManager
	maid:GivePromise(
		dataManager:GetCurrentSlot(player)

		:Then(function(stringValue)
			slotString = stringValue
		end)
		
		:Catch(function(...)
			warn(...)
			
			slotString = "slot1"
		end)
	);
	
	local inventoryTable
	
	--- get the current inventory from dataManager
	maid:GivePromise(
		dataManager:GetKey(player,slotString,"inventory")
		
		:Then(function(dataTable)
			inventoryTable = dataTable
		end)
		
		:Catch(function(...)
			warn(...)
			
			inventoryTable = { "Cloth Armor" }
		end)
	);
	
	return inventoryTable
end

local function ChangeInventory(player,insert,value)
	if insert then
		local inventoryTable = GetInventory(player)
		
		table.insert(inventoryTable,#inventoryTable,value)
		
		maid:GivePromise(
			dataManager:ChangeKey(player,"inventory",inventoryTable)
			
			:Then(function(dataDecoded)
				return dataDecoded
			end)
			
			:Catch(function(...)
				warn(...)
				
				return inventoryTable
			end)
		)
	elseif not insert then
		local inventoryTable = GetInventory(player)

		for index,slot in ipairs(inventoryTable) do
			if slot == value then
				table.remove(inventoryTable,index)
				break;
			end
		end
		

		maid:GivePromise(
			dataManager:ChangeKey(player,"inventory",inventoryTable)

			:Then(function(dataDecoded)
				return dataDecoded
			end)

			:Catch(function(...)
				warn(...)

				return inventoryTable
			end)
		)
	end
end

--------------------- Public functions ---------------------
function InventoryManager:AddItem(player,itemName,itemValue)
	return promise.new(function(resolve,reject,cancel)
		local inventory
	end)
end