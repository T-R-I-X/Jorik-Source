local replicatedstorage = game:GetService("ReplicatedStorage")
local serverstorage = game:GetService("ServerStorage")
local replicatedfirst = game:GetService("ReplicatedFirst")
local textservice = game:GetService("TextService")

local SetChatBubble = script:WaitForChild("SetChatBubble"):clone()
SetChatBubble.Parent = replicatedfirst
SetChatBubble.Disabled = false

if replicatedstorage:FindFirstChild("RemoteEvent") then replicatedstorage:FindFirstChild("RemoteEvent"):remove() end
local event = Instance.new("RemoteEvent")
event.Name = "ChatGuiEvent"
event.Parent = replicatedstorage

local namescript = script:WaitForChild("Name"):clone()
namescript.Parent = game:GetService("StarterPlayer"):WaitForChild("StarterCharacterScripts")
namescript.Disabled = false

local ChatGui = script:WaitForChild("ChatUi"):clone()
local Settings = script:WaitForChild("Settings")
Settings:Clone().Parent = ChatGui

ChatGui.Parent = game:GetService("StarterGui")
ChatGui:WaitForChild("LocalScript").Disabled = false

local chat = game:GetService("Chat")
local module = require(script:WaitForChild("MainModule"))


-- Useful functions
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


function GetUserId(name)
	local id
	pcall(function ()
		id = game.Players:GetUserIdFromNameAsync(name)
	end)
	return id
end

local display_names = {}
function findPlayer(target, player)
	if target then
		if string.lower(target) == "me" and player then
			return player
		end
		for key, v in pairs (display_names) do
			if string.find(string.lower(v), string.lower(target))==1 then
				local p = game.Players:FindFirstChild(key)
				if p then
					return p, v
				end
			end
		end
		for _, v in pairs (game.Players:GetPlayers()) do
			if string.find(string.lower(v.Name), string.lower(target))==1 then
				return v
			end
		end
	end
	return false
end
function Color(r,g,b)
	if r and g and b then
		return Color3.new(r/255, g/255, b/255)
	elseif r and not g and not b then
		Color(r,r,r)
	end
end
-- settings
local messagingService = game:GetService("MessagingService")
local settings = {
	['Display Name'] = Settings:WaitForChild("Display Name"),
	['ServerChat'] = Settings:WaitForChild("Server Chat"),
	['Command Key'] = Settings:WaitForChild("Command Key"),
	['SetColours'] = Settings:WaitForChild("Set Player Colours"),
	['AllColours'] = Settings:WaitForChild("All Player Colours"),
	['Commands'] = Settings:WaitForChild("Commands"),
	['Admins'] = Settings:WaitForChild("Admins"),
	['Chat Bubbles'] = Settings:WaitForChild("Chat Bubbles"),
	['FriendsJoining'] = Settings:WaitForChild("Show Friends Joining"),
	['CustomChatBar'] = Settings:WaitForChild("Custom Chat Bar")
}

local CanAccessDataStore, Banned = pcall(function()
	return false,false
end)


--Commands
local errors = {
	permissions = "You don't have permission to use this command.",
	missingplayer = "Unnable to find player '%s'.",
	notpublished = "You must publish this place to use this feature.",
	apiservices = "Server does not have access to APIs."
}
function get_command(cmd, folder_name, admin_required)
	local folder = settings['Commands']:FindFirstChild(folder_name)
	if folder then
		admin_required.Value = folder:WaitForChild("Admin Required").Value
		for _, v in pairs (folder:GetChildren()) do
			if v.Name == "Command" and string.lower(v.Value) == string.lower(cmd) then
				return true
			end
		end
	end
end

local lastmessage = {}

function DM(player, target, msg, fakename)
	local colours = Settings:WaitForChild("DM Colours")
	local font = colours:WaitForChild("Font").Value
	local bg = colours:WaitForChild("Background").Value
	local primary = colours:WaitForChild("Primary").Value
	local name = fakename or target.Name
	local displayname = display_names[player.Name] or player.Name
	
	local sucess,errorMessage = pcall(function()
		msg = textservice:FilterStringAsync(msg,player.UserId)
	end)

	if not sucess then
		warn("Error filtering: " .. msg .. " Error: " .. errorMessage)

		msg = "Error filtering text"
	end
	
	lastmessage[player.Name] = name
	lastmessage[target.Name] = displayname
	event:FireClient(target, "DM", {user=string.format("[%s] -> [You]:", displayname), message=msg, properties={user={Light = primary, Dark = primary},message={Light = font, Dark = font}}}, nil, bg)
	event:FireClient(player, "DM", {user=string.format("[You] -> [%s]:", name), message=msg, properties={user={Light = primary, Dark = primary},message={Light = font, Dark = font}}}, nil, bg)
