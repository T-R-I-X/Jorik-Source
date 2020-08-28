local methods = {}
methods.__index = methods

local data = {}

-- @@  Playerdata manager
-- @@  Manages all player data in the game

--// Modules
local modules = script.Parent.manager_Network
local utils = modules.helper_Modules
local network = modules.manager_Network

--// Services
local playerService = network:GetService("Players")
local dataStoreService = network:GetService("DataStoreService")

local globalFirst = dataStoreService:GetGlobalDataStore("globalFirst")
local globalBackup = dataStoreService:GetGlobalDataStore("globalBackup")

--.. creates a new blank save slate
methods.new = function ()
    return {
        gold=0,
        experience=0,
        level=1,
        kills=0,
        lastsaved=nil,

        class=nil,

        items={},
        equiped={},
        cosmetics={},
        points={}
    }
end

--.. saves the player data contained data table
function methods:save(self,player)
    if not player then return end

    --## defines the player and default data in the data table
    if not data[player.UserId] then
        data[player.UserId] = self:get(player) or self.new()
    end

    local success,err1 = pcall(function ()
        globalFirst:SetAsync("asYncQ-"..player.UserId,data[player.UserId])
    end)

    --## if saving data is succesful then return else try to back the data up
    if success then
        return true,"global"
    elseif err1 then
       local backed,err2 = pcall(function ()
           globalBackup:SetAsync("aisncQ-"..player.UserId,data[player.UserId])
       end)

       if backed then
            return true,"backup"
       elseif err2 then
            return false,"backup"
       end
    end
end

function methods:get(player,value)
    if value and type(value) == "number" and player then
        local success,err = pcall(function ()

        end)

        if not data[player.UserId] then
            data[player.UserId] = self.new()
        end


    elseif player then

    end
end

return methods