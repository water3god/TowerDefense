--!strict

-- By Wa1er_God --

-- Services --

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Modules = ReplicatedStorage.Modules;
local LayoutUtil = require(Modules.LayoutUtil);

local Shared = ReplicatedStorage.Shared;

local GameInfo = require(Shared.GameInfo);

local Player = Players.LocalPlayer;
local PlayerGui = Player.PlayerGui;

local MenuGui: ScreenGui = PlayerGui:WaitForChild("MenuGui");
local GamemodeSelection: Frame = (MenuGui :: any).GamemodeSelection;
local SelectionGroup: Frame = (GamemodeSelection :: any).SelectionGroup;

-- SelectionFrames --

local StoryFrame: Frame = (SelectionGroup :: any).Story;
local InfiniteFrame: Frame = (SelectionGroup :: any).Infinite;
local EventFrame: Frame = (SelectionGroup :: any).Event;

-- Story Frames --

local StoryMainFrame: Frame = (GamemodeSelection :: any).StoryMainFrame;

local MapInfoFrame: Frame = (StoryMainFrame :: any).MapInfoFrame;

local StoryStats: Frame = (MapInfoFrame :: any).StoryStats;
local StoryDifficultyLabel: TextLabel = (StoryStats :: any).Difficulty;
local StoryWaveValue: TextLabel = (StoryStats :: any).WaveValue;
local StoryWave: TextLabel = (StoryStats :: any).StoryWave;

local StoryStageSelection: ScrollingFrame = (StoryMainFrame :: any).StageSelection;
local StoryMapSelectionFrame: ScrollingFrame = (StoryMainFrame :: any).MapSelectionFrame;

-- Infinite Frames --

local InfiniteMainFrame: Frame = (GamemodeSelection :: any).InfiniteMainFrame;

local MapInfoFrame: Frame = (InfiniteMainFrame :: any).MapInfoFrame;

local StoryStats: Frame = (MapInfoFrame :: any).StoryStats;
local StoryDifficultyButton: TextButton = (StoryStats :: any).DifficultyButton;
local StoryWaveValue: TextLabel = (StoryStats :: any).WaveValue;
local StoryWave: TextLabel = (StoryStats :: any).StoryWave;

local InfiniteStageSelection: ScrollingFrame = (InfiniteMainFrame :: any).StageSelection;
local InfiniteMapSelectionFrame: ScrollingFrame = (InfiniteMainFrame :: any).MapSelectionFrame;

local MainFrames: {[Frame]: Frame} = {
	[StoryFrame] = StoryMainFrame;
	[InfiniteFrame] = InfiniteMainFrame;
};

local MapSample = script:WaitForChild("MapFrame");
local StageSample = script:WaitForChild("StageFrame");

LayoutUtil.list((StoryStageSelection :: any).UIListLayout);
LayoutUtil.list((StoryMapSelectionFrame :: any).UIListLayout);
LayoutUtil.list((InfiniteStageSelection :: any).UIListLayout);
LayoutUtil.list((InfiniteMapSelectionFrame :: any).UIListLayout);

local function HandleStory()
	StoryMainFrame:SetAttribute("AnimateVisible", true);
end

local function HandleInfinite()
	
end

local function OnClick(Frame: Frame)
	local MainFrame = MainFrames[Frame];
	
	SelectionGroup.Visible = false;
	MainFrame.Visible = true;
end

local function IsClick(Type: Enum.UserInputType)
	return Type == Enum.UserInputType.MouseButton1 or Type == Enum.UserInputType.Touch;
end

local function ClearFrames(Instance: Instance)
	for _, Child in pairs(Instance:GetChildren()) do
		if Child:IsA("Frame") then
			Child:Destroy();
		end
	end
end

StoryFrame.InputBegan:Connect(function(Input: InputObject)
	if IsClick(Input.UserInputType) then
		
	end
end)

-- Story --

do
	local function HandleStage(StageFrame: Frame, StageInfo: GameInfo.StageInfo)
		StageFrame.InputBegan:Connect(function(Input: InputObject)
			if IsClick(Input.UserInputType) then
				StoryWaveValue.Text = tostring(StageInfo.WaveCount);
				StoryStats.Visible = true;
			end
		end)
	end
	
	for Index1, MapInfo in ipairs(GameInfo.GameInfo) do
		local MapFrame = MapSample:Clone();
		MapFrame.Name = MapInfo.Name;
		MapFrame.MapName.Text = MapInfo.Name;

		MapFrame.InputBegan:Connect(function(Input: InputObject)
			if IsClick(Input.UserInputType) then
				ClearFrames(StoryStageSelection);
				for Index2, StageInfo in ipairs(MapInfo.StageInfos) do
					local StageFrame = StageSample:Clone();
					
					StageFrame.Name = StageInfo.Name;
					StageFrame.StageName.Text = StageInfo.Name;
					
					HandleStage(StageFrame, StageInfo);
					
					StageFrame.Parent = StoryStageSelection;
				end
			end
		end)
		
		MapFrame.Parent = StoryMapSelectionFrame;
	end
end

-- Infinite --

do
	local function HandleStage(StageFrame: Frame, StageInfo: GameInfo.StageInfo)
		StageFrame.InputBegan:Connect(function(Input: InputObject)
			if IsClick(Input.UserInputType) then
				StoryWaveValue.Text = tostring(StageInfo.WaveCount);
				StoryStats.Visible = true;
			end
		end)
	end

	for Index1, MapInfo in ipairs(GameInfo.GameInfo) do
		local MapFrame = MapSample:Clone();
		MapFrame.Name = MapInfo.Name;
		MapFrame.MapName.Text = MapInfo.Name;

		MapFrame.InputBegan:Connect(function(Input: InputObject)
			if IsClick(Input.UserInputType) then
				ClearFrames(StoryStageSelection);
				for Index2, StageInfo in ipairs(MapInfo.StageInfos) do
					local StageFrame = StageSample:Clone();

					StageFrame.Name = StageInfo.Name;
					StageFrame.StageName.Text = StageInfo.Name;

					HandleStage(StageFrame, StageInfo);

					StageFrame.Parent = StoryStageSelection;
				end
			end
		end)

		MapFrame.Parent = StoryMapSelectionFrame;
	end
end

