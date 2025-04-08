--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");

local TrueColor = Color3.new(0.317647, 1, 0);
local FalseColor =  Color3.new(1, 0, 0.0156863);

local Client = ReplicatedStorage.Client;
local GlobalClient = Client.GlobalClient;
local SettingsService = require(GlobalClient.SettingsService);

local Modules = ReplicatedStorage.Modules;
local LayoutUtil = require(Modules.LayoutUtil);

local Shared = ReplicatedStorage.Shared;
local SettingInfo = require(Shared.Settings);

local Player = Players.LocalPlayer;
local PlayerGui: typeof(game:GetService("StarterGui")) & typeof(ReplicatedStorage.CloneGui) = Player.PlayerGui;
local Camera = workspace.CurrentCamera;

local GlobalGui: typeof(PlayerGui.GlobalGui) = PlayerGui:WaitForChild("GlobalGui");
local SettingsGui = GlobalGui.SettingsGui;

local OpenButton = SettingsGui.Container.OpenButton;

local MainFrame = SettingsGui.Main;
local DataFrame = MainFrame.DataFrame;

local UIListLayout = DataFrame:FindFirstChildWhichIsA("UIListLayout");

local Settings = {
	"Music";
	"MusicVolume";
	"RollFrameLeft";
	"CanTrade";
	"CommonSkip";
	"RareSkip";
	"EpicSkip";
	"LegendarySkip";
	"MythicSkip";
};

local SettingData = {
	["Music"] = {Name = "Music"};
	["MusicVolume"] = {Name = "MusicVolume"};
	["RollFrameLeft"] = {Name = "Roll Frame Left"};
	["CanTrade"] = {Name = "Trading"};
	["CommonSkip"] = {Name = "Common", Header = "AutoRoll"};
	["RareSkip"] = {Name = "Rare", Header = "AutoRoll"};
	["EpicSkip"] = {Name = "Epic", Header = "AutoRoll"};
	["LegendarySkip"] = {Name = "Legendary", Header = "AutoRoll"};
	["MythicSkip"] = {Name = "Mythic", Header = "AutoRoll"};
};

local HeaderOrders = {
	["None"] = 0;
	["AutoRoll"] = 100;
};

local HeaderData: {
	[string]: {Frame};
} = {
	AutoRoll = {};
	None = {};
};

LayoutUtil.list(UIListLayout);
LayoutUtil.resize(DataFrame, UIListLayout, Enum.AutomaticSize.Y);

local BooleanFrame = script:WaitForChild("BooleanFrame");
local NumberFrame = script:WaitForChild("NumberFrame");
local StringFrame = script:WaitForChild("StringFrame");

if not SettingsService.IsSynced then
	SettingsService.Synced:Wait();
end

local function CreateFrame(Setting: string, Header: string?)
	local Header = Header or "None";
	local Type = SettingInfo.SettingTypes[Setting];
	local Frame = nil;
	
	if Type == "boolean" then
		local BooleanFrame = BooleanFrame:Clone();
		Frame = BooleanFrame;
		
		local Bar = BooleanFrame.Bar;
		local BarScroll = Bar.BarScroll;
		
		if SettingsService.GetSetting(Setting) then
			Bar.BackgroundColor3 = Color3.new(0.317647, 1, 0);
			BarScroll.Position = UDim2.fromScale(1, 0.5);
		else
			Bar.BackgroundColor3 = Color3.new(1, 0, 0.0156863);
			BarScroll.Position = UDim2.fromScale(0, 0.5);
		end
		
		local function HandleInput()
			SettingsService.ChangeSetting(Setting, not SettingsService.GetSetting(Setting));

			if SettingsService.GetSetting(Setting) then
				Bar.BackgroundColor3 = TrueColor;
				BarScroll.Position = UDim2.fromScale(1, 0.5);
			else
				Bar.BackgroundColor3 = FalseColor;
				BarScroll.Position = UDim2.fromScale(0, 0.5);
			end
		end
		
		BarScroll.InputBegan:Connect(function(Input: InputObject) 
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				HandleInput();
			end
		end)
		
	elseif Type == "number" then
		local NumberFrame = NumberFrame:Clone();
		Frame = NumberFrame;
		
		local Bar = NumberFrame.Bar;
		local BarScroll = Bar.BarScroll;
		
		local CurrentValue = SettingsService.GetSetting(Setting);
		
		BarScroll.Position = UDim2.fromScale(CurrentValue, 0.5);
		Bar.BackgroundColor3 = FalseColor:Lerp(TrueColor, CurrentValue);
		
		local HeldDown: boolean = false;
		
		BarScroll.InputBegan:Connect(function(Input: InputObject)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				HeldDown = true;
			end
		end)
		
		local Connection = UserInputService.InputChanged:Connect(function(Input: InputObject, Processed: boolean)
			if HeldDown then
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					local MousePos = UserInputService:GetMouseLocation();
					local Difference = MousePos.X - Bar.AbsolutePosition.X;
					local Percent: number = math.clamp(Difference / Bar.AbsoluteSize.X, 0, 1);
					
					SettingsService.ChangeSettingClient(Setting, Percent);
					
					Bar.BackgroundColor3 = FalseColor:Lerp(TrueColor, Percent);
					
					BarScroll.Position = UDim2.fromScale(Percent, 0.5);
				end
			end
		end)
		
		BarScroll.Destroying:Once(function()
			Connection:Disconnect();
			Connection = nil;
		end)
		
		BarScroll.InputEnded:Connect(function(Input: InputObject)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				SettingsService.SyncSetting(Setting);
				HeldDown = false;
			end
		end)
	elseif Type == "string" then
		local StringFrame = StringFrame:Clone();
		Frame = StringFrame;
		
		local InputFrame = StringFrame.InputFrame;
		
		InputFrame.FocusLost:Connect(function(EnterPressed: boolean, Input: InputObject)
			if EnterPressed then
				SettingsService.ChangeSetting(Setting, InputFrame.Text);
			end
		end)
	end
	
	Frame.SettingName.Text = SettingData[Setting].Name;
	table.insert(HeaderData[Header], Frame);
	Frame.LayoutOrder = #HeaderData[Header] + HeaderOrders[Header];
	Frame.Parent = DataFrame;
end

for _, Setting in ipairs(Settings) do
	CreateFrame(Setting, SettingData[Setting].Header);
end

OpenButton.MouseButton1Click:Connect(function()
	MainFrame:SetAttribute("AnimateVisible", not MainFrame:GetAttribute("AnimateVisible"));
end)

