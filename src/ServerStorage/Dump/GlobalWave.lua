--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");

local Modules = ReplicatedStorage.Modules;
local GenerateId = require(Modules.GenerateId);
local BezierPath = require(Modules.BezierPath);

local GlobalModules = ServerScriptService.GlobalModules;
local Enemy = require(GlobalModules.Enemy);
local Unit = require(GlobalModules.Unit);
local EnemyData = require(ServerStorage.Data.EnemyData);
local WaveData = require(ServerStorage.Data.WaveData);

local Utility = ServerScriptService.Utility;
local GoodSignal = require(Utility.GoodSignal);
local Trove = require(Utility.Trove);

local SafePlayer = Utility.SafePlayer;
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded);
local SafePlayerRemoving = require(SafePlayer.SafePlayerRemoving);

export type GlobalWaveInput = {
	Data: WaveData.WaveData;
	PlayerIds: {number};
	
	Positions: {Vector3};
	BaseHealthRatio: number?;
	
	SpeedRatio: number?;
	HealthRatio: number?;
	SpeedMultiplier: number?;
	HealthMultiplier: number?;
};

type InfiniteInput = {
	Data: WaveData.InfiniteData;
	PlayerIds: {number};
	
	Positions: {Vector3};
	BaseHealth: number;
	
	SpeedRatio: number?;
	HealthRatio: number?;
	SpeedMultiplier: number?;
	HealthMultiplier: number?;
};

type GlobalWaveData = {
	_Trove: Trove.Trove;
	
	UniqueId: string;
	Bezier: BezierPath.Path;
	BezierId: string;
	
	Positions: {Vector3};
	PlayerIds: {number};
	Infos: {[number]: {Yen: number}};
	
	YenChangedSignals: {[number]: GoodSignal.GoodSignal};
	
	SpectatingPlayers: {Player};
	
	StartTime: number;
	Time: number;
	Data: WaveData.WaveData;
	InIntermission: boolean;
	
	LastWave: number;
	CurrentWave: number;
	BaseHealth: number;
	MaxHealth: number;
	
	HealthRatio: number;
	SpeedRatio: number;
	SpeedMultiplier: number;
	HealthMultiplier: number;
	
	CurrentEnemies: {Enemy.Enemy};
	CurrentUnits: {Unit.Unit};
	
	EnemyThreads: {thread};
	Connections: {GoodSignal.Connection};
	WaveConnection: RBXScriptConnection;
	
	SpectatorAdded: GoodSignal.GoodSignal;
	
	WavePassed: GoodSignal.GoodSignal;
	MaxHealthChanged: GoodSignal.GoodSignal;
	HealthChanged: GoodSignal.GoodSignal;
	TimeChanged: GoodSignal.GoodSignal;
	Ended: GoodSignal.GoodSignal;
};

type GlobalWaveImpl = {
	new: (Input: GlobalWaveInput) -> GlobalWave;
	infinite: (Input: InfiniteInput) -> GlobalWave;
	AdvanceToNextWave: (self: GlobalWave) -> ();
	
	Start: (self: GlobalWave) -> ();
	
	ChangeHealth: (self: GlobalWave, Health: number) -> ();
	AddHealth: (self: GlobalWave, Health: number) -> ();
	SubtractHealth: (self: GlobalWave, Health: number) -> ();
	ChangeMaxHealth: (self: GlobalWave, Health: number) -> ();
	
	_ChangeTime: (self: GlobalWave, Time: number) -> ();
	
	SetYen: (self: GlobalWave, Id: number, Yen: number) -> ();
	AddYen: (self: GlobalWave, Id: number,  Yen: number) -> ();
	SubtractYen: (self: GlobalWave, Id: number,  Yen: number) -> ();
	
	HasEnoughYen: (self: GlobalWave, Id: number, Yen: number) -> boolean;
	
	GetYenChangedSignal: (self: GlobalWave, Id: number) -> GoodSignal.GoodSignal;
	
	End: (self: GlobalWave, Win: boolean) -> ();
	Delete: (self: GlobalWave) -> ();
	
	GetWaveFromPlayerId: (PlayerId: number) -> GlobalWave?;
	GetWaveFromId: (UniqueId: string) -> GlobalWave?;
	GetWaves: () -> {[string]: GlobalWave};
	
	WaveAdded: GoodSignal.GoodSignal;

	__eq: (a: GlobalWave, b: GlobalWave) -> boolean;
	__index: GlobalWaveImpl;
};

export type GlobalWave = typeof(setmetatable({} :: GlobalWaveData, {} :: GlobalWaveImpl));

