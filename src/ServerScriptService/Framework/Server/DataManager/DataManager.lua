-- Author .Trix
-- Date 10/12/20

local DataManager = {}
DataManager._init = false

-- Service
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local dataStoreService = game:GetService("DataStoreService")
local httpService = game:GetService("HttpService")

-- Modules
local require = require(replicatedStorage:WaitForChild("Engine"))

--- default slot data
local defaultModelData = {
	--- currency
	coins = 0;
	cartelcoins = 0;

	--- equips
	weapon = "Tester Sword";
	shield = "Wooden Shield";
	armor = "Iron Armor";
	helmet = "Cloth Helmet";

	--- Abilites
	Abilities = {

	},

	--- stats
	physical = 1;
	magic = 1;
	health = 1;
	level = 1;
	exp = 0;

	--- extra
	vip = 0;
}

--- setup DataManager
function DataManager.init()
	if DataManager._init then return end

	--- requiring all the modules after the module has returned its value
	DataManager._playerDataManager = require("PlayerDataStoreManager")
	DataManager._maid = require("Maid").new()

	DataManager._dataStoreManager = DataManager._playerDataManager.new(
		dataStoreService:GetDataStore("PlayerData", "Developer_Version"),
		function(player)
			return tostring(player.UserId)
		end)

	--- setting the _init value so it can't be loaded again
	DataManager._init = true
end
------------------------- Private functions -------------------------
local function instance(instanceType,instanceName,instanceParent)
	local temp = Instance.new(instanceType)

	temp.Name = instanceName
	temp.Parent = instanceParent

	return instance
end

local function GetCurrent(player)
	--- get the datastore from the manager
	local dataStore = DataManager._dataStoreManager:GetDataStore(player)

	return dataStore:Load("currentslot","slot1")
end

local function LoadStore(player,slotStoreString)
	local dataFolder = player:FindFirstChild("leaderstats")

	return DataManager._promise.new(function(resolve,reject,cancel)
		if dataFolder then
			dataFolder:Destroy()
		end

		--- get the datastore from the manager | get the substore for the slot being loaded
		local dataStore = DataManager._dataStoreManager:GetDataStore(player)
		local slotStore = dataStore:GetSubStore(slotStoreString):GetSubStore("data")

		dataFolder = instance("Folder","leaderstats", player)

		local slotData = instance("StringValue","slot",dataFolder)

		dataStore:Store("currentslot",slotStoreString)

		DataManager._maid:GivePromise(slotStore:Load("data", defaultModelData):Then(function(value) -- if loading was successful then set the value of slot data
			slotData.Value = httpService:JSONEncode(value)

			resolve(slotData,value)
			warn("Loaded slot: " .. slotStoreString .. " (" .. player.UserId .. ")")
		end):Catch(function(...) --- catch any errors with loading the data
			warn(...)
			reject(...)
		end))
	end)
end

local function DeleteStore(player,slotStoreString)
	return DataManager._promise.new(function(resolve,reject,cancel)
		--- get the datastore from the manager | get the substore for the slot being loaded
		local dataStore = DataManager._dataStoreManager:GetDataStore(player)
		local slotStore = dataStore:GetSubStore(slotStoreString):GetSubStore("data")

		slotStore:Delete("data")

		slotStore:Store("data",defaultModelData)

		DataManager._maid:GivePromise(LoadStore(player,slotStoreString):Then(function(dataEncoded)
			warn("Deleted save slot and reloaded: (" .. player.UserId .. ")")
			resolve(dataEncoded)
		end):Catch(function(...)
			warn(...)
			reject(...)
		end))
	end)
end

------------------------- Public functions -------------------------



--[[
@parm slotString : string
@parm player : instance
@return promise : value
]]
function DataManager:GetData(player,slotString)
	return LoadStore(player,slotString) --- just passing the LoadStore promise thorugh
end

function DataManager:GetKey(player,slotString,keyString)
	return DataManager._promise.new(function(resolve,reject,cancel)
		if not DataManager._init then
			reject("Module hasn't been started yet!")
		end

		--- giving maid the LoadStore promise to tidy up
		DataManager._maid:GivePromise(

			LoadStore(player,slotString)

			--- andThen pass through and check the table for the key
			:andThen(function(dataEncoded,dataDecoded)
				local keyData = dataDecoded[keyString]

				--- check the table for the key
				if keyData ~= nil then
					resolve(keyData)
				else
					reject("No key data")
				end
			end)

			--- catch any errors fetching could've produced
			:Catch(function(...)
				warn(...)
				reject(...)
			end))

	end)
