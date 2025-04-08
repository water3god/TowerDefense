--!strict

-- By Wa1er_God --

local Time = 5;

-- Services --

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local StarterGui = game:GetService("StarterGui");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");

local Remotes = ReplicatedStorage.Remotes;
local StartPointEvents = Remotes.StartPoint;

local ChooseGameEvent = StartPointEvents.ChooseGameEvent;
local ChooseGame = StartPointEvents.ChooseGame;
local ClosePoint = StartPointEvents.ClosePoint;
local OnClose = StartPointEvents.OnClose;
local PlayerCountChange = StartPointEvents.PlayerCountChange;
local OwnerStartEvent = StartPointEvents.OwnerStartEvent;

local CloneGui = ReplicatedStorage.CloneGui;

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);

local Shared = ReplicatedStorage.Shared;

local GameInfo = require(Shared.GameInfo);

local Player = Players.LocalPlayer;
local PlayerGui: typeof(CloneGui) & typeof(StarterGui) = Player.PlayerGui;
local LobbyGui: typeof(PlayerGui.LobbyGui) = PlayerGui:WaitForChild("LobbyGui");
local GlobalGui: typeof(PlayerGui.GlobalGui) = PlayerGui:WaitForChild("GlobalGui");

local Client = ReplicatedStorage.Client;
local LobbyClient = Client.LobbyClient;
local GUI = LobbyClient.GUI;

local MenuGui = LobbyGui.MenuGui;

local StoryFrame = MenuGui.StoryFrame;
local MainFrame = StoryFrame.MainFrame;

local PlayButton = StoryFrame.PlayButton;
local CloseButton = StoryFrame.CloseButton;

local StageFrame = StoryFrame.StageFrame;

local Bar = MenuGui.Bar;
local InnerBar = Bar.BarOverlay.InnerBar;
local TimeLabel = Bar.TimeLabel;

local MapFrame = script:WaitForChild("MapFrame");
local RewardSample = script:WaitForChild("Reward");

local Layouts = {
	[MainFrame.UIListLayout] = Enum.AutomaticSize.X;
};

local StageFrames = {};

for _, Frame in ipairs(StageFrame:GetChildren()) do
	if Frame:IsA("Frame") then
		table.insert(StageFrames, Frame);
	end
end

table.sort(StageFrames, function(Frame1, Frame2)
	local Num1 = tonumber(Frame1.Name:sub(10));
	local Num2 = tonumber(Frame2.Name:sub(10));
	
	return Num1 < Num2;
end)

local function ClearFrames(Instance: Instance)
	for i, v in ipairs(Instance:GetChildren()) do
		if v:IsA("GuiObject") then
			v:Destroy();
		end
	end
end

local CurrentMap = nil; -- frame --
local CurrentMapName = nil; --string --
local MapConnections: {RBXScriptConnection} = {};
local CurrentStage = nil; -- frame --
local CurrentStageIndex = nil; -- number --
local StageConnections: {RBXScriptConnection} = {};
local CurrentDifficulty = "Normal"; -- string --

local TimeConnection: RBXScriptConnection? = nil;
local Timethread: thread? = nil;

for _Ind, MapData in ipairs(GameInfo.GameInfo) do
	local MapFrame = MapFrame:Clone();
	
	MapFrame.MapName.Text = MapData.Name;
	MapFrame.MapImage.Image = MapData.Image;
	
	local ChangeDifficulty = MapFrame.ChangeDifficulty;
	local DifficultyLabel = ChangeDifficulty.DifficultyLabel;
	local DifficultyTitle = MapFrame.DifficultyTitle;
	local RewardsLabel = MapFrame.RewardsLabel;
	local RewardsFrame = MapFrame.RewardsFrame;
	
	local function OnMapClick()
		if CurrentMap == MapFrame then
			return;
		end

		if CurrentMap then
			CurrentMap.BackgroundColor3 = Color3.fromRGB(68, 11, 93);
			CurrentMap.ChangeDifficulty.Visible = false;
			CurrentMap.DifficultyTitle.Visible = false;
			CurrentMap.RewardsLabel.Visible = false;
			CurrentMap.RewardsFrame.Visible = false;
		end

		CurrentMap = MapFrame;
		CurrentMapName = MapData.Name;

		CurrentMap.BackgroundColor3 = Color3.fromRGB(125, 47, 171);
		MapFrame.ChangeDifficulty.Visible = true;
		MapFrame.DifficultyTitle.Visible = true;
		MapFrame.RewardsLabel.Visible = true;
		MapFrame.RewardsFrame.Visible = true;

		HelperFunctions.DisconnectAll(MapConnections);
		HelperFunctions.DisconnectAll(StageConnections);

		DifficultyLabel.Text = string.upper(CurrentDifficulty);

		table.insert(MapConnections, ChangeDifficulty.MouseButton1Click:Connect(function()
			local Index = table.find(GameInfo.Difficulty, CurrentDifficulty);
			if Index then
				CurrentDifficulty = GameInfo.Difficulty[Index + 1] or GameInfo.Difficulty[1];
				DifficultyLabel.Text = string.upper(CurrentDifficulty);
			end
		end))

		local function OnClick(Frame, Index, Data: GameInfo.StageInfo, Override: boolean)
			if Index == CurrentStageIndex and not Override then
				return;
			end

			if CurrentStage then
				CurrentStage.StageName.BackgroundColor3 = Color3.fromRGB(31, 4, 41);
				CurrentStage.StageNumber.BackgroundColor3 = Color3.fromRGB(31, 4, 41);
			end

			Frame.StageName.BackgroundColor3 = Color3.fromRGB(105, 29, 144);
			Frame.StageNumber.BackgroundColor3 = Color3.fromRGB(105, 29, 144);

			CurrentStage = Frame;
			CurrentStageIndex = Index;

			ClearFrames(RewardsFrame);

			for RewardIndex, RewardData in ipairs(Data.RewardInfo) do
				local Frame = RewardSample:Clone();

				local RewardBaseInfo = GameInfo.RewardInfo[RewardData.Reward];

				Frame.Stroke.UIGradient.Color = RewardBaseInfo.Color;
				Frame.RewardImage.Image = RewardBaseInfo.Image;
				Frame.CountLabel.Text = string.format("%ux", RewardData.Count);
				Frame.RewardType.Text = RewardBaseInfo.Name;

				Frame.Parent = RewardsFrame;
			end

			ChangeDifficulty.Visible = true;
			DifficultyTitle.Visible = true;
			RewardsLabel.Visible = true;
			RewardsFrame.Visible = true;
			PlayButton.Visible = true;
		end

		for Index, StageData in ipairs(MapData.StageInfos) do
			local StageFrame = StageFrames[Index];

			table.insert(MapConnections, StageFrame.InputBegan:Connect(function(Input: InputObject)
				if HelperFunctions.IsClick(Input) then
					OnClick(StageFrame, Index, StageData, false);
				end
			end))

			StageFrame.StageName.Label.Text = StageData.Name;
			StageFrame.StageNumber.Label.Text = if StageData.Index == -1 then "∞" else StageData.Index;

			StageFrame.Visible = true;
		end

		for i = #MapData.StageInfos, #StageFrames, 1 do
			local StageFrame = StageFrames[i];

			if StageFrame then
				StageFrame.Visible = false;
			end
		end

		OnClick(StageFrames[1], 1, MapData.StageInfos[1], true);
	end
	
	MapFrame.InputBegan:Connect(function(Input: InputObject)
		if HelperFunctions.IsClick(Input) then
			OnMapClick();
		end
	end)
	
	if _Ind == 1 then
		OnMapClick();
	end
	
	MapFrame.Parent = MainFrame;
