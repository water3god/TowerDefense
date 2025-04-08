--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local StarterGui = game:GetService("StarterGui");

local Client = ReplicatedStorage.Client;
local GlobalClient = Client.GlobalClient;
local WaveService = require(GlobalClient.WaveService);

local Modules = ReplicatedStorage.Modules;
local FormatTime = require(Modules.FormatTime);
local GoodSignal = require(Modules.GoodSignal);

local Player = Players.LocalPlayer;
local PlayerGui: typeof(ReplicatedStorage.CloneGui) & typeof(StarterGui) = Player.PlayerGui;

local Remotes = ReplicatedStorage.Remotes;
local StartPoint = Remotes.StartPoint;
local VoteEvent = StartPoint.VoteEvent;
local VoteSendEvent = StartPoint.VoteSendEvent;

local GlobalGui: typeof(PlayerGui.GlobalGui) = PlayerGui:WaitForChild("GlobalGui");
local GameGui = GlobalGui.GameGui;
local TopFrame = GameGui.TopFrame;

local TimeLabel = TopFrame.TimeLabel;
local WaveLabel = TopFrame.WaveLabel;

local HealthFrame = TopFrame.HealthFrame;
local Bar = HealthFrame.CanvasGroup.Bar;
local HealthLabel = HealthFrame.HealthLabel;

local BottomFrame = GameGui.BottomFrame;

local GameStartFrame = GameGui.GameStartFrame;
local NoButton = GameStartFrame.NoButton;
local YesButton = GameStartFrame.YesButton;
local VoteTimeLabel = GameStartFrame.TimeLabel;
local PlayerCountLabel = GameStartFrame.PlayerCount;

local GameEndFrame = GameGui.GameEndFrame;
local LeaveButton = GameEndFrame.LeaveButton;
local GameLabel = GameEndFrame.GameLabel;

local Connections: {[string]: RBXScriptConnection?} = {};
local CurrentTime = 0;
local StartTime: number = 0;
local ChangedTime: number = 0;
local Started = false;
local InSpectate = false;

local function HandleTime(Time: number, CurrentStart: number)
	CurrentTime = Time;
	StartTime = CurrentStart;
end

local function HandleWave(Wave: number)
	WaveLabel.Text = "Wave: "..Wave;
end

local LowColor = Color3.new(0.856123, 0.254826, 0.249577);
local HighColor = Color3.new(0.473335, 0.945403, 0.296986);

local function HandleHealth(Health: number, MaxHealth: number)
	HealthLabel.Text = string.format("%u / %u", Health, MaxHealth);
	local Ratio: number = math.clamp(Health / MaxHealth, 0, 1);

	TweenService:Create(
		Bar,
		TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		{Size = UDim2.fromScale(Ratio, 1), BackgroundColor3 = LowColor:Lerp(HighColor, Ratio)}
	):Play();
end

local function Start()
	local Data: WaveService.GetWaveSync = WaveService.GetData() or WaveService.Added:Wait() :: any;

	if not InSpectate then
		HandleTime(Data.Time, Data.TimeSent);
		HandleHealth(Data.BaseHealth, Data.MaxHealth);
		HandleWave(Data.CurrentWave);
	end

	WaveService.HealthChanged:Connect(function(Health: number)
		if not InSpectate then
			HandleHealth(Health, Data.MaxHealth);
		end
	end)

	WaveService.WaveChanged:Connect(function(Wave: number, Time: number)
		if not InSpectate then
			HandleWave(Wave);
		end
	end)
	
	WaveService.TimeChanged:Connect(function(Time: number, TimeSent: number)
		if not InSpectate then
			HandleTime(Time, TimeSent);
		end
	end)
	
	Started = true;
end

local CanStart = false;
local GameEndOpen = false;

WaveService.Ended:Connect(function(Win: boolean)
	CanStart = true;
	
	if Connections.TimeLabelConnection then
		Connections.TimeLabelConnection:Disconnect();
		Connections.TimeLabelConnection = nil;
	end
	
	if Win then
		GameLabel.Text = "Game Won";
	else
		GameLabel.Text = "Game Lost";
	end
	
	GameEndFrame.Visible = true;
	GameEndOpen = true;
	
	TimeLabel.Text = FormatTime(0);
	ChangedTime = 0;
	Started = false;
end)

WaveService.Added:Connect(function(WaveData: WaveService.GetWaveSync)
	if WaveData.UniqueId == WaveService.CurrentWave then
		TopFrame.Visible = true;
		Start();
	end
end)

WaveService.GlobalWaveChanged:Connect(function(Spectating: boolean)
	if not Spectating then
		local NewData = WaveService.GetData();
		if NewData then
			HandleTime(NewData.Time, NewData.TimeSent);
			HandleHealth(NewData.BaseHealth, NewData.MaxHealth);
			HandleWave(NewData.CurrentWave);
		else
			TopFrame.Visible = false;
		end
	end
end)

RunService.PostSimulation:Connect(function(Delta: number)
	if not Started then
		return;
	end
	
	local AdjustedTime = math.floor((StartTime - workspace:GetServerTimeNow()) + CurrentTime);
	
	local NewTime = math.max(AdjustedTime, 0);
	if ChangedTime ~= NewTime then
		TimeLabel.Text = FormatTime(NewTime);
		ChangedTime = NewTime;
	end
end)

local function HandleVote(VoteCount: number, Maximum: number)
	PlayerCountLabel.Text = string.format("%u/%u", VoteCount, Maximum);
end

VoteSendEvent.OnClientEvent:Connect(function(Data: any, Type: string)
	if Type == "Start" then
		if WaveService.CurrentWave then
			return;
		end
		local SentTime = Data.SentTime;
		local Time = Data.Time;
		
		if Connections.VotesTime then
			Connections.VotesTime:Disconnect();
			Connections.VotesTime = nil;
		end
		
		Connections.VotesTime = RunService.PostSimulation:Connect(function()
			local NewTime = math.max(math.floor((SentTime - workspace:GetServerTimeNow()) + Time), 0);
			VoteTimeLabel.Text = string.format("Starts in: %u", NewTime);
			
			if NewTime == 0 then
				if Connections.VotesTime then
					Connections.VotesTime:Disconnect();
					Connections.VotesTime = nil;
				end
				GameStartFrame.Visible = false;
			end
		end)
		
		Connections.YesVotesClick = YesButton.MouseButton1Click:Connect(function()
			VoteEvent:FireServer();
		end)
		
		HandleVote(Data.Votes, Data.VotesNeeded);
		GameStartFrame.Visible = true;
	elseif Type == "Votes" then
		HandleVote(Data.Votes, Data.VotesNeeded);
	elseif Type == "End" then
		--GameStartFrame.Visible = false;
	end
end)

NoButton.MouseButton1Click:Connect(function()
	GameStartFrame.Visible = false;
	if Connections.VotesTime then
		Connections.VotesTime:Disconnect();
		Connections.VotesTime = nil;
	end
end)

YesButton.MouseButton1Click:Connect(function()
	GameStartFrame.Visible = false;
	if Connections.VotesTime then
		Connections.VotesTime:Disconnect();
		Connections.VotesTime = nil;
	end
end)

LeaveButton.MouseButton1Click:Connect(function()
	if not WaveService.SpectateWave then
		TopFrame.Visible = false;
	end
	
	GameEndFrame.Visible = false;
	GameEndOpen = false;
	
	WaveService.LeaveButton();
end)