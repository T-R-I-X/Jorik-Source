-- Author .Trix
-- Date 10/14/20

-- Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- Modules
local require = require(game:GetService("ReplicatedStorage"):WaitForChild("Engine"))
local baseObject = require("BaseObject")

--- setting the meta table, classname, and index
local PlayerDataStoreManager = { }-- setmetatable({}, baseObject)
PlayerDataStoreManager.ClassName = "PlayerDataStoreManager"
PlayerDataStoreManager.__index = PlayerDataStoreManager

------------------------------- Public functions -------------------------------
function PlayerDataStoreManager.new(robloxDataStore, keyGenerator)
	local self = setmetatable(baseObject.new(), PlayerDataStoreManager)
	
	--- modules
	self._dataStore = require("DataStore")
	self._promiseUtils = require("PromiseUtils")
	self._pendingPromiseTracker = require("PendingPromiseTracker")
	self._maid = require("Maid").new()
	
	self._robloxDataStore = robloxDataStore or error("No robloxDataStore")
	self._keyGenerator = keyGenerator or error("No keyGenerator")

	self._maid._savingConns = self._maid.new()

	self._datastores = {} -- [player] = datastore
	self._removing = {} -- [player] = true
	self._pendingSaves = self._pendingPromiseTracker.new()
	self._removingCallbacks = {} -- [func, ...]

	self._maid:GiveTask(players.PlayerRemoving:Connect(function(player)
		if self._disableSavingInStudio then
			return
		end

		self:_removePlayerDataStore(player)
	end))

	game:BindToClose(function()
		if self._disableSavingInStudio then
			return
		end

		self:PromiseAllSaves():Wait()
	end)

	return self
end

--- for if you want to disable saving in studio for faster close time!
function PlayerDataStoreManager:DisableSaveOnCloseStudio()
	assert(runService:IsStudio())

	self._disableSavingInStudio = true
end

--- adds a callback to be called before save on removal
function PlayerDataStoreManager:AddRemovingCallback(callback)
	table.insert(self._removingCallbacks, callback)
end

--- callable to allow manual GC so things can properly clean up.
--- this can be used to pre-emptively cleanup players.
function PlayerDataStoreManager:RemovePlayerDataStore(player)
	self:_removePlayerDataStore(player)
end

function PlayerDataStoreManager:GetDataStore(player)
	assert(typeof(player) == "Instance")
	assert(player:IsA("Player"))

	if self._removing[player] then
		warn("[PlayerDataStoreManager.GetDataStore] - Called GetDataStore while player is removing, cannot retrieve")
		return nil
	end

	if self._datastores[player] then
		return self._datastores[player]
	end

	return self:_createDataStore(player)
end

function PlayerDataStoreManager:PromiseAllSaves()
	for player, _ in pairs(self._datastores) do
		self:_removePlayerDataStore(player)
	end
	return self._maid:GivePromise(self._promiseUtils.all(self._pendingSaves:GetAll()))
end

function PlayerDataStoreManager:_createDataStore(player)
	assert(not self._datastores[player])

	local datastore = self._dataStore.new(self._robloxDataStore, self:_getKey(player))

	self._maid._savingConns[player] = datastore.Saving:Connect(function(promise)
		self._pendingSaves:Add(promise)
	end)

	self._datastores[player] = datastore

	return datastore
end

function PlayerDataStoreManager:_removePlayerDataStore(player)
	assert(typeof(player) == "Instance")
	assert(player:IsA("Player"))

	local datastore = self._datastores[player]
	if not datastore then
		return
	end

	self._removing[player] = true

	for _, func in pairs(self._removingCallbacks) do
		func(player)
	end

	datastore:Save():Finally(function()
		datastore:Destroy()
		self._removing[player] = nil
	end)

	--- prevent double removal or additional issues
	self._datastores[player] = nil
	self._maid._savingConns[player] = nil
end

function PlayerDataStoreManager:_getKey(player)
	return self._keyGenerator(player)
end

return PlayerDataStoreManager