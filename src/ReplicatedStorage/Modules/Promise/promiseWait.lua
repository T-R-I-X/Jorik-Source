--- Wraps the wait()/delay() API in a promise
-- @module promiseWait

local Promise = require(script.Parent)

return function(time)
	return Promise.new(function(resolve, reject)
		delay(time, function()
			resolve()
		end)
	end)
end