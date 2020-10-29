-- Author .Trix
-- Date 10/17/20

-- Services
local starterGui = game:GetService("StarterGui")

-- Values
local disableGui = {
	Enum.CoreGuiType.Backpack;
	Enum.CoreGuiType.EmotesMenu;
	Enum.CoreGuiType.Health;
	Enum.CoreGuiType.PlayerList;	
}

--- disable the gui
for _,typeGui in ipairs(disableGui) do
	starterGui:SetCoreGuiEnabled(typeGui,false)
end