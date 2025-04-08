--!strict

--10-24-2024

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");

local EnemyModels: {[string]: Model} = {};
for _, Enemy in ipairs(ReplicatedStorage.ModelStorage.Enemies:GetChildren()) do
	EnemyModels[Enemy.Name] = Enemy;
end

local Modules = ReplicatedStorage.Modules;
local GenerateId = require(Modules.GenerateId);

local Remotes = ReplicatedStorage.Remotes;
local Events = Remotes.Enemy;

local MoveEvent = Events.MoveEvent;
local SpawnEvent = Events.SpawnEvent;
local DestroyEvent = Events.DestroyEvent;
local SpeedEvent = Events.SpeedEvent;
local NodeEvent = Events.NodeEvent;
local DamageEvent = Events.DamageEvent;

local Utility = ServerScriptService.Utility;
local Trove = require(Utility.Trove);
local GoodSignal = require(Utility.GoodSignal);
local SafePlayer = Utility.SafePlayer;
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded);
local SafePlayerRemoving = require(SafePlayer.SafePlayerRemoving);

local Lerps = require(ReplicatedStorage.Modules.Lerps);

--local Nodes: {BasePart} = workspace.Nodes:GetChildren();

local Random = Random.new();

local Utility = ServerScriptService.Utility;
local BezierPath = require(Utility.BezierPath);

export type EnemyInput = {
	ModelName: string;
	Health: number;
	Speed: number;
	Reverse: boolean;
	IsBoss: boolean;
	Ally: boolean;
};

export type ExtraData = {
	BezierPath: BezierPath.Path;
	NodeFolder: Folder;
	ReplicateTo: {Player}?;
};

type EnemyData = {
	_Trove: Trove.Trove;
	
	BezierPath: BezierPath.Path;
	T: number;
	
	Nodes: {BasePart};
	ReplicateTo: {Player};
	IsGlobal: boolean;
	
	CharModel: Model;
	TranslatedY: number;
	
	UniqueId: string;
	ModelName: string;
	CFrame: CFrame;
	
	Health: number;
	MaxHealth: number;
	Speed: number;
	Reverse: boolean;
	IsBoss: boolean;
	Ally: boolean;
	
	Node: number;
	
	Stuned: boolean;
	
	Destroying: GoodSignal.GoodSignal;
	Damaged: GoodSignal.GoodSignal;
	ReachedEnd: GoodSignal.GoodSignal;
};

export type SortType = "First" | "Last" | "Strongest" | "Weakest";
local SortTypes: {SortType} = {"First", "Last", "Strongest", "Weakest"};

type EnemyImpl = {
	new: (Input: EnemyInput, ExtraData: ExtraData) -> Enemy;
	
	AddSpectator: (self: Enemy, Spectator: Player) -> ();
	RemoveSpectator: (self: Enemy, Spectator: Player) -> ();
	
	IsInRange: (self: Enemy, CFrame: CFrame, Range: number) -> ();
	DoDamage: (self: Enemy, Damage: number, NoFire: boolean?) -> ();
	AdjustSpeed: (self: Enemy, Speed: number) -> ();
	
	Delete: (self: Enemy) -> ();
	
	GetSortedEnemy: (Enemies: {[any]: Enemy}, SortType: SortType) -> Enemy?;
	GetRangeEnemies: (CFrame: CFrame?, Range: number?) -> {[string]: Enemy};
	GetSortTypes: () -> {SortType};
	
	GetEnemy: (UniqueId: string) -> Enemy?;
	SyncEnemies: (Players: {Player}, Enemies: {[string]: Enemy}, Spawn: boolean) -> ();
	GetEnemies: () -> {[string]: Enemy};
	
	__index: EnemyImpl;
	__eq: (a: Enemy, b: Enemy) -> boolean;
};

local Enemies: {[string]: Enemy} = {};

export type Enemy = typeof(setmetatable({} :: EnemyData, {} :: EnemyImpl));

