--!strict

-- By Wa1er_God --

-- 93, 11, 141 UnSelected Level Color
-- 127, 32, 165 Selected Level Color

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local StarterGui = game:GetService("StarterGui");
local RunService = game:GetService("RunService");

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);
local ObserveTag = require(Modules.ObserveTag);
local Trove = require(Modules.Trove);
local DelayHandler = require(Modules.DelayHandler);

local Shared = ReplicatedStorage.Shared;
local GameInfo = require(Shared.GameInfo);

local CloneGui = ReplicatedStorage.CloneGui;

local Player = Players.LocalPlayer;
local PlayerGui: typeof(CloneGui) & typeof(StarterGui) = Player.PlayerGui;
local LobbyGui: typeof(PlayerGui.LobbyGui) & typeof(StarterGui) = PlayerGui:WaitForChild("LobbyGui");
local GlobalGui: typeof(PlayerGui.GlobalGui) & typeof(StarterGui) = PlayerGui:WaitForChild("GlobalGui");

local Client = ReplicatedStorage.Client;
local LobbyClient = Client.LobbyClient;
local GlobalClient = Client.GlobalClient;
local GUI = LobbyClient.GUI;
local OtherGUI = GlobalClient.GUI;
local Reward = OtherGUI.Reward;
local StageSample = GUI.StageSample;
local DifficultyStroke = GUI.DifficultyStroke;

local InventoryService = require(GlobalClient.InventoryService);

-- Remotes --

local BoothEvents = ReplicatedStorage.Remotes.Booth;

local ServerFires = BoothEvents.ServerFires;
local BoothChoosing = ServerFires.BoothChoosing;
local BoothMapLoading = ServerFires.BoothMapLoading;
local BoothRestarted = ServerFires.BoothRestarted;
local BoothWaiting = ServerFires.BoothWaiting;
local PlayerChanged = ServerFires.PlayerChanged;

local ClientFires = BoothEvents.ClientFires;
local ChooseMap = ClientFires.ChooseMap;
local LeaveBooth = ClientFires.LeaveBooth;
local OwnerStart = ClientFires.OwnerStart;

-- GUI --

local GameGui: typeof(GlobalGui.GameGui) = GlobalGui:WaitForChild("GameGui");
local BottomFrame = GameGui.BottomFrame;

local MenuGui: typeof(LobbyGui.MenuGui) = LobbyGui:WaitForChild("MenuGui");
local StoryFrame = MenuGui.StoryFrame;
local DifficultyFrame = StoryFrame.DifficultyFrame;
local LevelFrame = StoryFrame.LevelFrame;
local LevelMainFrame = LevelFrame.MainFrame;
local ResourcesFrame = StoryFrame.ResourcesFrame;
local ResourceMainFrame = ResourcesFrame.ResourceMainFrame;

local StatsFrame = StoryFrame.StatsFrame;

local Title = StoryFrame.Title;
local CancelButton = StoryFrame.CancelButton;
local CloseButton = StoryFrame.CloseButton;
local ConfirmButton = StoryFrame.ConfirmButton;
local MapImage = StoryFrame.MapImage;
local MapName = StoryFrame.MapName;

local StageFrame = StoryFrame.StageFrame;
local MainStageFrame = StageFrame.MainStageFrame;

local Bar = StoryFrame.Bar;
local InnerBar = Bar.InnerBar;
local TimeLabel = Bar.TimeLabel;

local WaitingFrame = MenuGui.WaitingFrame;
local WaitingStart = WaitingFrame.StartButton;
local WaitingClose = WaitingFrame.CloseButton;
local WaitingTitle = WaitingFrame.Title;
local WaitingMapImage = WaitingFrame.MapImage;
local WaitingDifficulty = WaitingFrame.Difficulty;
local WaitingBar = WaitingFrame.TimeBar.Bar;
local WaitingTimeLabel = WaitingFrame.TimeBar.TimeLabel;

local Levels = {
	LevelMainFrame.Stage1;
	LevelMainFrame.Stage2;
	LevelMainFrame.Stage3;
	LevelMainFrame.Stage4;
	LevelMainFrame.Stage5;
};

type TimeData = {StartTime: number, EndTime: number};

