local methods = {};

--// Add later for basic utils

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
    if not player or not player:IsA("Player") or not message then self.errorOut(script,"missing params",36) return end

    if developerTable[player.UserId] ~= nil then
        local playerGui = player:WaitForChild("PlayerGui",15)

        if not playerGui then self.errorOut(script,"missing PlayerGui",36) return end

        message = tostring(message)

        local textLabel = {
            Parent = playerGui,
            Name = "ErrorDependant",
            Text = message,
            TextColor = Color3.new(255,255,0),
            BackgroundTransparency = 1,
            Font = Enum.Font.SourceSansBold
            
        }
    end
end

return methods