--!strict

-- By Wa1er_God --

local DifficultyModifiers = {
	Easy = 0.8;
	Normal = 1;
	Hard = 1.2;
};

local BaseHealthRatios = {
	Easy = 1.2;
	Normal = 1;
	Hard = 0.8;
}

local Time = 5;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");
local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");

local Remotes = ReplicatedStorage.Remotes;
local StartPointEvents = Remotes.StartPoint;
local ChooseGameEvent = StartPointEvents.ChooseGameEvent;
local ChooseGame = StartPointEvents.ChooseGame;
local ClosePoint = StartPointEvents.ClosePoint;
local OnClose = StartPointEvents.OnClose;
local PlayerCountChange = StartPointEvents.PlayerCountChange;
local OwnerStartEvent = StartPointEvents.OwnerStartEvent;
local VoteEvent = StartPointEvents.VoteEvent;
local VoteSendEvent = StartPointEvents.VoteSendEvent;

local LeaveButton = Remotes.Waves.LeaveButton;

local Modules = ReplicatedStorage.Modules;
local GenerateId = require(Modules.GenerateId);
local ObserveTag = require(Modules.ObserveTag);
local GoodSignal = require(Modules.GoodSignal);

local Shared = ReplicatedStorage.Shared;
local GameInfo = require(Shared.GameInfo);

local GlobalModules = ServerScriptService.GlobalModules;
local GlobalWave = require(GlobalModules.GlobalWave);
local PlayerData = require(GlobalModules.PlayerData);

local SafePlayer = ServerScriptService.Utility.SafePlayer;
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded);
local SafePlayerRemoving = require(SafePlayer.SafePlayerRemoving)

local ServerData = ServerStorage.Data;
local WaveData = require(ServerData.WaveData);

local VotedSignal = GoodSignal.new();

local Maps = {};
for _, Map in ipairs(ServerStorage.Maps:GetChildren()) do
	Maps[Map.Name] = Map :: Model;
end

local UsedOrigins = {};
local MapOrigins = workspace.Maps:GetChildren();

type StartPointData = {
	UniqueId: string;
	Instance: Instance;
	Owner: Player,
	Players: {Player},
	MapName: string?,
	Stage: number?,
	Difficulty: string?;
	Time: number;
	MaxPlayers: number;
	HasChosen: boolean;
	Threads: {thread};
};

local StartPointData: {[Instance]: StartPointData} = {};
local GameDestroyingData: {[string]: {Map: Model, Players: {number}, Id: string}} = {};
local DelayedPlayers: {Player} = {};
local DelayedThreads: {[Player]: thread} = {};

local function ClearThreads(Data: {thread})
	for _, thread in ipairs(Data) do
		if coroutine.status(thread) ~= "running" then
			task.cancel(thread);
		end
	end
	table.clear(Data);
end

local function TpModelTo(Model: Model, NewCFrame: CFrame)
	local Pos, Size = Model:GetBoundingBox();
	local Root = Model.PrimaryPart :: BasePart;

	local HeightDifference = (Root.Position - Pos.Position).Y;

	local AlteredCFrame = CFrame.new(NewCFrame.Position) + Vector3.new(
		0,
		Size.Y/2 + HeightDifference,
		0
	);

	Root.CFrame = AlteredCFrame;
end

local function DelayPlayer(Player: Player)
	local thread = DelayedThreads[Player];

	if thread then
		if coroutine.status(thread) ~= "running" then
			task.cancel(thread);
			DelayedThreads[Player] = nil;
		end
	end
	
	table.insert(DelayedPlayers, Player);

	DelayedThreads[Player] = task.delay(1, function()
		local Index = table.find(DelayedPlayers, Player);

		if Index then
			table.remove(DelayedPlayers, Index);
		end
	end)
end

local function HandleDestroy(Data: StartPointData, StartingGame: boolean?)
	ClearThreads(Data.Threads)
	for _, Player in ipairs(Data.Players) do
		OnClose:FireClient(Player, Data.UniqueId);

		if not StartingGame then
			if Player.Character then
				TpModelTo(Player.Character, (Data :: any).Instance.Parent.ReturnPart.CFrame);
			end
		end
		
		DelayPlayer(Player);
	end
	
	StartPointData[Data.Instance] = nil;
end

