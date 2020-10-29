wait()
local player = game.Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local replicatedstorage = game:GetService("ReplicatedStorage")
local chat = game:GetService("Chat")
local textservice = game:GetService("TextService")

local rooms = script.Parent:WaitForChild("ChatRooms")
local textbox = script.Parent:WaitForChild("Frame"):WaitForChild("TextBox")
local mouse = player:GetMouse()

local event = replicatedstorage:WaitForChild("ChatGuiEvent")
local clone = script:WaitForChild("Frame")
local Settings = script.Parent:WaitForChild("Settings")
local darkmode = script.Parent:WaitForChild("DarkTheme")
local assetid = "rbxassetid://"
local ChatBar = Settings:WaitForChild("Custom Chat Bar")

script.Parent:WaitForChild("UserSettings"):WaitForChild("LocalScript").Disabled = false

local canChat = game:GetService("Chat"):CanUserChatAsync(player.UserId)

local FramePosition = {
	[true] = UDim2.new(0.005, 0, 0.38, 0),
	[false] = UDim2.new(-0.23, 0, 0.38, 0)
}

function getplatform()
    if (GuiService:IsTenFootInterface()) then
        return "Console"
    elseif (UserInputService.TouchEnabled and not UserInputService.MouseEnabled) then
        local DeviceSize = workspace.CurrentCamera.ViewportSize; 

		if ( DeviceSize.Y > 600 ) then
			return "Mobile-tablet"
		else
			return "Mobile-phone"
		end
    else
        return "Desktop"
    end
end

local platform = getplatform()

textbox.Parent.Position = FramePosition[false]

function EnableChatBar(val)
	if val then
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
	else
		textbox.Parent:TweenPosition(UDim2.new(0, -300, 1, -40), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)

		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)

		if platform == "Desktop" then
			game.StarterGui:SetCore("ChatWindowPosition", UDim2.new(0, 0, 0.6, 0))
		end

		game.StarterGui:SetCore("ChatActive", true)
	end
end
EnableChatBar(ChatBar.Value)
ChatBar.Changed:connect(EnableChatBar)

local preload_images = {
	"rbxassetid://4731213346",
	"rbxassetid://4731249828",
	"rbxassetid://4731334783"
}
game:GetService("ContentProvider"):PreloadAsync(preload_images)

-- Useful functions
function Color(r,g,b)
	if r and g and b then
		return Color3.new(r/255, g/255, b/255)
	elseif r and not g and not b then
		Color(r,r,r)
	end
end

function getTime(s)
	local year = string.sub(s, 1, 4)
	local month = string.sub(s, 6, 7)
	local day = string.sub(s, 9, 10)
	local Time = string.sub(s, 12,16)
	local Date = (year .. "/" .. month .. "/" .. day)

	return Date, Time
end

function Tween(item, properties, easying_direction, easying_style, t)
	local info = TweenInfo.new(t, easying_style, easying_direction)

	game:GetService("TweenService"):Create(item, info, properties):Play()
end

function TweenBG(item, properties, easying_direction, easying_style, t)
	local info = TweenInfo.new(t, easying_style, easying_direction)

	for _, v in pairs (item:GetChildren()) do
		if v:IsA("ImageLabel") then
			game:GetService("TweenService"):Create(v, info, properties):Play()
		end
	end
end

function removeSpaceFromEnd(text)
	local new = string.reverse(text)
	local f = string.sub(new, 1, 1)

	if f == " " then
		local newtext = string.sub(new, 2)

		return removeSpaceFromEnd(string.reverse(newtext))
	else
		return text
	end
end

function ClearAllChildren(parent, exception)
	for _, v in pairs (parent:GetChildren()) do
		if not v:IsA(exception) then
			v:remove()
		end
	end
end

