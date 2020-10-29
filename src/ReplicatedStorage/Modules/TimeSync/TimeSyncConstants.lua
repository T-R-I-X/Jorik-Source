---
-- @module TimeSyncConstants
-- @author Quenty

local require = require(game:GetService("ReplicatedStorage"):WaitForChild("Engine"))

local Table = require("Table")

return Table.readonly({
	REMOTE_EVENT_NAME = "TimeSyncServiceRemoteEvent";
	REMOTE_FUNCTION_NAME = "TimeSyncServiceRemoteFunction";
})