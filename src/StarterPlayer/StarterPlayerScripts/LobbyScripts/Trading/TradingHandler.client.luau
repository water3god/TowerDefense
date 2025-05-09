
-- By Wa1er_God --

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Player = Players.LocalPlayer;
local PlayerGui: typeof(ReplicatedStorage.CloneGui) & typeof(game:GetService("StarterGui")) = Player.PlayerGui;

local Client = ReplicatedStorage.Client;
local GlobalClient = Client.GlobalClient;
local LobbyClient = Client.LobbyClient;
local TradeService = require(LobbyClient.TradeService);
local InventoryService = require(GlobalClient.InventoryService);
local ConfirmGui = require(GlobalClient.ConfirmGui);
local Shared = ReplicatedStorage.Shared;
local Types = require(Shared.Types);

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);
local DelayHandler = require(Modules.DelayHandler);

local LobbyGui: typeof(PlayerGui.LobbyGui) = PlayerGui:WaitForChild("LobbyGui");
local TradeGui = LobbyGui.TradeGui;


local TradeFrame = TradeGui.TradeFrame;
local YourTrades = TradeFrame.YourTrades;
local OtherTrades = TradeFrame.OtherTrades;

local YesButton = TradeFrame.YesButton;
local NoButton = TradeFrame.NoButton;

local OtherName = TradeFrame.OtherName;
local YourName = TradeFrame.YourName;

YourName.Text = Player.Name;

TradeService.NewTrade:Connect(function(TradeData: Types.TradeData)
	OtherName.Text = TradeData.OtherPlayer.Name;
	
	TradeFrame:SetAttribute("AnimateVisible", true);
end)

local function GetFrameFromPlayer(OtherPlayer: Player)
	if OtherPlayer == Player then
		return YourTrades;
	else
		return OtherTrades;
	end
end

local TradeFrames: {[string]: typeof(InventoryService.UnitFrame)} = {};

TradeService.UnitAdded:Connect(function(UnitData: Types.VisualUnitData, OtherPlayer: Player)
	local Frame = InventoryService.ApplyDataUnitFrame(UnitData);
	local TradeFrame = GetFrameFromPlayer(OtherPlayer);
	
	local Id = UnitData.UniqueId;
	
	TradeFrames[Id] = TradeFrame;
	
	TradeFrame.Destroying:Once(function()
		TradeFrames[Id] = nil;
	end)
	
	Frame.Parent = TradeFrame.GridContainer;
end)

TradeService.UnitRemoving:Connect(function(UniqueId: string, OtherPlayer: Player)
	if TradeFrames[UniqueId] then
		TradeFrames[UniqueId]:Destroy();
	end
end)

TradeService.Ended:Connect(function()
	TradeFrame:SetAttribute("AnimateVisible", false);
end)
