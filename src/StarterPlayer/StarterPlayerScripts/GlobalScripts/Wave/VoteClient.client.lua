--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);
local DelayHandler = require(Modules.DelayHandler);
local Trove = require(Modules.Trove);

local Client = ReplicatedStorage.Client;
local GlobalClient = Client.GlobalClient;
local WaveService = require(GlobalClient.WaveService);

local Player = Players.LocalPlayer;
local PlayerGui: typeof(game.StarterGui) & typeof(ReplicatedStorage.CloneGui) = Player.PlayerGui;
local GlobalGui: typeof(PlayerGui.GlobalGui) = PlayerGui:WaitForChild("GlobalGui");
local GameGui: typeof(GlobalGui.GameGui) = GlobalGui.GameGui;

local Main = GameGui.GameStartFrame;
local NoButton = Main.NoButton;
local YesButton = Main.YesButton;
local PlayerCount = Main.PlayerCount;
local TimeLabel = Main.TimeLabel;
local Title = Main.Title;

local function SetPlayerCount(CurrentVotes: number, NeededVotes: number)
	PlayerCount.Text = string.format("%u/%u", CurrentVotes, NeededVotes);
end

local TimeTrove = Trove.new();

local function OnVoteStarted(VoteData: WaveService.VoteData)
	TimeTrove:Destroy();

	local WaveData = WaveService.GetWaveData();
	if WaveData then
		if WaveData.Wave == 0 then
			Title.Text = "Vote Start";
			HelperFunctions.ConnectTime(VoteData.StartTime, VoteData.StartTime + VoteData.Time, function(Time: number)
				TimeLabel.Text = string.format("Starts In: %u", math.floor(Time));
			end, TimeTrove)
		else
			Title.Text = "Vote Skip";
			HelperFunctions.ConnectTime(VoteData.StartTime, VoteData.StartTime + VoteData.Time, function(Time: number)
				TimeLabel.Text = string.format("Time Left: %u", math.floor(Time));
			end, TimeTrove)
		end
	end

	TimeTrove:Add(function()
		Main:SetAttribute("IsVisible", false);
	end)
	SetPlayerCount(VoteData.CurrentCount, VoteData.NeededCount);
	Main:SetAttribute("IsVisible", true);
end

local VoteData = WaveService.GetVoteData();
if VoteData then
	OnVoteStarted(VoteData);
end

WaveService.VoteData.VoteStarted:Connect(OnVoteStarted);
WaveService.VoteData.VoteChanged:Connect(SetPlayerCount);

WaveService.VoteData.VoteEnded:Connect(function()
	TimeTrove:Destroy();
end)

NoButton.MouseButton1Click:Connect(function()
	TimeTrove:Destroy();
end)

YesButton.MouseButton1Click:Connect(function()
	if DelayHandler(YesButton, 0.5) then
		WaveService.Vote();
	end
end)