end

type Data = {
	UniqueId: string;
	OwnerId: number;
	PlayerCount: number;
	Time: number;
};

local CurrentData: Data? = nil;

local function TweenBar(Time: number, MaxTime: number)
	if TimeConnection then
		TimeConnection:Disconnect();
		TimeConnection = nil;
	end
	if Timethread and coroutine.status(Timethread) ~= "running" then
		task.cancel(Timethread);
		Timethread = nil;
	end
	
	local Ratio = Time / MaxTime;
	TimeLabel.Text = math.abs(math.round(Time));
	local StartTime = tick();
	TimeConnection = RunService.PostSimulation:Connect(function(Delta: number)
		local CurrentTime = tick();
		local NewTime = math.round(Time + (StartTime - CurrentTime));
		TimeLabel.Text = math.abs(math.clamp(NewTime, 0, MaxTime));
		
		if NewTime <= 0 and TimeConnection then
			TimeConnection:Disconnect();
			TimeConnection = nil;
		end
	end)
	
	local FirstTween = TweenService:Create(
		InnerBar,
		TweenInfo.new(0.3, Enum.EasingStyle.Sine),
		{Size = UDim2.fromScale(Ratio, 0.9)}
	);
	FirstTween.Completed:Once(function()
		local Tween = TweenService:Create(
			InnerBar,
			TweenInfo.new(Time - 0.3, Enum.EasingStyle.Linear),
			{Size = UDim2.fromScale(0, 0.9)}
		);
		Tween.Completed:Once(function()
			Timethread = task.delay(0.5, function()
				if tonumber(TimeLabel.Text) <= 0 then
					Bar.Visible = false;
				end
			end)
		end)
		Tween:Play();
	end)
	FirstTween:Play();
	Bar.Visible = true;
end

ChooseGameEvent.OnClientEvent:Connect(function(Data: Data & {SendTime: number})
	local NewTime = Data.Time - (workspace:GetServerTimeNow() - Data.SendTime);
	
	Data.SendTime = nil :: any;
	CurrentData = Data;
	StoryFrame:SetAttribute("AnimateVisible", false);
	TweenBar(NewTime, Time);
end)

OwnerStartEvent.OnClientEvent:Connect(function(Data: {Time: number, SendTime: number})
	local PassedTime = Data.Time - (workspace:GetServerTimeNow() - Data.SendTime)
	TweenBar(PassedTime, Time);
	StoryFrame:SetAttribute("AnimateVisible", true);
end)

PlayButton.MouseButton1Click:Connect(function()
	if CurrentMapName and CurrentStageIndex then
		ChooseGameEvent:FireServer(CurrentMapName, CurrentStageIndex, CurrentDifficulty);
	end
end)

PlayerCountChange.OnClientEvent:Connect(function(Data: {UniqueId: string, Count: number})
	if CurrentData then
		if CurrentData.UniqueId == Data.UniqueId then
			CurrentData.PlayerCount = Data.Count;
		end
	end
end)

OnClose.OnClientEvent:Connect(function(Player: Player, UniqueId: string)
	StoryFrame:SetAttribute("AnimateVisible", false);
	Bar.Visible = false;
	
	CurrentData = nil;
end)

CloseButton.MouseButton1Click:Connect(function()
	ClosePoint:FireServer();
end)