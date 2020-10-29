if not script.Parent:FindFirstChildOfClass("Humanoid") then script.Disabled = true end

function Colour(r,g,b)
	return Color3.new(r/255, g/255, b/255)
end

local Colours = {
	Colour(255, 0, 0),
	Colour(255, 115, 0),
	Colour(255, 255, 0),
	Colour(0, 255, 0),
	Colour(0, 0, 255),
	Colour(170, 0, 170)
}

local TweenService = game:GetService("TweenService")
function Tween(item, properties, direction, style, t)
	local info = TweenInfo.new(t, style, direction)
	TweenService:Create(item, info, properties):Play()
end

while true do
	for _, colour in pairs (Colours) do
		for _, part in pairs (script.Parent:GetChildren()) do
			if part:IsA("BasePart") then
				Tween(part, {Color = colour}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 1)
			end
		end
		wait(0.5)
	end
	
	wait(0.5)
end