--- ScrollType enum, determines scrolling behavior
-- @module ScrollType

local require = require(game:GetService("ReplicatedStorage"):WaitForChild("Engine"))

local Table = require("Table")

return Table.readonly({
	Vertical = { Direction = "y" };
	Horizontal = { Direction = "x" };
})