local BoothTrove = Trove.new();
local HoveredTrove = Trove.new();
local LevelTrove = Trove.new();
local DifficultyTrove = Trove.new();
local MapId: string? = nil;
local CurrentIndex: number? = nil;

local function OnLeave()
	DifficultyTrove:Destroy();
	LevelTrove:Destroy();
	HoveredTrove:Destroy();
	BoothTrove:Destroy();
end

local function ClickStage(MapData: GameInfo.MapInfo, LevelData: GameInfo.LevelInfo)
	DifficultyTrove:Destroy();
	LevelTrove:Destroy();
	LevelTrove:Add(function()
		for _, Frame in ipairs(ResourceMainFrame:GetChildren()) do
			if Frame:IsA("GuiObject") then
				Frame:Destroy();
			end
		end
	end)
	
	CurrentIndex = LevelData.Index;
	LevelTrove:Add(function()
		CurrentIndex = nil;
	end)
	
	local CurrentDifficulty: string = nil;
	local function ClickDifficulty(Name: string)
		DifficultyTrove:Destroy();
		local Frame: ImageLabel = DifficultyFrame:FindFirstChild(Name);

		if Frame then
			CurrentDifficulty = Name;
			Frame.ImageColor3 = Color3.fromRGB(183, 42, 255);
			DifficultyTrove:Add(function()
				Frame.ImageColor3 = Color3.new();
			end)
		end
	end
	
	ClickDifficulty("Normal");
	
	for _, Frame in ipairs(DifficultyFrame:GetChildren()) do
		if Frame:IsA("GuiObject") then
			HelperFunctions.MouseButton1Click(Frame, function()
				if Frame.Name ~= CurrentDifficulty then
					ClickDifficulty(Frame.Name);
				end
			end, LevelTrove);
		end
	end
	
	local CurrentIndex = 1;
	
	for _, UnitInfo in ipairs(LevelData.UnitInfo) do
		local Frame = InventoryService.ApplyDataUnitRaw(UnitInfo);
		Frame.Container:RemoveTag("GuiAnimateBasic");
		Frame.LayoutOrder = CurrentIndex;
		CurrentIndex += 1;
		Frame.Parent = ResourceMainFrame;
	end
	
	for _, Reward in ipairs(LevelData.RewardInfo) do
		local Frame = InventoryService.ApplyDataRewardRaw(Reward);
		Frame.Container:RemoveTag("GuiAnimateBasic");
		Frame.LayoutOrder = CurrentIndex;
		CurrentIndex += 1;
		Frame.Parent = ResourceMainFrame;
	end
	
	MapName.Text = GameInfo.GetFullName(MapData.Name, LevelData.Index, LevelData.Name);
	
	-- Handle Stats --
	
	LevelTrove:Connect(ConfirmButton.MouseButton1Click, function()
		if MapId then
			if DelayHandler("LevelClick1", 0.2) then
				ChooseMap:FireServer({
					MapId = MapId;
					LevelId = LevelData.GameId;
					Difficulty = CurrentDifficulty;
				});
			end
		end
	end)

	LevelTrove:Connect(CancelButton.MouseButton1Click, function()
		if DelayHandler("LevelBooth", 0.2) then
			LeaveBooth:FireServer();
		end
	end)
	
	local Frame = Levels[LevelData.Index];
	Frame.BackgroundColor3 = Color3.fromRGB(127, 32, 165);
	
	LevelTrove:Add(function()
		Frame.BackgroundColor3 = Color3.fromRGB(93, 11, 141);
	end)
end

local function OpenMap(MapData: GameInfo.MapInfo)
	DifficultyTrove:Destroy();
	LevelTrove:Destroy();
	MapId = MapData.MapId;
	HoveredTrove:Add(function()
		MapId = nil;
	end)
	
	MapImage.Image = MapData.Image;

	for Index, Frame in ipairs(Levels) do
		local LevelInfo = MapData.LevelInfo[Index];
		
		if LevelInfo then
			HelperFunctions.MouseButton1Click(Frame, function()
				if CurrentIndex ~= Index then
					ClickStage(MapData, LevelInfo);
				end
			end, HoveredTrove);
			Frame.Visible = true;
		else
			Frame.Visible = false;
		end
	end
	
	ClickStage(MapData, MapData.LevelInfo[1]);
