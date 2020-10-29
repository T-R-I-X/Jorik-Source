wait(10)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local require = require(ReplicatedStorage:WaitForChild("Engine"))

local dataManager = require("DataManager")
local maid = require("Maid").new()
local ToolMetaData = require("ToolMetadata")
local ArmorMetaData = require("ArmorMetadata")
local ShieldMetaData = require("ShieldMetadata")

dataManager.init()

local function Load(player)
	local dataTable
	
	repeat runService.Stepped:Wait() until dataManager._init == true
	
	maid:GivePromise(
		dataManager:GetData(player,"slot1")
		
		:Then(function(dataEncoded,dataDecoded)
			dataTable = dataDecoded
		end)
		:Catch(function(...)
			warn("Couldn't equip sword data \n")
			warn(...)
	end))
	
	repeat wait(); until dataTable ~= nil
	
	local Tool = ToolMetaData[dataTable.weapon]
	local Armor = ArmorMetaData[dataTable.armor]
	local Shield = ShieldMetaData["Wooden Shield"]
	
	assert(Tool,"No tool found")
	assert(Armor,"No armor found")
	assert(Shield,"No shield found")

	local SwordClass = Tool.GetClass
	local Sword = SwordClass.new(Tool)
	
	local ArmorClass = Armor.GetClass
	local Armor = ArmorClass.new(Armor)
	
	local ShieldClass = Shield.GetClass
	local Shield = ShieldClass.new(Shield)
	
	maid:GivePromise(
		Sword:Equip(player.Character:WaitForChild("RightHand"))
		
		:Then(function(tool)-- if promise wasn't rejected
			
			print("Equipped " .. tool.Name)
		end)
		
		:Catch(function(...)-- if promise was rejected
			
			warn(...)
		end))
	
	maid:GivePromise(
		Shield:Equip(player.Character:WaitForChild("LeftHand"))

		:Then(function(Shield)-- if promise wasn't rejected

			print("Equipped " .. Shield.Name)
		end)

		:Catch(function(...)-- if promise was rejected

			warn(...)
		end))
	
	maid:GivePromise(
		Armor:Equip(player.Character)
		
		:Then(function(armor)
			
			print("Equipped " .. armor.Name)
		end)
		
		:Catch(function(...)
			
			warn(...)
		end)
	)
	
	Sword:Swing()
end


for _,player in ipairs(game.Players:GetPlayers()) do
	if player.ClassName == "Player" then
		Load(player)
	end
end
game.Players.PlayerAdded:Connect(Load)



 


