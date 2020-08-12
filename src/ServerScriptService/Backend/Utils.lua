local methods = {};

--// Add later for basic utils

methods.splitNumberFromString = function (splitString)
    local _,res = string.gsub(splitString,"[1-300]")

    if res ~= nil then return res end

    return " "
end

return methods