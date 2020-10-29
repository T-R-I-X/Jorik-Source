wait(2)
local sg = game.StarterGui
local Settings = script.Parent.Parent:WaitForChild("Settings")
local Admins = Settings:WaitForChild("Admins")
local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TopBarTransparency = PlayerGui:GetTopbarTransparency()
local ChatBar = Settings:WaitForChild("Custom Chat Bar")

local BanPlayer = script.Parent:WaitForChild("BanPlayer")
local Panel = script.Parent:WaitForChild("Panel")
local PB = Panel:WaitForChild("Frame")

local PanelButtons = {
	BanPlayer = PB:WaitForChild("BanPlayer")
}
local panel_size = {
	[true] = UDim2.new(0, 350, 0, 280),
	[false] = UDim2.new(0, 00, 0, 0)
}
local panel_position = {
	[true] = UDim2.new(0, 20, 0, 10),
	[false] = UDim2.new(0, 120, 0, 10)
}

function update()
	wait()
	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	local Backpack = sg:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
	local Chat = sg:GetCoreGuiEnabled(Enum.CoreGuiType.Chat)
	local EmotesMenu = sg:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu) and humanoid.RigType == Enum.HumanoidRigType.R15
	script.Parent.Visible = true
	local Buttons = {Backpack, Chat, EmotesMenu}
	local pos = 55
	for _, v in pairs (Buttons) do
		if v then
			pos = pos + 50
		end
	end
	local disablebar = false
	local supported_uis = Settings:WaitForChild("Supported Third-Party TopBar UIs")
	for _, v in pairs (supported_uis:GetChildren()) do
		if PlayerGui:FindFirstChild(v.Name) then
			pos = pos + v.Value
			disablebar = true
		end
	end
	wait()
end
update()
LocalPlayer.CharacterAdded:connect(update)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Event = ReplicatedStorage:WaitForChild("ChatGuiEvent")

local BanPlayer_Buttons = {
	Confirm = BanPlayer:WaitForChild("Confirm"),
	Cancel = BanPlayer:WaitForChild("Cancel"),
	TimerButtons = BanPlayer:WaitForChild("TimerButtons"),
	Reason = BanPlayer:WaitForChild("Reason"),
	Username = BanPlayer:WaitForChild("Username")
}

local Days = BanPlayer_Buttons.TimerButtons:WaitForChild("0Days")
local Hours = BanPlayer_Buttons.TimerButtons:WaitForChild("1Hours")
local Minutes = BanPlayer_Buttons.TimerButtons:WaitForChild("2Minutes")
local Timer = {Days, Hours, Minutes}

local positions = {
	[true] = UDim2.new(0.5, -140, 0.5, -110),
	[false] = UDim2.new(0.5, -140, -1, 0)
}
local tween_info = {
	[true] = {Direction = Enum.EasingDirection.Out, Style = Enum.EasingStyle.Quad},
	[false] = {Direction = Enum.EasingDirection.In, Style = Enum.EasingStyle.Quad}
}
BanPlayer.Position = positions[false]

local TweenService = game:GetService("TweenService")
function Tween(item, properties, direction, style, t)
	local info = TweenInfo.new(t, style, direction)
	return TweenService:Create(item, info, properties)
end

