--!strict

--10-24-2024

-- By Wa1er_God --

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

local UnitEvents = ReplicatedStorage.Remotes.Unit
local AttackEvent = UnitEvents.Attack
local PlacementEvent = UnitEvents.PlacementEvent
local DestroyEvent = UnitEvents.DestroyEvent
local UpgradeEvent = UnitEvents.Upgrade
local PriorityChanged = UnitEvents.PriorityChanged

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)

local Modules = ReplicatedStorage.Modules
local GenerateId = require(Modules.GenerateId)
local HelperFunctions = require(Modules.HelperFunctions)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)

local Utility = ServerScriptService.Utility
local SafePlayer = Utility.SafePlayer
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded)
local SafePlayerRemoving = require(SafePlayer.SafePlayerRemoving)

local ModelStorage = ReplicatedStorage.ModelStorage
local UnitModels: { [string]: Model } = {}

for _, Unit in ipairs(ModelStorage.Units:GetChildren()) do
	UnitModels[Unit.Name] = Unit
end

local GlobalModules = ServerScriptService.GlobalModules
local Enemy = require(GlobalModules.Enemy)
local SortTypes = Enemy.GetSortTypes()

local Units: { [string]: Unit } = {}

export type UserInput = {
	OwnerId: number?,
	CFrame: CFrame,
	Level: number,

	ReplicateTo: { Player }?,

	DamageMultiplier: number?,
	RangeMultiplier: number?,
	--Price: number?;
}

export type UnitInput = {
	UnitName: string,

	-- Array of AttackFuncs per Level; --
	AttackFuncs: { [number]: { (self: Unit, Damage: number) -> () } },

	Abilities: {},
}

type UnitData = {
	_Trove: Trove.Trove,
	AttackTrove: Trove.Trove,
	EnemyTrove: Trove.Trove,

	UniqueId: string,
	UnitName: string,
	ModelReference: Model,
	AttackPriority: UnitInfo.SortType | string,

	ReplicateTo: { Player },
	IsGlobal: boolean,
	TotalCost: number,

	CFrame: CFrame,
	SpeedRatio: number,

	UnitData: UnitInfo.UnitInfo,

	AttackFuncs: { [number]: { (self: Unit, Damage: number) -> () } },
	AttackIndex: number,

	CurrentEnemy: Enemy.Enemy?,
	Level: number,
	MaxLevel: number,
	LastFired: number,
	Owner: Player?,
	OwnerId: number?,

	Attacked: Signal.Signal<>,
	Destroying: Signal.Signal<>,

	Abilities: {},
	CollisionRadius: number,
}

type UnitImpl = {
	new: (UserInput: UserInput, Data: UnitInput) -> Unit,

	Attack: (self: Unit) -> (),
	ChangePriority: (self: Unit) -> (),
	UpdateEnemy: (self: Unit) -> (),
	Upgrade: (self: Unit) -> (),

	Watch: (self: Unit, Time: number, Funcs: { { Func: () -> (), TimeRatio: number } }) -> (),

	AddSpectator: (self: Unit, Player: Player) -> (),
	RemoveSpectator: (self: Unit, Player: Player) -> (),

	IsOwnedBy: (self: Unit, Player: Player) -> boolean,

	Delete: (self: Unit) -> (),
	Destroy: (self: Unit) -> (),

	GetUnit: (UniqueId: string) -> Unit?,
	GetOwnedUnits: (Player: Player, Array: boolean) -> { Unit } | { [string]: Unit },
	SyncUnits: (Players: { Player }, Units: { [string]: Unit }, Spawn: boolean) -> (),

	GetUnits: () -> { [string]: Unit },

	__eq: (a: Unit, b: Unit) -> boolean,
	__index: UnitImpl,
}

export type Unit = typeof(setmetatable({} :: UnitData, {} :: UnitImpl))

local function SendInfo(Units: { [string]: Unit }, Players: { Player })
	local Data: { [string]: any } = {}
	for Id, Unit in pairs(Units) do
		Data[tostring(Unit.UniqueId)] = {
			UniqueId = Unit.UniqueId,
			UnitName = Unit.UnitName,
			CFrame = Unit.CFrame,
			OwnerId = Unit.OwnerId,
			AttackPriority = Unit.AttackPriority,
			Level = Unit.Level,

			SpeedRatio = Unit.SpeedRatio,
		}
	end

	HelperFunctions.FireClients(PlacementEvent, Players, Data)
