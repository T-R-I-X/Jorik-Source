--- Constants for the character IK calculations
-- @module IKConstants

local require = require(game:GetService("ReplicatedStorage"):WaitForChild("Engine"))

local Table = require("Table")

return Table.readonly({
	REMOTE_EVENT_NAME = "IKRigRemoteEvent";
	COLLECTION_SERVICE_TAG = "IKRig";
})