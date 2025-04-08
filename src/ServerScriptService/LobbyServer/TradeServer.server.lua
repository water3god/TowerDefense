--!strict

-- By Wa1er_God --

local TradeRequestTime: number = 15;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Players = game:GetService("Players");

local TradeEvents = ReplicatedStorage.Remotes.Trade;
local ChangeProduct = TradeEvents.ChangeProduct;
local ChangeUnit = TradeEvents.ChangeUnit;
local TradeStart = TradeEvents.TradeStart;
local TradeEnd = TradeEvents.TradeEnd;
local TradeRequest = TradeEvents.TradeRequest;
local TradeAccept = TradeEvents.TradeAccept;
local TradeSync = TradeEvents.TradeSync;

local UnitChanged = TradeEvents.UnitChanged;
local ProductChanged = TradeEvents.ProductChanged;

local Modules = ReplicatedStorage.Modules;
local Trove = require(Modules.Trove);
local HelperFunctions = require(Modules.HelperFunctions);

local GlobalModules = ServerScriptService.GlobalModules;
local LobbyModules = ServerScriptService.LobbyModules;
local Trade = require(LobbyModules.Trade);
local PlayerData = require(GlobalModules.PlayerData);
local GlobalWave = require(GlobalModules.GlobalWave);

type TradeData = {
	Trade: Trade.Trade?;
	CanTrade: boolean;
	TradeEnabled: boolean;
	LastTradedPlayers: {[Player]: number};
	RequestThreads: {thread};

	Trove: Trove.Trove;
};

local PlayerTradeData: {[Player]: TradeData} = {};

local function GetStatusFromData(Data: TradeData)
	if Data.Trade then 
		return "Trading";
	elseif not Data.TradeEnabled or not Data.CanTrade then
		return "TradeDisabled";
	else 
		return "CanTrade";
	end
end

local function UpdateStatus(TradeDatas: {Player})
	local SentData = {};
	if TradeDatas then
		for _, Player in pairs(TradeDatas) do
			local Data = PlayerTradeData[Player];
			SentData[Player.UserId] = {
				Status = GetStatusFromData(Data);
			};
		end
	end
	
	if HelperFunctions.Len(SentData) ~= 0 then
		TradeSync:FireAllClients(SentData);
	end
end


TradeRequest.OnServerEvent:Connect(function(Player: Player, OtherPlayer: Player)
	if not OtherPlayer then
		return;
	end
	
	local Data = PlayerTradeData[OtherPlayer];
	
	if Data.Trade or not Data.CanTrade or not Data.TradeEnabled then
		return;
	end
	
	if Data.LastTradedPlayers[Player] then
		return;
	end
	
	local Time = workspace:GetServerTimeNow();
	
	TradeRequest:FireClient(OtherPlayer, Player, Time);
	Data.LastTradedPlayers[Player] = Time;
	
	local thread: thread = nil;
	
	thread = task.delay(Time + TradeRequestTime, function()
		Data.LastTradedPlayers[Player] = nil;
		
		local Index = table.find(Data.RequestThreads, thread);
		if Index then
			table.remove(Data.RequestThreads, Index);
		end
	end)
	
	table.insert(Data.RequestThreads, thread);
	
	Data.Trove:Add(thread);
end)