end

local Unit: UnitImpl = {} :: UnitImpl
Unit.__index = Unit

function Unit.__eq(a, b)
	return rawequal(a.UniqueId, b.UniqueId)
end

function Unit.new(UserInput: UserInput, Data: UnitInput)
	local self = setmetatable({}, Unit) :: Unit

	self.UniqueId = GenerateId.GenerateId()
	self._Trove = Trove.new()
	self.AttackTrove = self._Trove:Extend()
	self.EnemyTrove = self._Trove:Extend()

	self.Attacked = self._Trove:Add(Signal.new(), "DisconnectAll")
	self.Destroying = self._Trove:Add(Signal.new(), "DisconnectAll")
	self.CFrame = UserInput.CFrame
	self.OwnerId = UserInput.OwnerId
	if UserInput.OwnerId then
		self.Owner = Players:GetPlayerByUserId(UserInput.OwnerId)
	end

	self.UnitData = UnitInfo.UnitInfo[Data.UnitName]

	local AttackFuncs = table.clone(Data.AttackFuncs)
	local HighestLevel = 0

	for Level, Funcs in ipairs(AttackFuncs) do
		if Level > HighestLevel then
			HighestLevel = Level
		end
	end

	local HighestData = 0

	for i = 1, HighestLevel, 1 do
		if Data.AttackFuncs[i] then
			HighestData = i
		else
			AttackFuncs[i] = AttackFuncs[HighestData]
		end
	end

	self.AttackFuncs = Data.AttackFuncs

	self.UnitName = Data.UnitName
	self.ModelReference = UnitModels[self.UnitName]
	self.Abilities = Data.Abilities
	self.LastFired = 0
	self.Level = UserInput.Level
	self.MaxLevel = #self.UnitData.UnitData
	self.AttackIndex = 1
	self.AttackPriority = UnitInfo.SortTypes[1]
	self.SpeedRatio = 1
	self.CollisionRadius = self.UnitData.CollisionRadius

	self.IsGlobal = if UserInput.ReplicateTo then false else true
	self.ReplicateTo = UserInput.ReplicateTo or Players:GetPlayers()

	self.TotalCost = UnitInfo.CalculateTotalCost(self.UnitData.UnitData, self.Level)

	SendInfo({ [self.UniqueId] = self }, self.ReplicateTo)

	self._Trove:Connect(RunService.PostSimulation, function(Delta: number)
		self:UpdateEnemy()
	end)

	Units[self.UniqueId] = self

	return self
end

function Unit:UpdateEnemy()
	local LevelData = self.UnitData.UnitData[self.Level]
	local Range = LevelData.Range
	local FireRate = LevelData.FireRate

	local EnemiesInRange = Enemy.GetEnemiesInRange(self.CFrame.Position, Range)
	for _, Enemy in ipairs(EnemiesInRange) do
		HelperFunctions.Debug.VisualizeCFrame(Enemy.CFrame)
	end
	local ClosestEnemy = Enemy.GetSortedEnemy(EnemiesInRange, self.AttackPriority)

	if ClosestEnemy == self.CurrentEnemy then
		if not ClosestEnemy then
			self.EnemyTrove:Destroy()
		end
	else
		if ClosestEnemy then
			self.EnemyTrove:Connect(ClosestEnemy.Destroying, function()
				self.CurrentEnemy = nil
				self.EnemyTrove:Destroy()
			end)
		end
	end

	self.CurrentEnemy = ClosestEnemy

	if not self.CurrentEnemy then
		return
	end

	local TimeDef = workspace:GetServerTimeNow() - self.LastFired

	if TimeDef >= FireRate * self.SpeedRatio then
		self:Attack()
	end
end

function Unit:ChangePriority()
	self.AttackPriority = UnitInfo.GetNextSortType(self.AttackPriority)
	HelperFunctions.FireClients(PriorityChanged, self.ReplicateTo, {
		UniqueId = self.UniqueId,
		Priority = self.AttackPriority,
	})
end