end

function wear(player, outfit)
	local char = player.Character

	if char then
		local humanoid = char:FindFirstChild("Humanoid")
		local head = char:FindFirstChild("Head")

		if humanoid then
			player:ClearCharacterAppearance()

			for _, item in pairs (outfit:GetChildren()) do
				local i = item:clone()

				if item:IsA("Accessory") then
					humanoid:AddAccessory(i)
				elseif item:IsA("Decal") and head then
					local face = head:FindFirstChildOfClass("Decal")

					if face then
						face.Texture = i.Texture
					end
				elseif item:IsA("Shirt") then
					local s = char:FindFirstChildWhichIsA("Shirt")

					if s then 
						s:remove() 
					end

					i.Parent = char
				elseif item:IsA("Pants") then
					local s = char:FindFirstChildWhichIsA("Pants")

					if s then 
						s:remove() 
					end

					i.Parent = char
				elseif item:IsA("BodyColors") then
					local s = char:FindFirstChildWhichIsA("BodyColors")

					if s then 
						s:remove() 
					end

					i.Parent = char

					for _, v in pairs (char:GetChildren()) do
						local s = v:FindFirstChildWhichIsA("BodyColors")

						if s then 
							s:remove() 
						end

						i:clone().Parent = v
					end
				elseif item:IsA("LocalScript") and item.Name == "AnimateR6" and humanoid.RigType == Enum.HumanoidRigType.R6 then
					local animate = char:FindFirstChild("Animate")

					if animate then 
						animate:remove() 
					end

					i.Parent = char
					i.Name = "Animate"
					i.Disabled = false
				elseif item:IsA("LocalScript") and item.Name == "AnimateR15" and humanoid.RigType == Enum.HumanoidRigType.R15 then
					local animate = char:FindFirstChild("Animate")

					if animate then 
						animate:remove() 
					end

					i.Parent = char
					i.Name = "Animate"
					i.Disabled = false
				elseif item:IsA("CharacterMesh") and humanoid.RigType == Enum.HumanoidRigType.R6 then
					item.Parent = char
				end
			end
		end
	end
end


function findOutfit(outfit)
	for _, v in pairs (Settings:WaitForChild("Outfits"):GetChildren()) do
		if string.find(string.lower(v.Name), outfit) then
			return v
		end
	end
	return nil
end

function remove_disguise(player)
	if player.CharacterAppearanceId ~= player.UserId then
		display_names[player.Name] = nil
		player.CharacterAppearanceId = player.UserId
		sendAsServer("You have removed your disguise.", nil, player)
		wait(0.2)
		player:LoadCharacter()
	else
		sendAsServer("You do not need to remove a disguise.", nil, player)
	end
end

function UseMessagingService(service, data)
	if typeof(data) == "table" then
		local UUID = game:GetService("HttpService"):GenerateGUID(false)
		data['GUID'] = UUID

		for i = 1, 5 do
			local success, err = pcall(function()
				messagingService:PublishAsync(service, data)
			end)

			if not success then
				warn(err)
				break
			end
		end
	end
end

	
function Announce(msg)	
	UseMessagingService("GlobalAnnouncements", {Message = msg})
end

local reason_presets = {
	"Violated ROBLOX's Terms of Service"
}

function ban_user(player, bantarget, reason, t)
	if CanAccessDataStore then
		if bantarget then
			if bantarget ~= game.CreatorId and bantarget ~= player.UserId then
				local r = reason or "No reason given"
				Banned:SetAsync(tostring(bantarget), r)
				sendAsServer(string.format("Banned '%s' with reason: %s", game.Players:GetNameFromUserIdAsync(bantarget), r), nil, player)
				local data = {Message = bantarget, Reason = r}
				UseMessagingService("BannedAPlayer", data)
				
			elseif bantarget == player.UserId then
				sendAsServer("You cannot ban yourself.", nil, player)
			elseif bantarget == game.CreatorId then
				sendAsServer("You cannot ban the game creator.", nil, player)
			end
		else
			sendAsServer(string.format("Could not find a player named '%s'.", t[2]), nil, player)
		end
	else
		sendAsServer(errors['apiservices'], nil, player)
	end
end

function unban_user(bantarget, player)
	if CanAccessDataStore then
		local banned = Banned:GetAsync(tostring(bantarget))
		if banned then
			Banned:SetAsync(tostring(bantarget), false)
			Banned:SetAsync(tostring(bantarget).."TEMP", false)
			if player then
				sendAsServer(string.format("Unbanned '%s'.", game.Players:GetNameFromUserIdAsync(bantarget)), nil, player)
			end
		elseif player then
			sendAsServer(string.format("'%s' is not banned.", game.Players:GetNameFromUserIdAsync(bantarget)), nil, player)
		end
	else
		sendAsServer(errors['apiservices'], nil, player)
	end