local Enemy: EnemyImpl = {} :: EnemyImpl;
Enemy.__index = Enemy;
Enemy.__eq = function(a, b)
	return rawequal(a.UniqueId, b.UniqueId)
end

local NotReplicated = {"_Trove", "ChangedAttributes", "CharModel", "Destroying", "Damaged", "ReachedEnd", "ReplicateTo", "IsGlobal"};

local function IsNan(CFrame: CFrame | Vector3)
	if typeof(CFrame) == "CFrame" then
		for _, Comp in pairs(table.pack(CFrame:GetComponents())) do
			if Comp ~= Comp then
				return true;
			end
		end
	else
		if CFrame.X ~= CFrame.X or CFrame.Y ~= CFrame.Y or CFrame.Z ~= CFrame.Z then
			return true;
		end
	end

	return false;
end

local function SendNewData(Data: {}, Enemy: Enemy)
	for i, v in pairs(Enemy) do
		if not table.find(NotReplicated, i) then
			Data[i] = v;
		end
	end
	
	return Data;
end

local function SendFrameData(Data: {[any]: any}, Enemy: Enemy)
	Data.X = Enemy.CFrame.X;
	Data.Z = Enemy.CFrame.Z;
	local _, rY, _ = Enemy.CFrame:ToEulerAnglesYXZ();
	Data.rY = rY;
	
	return Data;
end

--[[
	Creates a new Enemy on the Path with the given Data.
]]
function Enemy.new(Data: EnemyInput, ExtraData: ExtraData)
	local self = setmetatable({}, Enemy) :: Enemy;
	
	self.UniqueId = GenerateId.GenerateId();
	self._Trove = Trove.new();
	self.ModelName = Data.ModelName;
	
	self.Damaged = self._Trove:Add(GoodSignal.new(), "DisconnectAll");
	self.Destroying = self._Trove:Add(GoodSignal.new(), "DisconnectAll");
	self.ReachedEnd = self._Trove:Add(GoodSignal.new(), "DisconnectAll");
	
	self.Nodes = (ExtraData :: any).NodeFolder:GetChildren() :: {BasePart};
	self.BezierPath = ExtraData.BezierPath;
	self.T = 0;
	local Nodes = self.Nodes;
	
	self.CharModel = EnemyModels[self.ModelName];
	self.Health = math.round(Data.Health);
	self.Speed = Data.Speed;
	self.Reverse = Data.Reverse;
	self.IsBoss = Data.IsBoss;
	--self.Ally = Data.Ally;
	
	self.ReplicateTo = ExtraData.ReplicateTo or Players:GetPlayers();
	self.IsGlobal = if ExtraData.ReplicateTo then false else true;
	
	self.Stuned = false;
	if self.Reverse then
		self.Node = #Nodes;
	else
		self.Node = 1;
	end
	self.MaxHealth = self.Health;
	
	if ExtraData then
		for Name, Value in pairs(ExtraData) do
			if self[Name] ~= "nil" and typeof(Value) == typeof(self[Name]) then
				self[Name] = Value;
			end
		end
	end
	
	local CenterCFrame, Size = self.CharModel:GetBoundingBox();
	local Root: BasePart = self.CharModel.PrimaryPart :: BasePart;
	local YHeight = Size.Y/2 + (Root.Position - CenterCFrame.Position).Y;
	
	self.TranslatedY = Nodes[1].CFrame.Position.Y + (Nodes[1].Size/2).Y + YHeight;
	
	local FirstNum: number = 1;
	local SecondNum: number = 2;
	
	if self.Reverse then
		FirstNum = #Nodes;
		SecondNum = #Nodes - 1;
	end
	
	local CurrentNodePosition = Vector3.new(Nodes[FirstNum].CFrame.Position.X, self.TranslatedY, Nodes[FirstNum].CFrame.Position.Z);
	local NextNodePosition = Vector3.new(Nodes[SecondNum].Position.X, self.TranslatedY, Nodes[SecondNum].Position.Z);
	
	self.CFrame = CFrame.lookAt(CurrentNodePosition, NextNodePosition);
	
	local ClientData = SendNewData({}, self);
	for _, Player in ipairs(self.ReplicateTo) do
		SpawnEvent:FireClient(Player, {[self.UniqueId] = ClientData});	
	end
	--SpawnEvent:FireAllClients({[self.UniqueId] = ClientData});	
	Enemies[self.UniqueId] = self;
	
	return self;
