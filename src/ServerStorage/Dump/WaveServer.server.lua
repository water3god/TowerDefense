--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");
local Players = game:GetService("Players");

local GlobalModules = ServerScriptService.GlobalModules;
local PlayerData = require(GlobalModules.PlayerData);
local GlobalWave = require(GlobalModules.GlobalWave);

local UnitData = require(ServerStorage.Data.UnitData);

local Remotes = ReplicatedStorage.Remotes;

-- Waves --

local WavesEvents = Remotes.Waves;
local SpecateRemote = WavesEvents.Spectate;
local WavePassed = WavesEvents.WavePassed;
local TimeChanged = WavesEvents.TimeChanged;
local WaveSync = WavesEvents.WaveSync;
local BaseHealthChanged = WavesEvents.BaseHealthChanged;
local WaveEnded = WavesEvents.WaveEnded;
local WaveSyncEvent = WavesEvents.WaveSyncEvent;

local CurrencyEvents = Remotes.Currencies;
local CoinChanged = CurrencyEvents.CoinChanged;
local CoinSync = CurrencyEvents.CoinSync;
local YenChanged = CurrencyEvents.YenChanged;

local UnitInfoGet = Remotes.Unit.UnitInfoGet;

GlobalWave.WaveAdded:Connect(function(Wave: GlobalWave.GlobalWave)
	Wave.WavePassed:Connect(function(WaveNumber: number)
		local WaveData = {
			CurrentWave = WaveNumber;
		};
		
		for _, Player in ipairs(Wave.SpectatingPlayers) do
			WavePassed:FireClient(Player, WaveData);
		end
	end)
	
	Wave.HealthChanged:Connect(function(Health: number)
		local Data = {
			BaseHealth = Health;
			MaxHealth = Wave.MaxHealth;
		};
		
		for _, Player in ipairs(Wave.SpectatingPlayers) do
			BaseHealthChanged:FireClient(Player, Data);
		end
	end)
	
	Wave.MaxHealthChanged:Connect(function(MaxHealth: number)
		local Data = {
			BaseHealth = Wave.BaseHealth;
			MaxHealth = MaxHealth;
		};
		
		for _, Player in ipairs(Wave.SpectatingPlayers) do
			BaseHealthChanged:FireClient(Player, Data);
		end
	end)
	
	Wave.TimeChanged:Connect(function(Time: number)
		local Data = {
			Time = Time;
			SentTime = workspace:GetServerTimeNow();
		};
		
		for _, Player in ipairs(Wave.SpectatingPlayers) do
			TimeChanged:FireClient(Player, Data);
		end
	end)
	
	Wave.Ended:Connect(function(Win: boolean)
		local Data = {
			Win = Win;
		};

		for _, Player in ipairs(Wave.SpectatingPlayers) do
			WaveEnded:FireClient(Player, Data);
		end
	end)
	
	local Data = {
		Time = Wave.Time;
		CurrentWave = Wave.CurrentWave;
		BaseHealth = Wave.BaseHealth;
		MaxHealth = Wave.MaxHealth;
		PlayerIds = Wave.PlayerIds;
		InIntermission = Wave.InIntermission;
		TimeSent = workspace:GetServerTimeNow();
	};
	
	for _, Player in ipairs(Wave.SpectatingPlayers) do
		WaveSyncEvent:FireClient(Player, Data);
	end
	
	for _, Id in ipairs(Wave.PlayerIds) do
		task.spawn(function()
			local Player = Players:GetPlayerByUserId(Id);

			if not Player then
				return;
			end

			local PlayerData = PlayerData.GetPlayerData(Player);

			if not PlayerData then
				return;
			end

			local Data = {};
			local ProfileData = PlayerData.Profile.Data;

			local EquippedUnits = ProfileData.EquippedUnits;

			for Index, UnitId in pairs(EquippedUnits) do
				local ProfileUnit = ProfileData.Units[UnitId];

				if ProfileUnit then
					local UnitName = ProfileUnit.Unit;
					local UnitData = UnitData.UnitData[UnitName];

					Data[UnitName] = {UpgradeData = UnitData.UpgradeData, CollisionRadius = UnitData.CollisionRadius};
				end
			end

			UnitInfoGet:FireClient(Player, Data);
		end)
	end
	
	for Id, Data in pairs(Wave.Infos) do
		local Player = Players:GetPlayerByUserId(Id);
		
		if not Player then
			continue;
		end
		
		local YenSignal = Wave:GetYenChangedSignal(Id);
		
		if Player then
			YenChanged:FireClient(Player, Data.Yen);
		end
		
		YenSignal:Connect(function(Yen: number)
			if Player:IsDescendantOf(Players) then
				YenChanged:FireClient(Player, Data.Yen);
			end
		end)
	end
end)

local function OnDataAdded(Data: PlayerData.PlayerData)
	local Player = Data.Player;
	local GivenData = Data.Profile.Data;
	CoinSync:FireClient(Player, Data.Profile.Data.Coins);

	Data.CoinsChanged:Connect(function(Coins: number)
		CoinChanged:FireClient(Player, Coins);
	end)
	
	local function SyncWave(Wave: GlobalWave.GlobalWave)
		local Data = {
			UniqueId = Wave.UniqueId;
			Time = Wave.Time;
			CurrentWave = Wave.CurrentWave;
			BaseHealth = Wave.BaseHealth;
			MaxHealth = Wave.MaxHealth;
			PlayerIds = Wave.PlayerIds;
			InIntermission = Wave.InIntermission;
			TimeSent = workspace:GetServerTimeNow();
		};
		
		WaveSyncEvent:FireClient(Player, Data);
	end
	
	for _, Wave in pairs(GlobalWave.GetWaves()) do
		SyncWave(Wave);
	end
end

for Id, Data in pairs(PlayerData.GetDatas()) do
	OnDataAdded(Data);
end

PlayerData.DataAdded:Connect(OnDataAdded);