local function PlayerOwns(Player: Player): StartPointData?
	for _, Data in pairs(StartPointData) do
		if Data.Owner == Player then
			return Data;
		end
	end
	
	return;
end

local function PlayerInPoint(Player: Player): StartPointData?
	for _, Data in pairs(StartPointData) do
		if table.find(Data.Players, Player) then
			return Data;
		end
	end
	
	return;
end

local function HandlePlayerChange(Data: StartPointData, Player: Player)
	local Send = {
		UniqueId = Data.UniqueId;
		Count = #Data.Players;
	};
	if Data.Owner == Player then
		HandleDestroy(Data);
		return;
	end
	for _, Player in ipairs(Data.Players) do
		PlayerCountChange:FireClient(Player, Send);
	end
end

local function RemovePlayer(Data: StartPointData, Player: Player)
	local Index = table.find(Data.Players, Player);

	if Index then
		table.remove(Data.Players, Index);
		HandlePlayerChange(Data, Player);
		
		if Player.Character then
			TpModelTo(Player.Character, (Data :: any).Instance.ReturnPart.CFrame);
		end
	end
end

local function Sync(Data: StartPointData, Player: Player)
	local DataToSend = {
		UniqueId = Data.UniqueId;
		OwnerId = Data.Owner.UserId;
		PlayerCount = #Data.Players;
		Time = Data.Time,
		SendTime = workspace:GetServerTimeNow();
	};
	ChooseGameEvent:FireClient(Player, DataToSend);
end

