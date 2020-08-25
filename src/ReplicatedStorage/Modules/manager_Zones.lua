local Zone = {};
Zone.Fields = {};
Zone.LastTouchedLog = {};
Zone.__index = Zone

--// Services
local runService = game:GetService("RunService")
local replicatedFirst = game:GetService("ReplicatedFirst")
local playerService = game:GetService("Players") 

--// Modules
local modules = replicatedFirst.holder_Modules
local utils = modules.helper_Modules
local event = utils.Event

--// Values
local maxPlayerHeight = 12; -- MAX HEIGH PLAYER CAN BE FROM GROUND TO BE IN A FIELD.
local updateDelay = 0.15; -- CHECK_FRE
local leaveOnDeath = false; -- LEAVE_FIELD_ON_DEATH

Zone.Initialized = false;
Zone.IsClient = runService:IsClient();
Zone.Running = false;

---------------------------------------- Functions ----------------------------------------

--.. Creates a new part table
function Zone.new(partTable)
	for i,v in pairs(partTable) do if not v:IsA("BasePart") then utils.errorOut(script,"not all parts are base parts",28) return end end;
	    local self = setmetatable({}, Zone)

	    self.PlayerEntered = event.new();
	    self.PlayerLeft = event.new();
	    self.Enabled = true;
	    self.Parts = partTable;

	    --## End this Field instance.
	    function self:Destroy()
		    self.Enabled = false;
		    self.PlayerEntered:Destroy();
		    self.PlayerLeft:Destroy();

            setmetatable(self, nil);
	    end

        table.insert(Zone.Fields, self);
        return self
end

--.. Starts zone module
function Zone:Start()
	Zone.Running = true;
end

--.. Stops zone module
function Zone:Stop()
	Zone.Running = false;
end

--.. Runs when a user is not in a zone 
local function SetFieldNoneWithEvent(Player)
	if Zone.LastTouchedLog[Player] ~= "None" then
		Zone.LastTouchedLog[Player].PlayerLeft:Fire(Player);
    end
    
	Zone.LastTouchedLog[Player] = "None";
end

--.. Updates the field
local function CheckPlayer(Player)
	if Zone.LastTouchedLog[Player] == nil then
		Zone.LastTouchedLog[Player] = "None";
	end

	if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.Humanoid.Health > 0 then
		local ray = Ray.new(Player.Character.HumanoidRootPart.Position, Vector3.new(0,maxPlayerHeight*-1,0));
        local part = workspace:FindPartOnRay(ray, Player.Character, false, true);
        
		if part then
            local isInField = false;
            
			for a, f in pairs(Zone.Fields) do
				if f ~= nil and f.Enabled then
					if table.find(f.Parts, part) then -- Player is in this field.
                        isInField = true;
                        
						if Zone.LastTouchedLog[Player] ~= "None" then -- Player came from another field.
							SetFieldNoneWithEvent(Player);
                        end
                        
						if Zone.LastTouchedLog[Player] == f then break end;
                        
                        Zone.LastTouchedLog[Player] = f;
						f.PlayerEntered:Fire(Player);
					end
				end
			end
			if not isInField then -- Player is not above a field part.
				SetFieldNoneWithEvent(Player);
			end
		else -- Part is nil; didnt find part
			SetFieldNoneWithEvent(Player);
		end
	end
end

--.. Handles player death
local function PlayerDied(Player)
	if leaveOnDeath then
		SetFieldNoneWithEvent(Player);
	end
end

local function ConnectDeath(Player, CheckExisting)
	if CheckExisting then
		local Humanoid = Player.Character:WaitForChild("Humanoid",10);
        if not Humanoid then return end

        Humanoid.Died:Connect(function()
			PlayerDied(Player);
		end)
	end
	Player.CharacterAdded:Connect(function(Character)
		local Humanoid = Character:WaitForChild("Humanoid",10);
        if not Humanoid then return end

        Humanoid.Died:Connect(function()
			PlayerDied(Player);
		end)
	end)
end

--.. Player died event
if not Zone.Initialized then
	if Zone.IsClient then -- Check only the local player for death.
		ConnectDeath(playerService.LocalPlayer, true);
	else 
		for i,v in pairs(playerService:GetPlayers()) do
			v.CharacterAdded:Wait();
			ConnectDeath(v, true);
        end
        
		-- Now when a player joins.
		playerService.PlayerAdded:Connect(function(Player)
			ConnectDeath(Player, false);
		end)
	end
end

--.. Main loop
spawn(function()
	while wait(updateDelay) do
		if Zone.Running then
			if Zone.IsClient then
				CheckPlayer(playerService.LocalPlayer);
			else
				for i,v in pairs(playerService:GetPlayers()) do
					CheckPlayer(v);
				end
			end
		end
	end
end)

Zone.Initialized = true;

return Zone