local function TableClone<T>(Data: T & {[any]: any}): T
	local Cloned = {};
	for i, v in pairs(Data) do
		Cloned[i] = type(v) == "table" and TableClone(v) or v;
	end;
	return Cloned :: any;
end

local function ClearConnections(List: {GoodSignal.Connection})
	for _, Connection in ipairs(List) do
		if Connection.Disconnect then
			Connection:Disconnect();
		end
	end
	table.clear(List);
end

local function Round(Number: number, Place: number)
	return math.round(Number * math.pow(10, Place)) / math.pow(10, Place);
end

local GlobalWave: GlobalWaveImpl = {} :: GlobalWaveImpl;
GlobalWave.__index = GlobalWave;

local GlobalWaves: {[string]: GlobalWave} = {};

function GlobalWave.__eq(a, b)
	return rawequal(a.UniqueId, b.UniqueId);
end

function GlobalWave.new(Input: GlobalWaveInput, Infinite: boolean?)
	local self = setmetatable({}, GlobalWave) :: GlobalWave;
	
	self._Trove = Trove.new();
	
	self.WavePassed = self._Trove:Add(GoodSignal.new(), "DisconnectAll");
	self.HealthChanged = self._Trove:Add(GoodSignal.new(), "DisconnectAll");
	self.Ended = self._Trove:Add(GoodSignal.new(), "DisconnectAll");
	self.MaxHealthChanged = self._Trove:Add(GoodSignal.new(), "DisconnectAll");
	self.TimeChanged = self._Trove:Add(GoodSignal.new(), "DisconnectAll");
	
	self.SpectatorAdded = self._Trove:Add(GoodSignal.new(), "DisconnectAll");
	
	self.Positions = Input.Positions;
	self.PlayerIds = Input.PlayerIds;
	self.Infos = {};
	self.UniqueId = GenerateId.GenerateId();
	self.Data = Input.Data;
	self.LastWave = #self.Data.Data;
	
	for _, Id in pairs(self.PlayerIds) do
		self.Infos[Id] = {Yen = Input.Data.StartYen};
	end
	
	self.Positions = Input.Positions;
	
	self.Bezier = BezierPath.new(self.Positions, 5);
	self.BezierId = GenerateId.GenerateId();
	Enemy.AddBezier(self.BezierId, self.Bezier);
	
	self.CurrentEnemies = {};
	self.CurrentUnits = {};
	
	self.CurrentWave = 0;
	self.EnemyThreads = {};
	self.Connections = {};
	self.YenChangedSignals = {};
	
	for _, PlayerId in ipairs(self.PlayerIds) do
		local Player = Players:GetPlayerByUserId(PlayerId);
		
		if not Player then
			local Index = table.find(self.PlayerIds, PlayerId);
			
			if Index then
				table.remove(self.PlayerIds, Index);
			end
		end
	end
	
	self.HealthRatio = Input.HealthRatio or 1;
	self.SpeedRatio = Input.SpeedRatio or 1;
	
	self.HealthMultiplier = Input.HealthMultiplier or 1;
	self.SpeedMultiplier = Input.SpeedMultiplier or 1;
	
	self.MaxHealth = self.Data.BaseHealth * (Input.BaseHealthRatio or 1);
	self.BaseHealth = self.MaxHealth;
	
	self.InIntermission = false;
	
	self:_ChangeTime(0);
	
	GlobalWaves[self.UniqueId] = self;

	self.WaveAdded:Fire(self);
	
	return self;
end

function GlobalWave:Start()
	self:AdvanceToNextWave();
end

