--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");

local Modules = ReplicatedStorage.Modules;
local Signal = require(Modules.Signal);

local Remotes = ReplicatedStorage.Remotes;
local WaveEvents = Remotes.Waves;

local SpectateRemote = WaveEvents.Spectate;
local WaveSync = WaveEvents.WaveSync;
local BaseHealthChanged = WaveEvents.BaseHealthChanged;
local WavePassed = WaveEvents.WavePassed;
local TimeChanged = WaveEvents.TimeChanged;
local WaveEnded = WaveEvents.WaveEnded;
local WaveSyncEvent = WaveEvents.WaveSyncEvent;
local LeaveButton = WaveEvents.LeaveButton;

local Player = Players.LocalPlayer;

local WaveService = {};


-- Types --

--[[type WavePassed = {
	Time: number;
	CurrentWave: number;
	TimeSent: number;
};

type BaseHealthChanged = {
	BaseHealth: number;
	MaxHealth: number;
};

export type GetWaveSync = {
	CurrentWave: number;
	BaseHealth: number;
	MaxHealth: number;
	PlayerIds: {number};
	TimeSent: number;
	Time: number;
	InIntermission: boolean;
};

type WaveEnded = {
	UniqueId: string;
	Win: boolean;
};

-- Service --

local WaveService = {};

local WaveData: GetWaveSync? = nil;

WaveService.IsConnected = false;

WaveService.ConnectionChanged = GoodSignal.new();

WaveService.Added = GoodSignal.new();
WaveService.HealthChanged = GoodSignal.new();
WaveService.WaveChanged = GoodSignal.new();
WaveService.TimeChanged = GoodSignal.new();
WaveService.Ended = GoodSignal.new();

WaveService.InMap = false;
WaveService.InMapChanged = GoodSignal.new();

WaveService.GlobalWaveChanged = GoodSignal.new();

local CurrentThread = nil;

-- Connections --

WavePassed.OnClientEvent:Connect(function(Data: WavePassed)
	WaveData.CurrentWave = Data.CurrentWave;
	WaveData.Time = Data.Time
	if not WaveData[Data.UniqueId] then
		return;
	end
	
	local ClientData = WaveData[Data.UniqueId];
	
	ClientData.CurrentWave = Data.CurrentWave;
	
	if Data.UniqueId == WaveService.CurrentWave then
		WaveService.WaveChanged:Fire(Data.CurrentWave);
	end
end)


BaseHealthChanged.OnClientEvent:Connect(function(Data: BaseHealthChanged)
	if not WaveData[Data.UniqueId] then
		return;
	end
	
	WaveData[Data.UniqueId].BaseHealth = Data.BaseHealth;
	WaveData[Data.UniqueId].MaxHealth = Data.MaxHealth;
	if Data.UniqueId == WaveService.CurrentWave then
		WaveService.HealthChanged:Fire(Data.BaseHealth, Data.MaxHealth);
	end
end)

TimeChanged.OnClientEvent:Connect(function(Data: {UniqueId: string, Time: number, SentTime: number})
	if not WaveData[Data.UniqueId] then
		return;
	end
	
	local WaveData = WaveData[Data.UniqueId];
	WaveData.Time = Data.Time--[[ - (workspace:GetServerTimeNow() - Data.SentTime);
	WaveData.TimeSent = Data.SentTime;
	if Data.UniqueId == WaveService.CurrentWave then
		WaveService.TimeChanged:Fire(Data.Time, Data.SentTime);
	end
end)

WaveEnded.OnClientEvent:Connect(function(Data: WaveEnded)
	if WaveData[Data.UniqueId] then
		WaveData[Data.UniqueId] = nil;
		if WaveService.CurrentWave == Data.UniqueId then
			WaveService.Ended:Fire(Data.Win);
			WaveService.CurrentWave = nil;
			WaveService.IsConnected = false;
			
			WaveService.HealthChanged:DisconnectAll();
			WaveService.Ended:DisconnectAll();
			WaveService.WaveChanged:DisconnectAll();
			
			WaveService.ConnectionChanged:Fire(false);
		end
	end
end)

WaveSyncEvent.OnClientEvent:Connect(function(Data: GetWaveSync)
	WaveData[Data.UniqueId] = Data;
	
	if table.find(Data.PlayerIds, Player.UserId) then
		WaveService.CurrentWave = Data.UniqueId;
		WaveService.IsConnected = true;
		WaveService.ConnectionChanged:Fire(true);
		WaveService.InMap = true;
		WaveService.InMapChanged:Fire(true);
	end
	
	WaveService.Added:Fire(Data);
end)

function WaveService.GetHealth(Id: string?): number?	
	if Id then
		return WaveData[Id].BaseHealth;
	elseif WaveService.CurrentWave then
		return WaveData[WaveService.CurrentWave].BaseHealth;
	end
	
	return;
end

function WaveService.GetData(Id: string?): GetWaveSync?
	return WaveData;
end

function WaveService.LeaveButton()
	if WaveService.InMap then
		WaveService.InMap = false;
		WaveService.InMapChanged:Fire(false);
	end
	LeaveButton:FireServer();
end]]



return WaveService;
