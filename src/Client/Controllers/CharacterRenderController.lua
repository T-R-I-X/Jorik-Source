-- Character Render Controller
-- .Trix
-- August 29, 2020

local CharacterRenderController = {}

-- Services
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

-- Modules
local utils;

-- Objects
local player = players.LocalPlayer
local character = player.Character

function CharacterRenderController:Start()
    local debounce = false

    --## function gets fired when addedPlayer gets fired
    function AddPlayer(addedPlayer)
	    local realCharacter = addedPlayer.Character or addedPlayer.CharacterAdded:Wait()
	    if not realCharacter then utils.errorOut(script,"missing character",27) return end

	    --## Generating the fake character
	    local fakeCharacter = replicatedStorage.FakeCharacter:Clone()
	    fakeCharacter.Name = player.UserId
	    fakeCharacter.Parent = character

        --## Setting the primaty part cframe to the real character primary cframe
	    fakeCharacter:SetPrimaryPartCFrame(realCharacter.PrimaryPart.CFrame)

	    --## Setting the HRP and Hitbox transparent on client
	    realCharacter.HumanoidRootPart.Transparency = .5
	    realCharacter.HitBox.Transparency = .5

	    --## Welding the fake character primary to the real characters primary
	    local characterWeld = Instance.new("Weld")

	    characterWeld.Part1 = realCharacter.PrimaryPart
	    characterWeld.Part0 = fakeCharacter.UpperTorso

	    characterWeld.Parent = realCharacter.PrimaryPart
    end

    --## function gets ran every 5 seconds to check if a player was rendered if not then render them
    function CheckPlayerCharacters()
        if debounce then
            return
        end
        wait(2)

        for _,checkPlayer in pairs(players:GetPlayers()) do
            if checkPlayer.Character then
                if checkPlayer.Character:WaitForChild(checkPlayer.UserId,5) then
                    return
                else
                    AddPlayer(player)

                    return
                end
            else
                return
            end
        end
    end

    ----------------- Events ------------------
    self._addedPlayer:Connect(AddPlayer)

    ----------------- Run service ------------------
    runService.HeartBeat:Connect(CheckPlayerCharacters)
end

function CharacterRenderController:Init()
    utils = self.Shared.Utils
end

return CharacterRenderController