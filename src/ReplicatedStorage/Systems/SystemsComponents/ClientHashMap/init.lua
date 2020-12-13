--Author .4thAxis
--10/13/2020

--[[
	The hashmap will hold useful client methods in order to construct -
	proper abstraction and modularity. This module serves as a directory.
]]

local HashMap = {
	EnumarationMethods = require(script.ClientCoreScripts.EnumarationUtilties),
	WeaponManager = require(script.ClientCoreScripts.WeaponManager)
}

return HashMap