end

function Enemy:AddSpectator(Player: Player)
	local Index = table.find(self.ReplicateTo, Player);
	
	if not Index then
		table.insert(self.ReplicateTo, Player);
	end
end

function Enemy:RemoveSpectator(Player: Player)
	local Index = table.find(self.ReplicateTo, Player);

	if Index then
		table.remove(self.ReplicateTo, Index);
	end
end

function Enemy:IsInRange(CFrame: CFrame, Range: number)
	local CurrentPosition = Vector3.new(self.CFrame.X, 0, self.CFrame.Z);
	local UnitPosition = Vector3.new(CFrame.X, 0, CFrame.Z);
	
	if (CurrentPosition - UnitPosition).Magnitude <= Range / 2 then
		return true;
	else
		return false;
	end
end

function Enemy:DoDamage(Damage: number)
	local NewHealth = math.clamp(self.Health - Damage, 0, self.MaxHealth);
	local Difference = self.Health - NewHealth;
	self.Health = math.round(NewHealth);
	
	if self.Health == 0 then
		self:Delete();
	else
		for _, Player in ipairs(self.ReplicateTo) do
			DamageEvent:FireClient(Player, self.UniqueId, self.Health);
		end
		--DamageEvent:FireAllClients(self.UniqueId, self.Health);
		self.Damaged:Fire(Difference);
	end
	
end

function Enemy:AdjustSpeed(Speed: number)
	self.Speed = Speed;
	for _, Player in ipairs(self.ReplicateTo) do
		SpeedEvent:FireClient(Player, {[self.UniqueId] = Speed});
	end
	--SpeedEvent:FireAllClients({[self.UniqueId] = Speed});
end

function Enemy:Delete()
	Enemies[self.UniqueId] = nil;
	
	self.Destroying:Fire();
	for _, Player in ipairs(self.ReplicateTo) do
		DestroyEvent:FireClient(Player, {self.UniqueId});
	end

	self._Trove:Destroy();
	table.clear(self :: any);
	setmetatable(self :: any, nil);
end

function Enemy.GetRangeEnemies(CFrame: CFrame?, Range: number?)
	if CFrame and Range then
		local InRangeEnemies: {[string]: Enemy} = {};
		
		for Id, Enemy in pairs(Enemies) do
			local SelfPos = Vector3.new(Enemy.CFrame.X, 0, Enemy.CFrame.Z);
			local GivenPos = Vector3.new(CFrame.X, 0, CFrame.Z);
			
			local Distance = (SelfPos - GivenPos).Magnitude;
			
			if Distance <= Range then
				InRangeEnemies[Id] = Enemy;
			end
		end
		
		return InRangeEnemies;
	else
		return Enemies;
	end
end