-----
local settings = {
	['Default Text'] = Settings:WaitForChild("Default Text"),
	['Chat Key'] = Settings:WaitForChild("Chat Key"),
	['Chat Hidden'] = Settings:WaitForChild("Chat Hidden"),
	['Fade Time'] = Settings:WaitForChild("Fade Time"),
	['Background'] = Settings:WaitForChild("Background Enabled"),
	['Theme'] = Settings:WaitForChild("Theme"),
	['Hidden'] = Settings:WaitForChild("Chat Hidden"),
	['Changeable Theme'] = Settings:WaitForChild("Can Change Theme"),
	['Server Chat'] = Settings:WaitForChild("Server Chat"),
	['FontSize'] = Settings:WaitForChild("Font Size"),
	['Admins'] = Settings:WaitForChild("Admins"),
	['Display Name'] = Settings:WaitForChild("Display Name"),
	['NameBG'] = Settings:WaitForChild("NameBackground"),
	['Bubble Chat'] = Settings:WaitForChild("Chat Bubbles"),
	['CommandKey'] = Settings:WaitForChild("Command Key"),
	['MaxLineWidth'] = Settings:WaitForChild("Max Line Width (Pixels)")
}
local currentfont = settings['FontSize']:WaitForChild("Default")

local theme = {
	Light = {
		Primary = settings['Theme']:WaitForChild("Light"):WaitForChild("Primary"),
		Secondary = settings['Theme']:WaitForChild("Light"):WaitForChild("Secondary"),
		Other = settings['Theme']:WaitForChild("Light"):WaitForChild("Other"),
		Icon = settings['Theme']:WaitForChild("Light"):WaitForChild("Icon"),
		Font = settings['Theme']:WaitForChild("Light"):WaitForChild("Font"),
		FontStroke = settings['Theme']:WaitForChild("Light"):WaitForChild("FontStroke"),
		Button = settings['Theme']:WaitForChild("Light"):WaitForChild("Button"),
		ButtonFont = settings['Theme']:WaitForChild("Light"):WaitForChild("ButtonFont"),
		IconColour = settings['Theme']:WaitForChild("Light"):WaitForChild("IconColours"),
		TextStrokeTransparency = settings['Theme']:WaitForChild("Light"):WaitForChild("TextStrokeTransparency")
	},
	Dark = {
		Primary = settings['Theme']:WaitForChild("Dark"):WaitForChild("Primary"),
		Secondary = settings['Theme']:WaitForChild("Dark"):WaitForChild("Secondary"),
		Other = settings['Theme']:WaitForChild("Dark"):WaitForChild("Other"),
		Icon = settings['Theme']:WaitForChild("Dark"):WaitForChild("Icon"),
		Font = settings['Theme']:WaitForChild("Dark"):WaitForChild("Font"),
		FontStroke = settings['Theme']:WaitForChild("Dark"):WaitForChild("FontStroke"),
		Button = settings['Theme']:WaitForChild("Dark"):WaitForChild("Button"),
		ButtonFont = settings['Theme']:WaitForChild("Dark"):WaitForChild("ButtonFont"),
		IconColour = settings['Theme']:WaitForChild("Dark"):WaitForChild("IconColours"),
		TextStrokeTransparency = settings['Theme']:WaitForChild("Dark"):WaitForChild("TextStrokeTransparency")
	}
}


-- Chat Functions
textbox.Text = settings['Default Text'].Value
local timeTillFade = settings['Fade Time'].Value

mouse.KeyDown:connect(function(Key)
	if (Key == settings['Chat Key'].Value or (not ChatBar.Value and Key == "/")) and not settings['Chat Hidden'].Value then
		wait()
		if ChatBar.Value and canChat then
			textbox:CaptureFocus()
		end
		addtoticket()
	end
end)

if textbox.TextBounds.X > 5 and ChatBar.Value then
	textbox.Parent:TweenSize(UDim2.new(0, textbox.TextBounds.X + 40, 0, 30), "Out", Enum.EasingStyle.Quad, 0.2, true)
else
	textbox.Parent:TweenSize(UDim2.new(0, 30, 0, 30), "Out", Enum.EasingStyle.Quad, 0.2, true)
end

textbox.Text = settings['Default Text'].Value:format(string.upper(settings['Chat Key'].Value))