function Unit:Attack()
	local UpgradeData = self.UnitData.UnitData
	local CurrentTime = workspace:GetServerTimeNow()

	if not self.CurrentEnemy then
		return
	end

	self.LastFired = CurrentTime

	local LevelData = UpgradeData[self.Level]
	local AttackFuncs = self.AttackFuncs[self.Level]

	if self.AttackIndex > #AttackFuncs then
		self.AttackIndex = 1
	end

	local Damage = LevelData.Damage[self.AttackIndex]

	self.AttackTrove:Destroy()

	local Data = {
		UniqueId = self.UniqueId,
		Index = self.AttackIndex,
		EnemyId = self.CurrentEnemy.UniqueId,
		Firetime = workspace:GetServerTimeNow(),
		SpeedRatio = self.SpeedRatio,
	} :: {
		UniqueId: string,
		Index: number,
		EnemyId: string,
		Firetime: number,
		SpeedRatio: number,
	}

	HelperFunctions.FireClients(AttackEvent, self.ReplicateTo, Data)

	AttackFuncs[self.AttackIndex](self, Damage)
	self.Attacked:Fire()

	self.AttackIndex += 1
end

function Unit:Upgrade()
	if self.Level >= self.MaxLevel then
		return
	end

	self.AttackTrove:Destroy()
	self.LastFired = workspace:GetServerTimeNow()
	self.Level += 1
	self.AttackIndex = 1
	self.TotalCost = UnitInfo.CalculateTotalCost(self.UnitData.UnitData, self.Level)

	local Data = {
		UniqueId = self.UniqueId,
		Level = self.Level,
	}

	HelperFunctions.FireClients(UpgradeEvent, self.ReplicateTo, Data)
end

function Unit:Watch(Time: number, Funcs: { { Func: () -> (), TimeRatio: number } })
	for _, FuncData in ipairs(Funcs) do
		local NewTime = (Time * self.SpeedRatio) * FuncData.TimeRatio
		self.AttackTrove:Add(task.delay(NewTime, FuncData.Func))
	end
end

function Unit:AddSpectator(Player: Player)
	local Index = table.find(self.ReplicateTo, Player)

	if not Index then
		table.insert(self.ReplicateTo, Player)
	end
end

function Unit:RemoveSpectator(Player: Player)
	local Index = table.find(self.ReplicateTo, Player)

	if Index then
		table.remove(self.ReplicateTo, Index)
	end
end

function Unit:IsOwnedBy(Player: Player)
	return self.Owner == Player
end

function Unit:Delete()
	self.Destroying:Fire()
	HelperFunctions.FireClients(DestroyEvent, self.ReplicateTo, { self.UniqueId })
	Units[self.UniqueId] = nil
	self._Trove:Destroy()

	table.clear(self :: any)
	setmetatable(self :: any, nil)
end

function Unit:Destroy()
	self:Delete()
end

function Unit.GetUnit(UniqueId: string)
	return Units[UniqueId]
end

function Unit.GetOwnedUnits(Player: Player, Array: boolean)
	local Data: { [any]: any } = {}

	if Array then
		for _, Unit in pairs(Units) do
			if Unit.Owner == Player then
				table.insert(Data, Unit)
			end
		end
	else
		for _, Unit in pairs(Units) do
			if Unit.Owner == Player then
				Data[Unit.UniqueId] = Unit
			end
		end
	end

	return Data
end

function Unit.SyncUnits(Players: { Player }, Units: { [string]: Unit }, Spawn: boolean)
	if Spawn then
		SendInfo(Units, Players)
	else
		local Data = {}
		for Id, _ in pairs(Units) do
			table.insert(Data, Id)
		end
		HelperFunctions.FireClients(DestroyEvent, Players, Data)
	end
end

function Unit.GetUnits()
	return Units
end

SafePlayerAdded:Connect(function(Player: Player)
	local UnitsToReplicate = {}
	for Id, Unit in pairs(Units) do
		if Unit.OwnerId == Player.UserId then
			Unit.Owner = Player
		end
		if Unit.IsGlobal then
			table.insert(Unit.ReplicateTo, Player)
		end

		if table.find(Unit.ReplicateTo, Player) then
			UnitsToReplicate[Unit.UniqueId] = Unit
		end
	end

	if HelperFunctions.Len(UnitsToReplicate) ~= 0 then
		SendInfo(UnitsToReplicate, { Player })
	end
end, true)

SafePlayerRemoving:Connect(function(Player: Player)
	for Id, Unit in pairs(Units) do
		local Index = table.find(Unit.ReplicateTo, Player)

		if Index then
			table.remove(Unit.ReplicateTo, Index)
		end
	end
end)

return Unit
