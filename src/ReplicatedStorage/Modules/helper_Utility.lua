-- @@ Utility Module
-- @@ Has all the utilitys to make my life easier

local methods = {};
methods.__index = methods

--// Objects
local assertEvent = assert
local selectEvent = select
local unpackEvent = unpack
local typeEvent = type

--// Values
local textLabelProps = {
    Parent = playerGui,
    Name = "ErrorDependant",
    TextColor = Color3.new(255,255,0),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold
}

--------------------------------- Functions ---------------------------------

--.. Splits a number from a string
methods.splitNumberFromString = function (splitString)
    local _,res = string.gsub(splitString,"[1-500]")

    if res ~= nil then return res end

    return " "
end

--.. Splits a string from a number
methods.splitStringFromNumber = function (splitString)
    local _,res = string.gsub(splitString,"[a-Z]")

    if res ~= nil then return tonumber(res) end

    return 1
end

--.. "Errors" a script aka. provides a more detailed report
methods.errorOut = function (errorScript,message,line)
    if not errorScript or not message or not line then return warn("(" .. errorScript:GetFullName() .. ") missing params : line 14") end

    message = tostring(message) .. ": "
    line = "line " .. tostring(line)
    errorScript = "(" .. errorScript:GetFullName() .. ") "

    newMessage = errorScript .. message .. line

    return warn(newMessage)
end

--.. Helps developers by creating the warn on their screen via text label
function methods.createDeveloperWarn (self,player,message)
    if not player or not player:IsA("Player") or not message then self.errorOut(script,"missing params or player isn't a player",36) return end

    --## if userid not found in the developer table then return
    if developerTable[player.UserId] ~= nil then
        local playerGui = player:WaitForChild("PlayerGui",15)

        --## If not playergui then errorout
        if not playerGui then self.errorOut(script,"missing PlayerGui",36) return end

        message = tostring(message)

        local textLabel = Instance.new("TextLabel")
        textLabel.Text = message

        --## Setting the properties to the text label
        for prop,value in pairs(textLabelProps) do
            textLabel[prop] = value
        end
    else
        self.errorOut(script,"user is not a developer",45) return
    end
end

----------------------------- Event utility -----------------------------
methods.event = {}
methods.event.__index = methods.event

--.. Creates a new event
function methods.event.new()
	local self = setmetatable({
		_connections = {};
		_destroyed = false;
		_firing = false;
		_bindable = Instance.new("BindableEvent");
	}, methods.event)

	return self
end

--.. Fires a event
function methods.event:Fire(...)
	self._args = {...}
    self._numArgs = selectEvent("#", ...)

	self._bindable:Fire()
end

--.. "Awaits" an event
function methods.event:Wait()
    self._bindable.Event:Wait()

	return unpackEvent(self._args, 1, self._numArgs)
end

--.. Connects a function to an event
function methods.event:Connect(func)
	assertEvent(not self._destroyed, "Cannot connect to destroyed event")
	assertEvent(typeEvent(func) == "function", "Argument must be function")

    return self._bindable.Event:Connect(function()
		func(unpackEvent(self._args, 1, self._numArgs))
	end)
end

--.. Disconnects all functions from the event
function methods.event:DisconnectAll()
	self._bindable:Destroy()
	self._bindable = Instance.new("BindableEvent")
end

--.. Destroys the created event
function methods.event:Destroy()
    if (self._destroyed) then return end

	self._destroyed = true
	self._bindable:Destroy()
end

return methods 