local DisplayName
local setcolours = Settings:WaitForChild("Set Player Colours")
local allcolours = Settings:WaitForChild("All Player Colours"):GetChildren()
local PlayerColour = setcolours:FindFirstChild(player.Name) or allcolours[math.random(1, #allcolours)]

local HideFrom = Settings:WaitForChild("Supported Third-Party Commands")
function HideMessage(msg)
	for _, v in pairs (HideFrom:GetChildren()) do
		if string.lower(string.sub(msg, 1, #v.Value)) == string.lower(v.Value) then
			return true
		end
	end
end

function SendMessage(message)
	local text = tostring(message)
	local Hide = HideMessage(text)
	
	if removeSpaceFromEnd(text) ~= "" and not Hide then
		if string.sub(text, 1, #Settings:WaitForChild("Command Key").Value) ~= Settings:WaitForChild("Command Key").Value then
			local p = player.Name

			if DisplayName then
				p = DisplayName
			end
			
			ReceiveMessage(player, {user=string.format(settings['Display Name'].Value, p), message=removeSpaceFromEnd(text), properties={user={Light = PlayerColour:WaitForChild("Light").Value, Dark = PlayerColour:WaitForChild("Dark").Value}}})
		end
		event:FireServer({user=player.Name, message=removeSpaceFromEnd(text)})
	end
end

textbox.FocusLost:connect(function(entered)
	if not settings['Chat Hidden'].Value then
		if entered then
			SendMessage(textbox.Text)
		end
		
		wait()

		if not textbox:IsFocused() then
			textbox.Parent:TweenSize(UDim2.new(.3, 0, .18, 0), "In", Enum.EasingStyle.Quad, 0.2, true)
		end
	end
	textbox.Text = settings['Default Text'].Value:format(string.upper(settings['Chat Key'].Value))
end)

player.Chatted:Connect(SendMessage)

-- Emojis 
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
function set_emojis(textlabel)
	for key, value in pairs (emojis) do
		textlabel.Text = textlabel.Text:gsub(key, value)
	end
end

-- fade chat
local settings_fadetime = Settings:WaitForChild("Fade Time")
local fadetime = settings_fadetime.Value
local ticket = -100000

function addtoticket()
	ticket = ticket + 1
	if ticket > 100000 then ticket = -100000 end

	local t = ticket

	if not settings['Hidden'].Value then
		rooms:TweenPosition(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
	end
	wait(settings_fadetime.Value)

	if ticket == t then
		rooms:TweenPosition(UDim2.new(-1, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.6, true)
	end
end

for _, v in pairs (rooms:GetChildren()) do
	if v:IsA("ScrollingFrame") then
		v.ChildAdded:connect(function()
			addtoticket()
		end)
	end
end

rooms.ChildAdded:connect(function(v)
	if v:IsA("ScrollingFrame") then
		v.ChildAdded:connect(function()
			addtoticket()
		end)
	end
end)

-- Message Recieved
local sd = true

if canChat then
	textbox.Changed:connect(function()
		if platform == "Desktop" then
			set_emojis(textbox)
		end
		if not settings['Chat Hidden'].Value and sd and ChatBar.Value then
			textbox.Parent:TweenSize(UDim2.new(0, textbox.TextBounds.X + 50, 0, 30), "Out", Enum.EasingStyle.Quad, 0.05, true)
			addtoticket()
		end
	end)
else
	textbox.Position = UDim2.new(0, -300, 1, -40)
	textbox.Parent.Visible = false
end

-- Change Font Size
local max_line_height = Settings:WaitForChild("Max Lines")
function changeFontSize(fontsize)
	for _, room in pairs (rooms:GetChildren()) do
		for _, v in pairs (room:GetChildren()) do
			if v:IsA("Frame") then
				local message = v:FindFirstChild("Message")
				local user = v:FindFirstChild("Name")
				local bg2 = v:FindFirstChild("BackgroundName")
				if user and message then
					local framesize = 20
					local icon = user:FindFirstChildWhichIsA("ImageLabel")
					local msg_offset = 0
					user.TextSize = fontsize.Value
					if fontsize.Name == "Small" then
						user.Size = UDim2.new(1, 0, 1, 0)
					else
						user.Size = UDim2.new(1, 0, 0, fontsize.Value + 2)
					end
					local icon_offset = 0
					if icon and icon.Visible then
						icon_offset = -icon.Position.X.Offset
					end
					if bg2 and settings['NameBG'].Value then
						msg_offset = 5
						if fontsize.Name == "Small" then
							bg2.Size = UDim2.new(0, user.TextBounds.X + user.Position.X.Offset + 5, 0, framesize)
						else
							bg2.Size = UDim2.new(0, user.TextBounds.X + user.Position.X.Offset + 5, user.Size.Y.Scale, user.Size.Y.Offset)
						end
						
					end
					message.Position = UDim2.new(0, user.TextBounds.X + 15 + icon_offset + msg_offset, 0, 0)
					message.TextSize = fontsize.Value
					message.TextYAlignment = "Center"
					if fontsize.Name == "Small" then
						user.Size = UDim2.new(1, 0, 0, framesize)
					else
						user.Size = UDim2.new(1, 0, 0, fontsize.Value + 2)
					end
					if fontsize.Name == "Large" then
						framesize = fontsize.Value + 2
					end
					if message.TextBounds.Y > framesize then framesize = message.TextBounds.Y end
					v.Size = UDim2.new(0, user.TextBounds.X + message.TextBounds.X + 25 + icon_offset + msg_offset, 0, framesize)
				end
			end
		end
	end
	addtoticket()
end
settings['FontSize']:WaitForChild("Default").Changed:connect(changeFontSize)

function prev_frame(frame, num, bgname)
	if num > 1 then
		local prev = frame.Parent:FindFirstChild(tostring(num-1))
		local bg = frame:FindFirstChild(bgname)
		if prev and bg then
			local prev_bg = prev:FindFirstChild(bgname)
			if prev_bg and prev_bg.AbsoluteSize.Y == prev.AbsoluteSize.Y then
				if (bg.AbsoluteSize.X > prev_bg.AbsoluteSize.X) then
					local i = prev_bg:WaitForChild("BottomRight")
					i.BackgroundTransparency = 0
					i:WaitForChild("Frame").Visible = true
				elseif (bg.AbsoluteSize.X < prev_bg.AbsoluteSize.X) then
					local i = bg:WaitForChild("TopRight")
					i.BackgroundTransparency = 0
					i:WaitForChild("Frame").Visible = true
				elseif (bg.AbsoluteSize.X == prev_bg.AbsoluteSize.X) then
					local i = bg:WaitForChild("TopRight")
					i.BackgroundTransparency = 0
					i:WaitForChild("Frame").Visible = true
					local o = prev_bg:WaitForChild("BottomRight")
					o.BackgroundTransparency = 0
					o:WaitForChild("Frame").Visible = true
				end
			end
		end
	end
end
function reverse_format(s, f)
	local x = ""
	local z = s
	for i = 1, #f do
		if i < #f then
			local y = string.sub(f, i, i+1)
			if y == "%s" then
				if i > 1 then
					x = string.sub(f, 1, i-1) .. string.sub(f, i+2)
				else
					x = string.sub(f, i+2)
				end
				z = string.sub(s, i, i+(#s-#x)-1)
			end
		end
	end
	return z
end

local sheets = {
	sheet1 = "http://www.roblox.com/asset/?id=4723413698",
	sheet2 = "http://www.roblox.com/asset/?id=81263049"
}

local icons = {
	premium = {sheet="sheet1", ImageRectSize = Vector2.new(72, 72), ImageRectOffset = {
		Light = Vector2.new(348, 72), Dark = Vector2.new(348, 0)}},
	server = {sheet="sheet1", ImageRectSize = Vector2.new(72, 72), ImageRectOffset = {
		Light = Vector2.new(144, 72), Dark = Vector2.new(144, 0)}},
	creator = {sheet="sheet1", ImageRectSize = Vector2.new(72, 72), ImageRectOffset = {
		Light = Vector2.new(276, 72), Dark = Vector2.new(276, 0)}},
	friend = {sheet="sheet1", ImageRectSize = Vector2.new(72, 72), ImageRectOffset = {
		Light = Vector2.new(72, 72), Dark = Vector2.new(72, 0)}},
	admin = {sheet="sheet1", ImageRectSize = Vector2.new(72, 72), ImageRectOffset = {
		Light = Vector2.new(0, 216), Dark = Vector2.new(0, 144)}},
	rblx_admin = {sheet="sheet1", ImageRectSize = Vector2.new(72, 72), ImageRectOffset = {
		Light = Vector2.new(0, 72), Dark = Vector2.new(0, 0)}},
	cgb = {sheet="sheet2", ImageRectSize = Vector2.new(0, 0), ImageRectOffset = {
		Light = Vector2.new(0, 0), Dark = Vector2.new(0, 0)}}
}

local UserIcons = {
	['lordcrane123'] = {Icon = 'cgb', Color = {Light = Color3.new(39/255, 115/255, 1), Dark = Color3.new(43/255, 174/255, 1)}},
	['JPzo'] = {Icon = 'cgb', Color = {Light = Color3.new(39/255, 115/255, 1), Dark = Color3.new(43/255, 174/255, 1)}}
}

local CustomUserIcons = Settings:WaitForChild("Custom Icons")

function GetUserId(name)
	local id

	pcall(function ()
		id = game.Players:GetUserIdFromNameAsync(name)
	end)

	return id
end
cache = {}

function get_status(username)
	local name = string.lower(tostring(username))
	if cache[name] ~= nil then
		return cache[name]
	end
	if name == "server" then
		local status = {Icon = 'server'}
		cache[name] = status
		return status
	end
	for _, v in pairs (game.Players:GetPlayers()) do
		if string.lower(v.Name) == name and v:IsInGroup(1200769) then
			local status = {Icon = 'rblx_admin', Color = {Light = Color3.new(1, 106/255, 0), Dark = Color3.new(1, 183/255, 0)}}
			cache[name] = status
			return status
		end
	end
	for _, v in pairs (CustomUserIcons:GetChildren()) do
		if string.lower(v.Name) == name and v.Value then
			local status = {Icon = "Custom", Image=v.Value, Name=v.Name}
			cache[name] = status
			return status
		end
	end
	if UserIcons[username] then
		local status = UserIcons[username]
		cache[name] = status
		return status
	end
	if game.CreatorId > 0 then
		local creator = string.lower(game.Players:GetNameFromUserIdAsync(game.CreatorId))
		if creator == name then
			local status = {Icon = 'creator', Color = {Light = Color3.new(1, 29/255, 32/255), Dark = Color3.new(1, 29/255, 32/255)}}
			cache[name] = status
			return status
		end
	end
	for _, admin in pairs (settings['Admins']:GetChildren()) do
		if string.lower(admin.Name) == name then
			local status = {Icon = 'admin'}
			cache[name] = status
			return status
		end
	end

	local id = GetUserId(username)

	if id and player:IsFriendsWith(id) then
		local status = {Icon = 'friend'}
		cache[name] = status
		return status
	end
	for _, v in pairs (game.Players:GetPlayers()) do
		if string.lower(v.Name) == name and v.MembershipType == Enum.MembershipType.Premium then
			local status = {Icon = 'premium'}
			cache[name] = status
			return status
		end
	end
	cache[name] = false
	return false
end
local x = {}
for _, url in pairs (sheets) do
	table.insert(x, url)
end
local ContentProvider = game:GetService("ContentProvider")
ContentProvider:PreloadAsync(x)

function ChangeMessageBG(bg, t, p)
	for _, v in pairs (bg:GetChildren()) do
		if v:IsA("ImageLabel") then
			v.ImageColor3 = theme[t][p].Value
			v.BackgroundColor3 = theme[t][p].Value
		end
		local f = v:FindFirstChild("Frame")
		if f then
			f.BackgroundColor3 = theme[t][p].Value
		end
	end
end

local playerstatus = get_status(player.Name)
local displayname = Settings:WaitForChild("Display Name")
local servername = settings['Server Chat']:WaitForChild("Name")

function GetLines(message, fontSize, font, frameSize, maxlines)
	local TextService = game:GetService("TextService")
	local newmessage = ""
	local sentence = ""
	local line = 1
	for i, word in pairs (string.split(message, " ")) do
		local size2 = TextService:GetTextSize(word, fontSize, font, frameSize)
		if size2.X < settings['MaxLineWidth'].Value then
			sentence = sentence .. word .. " "
			newmessage = newmessage .. word .. " "
		end
		local size = TextService:GetTextSize(sentence, fontSize, font, frameSize)
		if size.X > settings['MaxLineWidth'].Value and i < #message then
			if line >= maxlines then
				break
			end
			newmessage = newmessage .. "\n"
			sentence = ""
			line = line + 1
		end
	end
	if newmessage == "" then
		newmessage = "##### "
	end
	return string.sub(newmessage, 1, #newmessage - 1)
end

function CreateColourTags(c, light, dark, t)
	local LightTheme = Instance.new("Color3Value", c)
	LightTheme.Name = t .. "Light"
	LightTheme.Value = light
	local LightTheme = Instance.new("Color3Value", c)
	LightTheme.Name = t .. "Dark"
	LightTheme.Value = dark
end

local muted = {}

function ReceiveMessage(from, data, r, override_bg)
	if data and data['message'] and string.sub(data['message'], 1, #settings['CommandKey'].Value) == settings['CommandKey'].Value then
		return
	end
	
	if data and (canChat or from == "Server") then
		if not r then
			for _, room in pairs (rooms:GetChildren()) do
				if room.Visible == true then
					r = tostring(room)
				end
			end
		end

		if data and data.Func and data.Player then
			if data.Func == "CachePlayer" and data.Player ~= game.Players.LocalPlayer then
				cache[string.lower(tostring(data.Player))] = nil
				get_status(data.Player)
			elseif data.Func == "SetDisplayName" then
				DisplayName = data.Player
			elseif data.Func == "ResetDisplayName" then
				DisplayName = nil
			elseif data.Func == "RemovePlayerFromCache" then
				cache[string.lower(tostring(data.Player))] = nil
			end
		elseif data and data['user'] and data['message'] then
			for _, room in pairs (rooms:GetChildren()) do
				if string.upper(room.Name) == string.upper(r) and not muted[data['user']] then
					local c = clone:Clone()
					local user = c:WaitForChild("Name")
					local message = c:WaitForChild("Message")
					local bg = c:WaitForChild("Background")
					local bg2 = c:WaitForChild("BackgroundName")
					local icon = user:WaitForChild("Icon")

					c:WaitForChild("Player").Value = tostring(from)
					user.Text = data['user']
					message.Text = data['message']

					local icon_offset = 0
					local msg_offset = 0
					local status = get_status(reverse_format(data['user'], settings['Display Name'].Value))

					if not status then
						status = get_status(from)
					end

					if status then
						if status.Icon == "Custom" and status.Image and status.Name then
							icon.Image = status.Image
							icon.Name = status.Name
							icon_offset = -icon.Position.X.Offset
						else
							icon.ImageRectSize = icons[status.Icon]['ImageRectSize']
							icon.Image = sheets[icons[status.Icon].sheet]
							icon_offset = -icon.Position.X.Offset
							icon.Name = status.Icon
							if darkmode.Value or not (settings['Background'].Value or settings['NameBG'].Value) then
								icon.ImageRectOffset = icons[status.Icon]['ImageRectOffset'].Dark
							else
								icon.ImageRectOffset = icons[status.Icon]['ImageRectOffset'].Light
							end
						end
						icon.Visible = true
					end

					local framesize = 20

					if currentfont then
						user.TextSize = currentfont.Value.Value
						if currentfont.Value.Name == "Small" then
							user.Size = UDim2.new(1, 0, 0, c.Size.Y.Offset)
						else
							user.Size = UDim2.new(1, 0, 0, currentfont.Value.Value + 2)
						end
						message.TextSize = currentfont.Value.Value
						if currentfont.Value.Name == "Large" then
							framesize = currentfont.Value.Value + 2
						end
					end
					c.Parent = room
					c.Name = tostring(#room:GetChildren())
					user.Position = UDim2.new(0, 10 + icon_offset, 0, 0)
					if not settings['Background'].Value then
						bg.Visible = false
						message.Font = Enum.Font.SourceSansBold
					end
					if settings['NameBG'].Value then
						msg_offset = 5
						bg2.Visible = true
						bg2.Size = UDim2.new(0, user.TextBounds.X + user.Position.X.Offset + 5, user.Size.Y.Scale, user.Size.Y.Offset)
						for _, v in pairs (bg2:GetChildren()) do
							if v:IsA("ImageLabel") then
								if darkmode.Value then
									v.ImageColor3 = theme['Dark']['Primary'].Value
								else
									v.ImageColor3 = theme['Light']['Primary'].Value
								end
							end
						end
					else
						bg2.Visible = false
					end

					message.Position = UDim2.new(0, user.TextBounds.X + 15 + icon_offset + msg_offset, 0, 0)
					local setusercolor = setcolours:FindFirstChild(reverse_format(data['user'], settings['Display Name'].Value))

					if data['properties'] then
						local prop_user = data['properties']['user']
						local prop_msg = data['properties']['message']

						if prop_user and ((from and typeof(from) == "string") or from.Neutral or setusercolor) then
							if darkmode.Value then
								user.TextColor3 = prop_user.Dark
							else
								user.TextColor3 = prop_user.Light
							end
							CreateColourTags(c, prop_user.Light, prop_user.Dark, "Player")
						elseif from and from.TeamColor then
							local colour = from.TeamColor.Color
							user.TextColor3 = colour
							CreateColourTags(c, colour, colour, "Player")
						else
							local colour = allcolours[math.random(1, #allcolours)]
							local t = "Light" if darkmode.Value then t = "Dark" end
							user.TextColor3 = colour:WaitForChild(t).Value
							CreateColourTags(c, allcolours:WaitForChild("Light").Value, allcolours:WaitForChild("Dark").Value, "Player")
						end

						if prop_msg then
							if darkmode.Value then
								message.TextColor3 = prop_msg.Dark
							else
								message.TextColor3 = prop_msg.Light
							end
						end
					end

					local p = "Primary"

					if settings['NameBG'].Value then
						p = "Secondary"
					end

					if darkmode.Value or not settings['Background'].Value then -- If dark mode is enabled
						user.TextStrokeColor3 = theme['Dark']['FontStroke'].Value
						user.TextStrokeTransparency = theme['Dark']['TextStrokeTransparency'].Value
						message.TextStrokeColor3 = theme['Dark']['FontStroke'].Value
						message.TextColor3 = theme["Dark"]["Font"].Value
						message.TextStrokeTransparency = theme['Dark']['TextStrokeTransparency'].Value
						ChangeMessageBG(bg, "Dark", p)
						ChangeMessageBG(bg2, "Dark", "Primary")
					else
						user.TextStrokeColor3 = theme['Light']['FontStroke'].Value
						user.TextStrokeTransparency = theme['Light']['TextStrokeTransparency'].Value
						message.TextStrokeColor3 = theme['Light']['FontStroke'].Value
						message.TextColor3 = theme["Light"]["Font"].Value
						message.TextStrokeTransparency = theme['Light']['TextStrokeTransparency'].Value
						ChangeMessageBG(bg, "Light", p)
						ChangeMessageBG(bg2, "Light", "Primary")
					end
					if status and status.Color then
						if darkmode.Value or not settings['Background'].Value then
							message.TextColor3 = status.Color.Dark
						else
							message.TextColor3 = status.Color.Light
						end
						CreateColourTags(c, status.Color.Light, status.Color.Dark, "Message")
					end
					if override_bg then
						local override = Instance.new("BoolValue")
						override.Name = "Override"
						override.Parent = c
						for _, v in pairs (bg:GetChildren()) do
							if v:IsA("ImageLabel") then
								v.ImageColor3 = override_bg
							end
							local f = v:FindFirstChild("Frame")
							if f then
								f.BackgroundColor3 = override_bg
							end
						end
						for _, v in pairs (bg2:GetChildren()) do
							if v:IsA("ImageLabel") then
								v.ImageColor3 = override_bg
							end
							local f = v:FindFirstChild("Frame")
							if f then
								f.BackgroundColor3 = override_bg
							end
						end
					end
					local newmsg = GetLines(data['message'], message.TextSize, message.Font, message.AbsoluteSize, max_line_height.Value)
					message.Text = newmsg
					
					if from and from.Character and from.Character:FindFirstChild("Head") and settings['Bubble Chat'].Value and ChatBar.Value then
						local head = from.Character:WaitForChild("Head")
						chat:Chat(head, newmsg, 3)
					end
					
					set_emojis(message)
					if message.TextBounds.Y > framesize then framesize = message.TextBounds.Y end
					c.Size = UDim2.new(0, user.TextBounds.X + message.TextBounds.X + 25 + icon_offset + msg_offset, 0, framesize)
					
					prev_frame(c, #room:GetChildren(), "Background")
					prev_frame(c, #room:GetChildren(), "BackgroundName")

					game.Debris:AddItem(c,40)
				end
			end
		else
			warn('message data not found.')
		end
	end
end
event.OnClientEvent:connect(ReceiveMessage)

-- Chat Rooms
local server = rooms:WaitForChild("Server")

function room_childadded(r, c)
	r.CanvasSize = UDim2.new(0, 0, 0, (#r:GetChildren()-1) * 20)
	Tween(r, {CanvasPosition = Vector2.new(0, r.CanvasPosition.Y + 20)}, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1)
end

server.ChildAdded:connect(function(c)
	--room_childadded(server, c)
end)


-- Hide Chat
settings['Hidden'].Changed:connect(function(val)
	if val then
		textbox.Parent:TweenSize(UDim2.new(0, 30, 0, 30), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true)
		rooms:TweenPosition(UDim2.new(-1, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.6, true)
		wait()
		if ChatBar.Value then
			textbox.Parent:TweenPosition(FramePosition[false], Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.25, true)
		end
	else
		sd = false
		if ChatBar.Value then
			textbox.Parent:TweenSize(UDim2.new(0, textbox.TextBounds.X + 50, 0, 30), "Out", Enum.EasingStyle.Quad, 0.5, true)
			textbox.Parent:TweenPosition(FramePosition[true], Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.25, true)
		end
		rooms:TweenPosition(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.6, true)
		wait(0.5)
		sd = true
	end
end)


-- Change Themes
function changeFont(parent, c)
	if parent and c then
		if parent:IsA("TextLabel") then
			parent.TextColor3 = c
		end
		for _, v in pairs (parent:GetChildren()) do
			changeFont(v, c)
		end
	end
end
function changeBG(bg, val)
	for _, v in pairs (bg:GetChildren()) do
		if v:IsA("ImageLabel") then
			v.ImageColor3 = val
			local f = v:FindFirstChild("Frame")
			if f then
				v.BackgroundColor3 = val
				f.BackgroundColor3 = val
			end
		end
	end
end
function change_themes(val)
	local t = "Light"
	if val then t = "Dark" end

	local f = script.Parent:WaitForChild("Frame")
	local f_bg = f:WaitForChild("Background")
	local f_s = f:WaitForChild("SettingsButton")
	local f_s_bg = f_s:WaitForChild("Background")
	local icon = f_s:WaitForChild("ImageLabel")
	local text = f:WaitForChild("TextBox")

	icon.Image = theme[t]['Icon'].Value
	changeBG(f_bg, theme[t]['Secondary'].Value)
	changeBG(f_s_bg, theme[t]['Primary'].Value)
	text.TextColor3 = theme[t]['Font'].Value
	
	for _, room in pairs (rooms:GetChildren()) do
		for _, message in pairs (room:GetChildren()) do
			if message:IsA("Frame") then
				local bg = message:FindFirstChild("Background")
				local bg2 = message:FindFirstChild("BackgroundName")
				local user = message:FindFirstChild("Name")
				local msg = message:FindFirstChild("Message")
				local override = message:FindFirstChild("Override")
				local MessageColor = message:FindFirstChild("Message"..t)
				local PlayerColor = message:WaitForChild("Player" .. t)

				if user and msg and bg and bg2 and not override then
					if settings['Background'].Value and not MessageColor then
						msg.TextColor3 = theme[t]['Font'].Value
						msg.TextStrokeColor3 = theme[t]['FontStroke'].Value
						msg.TextStrokeTransparency = theme[t]['TextStrokeTransparency'].Value
					elseif MessageColor and settings['Background'] then
						msg.TextColor3 = MessageColor.Value
						msg.TextStrokeTransparency = theme[t]['TextStrokeTransparency'].Value
						msg.TextStrokeColor3 = theme[t]['FontStroke'].Value
					end

					if settings['Background'].Value or settings['NameBG'].Value then
						user.TextStrokeColor3 = theme[t]['FontStroke'].Value
						user.TextStrokeTransparency = theme[t]['TextStrokeTransparency'].Value
					end

					if PlayerColor then
						user.TextColor3 = PlayerColor.Value
					end
					local icon = user:FindFirstChildWhichIsA("ImageLabel")

					if icon and icon.Visible and (settings['Background'].Value or settings['NameBG'].Value) and icons[icon.Name] then
						icon.ImageRectOffset = icons[icon.Name].ImageRectOffset[t]
					end
					if settings['NameBG'].Value then
						changeBG(bg, theme[t]['Secondary'].Value)
						changeBG(bg2, theme[t]['Primary'].Value)
					else
						bg2.Visible = false
						changeBG(bg, theme[t]['Primary'].Value)
					end
				end
			end
		end
	end
end

change_themes(darkmode.Value)
darkmode.Changed:connect(change_themes)

if platform == "Console" then
	currentfont.Value = settings['FontSize']:WaitForChild("Large")
end

if canChat and platform ~= "Console" and ChatBar.Value then
	textbox.Parent:TweenPosition(FramePosition[true], Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
end