TradeAccept.OnServerEvent:Connect(function(Player: Player, OtherPlayer: Player)
	if not OtherPlayer:IsA("Player") then
		return;
	end
	
	local Data = PlayerTradeData[OtherPlayer];
	
	if Data.Trade or not Data.CanTrade or not Data.TradeEnabled then
		return;
	end
	
	if not Data.LastTradedPlayers[OtherPlayer] then
		return;
	end
	
	table.clear(Data.LastTradedPlayers);
	for _, thread in ipairs(Data.RequestThreads) do
		if coroutine.status(thread) ~= "running" and coroutine.status(thread) ~= "dead" then
			task.cancel(thread);
		end
	end
	
	table.clear(Data.RequestThreads);
	
	local Trade = Trade.new(Player, OtherPlayer);
	
	if Trade then
		print("Trade Started");
		Data.Trade = Trade;

		local SentData = {
			Player1 = Trade.Player1;
			Player2 = Trade.Player2;
		};

		TradeStart:FireClient(Trade.Player1, SentData);
		TradeStart:FireClient(Trade.Player2, SentData);
		
		Trade.Destroying:Once(function()
			TradeEnd:FireClient(Trade.Player1);
			TradeEnd:FireClient(Trade.Player2);
			print("Trade Completed")
			Data.Trade = nil;
			
			UpdateStatus({Trade.Player1, Trade.Player2});
		end)
		
		UpdateStatus({Trade.Player1, Trade.Player2});
		
		Trade.UnitAdded:Connect(function(Unit: string, Player: Player)
			local PlayerData = PlayerData.GetPlayerData(Player);
			
			if PlayerData then
				local UnitData = PlayerData:GetUnitFromId(Unit);
				
				if UnitData then
					UnitChanged:FireClient(Trade.Player1, Player, UnitData, "Added");
					UnitChanged:FireClient(Trade.Player2, Player, UnitData, "Added");
				end
			end
		end)
		
		Trade.UnitRemoving:Connect(function(Unit: string, Player: Player)
			UnitChanged:FireClient(Trade.Player1, Player, Unit, "Removing");
			UnitChanged:FireClient(Trade.Player2, Player, Unit, "Removing");
		end)
	end
end)

ChangeUnit.OnServerEvent:Connect(function(Player: Player, Id: string, Type: string)
	if not Player:IsA("Instance") or typeof(Id) ~= "string" or typeof(Type) ~= "string" then
		return;
	end
	
	local Data = PlayerTradeData[Player];
	
	if Data and Data.Trade then
		if Type == "Add" then
			Data.Trade:AddUnit(Player, Id);
		elseif Type == "Remove" then
			Data.Trade:RemoveUnit(Player, Id);
		end
	end
end)

ChangeProduct.OnServerEvent:Connect(function(Player: Player)
	
end)	

local function OnDestroying(Player: Player, TradeData: TradeData)
	for OtherPlayer, OtherData in pairs(PlayerTradeData) do
		if Player ~= OtherPlayer then
			if OtherData.LastTradedPlayers[Player] then
				OtherData.LastTradedPlayers[Player] = nil;
			end
		end
	end
end

local function OnAdded(Data: PlayerData.PlayerData)
	PlayerTradeData[Data.Player] = {
		Trade = nil;
		CanTrade = if Data.CurrentWave then false else true;
		TradeEnabled = Data:GetSetting("CanTrade");
		LastTradedPlayers = {};
		RequestThreads = {};
		Trove = Trove.new();
	};
	
	local TradeData = PlayerTradeData[Data.Player];
	
	local CanTradeSignal = Data:GetSettingChangedSignal("CanTrade");
	
	TradeData.Trove:Connect(CanTradeSignal, function(Value: boolean)
		TradeData.TradeEnabled = Value;
		UpdateStatus({Data.Player});
	end);

	Data.Destroying:Once(function()
		local TradeData = PlayerTradeData[Data.Player];
		
		if TradeData then
			OnDestroying(Data.Player, TradeData);
			TradeData.Trove:Destroy();
			PlayerTradeData[Data.Player] = nil;
		end
	end)
	
	local SentData = {};
	
	for Player, Data in pairs(PlayerTradeData) do
		SentData[Player.UserId] = {
			Status = GetStatusFromData(Data);
		};
	end
	
	TradeSync:FireClient(Data.Player, SentData);
	
	local SentData = {
		[Data.Player.UserId] = {
			Status = GetStatusFromData(TradeData);
		};
	};
	
	TradeSync:FireAllClients(SentData);
end

for _, Data in pairs(PlayerData.GetDatas()) do
	OnAdded(Data);
end

PlayerData.DataAdded:Connect(OnAdded);