function Enemy.GetSortedEnemy(GivenEnemies: {[string]: Enemy}, SortType: SortType)
	if not table.find(SortTypes, SortType) then
		warn("No Valid Sort Type: "..SortType);
		return;
	end
	
	local NearestEnemy: Enemy = nil;
	
	if SortType == "First" then
		local ClosestNode: number = 1;
		local ClosestPosition: Vector3 = nil;
		
		for Id, Enemy in pairs(GivenEnemies) do
			local Nodes = Enemy.Nodes;
			if not NearestEnemy then
				ClosestNode = Enemy.Node;
				NearestEnemy = Enemy;
				ClosestPosition = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z);
			end
			
			if Enemy.Node > ClosestNode then
				local CurrentPosition = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z);
				ClosestNode = Enemy.Node;
				NearestEnemy = Enemy;
				ClosestPosition = CurrentPosition;
			elseif Enemy.Node == ClosestNode then
				local NodePart = Nodes[Enemy.Node + 1];

				if not NodePart then
					continue;
				end

				local CurrentPosition = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z);
				local NodePosition = Vector3.new(NodePart.Position.X, 0, NodePart.Position.Z);

				if (NodePosition - CurrentPosition).Magnitude < (NodePosition - ClosestPosition).Magnitude then
					ClosestNode = Enemy.Node;
					NearestEnemy = Enemy;
					ClosestPosition = CurrentPosition;
				end
			end
		end
	elseif SortType == "Last" then
		local ClosestNode: number = 1;
		local ClosestPosition: Vector3 = nil;

		for Id, Enemy in pairs(GivenEnemies) do
			local Nodes = Enemy.Nodes;
			if not NearestEnemy then
				ClosestNode = Enemy.Node;
				NearestEnemy = Enemy;
				ClosestPosition = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z);
			end

			if not NearestEnemy then
				ClosestNode = Enemy.Node;
				NearestEnemy = Enemy;
				ClosestPosition = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z);
			end

			if Enemy.Node < ClosestNode then
				local CurrentPosition = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z);
				ClosestNode = Enemy.Node;
				NearestEnemy = Enemy;
				ClosestPosition = CurrentPosition;
			elseif Enemy.Node == ClosestNode then

				local NodePart = Nodes[Enemy.Node + 1];

				if not NodePart then
					continue;
				end

				local CurrentPosition = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z);
				local NodePosition = Vector3.new(NodePart.Position.X, 0, NodePart.Position.Z);

				if (NodePosition - CurrentPosition).Magnitude > (NodePosition - ClosestPosition).Magnitude then
					ClosestNode = Enemy.Node;
					NearestEnemy = Enemy;
					ClosestPosition = CurrentPosition;
				end
			end
		end
	elseif SortType == "Strongest" then
		local MostHealth = 0;
		
		for Id, Enemy in pairs(GivenEnemies) do
			if Enemy.Health >= MostHealth then
				MostHealth = Enemy.Health;
				NearestEnemy = Enemy;
			end
		end
	elseif SortType == "Weakest" then
		local LeastHealth = math.huge;

		for Id, Enemy in pairs(GivenEnemies) do
			if Enemy.Health <= LeastHealth then
				LeastHealth = Enemy.Health;
				NearestEnemy = Enemy;
			end
		end
	end
	
	return NearestEnemy;
end

function Enemy.GetSortTypes()
	return SortTypes :: any;
end

function Enemy.GetEnemy(UniqueId: string)
	return Enemies[UniqueId];
end

function Enemy.SyncEnemies(Players: {Player}, Enemies: {[string]: Enemy}, Spawn: boolean)
	local Data: {[any]: any} = {};
	
	if Spawn then
		for Id, Enemy in pairs(Enemies) do
			Data[Id] = SendNewData({}, Enemy);
		end

		for _, Player in ipairs(Players) do
			SpawnEvent:FireClient(Player, Data);
		end
	else
		for Id, _ in pairs(Enemies) do
			table.insert(Data, Id);
		end

		for _, Player in ipairs(Players) do
			DestroyEvent:FireClient(Player, Data);
		end
	end
end

function Enemy.GetEnemies()
	return Enemies;
end

RunService.PostSimulation:Connect(function(Delta: number)
	for Id, Enemy in pairs(Enemies) do
		if Enemy.Reverse then
			Enemy.T = math.clamp(Enemy.T - (Enemy.Speed / Enemy.BezierPath:GetPathLength()) / 100, 0, 1);
		else
			Enemy.T = math.clamp(Enemy.T + (Enemy.Speed / Enemy.BezierPath:GetPathLength()) / 100, 0, 1);
		end
		
		Enemy.CFrame = Enemy.BezierPath:CalculateUniformCFrame(Enemy.T);
		
		if Enemy.T <= 0 or Enemy.T >= 1 then
			Enemy.ReachedEnd:Fire();
			if Enemy.Delete then
				Enemy:Delete();
			end
		end
	end
end)