end

local function HandleMapData(MapData: GameInfo.MapInfo, Index: number)
	local StageMapFrame = StageSample:Clone();
	StageMapFrame.LayoutOrder = Index;
	
	local Main = StageMapFrame.Main;
	
	Main.MapImage.Image = MapData.Image;
	Main.MapName.Text = MapData.Name;
	--Main.MapsCleared.Text = 1;
	
	HelperFunctions.MouseButton1Click(Main, function()
		if MapId ~= MapData.MapId then
			OpenMap(MapData);
		end
	end)

	StageMapFrame.Parent = MainStageFrame;
end

for Index, MapData in ipairs(GameInfo.GameInfo) do
	HandleMapData(MapData, Index);
end

BoothChoosing.OnClientEvent:Connect(function(Data: TimeData)
	local Length = Data.EndTime - Data.StartTime;
	OpenMap(GameInfo.GameInfo[1]);
	HelperFunctions.ConnectTime(Data.StartTime, Data.EndTime, function(Time: number)
		InnerBar.Size = UDim2.fromScale(Time / Length, 1);
		TimeLabel.Text = string.format("Time Left: %u", Time);
	end, HoveredTrove);
	BottomFrame:AddTag("StaticButtonVisibility");
	StoryFrame:SetAttribute("AnimateVisible", true);
	
	HoveredTrove:Add(function()
		StoryFrame:SetAttribute("AnimateVisible", false);
		task.delay(0.2, function()
			BottomFrame:RemoveTag("StaticButtonVisibility");
		end)
		
	end)
	HoveredTrove:Connect(StoryFrame:GetAttributeChangedSignal("AnimateVisible"), function()
		if not StoryFrame:GetAttribute("AnimateVisible") then
			LeaveBooth:FireServer();
		end
	end)
end)

-- the map is loading after timer ends
BoothMapLoading.OnClientEvent:Connect(function()
	WaitingStart.Visible = false;
	WaitingTimeLabel.Text = "Game Is Starting...";
end)

BoothRestarted.OnClientEvent:Connect(function()
	OnLeave();
end)

--When you finish picking map
BoothWaiting.OnClientEvent:Connect(function(Data: {OwnerId: number, MapId: string, LevelId: string, Difficulty: string} & TimeData)
	DifficultyTrove:Destroy();
	LevelTrove:Destroy();
	HoveredTrove:Destroy();
	
	BoothTrove:Add(function()
		WaitingFrame.Visible = false;
	end)
	
	local Length = Data.EndTime - Data.StartTime;
	HelperFunctions.ConnectTime(Data.StartTime, Data.EndTime, function(Time: number)
		WaitingBar.Size = UDim2.fromScale(Time / Length, 1);
		WaitingTimeLabel.Text = string.format("Time Left: %u", Time);
	end, BoothTrove);
	
	local MapData, LevelData = GameInfo.GetDataFromInfo(Data.MapId, Data.LevelId);
	if not MapData or not LevelData then
		return;
	end
	WaitingTitle.Text = GameInfo.GetFullName(MapData.Name, LevelData.Index, LevelData.Name);
	MapImage.Image = MapData.Image;
	WaitingDifficulty.Text = GameInfo.GetDifficultyString(Data.Difficulty);
	
	if Data.OwnerId == Player.UserId then
		BoothTrove:Connect(WaitingStart.MouseButton1Click, function()
			OwnerStart:FireServer();
		end)
		WaitingStart.Visible = true;
	end
	BoothTrove:Connect(WaitingClose.MouseButton1Click, function()
		if DelayHandler("LeaveBoothOnWaiting", 0.2) then
			LeaveBooth:FireServer();
		end
	end)
	WaitingFrame.Visible = true;
end)

-- Player Count Changed
PlayerChanged.OnClientEvent:Connect(function(OtherPlayer: Player, Added: boolean)
	if Player == OtherPlayer and not Added then
		OnLeave();
		return;
	end
end)

CloseButton.MouseButton1Click:Connect(function()
	if DelayHandler("CloseButton", 0.2) then
		LeaveBooth:FireServer();
	end
end)