end

--[[
@parm player : instance
@return promise : bool
]]
function DataManager:CompleteNukePlayer(player)
	return DataManager._promise.new(function(resolve,reject,cancel)
		if not DataManager._init then
			reject("Module hasn't been started yet!")
		end

		local currentSlot

		--- giving maid the promise for cleanup
		DataManager._maid:GivePromise(

			GetCurrent(player)

			--- andThen set the currentSlot value to slot
			:andThen(function(value)
				currentSlot = value
			end)

			--- catch any errors that the promise might throw
			:Catch(function(...)
				warn(...)
				reject(...)
			end))

		--- giving the promise to maid for tidy up
		DataManager._maid:GivePromise(

			DeleteStore(player,currentSlot)

			--- and then resolve the promise
			:andThen(function()
				resolve(true)
			end)

			--- catch any errors the fetching might produce
			:Catch(function(...)
				warn(...)
				reject(...)
			end))

	end)
end

--[[
@parm player : instance
@parm key : string
@parm value : string / int
@return promise : table
]]
function DataManager:ChangeKey(player,key,value)
	return DataManager._promise.new(function(resolve,reject,cancel)
		if not DataManager._init then
			reject("Module hasn't been started yet!")
		end

		local slotStoreString

		--- giving maid the GetCurrent promise to tidy up
		DataManager._maid:GivePromise(

			GetCurrent(player)

			--- andThen set the slot store string
			:andThen(function(value)
				slotStoreString = value
			end)

			--- catch any errors fetching could've had
			:Catch(function(...)
				warn(...)
				reject(...)
			end))

		--- get the datastore from the manager | get the substore for the slot being loaded
		local dataStore = DataManager._dataStoreManager:GetDataStore(player)
		local slotStore = dataStore:GetSubStore(slotStoreString):GetSubStore("data")

		local dataTable

		--- giving maid the LoadStore promise to tidy up
		DataManager._maid:GivePromise(

			LoadStore(player,slotStoreString)

			--- then if fetching was successful set the dataTable value
			:Then(function(dataEncoded,dataDecoded)
				dataTable = dataDecoded
			end)

			--- catch any errors data fetching might've had
			:Catch(function(...)
				warn(...)
				reject(...)
			end))

		--- setting the key value
		dataTable[key] = value

		--- storing the new value inside the store
		slotStore:Store(dataTable)

		--- resolving the promise
		resolve(dataTable)
	end)
end

--[[
@parm player : instance
@return promise : string
]]
function DataManager:GetCurrentSlot(player)
	return GetCurrent(player) --- just passing the private function through
end

--[[
@parm commandUser : string
@return promise : bool
]]
function DataManager:NukeAllPlayers()
	return DataManager._promise.new(function(resolve,reject,cancel)
		if not DataManager._init then
			reject("Module hasn't been started yet!")
		end

		--- looping through the players to delete all the stores
		for _,player in ipairs(players:GetPlayers()) do
			if player.ClassName == "player" then
				local slotStoreString = nil

				--- giving the get current slot promise to maid to tidy up
				DataManager._maid:GivePromise(

					DataManager:GetCurrentSlot(player)

					--- then if the fetching was successful
					:Then(function(value)
						slotStoreString = value
					end)

					--- catch the fetch error
					:Catch(function(...)
						warn(...)
						reject(...)
					end))

				--- giving the delete store promise to maid to tidy up
				DataManager._maid:GivePromise(

					DeleteStore(player,slotStoreString)

					--- then if deleting the store was successful log that their data was deleted
					:Then(function(decodedData)
						warn("Deleted: " .. player.Name .. " data")
					end)

					--- catch the promise error if it throws one
					:Catch(function(...)
						warn(...)
						reject(...)
				end))
			end
		end

		--- resolving the promise
		resolve(true)
	end)
end

function DataManager.DisableSaveOnStudio()
	if not DataManager._init then return end

	--- disabling the save on close will midgate the freeze when you stop the game test
	DataManager._dataStoreManager:DisableSaveOnCloseStudio()
end

return DataManager