--[[RunService.PostSimulation:Connect(function(Delta: number)
	local SentData = {};
	for Id, Enemy in pairs(Enemies) do
		local Nodes = Enemy.Nodes;
		local CurrentNode: BasePart = Nodes[Enemy.Node];
		local NextNode: BasePart = if Enemy.Reverse then Nodes[Enemy.Node - 1] else Nodes[Enemy.Node + 1];
		
		if NextNode then
			local NextNodePosition = Vector3.new(NextNode.Position.X, Enemy.TranslatedY, NextNode.Position.Z);
			local Distance = (NextNodePosition - Enemy.CFrame.Position);
			
			local Step: Vector3 = Distance.Unit * Delta * Enemy.Speed;
			
			if Step.Magnitude >= Distance.Magnitude or Step ~= Step then
				if Enemy.Reverse then
					Enemy.Node -= 1;
				else
					Enemy.Node += 1;
				end
				
				local NextNode = if Enemy.Reverse then Nodes[Enemy.Node - 1] else Nodes[Enemy.Node + 1];
				
				if NextNode then
					local NextNodePosition = Vector3.new(NextNode.Position.X, Enemy.TranslatedY, NextNode.Position.Z);
					local LookAt = CFrame.lookAt(Enemy.CFrame.Position, NextNodePosition);
					
					Enemy.CFrame = LookAt;
				end
				
				SentData[Id] = Enemy.Node;
			else
				Enemy.CFrame += Step;
			end
			
			local p = Instance.new("Part");
			p.CFrame = Enemy.CFrame;
			p.Anchored = true;
			p.Parent = workspace;
			
			task.delay(0.2, function()
				p:Destroy();
			end)
		else
			Enemy.ReachedEnd:Fire();
			if Enemy.Delete then
				Enemy:Delete();
			end
		end
	end
	
	if next(SentData) then
		for _, Player in ipairs(Players:GetPlayers()) do
			local NewData = {};
			for Id, Node in pairs(SentData) do
				local EnemyData = Enemies[Id];
				if table.find(EnemyData.ReplicateTo, Player) then
					NewData[Id] = Node;
				end
			end
			NodeEvent:FireClient(Player, NewData);
		end
		--NodeEvent:FireAllClients(SentData);
	end
end)]]

local Count = 0;

RunService.Heartbeat:Connect(function(Delta: number)
	Count += Delta;
	
	if Count >= 0.1 then
		Count = 0;
		
		local Data = {};
		for Id, Enemy in pairs(Enemies) do
			Data[Id] = SendFrameData({}, Enemy);
		end
		
		for _, Player in ipairs(Players:GetPlayers()) do
			local NewData = {};
			
			for Id, Enemy in pairs(Enemies) do
				if table.find(Enemy.ReplicateTo, Player) then
					NewData[Id] = Data[Id];
				end
			end
			
			MoveEvent:FireClient(Player, NewData);
		end
		--MoveEvent:FireAllClients(Data);
	end
end)

SafePlayerAdded:Connect(function(Player: Player)
	for Id, Enemy in pairs(Enemies) do
		if Enemy.IsGlobal then
			table.insert(Enemy.ReplicateTo, Player);
		end
	end
	
	local Data = {};
	for Id, Enemy in pairs(Enemies) do
		Data[Id] = SendNewData({}, Enemy);
	end
	
	for _, Player in ipairs(Players:GetPlayers()) do
		local NewData = {};
		for Id, Enemy in pairs(Enemies) do
			if table.find(Enemy.ReplicateTo, Player) then
				NewData[Id] = Data[Id];
			end
		end
		
		SpawnEvent:FireClient(Player, NewData);
	end
	
	--SpawnEvent:FireAllClients(Data);
end, true);

SafePlayerRemoving:Connect(function(Player: Player)
	for Id, Enemy in pairs(Enemies) do
		local Index = table.find(Enemy.ReplicateTo, Player)
		if Index then
			table.remove(Enemy.ReplicateTo, Index);
		end
	end
end);


return Enemy;