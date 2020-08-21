

local methods = {};

local textLabelProps = {
    Parent = playerGui,
    Name = "ErrorDependant",
    TextColor = Color3.new(255,255,0),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold
}

methods.splitNumberFromString = function (splitString)
    local _,res = string.gsub(splitString,"[1-300]")

    if res ~= nil then return res end

    return " "
end

methods.splitStringFromNumber = function (splitString)
    local _,res = string.gsub(splitString,"[a-Z]")

    if res ~= nil then return tonumber(res) end

    return 1
end

methods.errorOut = function (errorScript,message,line)
    if not errorScript or not message or not line then return warn("(" .. errorScript:GetFullName() .. ") missing params : line 14") end

    message = tostring(message) .. ": "
    line = "line " .. tostring(line)
    errorScript = "(" .. errorScript:GetFullName() .. ") "

    newMessage = errorScript .. message .. line

    return warn(newMessage)
end

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
        self.errorOut(script,"user is not a developer",45)
    end
end

return methods