end

function GetCommandList(player)
	local PlayerIsAdmin = settings['Admins']:FindFirstChild(player.Name) or settings['Admins']:FindFirstChild(player.UserId)
	local CommandsList = {}
	local CommandsPerPage = Settings:WaitForChild("Commands Per Help").Value
	local commandline = Settings:WaitForChild("Command Key").Value
	local i = 0
	for _, v in pairs (Settings:WaitForChild("Commands"):GetChildren()) do
		local command = v:FindFirstChild("Command")
		local description = v:FindFirstChild("Description")
		local admin = v:FindFirstChild("Admin Required")
		if v.Name ~= "Help" and command and description and admin and (not admin.Value or PlayerIsAdmin) then
			local list = math.floor(i / CommandsPerPage) + 1
			local cmd = commandline .. command.Value
			for _, x in pairs (v:GetChildren()) do
				if x.Name == command.Name and x ~= command then
					cmd = cmd .. " or " .. commandline .. x.Value
				end
			end
			local t = {Command = cmd, Description = description.Value}
			if CommandsList[list] then
				table.insert(CommandsList[list], t)
			else
				table.insert(CommandsList, {t})
			end
			i = i + 1
		end
	end
	return CommandsList
end


local defaults = {}
local muted = {}

function commands(player, message)
	local t = string.split(message, " ")
	local command = t[1]
	local isAdmin = settings['Admins']:FindFirstChild(player.Name) or settings['Admins']:FindFirstChild(player.UserId)
	local admin_required = Instance.new("BoolValue")
	admin_required.Value = false
	if get_command(command, "Reset", admin_required) then
		if not admin_required.Value or isAdmin then
			local char = player.Character
			if char then
				char:BreakJoints()
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Help", admin_required) then
		if not admin_required.Value or isAdmin then
			local list = tonumber(t[2]) or 1
			local PlayerCommands = GetCommandList(player)
			local page = PlayerCommands[list]
			if page then
				local sentence = "------------------[ Help page %s of %s ]------------------\n"
				for i = 1, #page do
					sentence = sentence .. tostring(page[i].Command) .. " (" .. tostring(page[i].Description) .. ")"
					if i < #page then
						 sentence = sentence .. "\n"
					end
				end
				sendAsServer(string.format(sentence, tostring(list), tostring(#PlayerCommands)), nil, player)
			else
				
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	-- Empty Command
	elseif get_command(command, "Reset", admin_required) then
		if not admin_required.Value or isAdmin then
			
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Mute", admin_required) then
		if not admin_required.Value or isAdmin then
			local targetPlayer = findPlayer(t[2])
			if targetPlayer then
				if not muted[player.Name] then
					muted[player.Name] = {[targetPlayer.Name] = true}
				else
					muted[player.Name][targetPlayer.Name] = true
				end
				sendAsServer("Player muted.", nil, player)
			else
				sendAsServer(string.format("Cannot find '%s'.", t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Unmute", admin_required) then
		if not admin_required.Value or isAdmin then
			local targetPlayer = findPlayer(t[2])
			if targetPlayer then
				if muted[player.Name] and muted[player.Name][targetPlayer.Name] then
					muted[player.Name][targetPlayer.name] = false
					sendAsServer("Player unmuted.", nil, player)
				else
					sendAsServer("Cannot unmute a player not already muted.", nil, player)
				end
			else
				sendAsServer(string.format("Cannot find player '$s'.", t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Ban", admin_required) then
		if not admin_required.Value or isAdmin then
			if CanAccessDataStore then
				local bantarget = GetUserId(t[2])
				local reason
				if #t > 2 then
					local num = tonumber(string.sub(t[3], 2))
					if (string.sub(t[3], 1 ,1)) == "-" and num and reason_presets[num] then
						reason = reason_presets[num]
					else
						reason = string.sub(message, #t[1] + #t[2] + 3)
					end
				end
				if bantarget then
					local isbanned = Banned:GetAsync(tostring(bantarget))
					if isbanned then
						unban_user(bantarget, player)
					else
						ban_user(player, bantarget, reason, t)
					end
				else
					sendAsServer(string.format("Could not find a player named '%s'.", t[2]), nil, player)
				end
			else
				sendAsServer(errors['apiservices'], nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Unban", admin_required) then
		if not admin_required.Value or isAdmin then
			if CanAccessDataStore then
				local bantarget = GetUserId(t[2])
				if bantarget then
					unban_user(bantarget, player)
				else
					sendAsServer(string.format("Could not find player by name '%s'.", t[2]), nil, player)
				end
			else
				sendAsServer(errors['apiservices'], nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "TempBan", admin_required) then
		if not admin_required.Value or isAdmin then
			if CanAccessDataStore then
				local bantarget = GetUserId(t[2])
				local timer = 0
				if t[3] then
					timer = tonumber(t[3])
				end
				if bantarget and timer and timer > 0 then
					local isbanned = Banned:GetAsync(tostring(bantarget))
					if isbanned then
						unban_user(bantarget, player)
					else
						local t = tostring(module.NumberToTimeLength(timer))
						local reason = "You are banned for " .. t .. "."
						ban_user(player, bantarget, reason, t)
						local banuntil = os.time() + timer
						Banned:SetAsync(tostring(bantarget).."TEMP", banuntil)
					end
				else
					sendAsServer(string.format("Could not find a player named '%s'.", t[2]), nil, player)
				end
			else
				sendAsServer(errors['apiservices'], nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
		
	elseif get_command(command, "Direct Message", admin_required) then
		if not admin_required.Value or isAdmin then
			local target, fakename = findPlayer(t[2])
			local msg = string.sub(message, #t[1] + #t[2] + 3)
			if target then
				if target ~= player then
					if removeSpaceFromEnd(msg) ~= "" then
						DM(player, target, msg, fakename)
					else
						sendAsServer("Message cannot be blank.", nil, player)
					end
				else
					sendAsServer("You cannot send a message to yourself.", nil, player)
				end
			else
				sendAsServer(string.format(errors['missingplayer'], t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Reply", admin_required) then
		if not admin_required.Value or isAdmin then
			local msg = string.sub(message, #t[1] + 2)
			local target, fakename = findPlayer(lastmessage[player.Name])
			if target then
				--local plr = fakename or target
				DM(player, target, msg, fakename)
			else
				sendAsServer("You cannot reply to no-one.", nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Display Name", admin_required) then
		if not admin_required.Value or isAdmin then
			local name = string.sub(message, #t[1] + 2)
			local set = Settings:WaitForChild("Display Names can only be a player")
			if set.Value then
				local id = game.Players:GetUserIdFromNameAsync(name)
				if id then
					local target = game.Players:GetNameFromUserIdAsync(id)
					if target then
						display_names[player.Name] = target
						event:FireClient(player, "Server", {Func="SetDisplayName", Player=target})
						sendAsServer(string.format("Other players will now see you as '%s'.", target), nil, player)
					end
				else
					sendAsServer(string.format("Unable to find a player called '%s'.", name), nil, player)
				end
			else
				display_names[player.Name] = name
						event:FireClient(player, "Server", {Func="SetDisplayName", Player=name})
				sendAsServer(string.format("You set your display name to '%s'.", name), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Reset Display Name", admin_required) then
		if not admin_required.Value or isAdmin then
			display_names[player.Name] = nil
			event:FireClient(player, "Server", {Func="ResetDisplayName", Player=player})
			sendAsServer("You reset your display name.", nil, player)
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Disguise", admin_required) then
		if not admin_required.Value or isAdmin then
			local target = t[2]
			local id = game.Players:GetUserIdFromNameAsync(target)
			local name = game.Players:GetNameFromUserIdAsync(id)
			if id and name then
				if id == player.UserId then
					remove_disguise(player)
					event:FireClient(player, "Server", {Func="ResetDisplayName", Player=player})
				else
					display_names[player.Name] = name
					sendAsServer(string.format("You have disguised as '%s'.", name), nil, player)
					event:FireClient(player, "Server", {Func="SetDisplayName", Player=name})
					player.CharacterAppearanceId = id
					wait(0.2)
					player:LoadCharacter()
				end
			else
				sendAsServer("Unable to find player by that name.", nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Remove Disguise", admin_required) then
		if not admin_required.Value or isAdmin then
			remove_disguise(player)
			event:FireClient(player, "Server", {Func="ResetDisplayName", Player=player})
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Kill", admin_required) then
		if not admin_required.Value or isAdmin then
			local target = findPlayer(t[2], player)
			if target and target.Character then
				target.Character:BreakJoints()
				sendAsServer(string.format("Killed %s.", target.Name), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "ForceField", admin_required) then
		if not admin_required.Value or isAdmin then
			local targ = t[2] or player.Name
			local target = findPlayer(targ, player)
			if target and target.Character then
				local ff = target.Character:FindFirstChildOfClass("ForceField")
				if ff then
					ff:remove()
					sendAsServer(string.format("Removed %s's ForceField.", target.Name), nil, player)
				else
					ff = Instance.new("ForceField")
					ff.Parent = target.Character
					sendAsServer(string.format("Gave %s a ForceField.", target.Name), nil, player)
				end
			else
				sendAsServer(string.format("Could not find player '%s'.", t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Heal", admin_required) then
		if not admin_required.Value or isAdmin then
			local targ = t[2] or player.Name
			local target = findPlayer(targ, player)
			if target and target.Character then
				local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.Health = humanoid.MaxHealth
					sendAsServer(string.format("Healed %s.", target.Name), nil, player)
				end
			else
				sendAsServer(string.format("Could not find player '%s'.", t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Jump Power", admin_required) then
		if not admin_required.Value or isAdmin then
			local targ = t[2] or player.Name
			local num = tonumber(t[3]) or defaults['JumpPower'] or 0
			local target = findPlayer(targ, player)
			if target and target.Character then
				local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					if not defaults['JumpPower'] then defaults['JumpPower'] = humanoid.JumpPower end
					humanoid.JumpPower = num
					sendAsServer(string.format("Set %s's Jump Power to %s.", target.Name, num), nil, player)
				end
			else
				sendAsServer(string.format("Could not find player '%s'.", t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Kick", admin_required) then
		if not admin_required.Value or isAdmin then
			local target = findPlayer(t[2], player)
			local reason = string.sub(message, #t[1] + #t[2] + 3)
			if target and target.Character then
				if target ~= player then
					sendAsServer(string.format("Kicked %s.", target.Name), nil, player)
					target:Kick(reason)
				else
					sendAsServer("You cannot kick yourself.", nil, player)
				end
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Respawn", admin_required) then
		if not admin_required.Value or isAdmin then
			local targ = t[2] or player.Name
			local target = findPlayer(targ, player)
			if target and target.Character then
				target:LoadCharacter()
				sendAsServer(string.format("%s Respawned.", target.Name), nil, player)
				
			else
				sendAsServer(string.format("Could not find player '%s'.", t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Set Health", admin_required) then
		if not admin_required.Value or isAdmin then
			local targ = t[2] or player.Name
			local num = tonumber(t[3]) or defaults['Health'] or 100
			local target = findPlayer(targ, player)
			if target and target.Character then
				local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					defaults['Health'] = humanoid.MaxHealth
					humanoid.Health = num
					sendAsServer(string.format("Set %s's Health to %s.", target.Name, num), nil, player)
				end
			else
				sendAsServer(string.format("Could not find player '%s'.", t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Set Max Health", admin_required) then
		if not admin_required.Value or isAdmin then
			local targ = t[2] or player.Name
			local num = tonumber(t[3]) or defaults['MaxHealth'] or 100
			local target = findPlayer(targ, player)
			if target and target.Character then
				local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					if not defaults['MaxHealth'] then defaults['MaxHealth'] = humanoid.MaxHealth end
					humanoid.MaxHealth = num
					sendAsServer(string.format("Set %s's Max Health to %s.", target.Name, num), nil, player)
				end
			else
				sendAsServer(string.format("Could not find player '%s'.", t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Speed", admin_required) then
		if not admin_required.Value or isAdmin then
			local targ = t[2] or player.Name
			local num = tonumber(t[3]) or defaults['Speed'] or 100
			local target = findPlayer(targ, player)
			if target and target.Character then
				local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					if not defaults['Speed'] then defaults['Speed'] = humanoid.WalkSpeed end
					humanoid.WalkSpeed = num
					sendAsServer(string.format("Set %s's Speed to %s.", target.Name, num), nil, player)
				end
			else
				sendAsServer(string.format("Could not find player '%s'.", t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Give Accessory", admin_required) then
		if not admin_required.Value or isAdmin then
			local target = findPlayer(t[2], player)
			local id = tonumber(t[3])
			if target and target.Character then
				if id and game:GetService("InsertService"):LoadAsset(id) then
					local item = game:GetService("InsertService"):LoadAsset(id):clone()
					local MarketplaceService = game:GetService("MarketplaceService") 
					local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
					if item and humanoid then
						item.Parent = replicatedstorage
						for _, v in pairs (item:GetChildren()) do
							if v:IsA("Accessory") then
								humanoid:AddAccessory(v)
							end
						end
						local product = MarketplaceService:GetProductInfo(id, Enum.InfoType.Asset)
						sendAsServer(string.format("Gave %s '%s'.", target.Name, product.Name), nil, player)
						item:remove()
					end
				end
			else
				sendAsServer(string.format("Could not find player '%s'.", t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Remove Accessories", admin_required) then
		if not admin_required.Value or isAdmin then
			local targ = t[2] or player.Name
			local target = findPlayer(targ, player)
			if target and target.Character then
				for _, v in pairs (target.Character:GetChildren()) do
					if v:IsA("Accessory") then
						v:remove()
					end
				end
				sendAsServer(string.format("Removed all '%s''s accessories.", target.Name), nil, player)
			else
				sendAsServer(string.format("Could not find player '%s'.", t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Get Face", admin_required) then
		if not admin_required.Value or isAdmin then
			local target = findPlayer(t[2], player)
			local id = tonumber(t[3])
			if target and target.Character then
				if id and game:GetService("InsertService"):LoadAsset(id) then
					local item = game:GetService("InsertService"):LoadAsset(id):clone()
					local MarketplaceService = game:GetService("MarketplaceService") 
					local head = target.Character:FindFirstChild("Head")
					if item and head then
						local face = head:FindFirstChildOfClass("Decal")
						item.Parent = replicatedstorage
						for _, v in pairs (item:GetChildren()) do
							if v:IsA("Decal") then
								if face then
									face.Texture = v.Texture
								end
							end
						end
						local product = MarketplaceService:GetProductInfo(id, Enum.InfoType.Asset)
						sendAsServer(string.format("Gave %s '%s'.", target.Name, product.Name), nil, player)
						item:remove()
					end
				end
			else
				sendAsServer(string.format("Could not find player '%s'.", t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Outfit", admin_required) then
		if not admin_required.Value or isAdmin then
			local outfit = findOutfit(t[2])
			local char = player.Character
			if outfit and char then
				wear(player, outfit)
				sendAsServer(string.format("Equipped the '%s' outfit.", outfit.Name), nil, player)
			else
				sendAsServer(string.format("Could not find an outfit called '%s'.", t[2]), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Get Outfits", admin_required) then
		if not admin_required.Value or isAdmin then
			local list = ""
			local total_outfits = Settings:WaitForChild("Outfits"):GetChildren()
			for i, v in pairs (total_outfits) do
				list = list .. v.Name
				if i ~= #total_outfits then
					list = list .. ", "
				end
			end
			sendAsServer(string.format("All Outfits: %s.", list), nil, player)
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Announcement", admin_required) then
		if isAdmin then
			local msg = string.sub(message, #t[1] + 2)
			Announce(msg)
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "SayAsServer", admin_required) then
		if not admin_required.Value or isAdmin then
			local msg = string.sub(message, #t[1] + 2)
			if msg then
				sendAsServer(msg)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Script", admin_required) then
		if not admin_required.Value or isAdmin then
			local scriptname = string.sub(message, #t[1] + 2)
			local folder = Settings:WaitForChild("Scripts")
			local Script
			for _, s in pairs (folder:GetChildren()) do
				if string.find(string.lower(s.Name), string.lower(scriptname)) == 1 and s.Name ~= "HOW TO USE" then
					Script = s
				end
			end
			if Script and player.Character then
				local s = Script:clone()
				s.Parent = player.Character
				s.Disabled = false
				sendAsServer(string.format("Placed '%s' script inside your Character.", s.Name), nil, player)
			else
				sendAsServer(string.format("Unable to find a script named '%s'.", scriptname), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Remove Script", admin_required) then
		if not admin_required.Value or isAdmin then
			local scriptname = string.sub(message, #t[1] + 2)
			local folder = Settings:WaitForChild("Scripts")
			local Script
			for _, s in pairs (folder:GetChildren()) do
				if string.find(string.lower(s.Name), string.lower(scriptname)) == 1 and s.Name ~= "HOW TO USE" then
					Script = s
				end
			end
			if Script and player.Character then
				local s = player.Character:FindFirstChild(Script.Name)
				if s then
					s:remove()
					sendAsServer(string.format("Removed '%s' from your Character.", s.Name), nil, player)
				else
					sendAsServer(string.format("Unable to find script '%s' inside your Character.", scriptname), nil, player)
				end
			else
				sendAsServer(string.format("Unable to find a script named '%s'.", scriptname), nil, player)
			end
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	elseif get_command(command, "Get Scripts", admin_required) then
		if not admin_required.Value or isAdmin then
			local scriptname = string.sub(message, #t[1] + 2)
			local folder = Settings:WaitForChild("Scripts")
			local Scripts = {}
			for i, s in pairs (folder:GetChildren()) do
				if string.find(string.lower(s.Name), string.lower(scriptname)) == 1 and s.Name ~= "HOW TO USE" then
					table.insert(Scripts, s.Name)
				end
			end
			local Line = ""
			for i, s in pairs (Scripts) do
				Line = Line .. s
				if i < #Scripts then
					Line = Line .. ", "
				end
			end
			sendAsServer(string.format("All current scripts: %s.", Line), nil, player)
			
		else
			sendAsServer(errors['permissions'], nil, player)
		end
	else
		sendAsServer(string.format("Unknown command '%s'.", command), nil, player)
	end
end

-- Rooms
local rooms = {}
local user_rooms = {}

-- Send Message
local playercolours = {}

function send_message(recipient, player, message, chatbar)
	local user = message['user']

	if display_names[user] then
		user = display_names[user]
	end

	local display = string.format(settings['Display Name'].Value, user)
	local message = message['message']
	local room = user_rooms[player]

	if not room then
		room = "Server"
		user_rooms[player] = room
	end

	local colour = playercolours[user]

	if not colour then
		colour = settings['SetColours']:FindFirstChild(user)

		if not colour then
			colour = settings['AllColours']:GetChildren()[math.random(1, #settings['AllColours']:GetChildren())]
		end

		playercolours[user] = colour
	end

	local isMuted

	if muted[recipient.Name] then
		isMuted = muted[recipient.Name][player.Name]
	end

	if not isMuted then
		event:FireClient(recipient, player, {user=display, message=message, properties=
			{user={Light = colour:WaitForChild("Dark").Value, Dark = colour:WaitForChild("Light").Value}}
		}, room)
	end
end
-- Send As Server
local server_properties = {}

if settings['ServerChat']:FindFirstChild("UserColour") then
	local colour = settings['ServerChat']:WaitForChild("UserColour")

	server_properties['user'] = {Light = colour:WaitForChild("Light").Value, Dark = colour:WaitForChild("Dark").Value}
end

if settings['ServerChat']:FindFirstChild("MessageColour") then
	local colour = settings['ServerChat']:WaitForChild("MessageColour")

	server_properties['message'] = {Light = colour:WaitForChild("Light").Value, Dark = colour:WaitForChild("Dark").Value}
end

function sendAsServer(message, room, target)
	local name = string.format(settings['Display Name'].Value, settings['ServerChat']:WaitForChild("Name").Value)

	if not room then 
		room = "Server" 
	end

	if target then
		if target:IsA("Player") then
			event:FireClient(target, "Server", {user=name, message=message, properties=server_properties}, room)
		else
			warn('Unable to find target.')
		end
	else
		event:FireAllClients("Server", {user=name, message=message, properties=server_properties}, room)
	end
end

-- Chat Function
local TextService = game:GetService("TextService")

local function getTextObject(message, fromPlayerId)
	local textObject

	local success, errorMessage = pcall(function()
		textObject = TextService:FilterStringAsync(message, fromPlayerId)
	end)

	if success then
		return textObject
	end

	return false
end

local function getFilteredMessage(textObject, toPlayerId)
	local filteredMessage
	local success, errorMessage = pcall(function()
		filteredMessage = textObject:GetChatForUserAsync(toPlayerId)
	end)

	if success then
		return filteredMessage
	end

	return false
end

local function onSendMessage(sender, recipient, message)
	if message ~= "" then
		local messageObject = getTextObject(message, sender.UserId)
 
		if messageObject then
			local filteredMessage = getFilteredMessage(messageObject, recipient.UserId)
			return recipient, sender, filteredMessage
		end
	end
end

function chat_server(message, player)
	local sucess,errorMessage = pcall(function()
		message = textservice:FilterStringAsync(message,player.UserId)
	end)

	if not sucess then
		warn("Error filtering: " .. message .. " Error: " .. errorMessage)

		message = "Error filtering text"
	end
	
	if player then
		event:FireClient(player, {user=string.format(settings['Display Name'].Value, "Server"), message=message}, server_properties)
	else
		event:FireAllClients({user=string.format(settings['Display Name'].Value, "Server"), message=message}, server_properties)
	end
end

event.OnServerEvent:connect(function(player, message, chatbar)
	if chat:CanUserChatAsync(player.UserId) then

		if string.sub(message['message'], 1, #settings['Command Key'].Value) == settings['Command Key'].Value then
			commands(player, string.sub(message['message'], #settings['Command Key'].Value + 1))
		else
			for _, plr in pairs (game.Players:GetChildren()) do
				if plr ~= player then
					local recipient, sender, filteredMessage = onSendMessage(player, plr, message['message'])

					message['message'] = filteredMessage

					send_message(recipient, player, message, chatbar)
				end
			end
		end
	end
end)

-- Something stupid i added with announcements, add something like below to announce a custom message to every server when
-- a certain player joins
local AnnounceUsersJoined = {}

local wearbydefault = Settings:WaitForChild("Wear Outfit By Default")

game.Players.PlayerAdded:connect(function(player)
	repeat wait() until player.Character
	
	if settings['FriendsJoining'].Value then
		local friends = 0
		
		for _, plr in pairs (game.Players:GetPlayers()) do
			if plr ~= player and player.FollowUserId == plr.UserId then
				sendAsServer(string.format("%s followed you into the game.", player.Name), nil, plr)

				if player:IsFriendsWith(plr.UserId) then
					friends = friends + 1
				end
			elseif plr ~= player and player:IsFriendsWith(plr.UserId) then
				sendAsServer(string.format("Friend %s joined the game.", player.Name), nil, plr)
				friends = friends + 1
			elseif plr ~= player then
				sendAsServer(string.format("%s joined.", player.Name), nil, plr)
			end
		end
		
		if friends == 1 then
			sendAsServer(string.format("%s joined.\nYou have %s friend connected.", player.Name, friends), nil, player)
		elseif friends > 1 then
			sendAsServer(string.format("%s joined.\nYou have %s friends connected.", player.Name, friends), nil, player)
		else
			sendAsServer(string.format("%s joined.", player.Name), nil, player)
		end
	else
		sendAsServer(string.format("%s joined.", player.Name))
	end
	local announceplayer = AnnounceUsersJoined[player.Name]

	if announceplayer then
		local msg = AnnounceUsersJoined[player.Name]

		Announce(msg)
	end

	player.CharacterAppearanceLoaded:connect(function()
		if player.CharacterAppearanceId > 0 then
			local get_player = game.Players:GetNameFromUserIdAsync(player.CharacterAppearanceId)

			if get_player then
				local hasOutfit = wearbydefault:FindFirstChild(get_player)

				if hasOutfit and hasOutfit:IsA("ObjectValue") and hasOutfit.Value and hasOutfit.Value:IsA("Folder") then
					wear(player, hasOutfit.Value)
				end
			end
		end
	end)
end)

game.Players.PlayerRemoving:connect(function(player)
	event:FireAllClients("Server", {Func="RemovePlayerFromCache", Player=player})
end)

game.Players.PlayerMembershipChanged:connect(function(player)
	event:FireAllClients("Server", {Func="CachePlayer", Player=player})
end)

local debris = game:GetService("Debris")
local GUIDs = Instance.new("Folder", serverstorage)

GUIDs.Name = "MessageServiceGUIDs"

pcall(function()
	messagingService:SubscribeAsync("GlobalAnnouncements", function(data)
		local Message = data.Data.Message
		local GUID = data.Data.GUID
		local Time = data.Sent

		if not GUIDs:FindFirstChild(GUID) then
			local value = Instance.new("ObjectValue", GUIDs)

			value.Name = GUID
			debris:AddItem(value, 60)

			local name = "[SYSTEM]:"
			event:FireAllClients("Server", {user=name, message=Message, properties=server_properties})
		end
	end)
		
	messagingService:SubscribeAsync("BannedAPlayer", function(data)
		local PlayerIdToKick = data.Data.Message
		local Reason = data.Data.Reason
		local GUID = data.Data.GUID
		local Time = data.Sent
		
		if not GUIDs:FindFirstChild(GUID) then
			local value = Instance.new("ObjectValue")
			value.Parent = GUIDs
			value.Name = GUID
			debris:AddItem(value, 60)

			for _, player in pairs (game.Players:GetPlayers()) do
				if player.UserId == PlayerIdToKick then
					player:Kick(Reason)
				end
			end
		end
	end)
end)
------------------------------------------------------------------------------------------------------------------------
local currentserver_time = Instance.new("StringValue")
currentserver_time.Parent = replicatedstorage
currentserver_time.Name = "LastUpdated"

local ServerOutdated = Instance.new("BoolValue")
ServerOutdated.Parent = currentserver_time
ServerOutdated.Name = "ServerOutdated"
ServerOutdated.Value = false

local GameLastVersion = 0

function Shutdown()
	sendAsServer("New game version was pushed restarting.")

	wait(5)

	for _, player in pairs (game.Players:GetPlayers()) do
		player:Kick("Restarted")
	end
end

function SetLastUpdated()
	local cangetupdate, updated = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Updated
	end)
	
	if cangetupdate then
		local LastUpdatedSeconds = module.GetLastUpdated(updated)
		local date = module.NumberToTimeLength(LastUpdatedSeconds)
		local lastupdated = string.split(date, " ")
		local n = tonumber(lastupdated[1])
		local f = lastupdated[2]
		local text = "[Error getting time]"

		if n and f then
			text = math.floor(n) .. " " .. f .. " ago"
		end
		
		if typeof(LastUpdatedSeconds) == "string" then
			return
		end
		
		if LastUpdatedSeconds > GameLastVersion then
			GameLastVersion = LastUpdatedSeconds
		else
			--Server outdated
			ServerOutdated.Value = true
		end

		currentserver_time.Value = text
	end
end
	
SetLastUpdated()

while wait(60) do
	SetLastUpdated()
end