local function GetRandomMapOrigin()
	local Map = MapOrigins[math.random(1, #MapOrigins)];
	
	if not table.find(UsedOrigins, Map) then
		table.insert(UsedOrigins, Map);
		return Map :: BasePart;
	else
		return GetRandomMapOrigin();
	end
end

local function OnGameStart(Data: StartPointData)
	if not Data.MapName or not Data.Stage then
		return;
	end
	
	local MapInfo = GameInfo.GetMapWithName(Data.MapName);
	if not MapInfo then
		warn("NO MAP INFO");
		return;
	end
	local StageInfo = MapInfo.StageInfos[Data.Stage];
	if not StageInfo then
		warn("NO STAGE INFO")
		return;
	end
	local Map = Maps[MapInfo.MapId];
	if not Map then
		return;
	end
	Map = Map:Clone();
	local MapOrigin = GetRandomMapOrigin();
	Map:PivotTo(MapOrigin.CFrame);
	
	Map.Parent = MapOrigin;
	
	local SpawnLocation = (Map :: any).SpawnLocation :: SpawnLocation;
	
	local PlayerIds = {};
	for _, Player in ipairs(Data.Players) do
		table.insert(PlayerIds, Player.UserId);
		
		Player:RequestStreamAroundAsync(MapOrigin.CFrame.Position);
	end
	
	task.delay(3, function()
		for _, Player in ipairs(Data.Players) do
			Player.RespawnLocation = SpawnLocation;
			if Player.Character then
				Player.Character:PivotTo(SpawnLocation.CFrame);
			end
		end
	end)
	
	
	local Infos = {};
	
	for _, Player in ipairs(Data.Players) do
		Infos[Player.UserId] = {Cash = 100};
	end
	
	local function StartWave()
		task.wait(1);
		local InputData = WaveData[StageInfo.GameId];
		
		local Positions = {};
		for _, Node in ipairs(Map:FindFirstChild("Nodes"):GetChildren()) do
			if Node:IsA("BasePart") then
				table.insert(Positions, Node.CFrame.Position);
			end
		end
		
		local Input: GlobalWave.GlobalWaveInput = {
			Data = InputData;
			PlayerIds = PlayerIds;
			Positions = Positions;
			Infos = Infos;
			HealthMultiplier = DifficultyModifiers[Data.Difficulty] * InputData.HealthMultiplier;
			SpeedMultiplier = InputData.SpeedMultiplier;
			HealthRatio = InputData.HealthRatio;
			SpeedRatio = InputData.SpeedRatio;
			BaseHealthRatio = BaseHealthRatios[Data.Difficulty];
			RootOrigin = MapOrigin;
		};
		local Wave = GlobalWave.new(Input);

		Wave.Ended:Connect(function()
			for _, Id in ipairs(Wave.PlayerIds) do
				local Player = Players:GetPlayerByUserId(Id);

				if Player then
					local PlayerData = PlayerData.GetPlayerData(Player);

					if PlayerData then
						PlayerData.CurrentWave = nil;
					end
				end
			end
			
			local FoundUser = false;
			
			for _, Id in ipairs(Wave.PlayerIds) do
				if Players:GetPlayerByUserId(Id) then
					FoundUser = true;
					break;
				end
			end
			
			if FoundUser then
				GameDestroyingData[Wave.UniqueId] = {Map = Map, Players = table.clone(Wave.PlayerIds), Id = Wave.UniqueId};
			end
		end)
		
		for _, Player in ipairs(Data.Players) do
			local PlayerData = PlayerData.GetPlayerData(Player);

			if PlayerData then
				PlayerData.CurrentWave = Wave.UniqueId;
			end
		end
		
		return Wave;
	end
	
	local VotedPlayers: {Player} = {};
	local NeededNum: number = math.ceil(#Data.Players / 2);
	local id = GenerateId.GenerateId();
	local Connection: GoodSignal.Connection? = nil;
	
	local Wave = StartWave();
	
	local function OnEnd()
		if Connection then
			Connection:Disconnect();
			Connection = nil;
			SafePlayerRemoving:Disconnect(id);
			for _, Player in ipairs(Data.Players) do
				VoteSendEvent:FireClient(Player, {}, "End");
			end

			Wave:Start();
		end
		
	end

	local function OnVoteChange()
		if #VotedPlayers >= NeededNum then
			OnEnd();
		end
		for _, Player in ipairs(Data.Players) do
			VoteSendEvent:FireClient(Player, {Votes = #VotedPlayers, VotesNeeded = NeededNum}, "Votes")
		end
	end

	Connection = VotedSignal:Connect(function(Player: Player)
		if table.find(Data.Players, Player) then
			if not table.find(VotedPlayers, Player) then
				table.insert(VotedPlayers, Player);
			end
		end
		OnVoteChange();
	end)

	SafePlayerRemoving:Connect(function(Player: Player)
		if table.find(Data.Players, Player) then
			local IndexA = table.find(VotedPlayers, Player);
			local IndexB = table.find(Data.Players, Player);
			if IndexA then
				table.remove(VotedPlayers, IndexA);
			end
			if IndexB then
				table.remove(Data.Players, IndexB)
			end
			
			local NeededNum: number = math.ceil(#Data.Players / 2);
			OnVoteChange();
		end
	end, false, id);
	
	local TimeDelay = 30;
	
	task.delay(3, function()
		for _, Player in ipairs(Data.Players) do
			VoteSendEvent:FireClient(Player, {
				Time = TimeDelay, SentTime = workspace:GetServerTimeNow(), Votes = #VotedPlayers, VotesNeeded = NeededNum
			}, "Start")
		end

		task.delay(TimeDelay, function()
			OnEnd();
		end)
	end)
end

ChooseGameEvent.OnServerEvent:Connect(function(Player: Player, MapName: string, WaveIndex: number, Difficulty: string)
	if typeof(MapName) ~= 'string' or typeof(WaveIndex) ~= "number" or not DifficultyModifiers[Difficulty] then
		return;
	end
	local PlayerPointData = PlayerOwns(Player);
	if not PlayerPointData then
		return;
	end
	local MapData: GameInfo.MapInfo? = GameInfo.GetMapWithName(MapName);
	if not MapData then
		return;
	end
	local StageData: GameInfo.StageInfo? = MapData.StageInfos[WaveIndex];
	if not StageData then
		return;
	end
	local PlayerData = PlayerData.GetPlayerDataAsync(Player);
	if not PlayerData then
		return;
	end

	local Prerequisite = StageData.Prerequisite;

	if Prerequisite then
		if not PlayerData:OwnsStage(Prerequisite.Map, Prerequisite.Index) then
			return;
		end
	end

	ClearThreads(PlayerPointData.Threads);

	PlayerPointData.Time = Time;
	
	PlayerPointData.MapName = MapName;
	PlayerPointData.Stage = WaveIndex;
	PlayerPointData.Difficulty = Difficulty;

	table.insert(PlayerPointData.Threads, task.delay(Time, function()
		if StartPointData[PlayerPointData.Instance] then
			if #PlayerPointData.Players ~= 0 then
				OnGameStart(PlayerPointData);
			end
			HandleDestroy(PlayerPointData, true);
		end
	end))
	
	Sync(PlayerPointData, Player);
end)

ObserveTag.ObserveTag("StartPoint", function(Observed: Instance)
	local TeleportPart: Part = (Observed :: any).TeleportPart;
	local TouchPart: Part = (Observed :: any).TouchPart;
	
	local Connection = TouchPart.Touched:Connect(function(OtherPart: BasePart)
		local Character = OtherPart.Parent;
		if not Character then
			return;
		end
		
		local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
		if not Humanoid then
			return
		end
		local Player = Players:GetPlayerFromCharacter(Character)
		if not Player then
			return;
		end
		
		if table.find(DelayedPlayers, Player) then
			return;
		end
		
		local PlayerData = PlayerData.GetPlayerData(Player);
		
		if PlayerData then
			if PlayerData.CurrentWave then
				return;
			end
		end
		
		if PlayerInPoint(Player) then
			return;
		end
		
		if StartPointData[TouchPart] then
			if not StartPointData[TouchPart].HasChosen then
				return;
			end
			
			local Index = table.find(StartPointData[TouchPart].Players, Player);

			if not Index then
				table.insert(StartPointData[TouchPart].Players, Player);
			end
			
			HandlePlayerChange(StartPointData[TouchPart], Player);
			Sync(StartPointData[TouchPart], Player);
		else
			local Id = GenerateId.GenerateId();

			StartPointData[TouchPart] = {
				UniqueId = Id;
				Instance = TouchPart;
				Owner = Player;
				Players = {Player};
				Time = Time;
				HasChosen = false;
				MaxPlayers = 4;
				Threads = {};
			};
			
			OwnerStartEvent:FireClient(Player, {
				Time = Time;
				SendTime = workspace:GetServerTimeNow();
			});
			--Sync(StartPointData[TouchPart], Player);

			table.insert(StartPointData[TouchPart].Threads, task.delay(Time, function()
				if StartPointData[TouchPart] then
					HandleDestroy(StartPointData[TouchPart]);
				end
			end))
		end
		
		TpModelTo(Character :: Model, TeleportPart.CFrame);
	end)
	
	return function()
		Connection:Disconnect();
	end
end)

ClosePoint.OnServerEvent:Connect(function(Player: Player, UniqueId: string)
	local Data = PlayerOwns(Player);
	
	if Data then
		if Data.UniqueId == UniqueId then
			return;
		end
		HandleDestroy(Data);
	else
		local Data = PlayerInPoint(Player);
		
		if Data then
			RemovePlayer(Data, Player);
		end
	end
end)

VoteEvent.OnServerEvent:Connect(function(Player: Player)
	VotedSignal:Fire(Player);
end)

local function SyncLeave(WaveDestroying: any)
	if #WaveDestroying.Players == 0 then
		local Origin = script.Parent;
		if Origin then
			local Index = table.find(UsedOrigins, Origin);
			
			if Index then
				table.remove(UsedOrigins, Index);
			end
		end
		WaveDestroying.Map:Destroy();
		
		if GameDestroyingData[WaveDestroying.UniqueId] then
			GameDestroyingData[WaveDestroying.UniqueId] = nil;
		end
	end
end

LeaveButton.OnServerEvent:Connect(function(Player: Player)
	local WaveDestroying = nil;
	
	for Id, Data in pairs(GameDestroyingData) do
		local Index = table.find(Data.Players, Player.UserId);
		
		if Index then
			table.remove(Data.Players, Index);
			if Player.Character then
				Player.Character:PivotTo(workspace.SpawnLocation.CFrame + Vector3.new(0, 3.5, 0));
			end
			
			SyncLeave(Data);
		end
	end
end)

SafePlayerRemoving:Connect(function(Player: Player)
	for Instance, Data in pairs(StartPointData) do
		local Index = table.find(Data.Players, Player);
		if Index then
			table.remove(Data.Players, Index);
		end
	end
	
	for Id, Data in pairs(GameDestroyingData) do
		local Index = table.find(Data.Players, Player.UserId);

		if Index then
			table.remove(Data.Players, Index);

			SyncLeave(Data);
		end
	end
end);