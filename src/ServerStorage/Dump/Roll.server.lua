--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");

local Modules = ReplicatedStorage.Modules;
local RandomGenerate = require(Modules.RandomGenerate);

local Shared = ReplicatedStorage.Shared;
local UnitInfo = require(Shared.UnitInfo);

local Remotes = ReplicatedStorage.Remotes;
local Roll = Remotes.Roll;

local AutoRoll = Roll.AutoRoll;
local DoRoll = Roll.DoRoll;
local ConfirmRoll = Roll.ConfirmRoll;
local RollEvent = Roll.RollEvent;

local GlobalModules = ServerScriptService.GlobalModules;
local PlayerData = require(GlobalModules.PlayerData);

local SafePlayer = ServerScriptService.Utility.SafePlayer;
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded);
local SafePlayerRemoving = require(SafePlayer.SafePlayerRemoving);
local GoodSignal = require(ServerScriptService.Utility.GoodSignal);

local ChanceData = require(ServerStorage.Data.ChanceData);

local UnitData = require(ServerStorage.Data.UnitData);

local InRollPlayers: {Player} = {};
local RollData: {[Player]: {
	CurrentRoll: string?;
	InRoll: boolean;
	AutoRollConnection: RBXScriptConnection?;
	Signal: GoodSignal.GoodSignal;
	Connection: GoodSignal.Connection?;
}} = {};

local ChangedEvent = GoodSignal.new();

local function Roll(Player: Player): {string}?
	local Data = RollData[Player];
	local PlayerData = PlayerData.GetPlayerDataAsync(Player);
	
	if PlayerData then
		local Values: {string} = {};

		for i = 1, 5, 1 do
			table.insert(Values, RandomGenerate(ChanceData) :: string);
		end

		local Value = RandomGenerate(ChanceData) :: string;
		Data.CurrentRoll = Value;

		table.insert(Values, Value);
		if not table.find(InRollPlayers, Player) then
			table.insert(InRollPlayers, Player);
		end

		local Duration = 0;

		for i = 1, #Values, 1 do
			Duration += (i / #Values) / (2.5^ (i / 50 + 1)) + 0.08;
		end
		
		task.delay(Duration, function()
			if PlayerData.AddRoll then
				PlayerData:AddRoll(1);
			end
		end)

		task.delay(Duration + 0.5, function()
			local Index = table.find(InRollPlayers, Player);

			if Index then
				table.remove(InRollPlayers, Index);
			end
		end)
		
		return Values;
	end
	
	return;
end

local function AutoRollConnection(PlayerData: PlayerData.PlayerData)
	local Signal = PlayerData:GetSettingChangedSignal("AutoRoll");
	local Player = PlayerData.Player;
	local Data = RollData[Player];
	
	local function HandleSignal(Value: any)
		if Value then
			local Step = 2;
			
			Data.Connection = Data.Signal:Connect(function()
				Step = 2.5;
			end)
			
			RollData[Player].AutoRollConnection = RunService.PostSimulation:Connect(function(Delta)
				Step += Delta;
				if Step >= 2.7736 then
					Step = 0;
					local PlayerData = PlayerData.GetPlayerData(Player);
					if not table.find(InRollPlayers, Player) and PlayerData then
						local RollData = RollData[Player];
						if RollData.CurrentRoll then
							local Rarity = UnitInfo.UnitInfo[RollData.CurrentRoll].Rarity;
							local IsSkipping = PlayerData:GetSetting(Rarity.."Skip");
							if not IsSkipping then
								return;
							end
						end
						
						local RollData = Roll(Player);
						RollEvent:FireClient(Player, RollData, workspace:GetServerTimeNow());
					end
				end
			end)
		else
			if Data.AutoRollConnection then
				Data.AutoRollConnection:Disconnect();
				Data.AutoRollConnection = nil;
			end
			if Data.Connection then
				Data.Connection:Disconnect();
				Data.Connection = nil;
			end
		end
	end
	HandleSignal(PlayerData:ChangeSetting("AutoRoll"));
	
	if Signal then
		Signal:Connect(HandleSignal);
	end
end

for _, Player in ipairs(Players:GetPlayers()) do
	local PlayerData = PlayerData.GetPlayerData(Player);
	if PlayerData then
		AutoRollConnection(PlayerData);
	end
end
PlayerData.DataAdded:Connect(AutoRollConnection);

DoRoll.OnServerInvoke = function(Player: Player): {string}?
	local Data = RollData[Player];
	if not table.find(InRollPlayers, Player) then
		return Roll(Player);
	end
	
	return;
end

ConfirmRoll.OnServerEvent:Connect(function(Player: Player, Value: string, Accept: boolean)
	local Data = RollData[Player];
	local PlayerData = PlayerData.GetPlayerDataAsync(Player);
	
	if Accept then
		if Data and PlayerData and Data.CurrentRoll and Value and not Data.InRoll then
			if Data.CurrentRoll == Value and UnitInfo.UnitInfo[Value] then
				PlayerData:AddUnit(Data.CurrentRoll);
			end
		end
	end
	
	if Data and not Data.InRoll then
		Data.CurrentRoll = nil;
	end
end)

SafePlayerAdded:Connect(function(Player: Player)
	RollData[Player] = {
		CurrentRoll = nil;
		InRoll = false;
		Signal = GoodSignal.new();
	};
end)

SafePlayerRemoving:Connect(function(Player: Player)
	local Data = RollData[Player];
	if Data then
		if Data.AutoRollConnection then
			Data.AutoRollConnection:Disconnect();
		end
	end
	RollData[Player] = nil;
end)