function GlobalWave.infinite(Input: InfiniteInput)
	local WaveInput: WaveData.WaveData = {
		Data = {
			[1] = {
				Enemies = {};
				Length = 1;
				WaveBonus = 0;
			};
		};
		EnemyData = {
			
		};
		HealthMultiplier = 1;
		SpeedMultiplier = 1;
		HealthRatio = 1;
		SpeedRatio = 1;
		BaseHealth = Input.BaseHealth;
		StartYen = Input.Data.StartYen;
	};
	
	local function HandleWaveInfinite(WaveNum: number)
		WaveInput.Data[WaveNum] = {
			Enemies = {};
		} :: any;
		local Order: {string} = {};

		for EnemyName, Data in pairs(Input.Data.EnemyData) do
			if Data.FirstSpawnWave > WaveNum then
				continue;
			end
			if Data.WaveDelay then
				if math.fmod(WaveNum + Data.FirstSpawnWave, Data.WaveDelay) ~= 0 then
					continue;
				end
			end
			table.insert(Order, EnemyName);
			WaveInput.EnemyData[EnemyName] = {
				ExtraData = Data.ExtraData;
			};
		end

		table.sort(Order, function(a, b)
			local AData = Input.Data.EnemyData[a];
			local BData = Input.Data.EnemyData[b];

			return AData.OrderPriority < BData.OrderPriority;
		end)

		local CurrentCount = 0;

		for _, EnemyName: string in ipairs(Order) do
			local Data = Input.Data.EnemyData[EnemyName];
			if Data.FirstSpawnWave >= WaveNum then
				WaveInput.Data[WaveNum].Enemies[EnemyName] = {};
				local Insertions = WaveInput.Data[WaveNum].Enemies[EnemyName];
				for i = 1, Data.SpawnCount, 1 do
					table.insert(Insertions, CurrentCount + i);
					CurrentCount += 1;
				end
			end

			CurrentCount += 2;
		end
		
		WaveInput.Data[WaveNum].Length = CurrentCount + 4;
		WaveInput.Data[WaveNum].WaveBonus = Input.Data.BaseYenBonus + (Input.Data.AdditiveYenBonus * (WaveNum - 1));
	end
	
	
	local Wave = GlobalWave.new({
		Data = WaveInput;
		PlayerIds = Input.PlayerIds;
		SpeedRatio = Input.SpeedRatio;
		HealthRatio = Input.HealthRatio;
		SpeedMultiplier = Input.SpeedMultiplier;
		HealthMultiplier = Input.HealthMultiplier;
		Positions = Input.Positions;
	});
	
	Wave.WavePassed:Connect(function(WaveNumber: number)
		HandleWaveInfinite(WaveNumber);
	end)
	
	return Wave;
end

function GlobalWave:AdvanceToNextWave()
	for _, Thread in ipairs(self.EnemyThreads) do
		task.cancel(Thread);
	end
	table.clear(self.EnemyThreads);
	if self.LastWave > self.CurrentWave then
		local DelayTick = tick();
		
		if self.InIntermission then
			return;
		end
		
		if self.CurrentWave ~= 0 then 
			self.InIntermission = true;
			self:_ChangeTime(6);
			task.wait(6);
			self.InIntermission = false;
		end
		
		self.CurrentWave += 1;
		
		local WaveNum = self.CurrentWave;
		local SpeedRatio = math.pow(self.SpeedRatio, WaveNum);
		local HealthRatio = math.pow(self.SpeedRatio, WaveNum);
		
		local CurrentWaveData = self.Data.Data[self.CurrentWave];
		
		for _, Id in ipairs(self.PlayerIds) do
			self:AddYen(Id, CurrentWaveData.WaveBonus);
		end
		
		local LastEnemyTime = 0;
		
		for EnemyName, Times in pairs(CurrentWaveData.Enemies) do
			for _, Time in ipairs(Times) do
				if LastEnemyTime < Time then
					LastEnemyTime = Time;
				end
			end
		end
		
		for EnemyName, Times in pairs(CurrentWaveData.Enemies) do
			for _, Time in ipairs(Times) do
				self._Trove:Add(task.delay(Time, function()
					local Data = TableClone(EnemyData[EnemyName]);
					Data.Speed *= SpeedRatio;
					Data.Health *= HealthRatio;
					Data.Health *= self.HealthMultiplier;
					Data.Speed *= self.SpeedMultiplier;
					if self.Data.EnemyData[EnemyName] then
						if self.Data.EnemyData[EnemyName].ExtraData then
							for i, v in pairs(self.Data.EnemyData[EnemyName].ExtraData :: any) do
								if Data[i] ~= "nil" then
									Data[i] = v;
								else
									warn(string.format("String Index of: %s and Value: %* does not exist!", i, v));
								end
							end
						end
					end
					
					local CurrentEnemy = Enemy.new({
						EnemyInfo = Data;
						BezierId = self.BezierId;
					})

					table.insert(self.CurrentEnemies, CurrentEnemy);
					
					CurrentEnemy.Damaged:Connect(function(Damage: number)
						local Damage = math.max(math.round(Damage), 0);
						for _, Id in ipairs(self.PlayerIds) do
							self:AddYen(Id, Damage);
						end
					end)
					
					CurrentEnemy.ReachedEnd:Once(function()
						local Health = CurrentEnemy.Health;
						
						self:SubtractHealth(Health);
					end)
					
					local Connection: GoodSignal.Connection;
					
					Connection = CurrentEnemy.Destroying:Once(function()
						local Index = table.find(self.Connections, Connection);
						
						if Connection then
							table.remove(self.Connections, Index);
						end
						
						local Index = table.find(self.CurrentEnemies, CurrentEnemy);
						
						if Index then
							table.remove(self.CurrentEnemies, Index);
						end
						
						local PassedTime = tick() - DelayTick;

						if #self.CurrentEnemies == 0 and PassedTime > LastEnemyTime then
							if self.CurrentWave == WaveNum then
								self:AdvanceToNextWave();
								if self.WavePassed then
									self.WavePassed:Fire(self.CurrentWave);
								end
							end
						end
					end)

					table.insert(self.Connections, Connection);
				end))
			end
		end
		
		self.Time = CurrentWaveData.Length;
		self.TimeChanged:Fire(self.Time);
		self._Trove:Add(task.delay(CurrentWaveData.Length, function()
			if self.CurrentWave == WaveNum then
				self:AdvanceToNextWave();
				if self.WavePassed then
					self.WavePassed:Fire(self.CurrentWave);
				end
			end
		end))
	else
		self:End(true);
	end