--Make timer buttons only numbers
function NumberOnlyString(str)
	if not tonumber(str) then
		for i = 1, #str do
			local letter = string.sub(str, i, i)
			if not tonumber(letter) then
				if i == 1 then
					str = string.sub(str, 2)
				elseif i == #str then
					str = string.sub(str, 1, #str - 1)
				else
					str = string.sub(str, 1, i-1) .. string.sub(str, i+1)
				end
			end
		end
	end
	return str
end

for _, textbox in pairs (Timer) do
	textbox.Changed:connect(function()
		if not tonumber(textbox.Text) then
			textbox.Text = NumberOnlyString(textbox.Text)
		end
	end)
end


local Panel_Arrow = Panel:WaitForChild("Arrow")

function Open_BanPlayer(val)
	BanPlayer:TweenPosition(positions[val], tween_info[val].Direction, tween_info[val].Style, 0.2, true)
	if not val then
		BanPlayer_Buttons.Username.Text = ""
		BanPlayer_Buttons.Reason.Text = ""
		for _, v in pairs (Timer) do
			v.Text = ""
		end
	end
end

function OnEvent(from, data)
	if data and data.Func then
		if data.Func == "OpenBanUI" then
			Open_BanPlayer(true)
		end
	end
end




BanPlayer_Buttons.Cancel.MouseButton1Click:connect(function()
	Open_BanPlayer(false)
end)

Event.OnClientEvent:connect(OnEvent)
BanPlayer_Buttons.Username.Changed:connect(function()
	if string.find(BanPlayer_Buttons.Username.Text, " ") then
		local text = string.gsub(BanPlayer_Buttons.Username.Text, " ", "")
		BanPlayer_Buttons.Username.Text = text
	elseif string.find(BanPlayer_Buttons.Username.Text, "	") then
		local text = string.gsub(BanPlayer_Buttons.Username.Text, "	", "")
		BanPlayer_Buttons.Username.Text = text
	end
end)

local button_bg = {Confirm = {}, Cancel = {}}
local button_hover = {Confirm = {}, Cancel = {}}
function setupbutton(bg, tabl, c1, c2)
	for _, v in pairs (bg:GetChildren()) do
		local dir = Enum.EasingDirection.InOut
		local sty = Enum.EasingStyle.Linear
		local t = 0.1
		if v:IsA("ImageLabel") then
			table.insert(button_bg[tabl], Tween(v, {ImageColor3 = c1}, dir, sty, t))
			table.insert(button_hover[tabl], Tween(v, {ImageColor3 = c2}, dir, sty, t))
		elseif v:IsA("Frame") then
			table.insert(button_bg[tabl], Tween(v, {BackgroundColor3 = c1}, dir, sty, t))
			table.insert(button_hover[tabl], Tween(v, {BackgroundColor3 = c2}, dir, sty, t))
		end
	end
end
setupbutton(BanPlayer_Buttons.Confirm:WaitForChild("Background"), "Confirm", Color3.fromRGB(29, 138, 221), Color3.fromRGB(32, 161, 221))
setupbutton(BanPlayer_Buttons.Cancel:WaitForChild("Background"), "Cancel", Color3.fromRGB(112, 112, 112), Color3.fromRGB(150, 150, 150))
BanPlayer_Buttons.Confirm.MouseEnter:connect(function()
	for _, v in pairs (button_hover.Confirm) do
		v:Play()
	end
end)
BanPlayer_Buttons.Confirm.MouseLeave:connect(function()
	wait()
	for _, v in pairs (button_bg.Confirm) do
		v:Play()
	end
end)

BanPlayer_Buttons.Cancel.MouseEnter:connect(function()
	for _, v in pairs (button_hover.Cancel) do
		v:Play()
	end
end)
BanPlayer_Buttons.Cancel.MouseLeave:connect(function()
	wait()
	for _, v in pairs (button_bg.Cancel) do
		v:Play()
	end
end)

function GetTime()
	local days = (tonumber(Days.Text) or 0) * 86400
	local hours = (tonumber(Hours.Text) or 0) * 3600
	local minutes = (tonumber(Minutes.Text) or 0) * 60
	return days + hours + minutes
end

BanPlayer_Buttons.Confirm.MouseButton1Click:connect(function()
	local message = "/ban"
	local timer
	local Time = GetTime()
	if Time and Time > 0 then
		timer = Time
	end
	
	if timer and timer > 0 then
		message = "/tempban"
	end
	if BanPlayer_Buttons.Username.Text ~= "" then
		message = message .. " " .. BanPlayer_Buttons.Username.Text
		if BanPlayer_Buttons.Reason.Text ~= "" and not timer then
			message = message .. " " .. BanPlayer_Buttons.Reason.Text
		elseif timer then
			message = message .. " " .. timer
		end
	end
	Event:FireServer({user=LocalPlayer.Name, message=message})
	Open_BanPlayer(false)
end)

local PanelButtonColours = {
	[true] = Color3.fromRGB(29, 138, 221),
	[false] = Color3.fromRGB(100, 100, 100)
}

function PanelButtonHover(bg, val)
	for _, v in pairs (bg:GetChildren()) do
		if v:IsA("Frame") then
			Tween(v, {BackgroundColor3 = PanelButtonColours[val]}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1):Play()
		elseif v:IsA("ImageLabel") then
			Tween(v, {ImageColor3 = PanelButtonColours[val]}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1):Play()
		end
	end
end
for panel, button in pairs (PanelButtons) do
	local bg = button:FindFirstChild("Background")
	button.MouseEnter:connect(function()
		if bg then
			PanelButtonHover(bg, true)
		end
	end)
	button.MouseLeave:connect(function()
		if bg then
			PanelButtonHover(bg, false)
		end
	end)
end

PanelButtons.BanPlayer.MouseButton1Click:connect(function()
	Open_BanPlayer(true)
end)

function TweenBG(bg, transparency, t)
	for _, v in pairs (bg:GetChildren()) do
		if v:IsA("Frame") then
			Tween(v, {BackgroundTransparency = transparency}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, t):Play()
		elseif v:IsA("ImageLabel") then
			Tween(v, {ImageTransparency = transparency}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, t):Play()
		end
	end
end
function TweenBGColour(bg, colour, t)
	for _, v in pairs (bg:GetChildren()) do
		if v:IsA("Frame") then
			Tween(v, {BackgroundColor3 = colour}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, t):Play()
		elseif v:IsA("ImageLabel") then
			Tween(v, {ImageColor3 = colour}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, t):Play()
		end
	end
end

------------------------- [ User Settings ]-------------------------
local Pages = Panel:WaitForChild("Pages")
local Home = Pages:WaitForChild("Home")
local ButtonFrame = Home:WaitForChild("Frame")
local FontSize = Home:WaitForChild("FontSize")
local HideChat = ButtonFrame:WaitForChild("00HideChat")
local DarkMode = ButtonFrame:WaitForChild("10DarkMode")
local Info = ButtonFrame:WaitForChild("20Info")
local Emojis = ButtonFrame:WaitForChild("40Emojis")
local Commands = ButtonFrame:WaitForChild("30Commands")

local DarkTheme = script.Parent.Parent:WaitForChild("DarkTheme")

local Buttons = FontSize:WaitForChild("Buttons")
local FS_Buttons = {Small = Buttons:WaitForChild("Small"), Medium = Buttons:WaitForChild("Medium"), Large = Buttons:WaitForChild("Large")}
local FS_Active = Buttons:WaitForChild("Active")

local Config = {
	['ChatHidden'] = Settings:WaitForChild("Chat Hidden"),
	['CanChangeTheme'] = Settings:WaitForChild("Can Change Theme")
}

local current = Settings:WaitForChild("Font Size"):WaitForChild("Default")
if current.Value and FS_Buttons[current.Value.Name] then
	local position = UDim2.new(0, FS_Buttons[current.Value.Name].Position.X.Offset, 0.5, -11)
	FS_Active.Position = position
end
for t, button in pairs (FS_Buttons) do
	local highlight = button:WaitForChild("Highlight")
	button.MouseEnter:connect(function()
		TweenBG(highlight, 0.9, 0.05)
	end)
	button.MouseLeave:connect(function()
		wait()
		TweenBG(highlight, 1, 0.05)
	end)
	button.MouseButton1Click:connect(function()
		local position = UDim2.new(0, button.Position.X.Offset, 0.5, -11)
		FS_Active:TweenPosition(position, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		local font = current.Parent:FindFirstChild(t)
		if font then
			current.Value = font
		end
	end)
end

local DM_Active = DarkMode:WaitForChild("active")
local DM_Checked = DM_Active:WaitForChild("checked")
local GH_Checked = HideChat:WaitForChild("active"):WaitForChild("checked")
local Checked = {
	Position = {[true] = UDim2.new(0, 0, 0, 0), [false] = UDim2.new(0.5, 0, 0.5, 0)},
	Size = {[true] = UDim2.new(1, 0, 1, 0), [false] = UDim2.new(0, 0, 0, 0)}
}


function DarkModeEnabled(val)
	DarkTheme.Value = val
	DM_Checked:TweenSizeAndPosition(Checked.Size[val], Checked.Position[val], "Out", "Quad", 0.05, true)
end
function HiddenChatEnabled(val)
	Config.ChatHidden.Value = val
	GH_Checked:TweenSizeAndPosition(Checked.Size[val], Checked.Position[val], "Out", "Quad", 0.05, true)
end

local Checkbox_Buttons = {DarkMode, HideChat}
local Page_Buttons = {Info, Commands, Emojis}
for _, button in pairs (Checkbox_Buttons) do
	local background = button:WaitForChild("Background")
	button.MouseEnter:connect(function()
		TweenBG(background, 0.9, 0.1)
	end)
	button.MouseLeave:connect(function()
		wait()
		TweenBG(background, 1, 0.1)
	end)
end


DarkModeEnabled(DarkTheme.Value)
DarkMode.MouseButton1Click:connect(function()
	DarkModeEnabled(not DarkTheme.Value)
end)
HiddenChatEnabled(Config.ChatHidden.Value)
HideChat.MouseButton1Click:connect(function()
	HiddenChatEnabled(not Config.ChatHidden.Value)
end)

function SwitchMenu(from, to, t)
	local from_position = UDim2.new(1, 0, 0, 0)
	local to_position = UDim2.new(1, 5, 0, 0)
	local next_pos = UDim2.new(0, 0, 0, 0)
	if from.Name == "Home" then
		from_position = UDim2.new(-1, -5, 0, 0)
	end
	from.Position = next_pos
	to_position = to_position
	from:TweenPosition(from_position, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, t, true)
	to:TweenPosition(next_pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, t, true)
end
for _, v in pairs (Pages:GetChildren()) do
	if v.Name == "Home" then
		v.Position = UDim2.new(0, 0, 0, 0)
	else
		v.Position = UDim2.new(1, 0, 0, 0)
	end
end


for _, button in pairs (Page_Buttons) do
	local background = button:WaitForChild("Background")
	button.MouseEnter:connect(function()
		TweenBGColour(background, PanelButtonColours[true], 0.05)
	end)
	button.MouseLeave:connect(function()
		wait()
		TweenBGColour(background, PanelButtonColours[false], 0.05)
	end)
	button.MouseButton1Click:connect(function()
		local frame = Pages:FindFirstChild(string.sub(button.Name, 3))
		if frame then
			local back = frame:FindFirstChild("Back")
			if back then
				SwitchMenu(Home, frame, 0.2)
				local back_bg = back:WaitForChild("Background")
				back.MouseEnter:connect(function()
					TweenBGColour(back_bg, PanelButtonColours[true], 0.05)
				end)
				back.MouseLeave:connect(function()
					wait()
					TweenBGColour(back_bg, PanelButtonColours[false], 0.05)
				end)
				back.MouseButton1Click:connect(function()
					SwitchMenu(frame, Home, 0.2)
				end)
			end
		end
	end)
end

local InfoPage = Pages:WaitForChild("Info")
local PlaceName = InfoPage:WaitForChild("PlaceName")
local Creator = PlaceName:WaitForChild("Creator")
local LastUpdate = InfoPage:WaitForChild("LastUpdate")
local Time = LastUpdate:WaitForChild("Time")
local LastUpdatedValue = ReplicatedStorage:WaitForChild("LastUpdated")
local ServerOutdated = LastUpdatedValue:WaitForChild("ServerOutdated")

local creator_a = InfoPage:WaitForChild("Title"):WaitForChild("Creator")
creator_a.Text = "by " .. game.Players:GetNameFromUserIdAsync(22005784)
creator_a.Visible = true
creator_a.Position = UDim2.new(1, 2, 0, 11)
creator_a.Size = UDim2.new(0, 39, 0, 16)
creator_a.ZIndex = 95
if game.PlaceId > 0 then
	local i = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
	PlaceName.Text = i.Name
	if game.CreatorId > 0 and game.CreatorType == Enum.CreatorType.User then
		Creator.Text = "by " .. tostring(game.Players:GetNameFromUserIdAsync(game.CreatorId))
	elseif game.CreatorId > 0 then
		Creator.Text = "by " .. tostring(game:GetService("GroupService"):GetGroupInfoAsync(game.CreatorId).Name)
	end
	Time.Text = LastUpdatedValue.Value
end

LastUpdatedValue.Changed:connect(function(val)
	Time.Text = val
	if ServerOutdated.Value then
		Time.Text = val .. " [Old Server Version]"
	end
end)


local emojis = {
	[":smile:"] = "😀",[":blush:"] = "😊",[":tongue3:"] = "😜",[":tongue2:"] = "😝",[":tongue1:"] = "😛",
	[":money_mouth:"] = "🤑",[":relieved:"] = "😌",[":pensive:"] = "😔",[":unamused:"] = "😒",[":smirk:"] = "😏",
	[":joy:"] = "😂",[":sweat_smile:"] = "😅",[":laugh:"] = "😆",[":grin:"] = "😆",[":happy:"] = "😃",
	[":upside_down:"] = "🙃",[":slight_smile:"] = "🙂",[":nerd:"] = "🤓",[":cool:"] = "😎",[":grimacing:"] = "😬",
	[":yum:"] = "😋",[":wink:"] = "😉",[":stare:"] = "😶",[":hushed:"] = "😯",[":frown:"] = "😦",[":surprise:"] = "😮",
	[":anguished:"] = "😧",[":rolleyes:"] = "🙄",[":thinking:"] = "🤔",[":sleepy:"] = "😪",[":confounded:"] = "😖",
	[":preserve:"] = "😣",[":tired:"] = "😩",[":weary:"] = "😩",[":triumph:"] = "😤",[":worried:"] = "😟",[":confused:"] = "😕",
	[":sad:"] = "☹",[":neutral:"] = "😐",[":expressionless:"] = "😑",[":sleeping:"] = "😴",[":halo:"] = "😇",[":flushed:"] = "😳",
	[":heart_eyes:"] = "😍",[":scream:"] = "😱",[":coldsweat:"] = "😰",[":fearful:"] = "😨",[":dizzy:"] = "😵",[":zipped:"] = "🤐",
	[":mask:"] = "😷",[":temp:"] = "🤒",[":bandage:"] = "🤕",[":pouting:"] = "😡",[":angry:"] = "😠",[":disappointed:"] = "😞",
	[":sweat:"] = "😓",[":crying:"] = "😭",[":relieved_sad:"] = "😥",[":cry:"] = "😢",[":poop:"] = "💩",[":smile_horns:"] = "😈",
	[":imp:"] = "👿",[":alien:"] = "👽",[":ghost:"] = "👻",[":clap:"] = "👏",[":thumbs_up:"] = "👍",[":thumbs_down:"] = "👎",
	[":point_left:"] = "👈",[":point_right:"] = "👉",[":point_up:"] = "👆",[":point_down:"] = "👇",[":hand:"] = "✋",[":hand2:"] = "🤚",
	[":wave:"] = "👋",[":eyes:"] = "👀",[":think:"] = "🧐",[":skull2:"] = "☠",[":skull:"] = "💀",[":pumpkin:"] = "🎃",
	[":robot:"] = "🤖",[":clown:"] = "🤡",[":sneeze:"] = "🤧",[":liar:"] = "🤥",[":sick:"] = "🤢",[":head_explode:"] = "🤯",
	[":vomit:"] = "🤮",[":shush:"] = "🤫",[":handovermouth:"] = "🤭"
}
local emojiframe = Pages:WaitForChild("Emojis"):WaitForChild("ScrollingFrame")
local emojitext = script:WaitForChild("Emoji")

for command, emoji in pairs (emojis) do
	local t = emojitext:clone()
	t.Text = emoji .. " " .. command
	t.Parent = emojiframe
	t.Visible = true
end
emojiframe.CanvasSize = UDim2.new(0, 0, 0, emojiframe:WaitForChild("UIGridLayout").AbsoluteContentSize.Y)

local CommandFrame = Pages:WaitForChild("Commands"):WaitForChild("ScrollingFrame")
local commandtext = script:WaitForChild("Command")

local Commands = Settings:WaitForChild("Commands")
local CommandKey = Settings:WaitForChild("Command Key")
local isAdmin = Settings:WaitForChild("Admins"):FindFirstChild(LocalPlayer.Name)
local i = 0
for _, v in pairs (Commands:GetChildren()) do
	local cmd = v:FindFirstChild("Command")
	local desc = v:FindFirstChild("Description")
	local adminrequired = v:FindFirstChild("Admin Required")
	if cmd and desc and adminrequired then
		if not adminrequired.Value or (adminrequired.Value and isAdmin) then
			i = i + 1
			local x = commandtext:clone()
			local c = x:WaitForChild("Command")
			local y = x:WaitForChild("Description")
			local bg = x:WaitForChild("Background")
			local text = CommandKey.Value .. cmd.Value
			c.Text = text
			y.Text = desc.Value
			x.Parent = CommandFrame
			y.Position = UDim2.new(0, c.TextBounds.X + 10, 0.5, -7)
			y.Size = UDim2.new(1, -c.TextBounds.X - 10, 0, 16)
			x.Visible = true
			if i % 2 == 0 then
				bg.Visible = true
			end
		end
	end
	CommandFrame.CanvasSize = UDim2.new(0, 0, 0, CommandFrame:WaitForChild("UIListLayout").AbsoluteContentSize.Y)
end

local list = ButtonFrame:WaitForChild("UIListLayout")
function CanChangeThemeUpdate()
	if Config.CanChangeTheme.Value then
		DarkMode.Parent = ButtonFrame
	else
		DarkMode.Parent = script
	end
	panel_size[true] = UDim2.new(panel_size[true].X.Scale, panel_size[true].X.Offset, 0, 110 + list.AbsoluteContentSize.Y)
end
CanChangeThemeUpdate()
Config.CanChangeTheme.Changed:connect(CanChangeThemeUpdate)

local DisableCustomChatBarOn = Settings:WaitForChild("Supported Third-Party Commands")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

function DisableChatBar(v)
	for _, x in pairs (DisableCustomChatBarOn:GetChildren()) do
		if x:IsA("StringValue") and v.Name == x.Name then
			ChatBar.Value = false
			update()
		end
	end
end

for _, v in pairs (PlayerGui:GetChildren()) do
	DisableChatBar(v)
end
PlayerGui.ChildAdded:connect(function(v)
	DisableChatBar(v)
end)

local title = Pages:WaitForChild("Info"):WaitForChild("Title")
local version = script.Parent.Parent:WaitForChild("Version")

title.Text = "v." .. tostring(version.Value)
title.Size = UDim2.new(0, title.TextBounds.X, 0, 35)