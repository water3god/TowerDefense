--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");

local Client = ReplicatedStorage.Client;
local GlobalClient = Client.GlobalClient;
local WaveService = require(GlobalClient.WaveService);

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);
local Trove = require(Modules.Trove);

local Player = Players.LocalPlayer;
local PlayerGui: typeof(game.StarterGui) & typeof(ReplicatedStorage.CloneGui) = Player.PlayerGui;
local GlobalGui: typeof(PlayerGui.GlobalGui) = PlayerGui:WaitForChild("GlobalGui");
local GameGui: typeof(GlobalGui.GameGui) = GlobalGui.GameGui;

local TopFrame = GameGui.TopFrame;
local HealthFrame = TopFrame.HealthFrame;
local Bar = HealthFrame.Bar;
local HealthLabel = HealthFrame.HealthLabel;

local TimeLabel = TopFrame.TimeFrame.TimeLabel;
local WaveLabel = TopFrame.WaveFrame.WaveLabel;

local function TweenHealth(Health: number, MaxHealth: number)
	HealthLabel.Text = string.format("%u / %u", Health, MaxHealth);
	local Ratio = math.clamp(Health / MaxHealth, 0, 1);
	local Size = UDim2.fromScale(Ratio, Bar.Size.Y.Scale);
	TweenService:Create(Bar, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Size}):Play();
end

local function SetWave(Wave: number)
	WaveLabel.Text = string.format("%u", Wave);
end

local TimeTrove = Trove.new();

local function UpdateTime(Time: number, StartTime: number)
	TimeTrove:Destroy();
	HelperFunctions.ConnectTime(StartTime, StartTime + Time, function(Time: number)
		TimeLabel.Text = HelperFunctions.FormatTime(Time);
	end, TimeTrove);
end

local function OnAdded(Wave: WaveService.WaveData)
	TopFrame.Visible = true;
	UpdateTime(Wave.Time, Wave.StartTime);
	TweenHealth(Wave.BaseHealth, Wave.MaxHealth);
	SetWave(Wave.Wave);
end

local Wave = WaveService.GetWaveData();

if Wave then
	OnAdded(Wave);
end

WaveService.Added:Connect(OnAdded);
WaveService.HealthChanged:Connect(TweenHealth);
WaveService.Passed:Connect(SetWave);
WaveService.TimeChanged:Connect(UpdateTime);
WaveService.Ended:Connect(function()
	TimeTrove:Destroy();
end)