end

function GlobalWave:ChangeHealth(Health: number)
	self.BaseHealth = math.clamp(Health, 0, self.MaxHealth);
	self.HealthChanged:Fire(self.BaseHealth);
	if self.BaseHealth == 0 then
		self:End(false);
	end
end

function GlobalWave:AddHealth(Health: number)
	self:ChangeHealth(self.BaseHealth + Health);
end

function GlobalWave:SubtractHealth(Health: number)
	self:ChangeHealth(self.BaseHealth - Health);
end

function GlobalWave:ChangeMaxHealth(Health: number)
	self.MaxHealth = Health;
	
	if self.MaxHealth < self.BaseHealth then
		self:ChangeHealth(self.MaxHealth);
	end
	
	self.MaxHealthChanged:Fire(Health);
end

function GlobalWave:SetYen(Id: number, Yen: number)
	local Info = self.Infos[Id];
	
	if Info then
		Info.Yen = math.max(Yen, 0);
		
		if self.YenChangedSignals[Id] then
			self.YenChangedSignals[Id]:Fire(Yen);
		end
	end
end

function GlobalWave:AddYen(Id: number, Yen: number)
	local Info = self.Infos[Id];
	
	if Info then
		self:SetYen(Id, Info.Yen + Yen);
	end
end

function GlobalWave:SubtractYen(Id: number, Yen: number)
	local Info = self.Infos[Id];

	if Info then
		self:SetYen(Id, Info.Yen - Yen);
	end
end

function GlobalWave:HasEnoughYen(Id: number, Yen: number)
	return self.Infos[Id].Yen >= Yen;
end

function GlobalWave:GetYenChangedSignal(PlayerId: number)
	if self.YenChangedSignals[PlayerId] then
		return self.YenChangedSignals[PlayerId];
	else
		local Signal = GoodSignal.new();
		self.YenChangedSignals[PlayerId] = Signal;
		
		return Signal;
	end
end

function GlobalWave:End(Win: boolean)
	print(Win);
	self.Ended:Fire(Win);
	self:Delete();
end

function GlobalWave:Delete()
	GlobalWaves[self.UniqueId] = nil;
	
	ClearConnections(self.Connections);
	
	for _, Enemy in ipairs(self.CurrentEnemies) do
		if Enemy.Delete then
			Enemy:Delete();
		end
	end
	
	Enemy.RemoveBezier(self.BezierId);
	self._Trove:Destroy();
	
	table.clear(self :: any);
	setmetatable(self :: any, nil);
end

GlobalWave.WaveAdded = GoodSignal.new();

function GlobalWave.GetWaveFromPlayerId(PlayerId: number)
	for _, Wave in pairs(GlobalWaves) do
		if table.find(Wave.PlayerIds, PlayerId) then
			return Wave;
		end
	end
	
	return;
end

function GlobalWave.GetWaveFromId(UniqueId: string)
	for Id, Wave in pairs(GlobalWaves) do
		if Id == UniqueId then
			return Wave;
		end
	end
	
	return;
end

function GlobalWave.GetWaves()
	return GlobalWaves;
end

SafePlayerRemoving:Connect(function(Player: Player)
	for Id, GlobalWave in pairs(GlobalWaves) do
		if table.find(GlobalWave.PlayerIds, Player.UserId) then
			for _, Id in ipairs(GlobalWave.PlayerIds) do
				if Players:GetPlayerByUserId(Id) then
					return;
				end
			end
			
			GlobalWave:End(false);
		end
	end
end)

return GlobalWave;