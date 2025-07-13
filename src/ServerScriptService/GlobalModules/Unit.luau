--!strict
--!native

--10-24-2024

-- By Wa1er_God --

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

local Network = require(ReplicatedStorage.Network.Server)

local AttackEvent = Network.UnitAttack
local PlacementEvent = Network.UnitPlacementEvent
local DestroyEvent = Network.UnitDestroyEvent
local UpgradeEvent = Network.UnitUpgradeEvent
local PriorityChanged = Network.UnitPriorityChanged
local AbilityEvent = Network.UnitAbilityEvent
local AnimationEvent = Network.UnitAnimationEvent
local SpeedRatioEvent = Network.SpeedRatioEvent

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)
local Promise = require(Packages.Promise)

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

export type AbilityParam = { Length: number, Cooldown: number }

export type UnitInput = {
	UnitName: string,

	-- Array of AttackFuncs per Level; --
	AttackFuncs: { { (self: Unit, Damage: number) -> () } },
	DefaultRuns: { [number]: (self: Unit, Damage: number) -> () },

	Abilities: { (self: Unit, Data: AbilityParam) -> () },
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
	SpeedRatioData: { [string]: { SpeedRatio: number, EndTime: number } },
	SpeedRatio: number,

	UnitData: UnitInfo.UnitInfo,

	DefaultRuns: { [number]: (self: Unit, Damage: number) -> () },
	AttackFuncs: { [number]: { (self: Unit, Damage: number) -> () } },
	AttackIndex: number,

	CurrentEnemy: Enemy.Enemy?,
	Level: number,
	MaxLevel: number,
	LastFired: number,
	Owner: Player?,
	OwnerId: number?,

	Disabled: boolean,

	Abilities: {
		{
			MinimumLevel: number,
			LastUsed: number,
			Name: string,
			Icon: string,
			BackgroundColor: ColorSequence,
			Length: number,
			Cooldown: number,
			Func: (self: Unit, AbilityParam: AbilityParam) -> (),
		}
	},
	CollisionRadius: number,

	Promises: { [string]: Promise.Promise },

	Attacked: Signal.Signal<>,
	Upgraded: Signal.Signal<number>,
	AbilityUsed: Signal.Signal<number, number>, -- First is Index, Second is Fire Time
	SpeedRatioChanged: Signal.Signal<number>,

	DamagedEnemy: Signal.Signal<Enemy.Enemy, number>,
	KilledEnemy: Signal.Signal<Enemy.Enemy>,
	AllyAdded: Signal.Signal<Enemy.Enemy>,

	Damaged: Signal.Signal<number>,
	Destroying: Signal.Signal<>,
}

type UnitImpl = {
	new: (UserInput: UserInput, Data: UnitInput) -> Unit,

	Attack: (self: Unit) -> (),
	ChangePriority: (self: Unit) -> (),
	UpdateEnemy: (self: Unit) -> (),
	Upgrade: (self: Unit) -> (),
	UseAbility: (self: Unit, Index: number) -> (),
	AddAlly: (self: Unit, Ally: Enemy.Enemy) -> (),

	PlayAnimation: (
		self: Unit,
		AnimationName: string,
		SecondsAfter: number?,
		SpeedRatio: number?,
		FadeTime: number?,
		Length: number?
	) -> (),
	StopAnimation: (self: Unit, AnimationName: string, FadeTime: number?) -> (),

	DisableAttack: (self: Unit, Length: number) -> (),
	EnableAttack: (self: Unit) -> (),

	Stun: (self: Unit, Length: number) -> (),

	_CalculateSpeedRatio: (self: Unit) -> (),
	ChangeSpeedRatio: (self: Unit, Name: string, SpeedRatio: number, Duration: number) -> (),

	AddPromise: (self: Unit, Promise: Promise.Promise, PromiseName: string) -> (),
	AddAttackPromise: (self: Unit, Promise: Promise.Promise, PromiseName: string) -> (),
	CancelPromise: (self: Unit, PromiseName: string) -> (),

	Watch: (self: Unit, Time: number, Funcs: { { Func: () -> (), TimeRatio: number } }) -> (),

	AddSpectator: (self: Unit, Player: Player) -> (),
	RemoveSpectator: (self: Unit, Player: Player) -> (),

	DamageEnemy: (self: Unit, Enemy: Enemy.Enemy, Damage: number) -> (),

	IsOwnedBy: (self: Unit, Player: Player) -> boolean,

	Delete: (self: Unit) -> (),
	Destroy: (self: Unit) -> (),

	GetUnit: (UniqueId: string) -> Unit?,
	GetOwnedUnits: (Player: Player, Array: boolean) -> { Unit } | { [string]: Unit },
	SyncUnits: (Players: { Player }, Units: { [string]: Unit }, Spawn: boolean) -> (),

	GetUnits: () -> { [string]: Unit },

	__eq: (a: Unit, b: Unit) -> boolean,
	__index: UnitImpl,
	Added: Signal.Signal<Unit>,
}

export type Unit = typeof(setmetatable({} :: UnitData, {} :: UnitImpl))

local function ConvertAbilityData(Table: any)
	local NewTable = {}
	for Index, Data in ipairs(Table) do
		NewTable[Index] = Data.LastUsed
	end
	return NewTable
end

local function SendInfo(UnitInput: { [string]: Unit }, PlayerInput: { Player }, New: boolean)
	local Data: { [string]: any } = {}
	for _, Unit in pairs(UnitInput) do
		Data[tostring(Unit.UniqueId)] = {
			UniqueId = Unit.UniqueId,
			UnitName = Unit.UnitName,
			CFrame = Unit.CFrame,
			OwnerId = Unit.OwnerId,
			AttackPriority = Unit.AttackPriority,
			Level = Unit.Level,
			Abilities = ConvertAbilityData(Unit.Abilities),

			SpeedRatio = Unit.SpeedRatio,
		}
	end

	PlacementEvent.FireList(PlayerInput, Data, New)
end

local function SyncFuncs(Table: { [number]: any })
	local HighestLevel: number = 0

	for Level, _ in ipairs(Table) do
		if Level > HighestLevel then
			HighestLevel = Level
		end
	end

	local Closest: number = 0
	local NewTable = {}

	for i = 0, HighestLevel, 1 do
		if Table[i] then
			Closest = i
		end
		NewTable[i] = Table[Closest]
	end

	return NewTable
end

local Unit: UnitImpl = {} :: UnitImpl
Unit.__index = Unit

Unit.Added = Signal.new()

function Unit.__eq(a, b)
	return rawequal(a.UniqueId, b.UniqueId)
end

function Unit.new(UserInput: UserInput, Data: UnitInput)
	local self = setmetatable({}, Unit) :: Unit

	self.UniqueId = GenerateId.GenerateId()
	self._Trove = Trove.new()
	self.AttackTrove = self._Trove:Extend()
	self.EnemyTrove = self._Trove:Extend()

	self.Attacked = self._Trove:Construct(Signal)
	self.Upgraded = self._Trove:Construct(Signal)
	self.AbilityUsed = self._Trove:Construct(Signal)
	self.SpeedRatioChanged = self._Trove:Construct(Signal)

	self.DamagedEnemy = self._Trove:Construct(Signal)
	self.KilledEnemy = self._Trove:Construct(Signal)
	self.AllyAdded = self._Trove:Construct(Signal)

	self.Damaged = self._Trove:Construct(Signal)
	self.Destroying = self._Trove:Construct(Signal)

	self.UnitName = Data.UnitName
	self.ModelReference = UnitModels[self.UnitName]

	self.CFrame = UserInput.CFrame
	self.OwnerId = UserInput.OwnerId
	if UserInput.OwnerId then
		self.Owner = Players:GetPlayerByUserId(UserInput.OwnerId)
	end

	local SharedUnitData = UnitInfo.UnitInfo[self.UnitName]

	self.UnitData = SharedUnitData

	self.DefaultRuns = SyncFuncs(Data.DefaultRuns)
	self.AttackFuncs = SyncFuncs(Data.AttackFuncs)

	self.LastFired = 0
	self.Level = UserInput.Level
	self.MaxLevel = #self.UnitData.UnitData
	self.AttackIndex = 1
	self.AttackPriority = UnitInfo.SortTypes[1]
	self.CollisionRadius = self.UnitData.CollisionRadius

	self.SpeedRatioData = {}
	self.SpeedRatio = 1

	self.Promises = {}

	self.IsGlobal = if UserInput.ReplicateTo then false else true
	self.ReplicateTo = UserInput.ReplicateTo or Players:GetPlayers()

	self.TotalCost = UnitInfo.CalculateTotalCost(self.UnitData.UnitData, self.Level)

	if #SharedUnitData.Abilities ~= #Data.Abilities then
		warn("Incorrect Ability Configuration for: " .. self.UnitName)
	end

	do
		local Table = {}
		for i = 1, #SharedUnitData.Abilities, 1 do
			local Func = Data.Abilities[i]
			local OtherData = SharedUnitData.Abilities[i]
			Table[i] = HelperFunctions.joinDicts(OtherData, { LastUsed = 0, Func = Func })
		end
		self.Abilities = Table :: any
	end

	SendInfo({ [self.UniqueId] = self }, self.ReplicateTo, true)

	self.AbilityUsed:Connect(function(Index: number, TimeUsed: number)
		AbilityEvent:FireList(self.UniqueId, Index, TimeUsed)
	end)

	self.AllyAdded:Connect(function(Ally: Enemy.Enemy)
		self._Trove:Connect(Ally.Damaged, function(Damage: number)
			self.Damaged:Fire(Damage)
		end)
	end)

	local function OnLevel(Level: number)
		local Func = self.DefaultRuns[Level]
		if Func then
			Func(self, self.UnitData.UnitData[Level].Damage[1])
		end

		if self.UnitData.UnitData[self.Level].FireRate ~= 0 then
			local Connection = self._Trove:Connect(RunService.PostSimulation, function()
				self:UpdateEnemy()
			end)

			self.Upgraded:Once(function()
				Connection:Disconnect()
			end)
		end
	end

	OnLevel(self.Level)
	self.Upgraded:Connect(OnLevel)

	Units[self.UniqueId] = self
	self.Added:Fire(self)

	return self
end

function Unit:UpdateEnemy()
	local LevelData: UnitInfo.UnitData = self.UnitData.UnitData[self.Level]
	local Range: number = LevelData.Range
	local FireRate: number = LevelData.FireRate

	local EnemiesInRange = Enemy.GetEnemiesInRange(self.CFrame.Position, Range)
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

	if self.Disabled then
		return
	end

	local TimeDef: number = workspace:GetServerTimeNow() - self.LastFired

	if TimeDef >= FireRate * self.SpeedRatio then
		self:Attack()
	end
end

function Unit:ChangePriority()
	self.AttackPriority = UnitInfo.GetNextSortType(self.AttackPriority)
	PriorityChanged.FireList(self.ReplicateTo, {
		UniqueId = self.UniqueId,
		Priority = self.AttackPriority :: any,
	})
end

function Unit:Attack()
	local UpgradeData = self.UnitData.UnitData
	local CurrentTime: number = workspace:GetServerTimeNow()

	if not self.CurrentEnemy then
		return
	end

	self.LastFired = CurrentTime

	local LevelData = UpgradeData[self.Level]
	local AttackFuncs = self.AttackFuncs[self.Level]

	if AttackFuncs and self.AttackIndex > #AttackFuncs then
		self.AttackIndex = 1
	end

	local Damage: number = LevelData.Damage[self.AttackIndex]

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

	AttackEvent.FireList(self.ReplicateTo, Data)

	if AttackFuncs then
		AttackFuncs[self.AttackIndex](self, Damage)
		self.Attacked:Fire()
		self.AttackIndex += 1
	end
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

	self.Upgraded:Fire(self.Level)

	local Data = {
		UniqueId = self.UniqueId,
		Level = self.Level,
	}

	UpgradeEvent.FireList(self.ReplicateTo, Data)
end

function Unit:UseAbility(Index: number)
	local Data = self.Abilities[Index]
	if self.Level < Data.MinimumLevel then
		return
	end
	if workspace:GetServerTimeNow() - Data.LastUsed >= Data.Cooldown then
		local TimeUsed = workspace:GetServerTimeNow()
		Data.LastUsed = TimeUsed
		Data.Func(self, {
			Cooldown = Data.Cooldown,
			Length = Data.Length,
		})
		self.AbilityUsed:Fire(Index, TimeUsed)
	end
end

function Unit:AddAlly(Ally: Enemy.Enemy)
	self.AllyAdded:Fire(Ally)
end

function Unit:PlayAnimation(
	AnimationName: string,
	SecondsAfter: number?,
	SpeedRatio: number?,
	FadeTime: number?,
	Length: number?
)
	AnimationEvent.FireList(self.ReplicateTo, {
		UniqueId = self.UniqueId,
		AnimationName = AnimationName,
		SecondsAfter = SecondsAfter,
		SpeedRatio = SpeedRatio,
		FadeTime = FadeTime,
		Length = Length,
		SentTime = workspace:GetServerTimeNow(),
	}, true)
end

function Unit:StopAnimation(AnimationName: string)
	AnimationEvent.FireList(self.ReplicateTo, {
		UniqueId = self.UniqueId,
		AnimationName = AnimationName,
		SentTime = workspace:GetServerTimeNow(),
	}, false)
end

function Unit:DisableAttack(Length: number)
	self:CancelPromise("DisablePromise")
	self.Disabled = true
	self:StopAnimation("Attack")
	self.AttackTrove:Destroy()
	self:AddPromise(
		Promise.delay(Length):andThen(function()
			self.Disabled = false
			self.LastFired = workspace:GetServerTimeNow()
		end),
		"DisablePromise"
	)
end

function Unit:EnableAttack()
	self:CancelPromise("DisablePromise")
	self.Disabled = false
end

function Unit:Stun(Length: number)
	self:DisableAttack(Length)
	self:PlayAnimation("Stun", nil, nil, nil, Length)
end

function Unit:DamageEnemy(EnemyInput: Enemy.Enemy, Damage: number)
	if not getmetatable(EnemyInput) then
		return
	end

	EnemyInput:Damage(Damage)
	self.DamagedEnemy:Fire(EnemyInput, Damage)
	if EnemyInput.Health == 0 then
		self.KilledEnemy:Fire(EnemyInput)
	end
end

function Unit:_CalculateSpeedRatio()
	local OldRatio: number = self.SpeedRatio
	local SpeedRatio: number = 1

	for _, Data in pairs(self.SpeedRatioData) do
		SpeedRatio *= Data.SpeedRatio
	end

	if OldRatio ~= SpeedRatio then
		self.SpeedRatio = SpeedRatio
		self.SpeedRatioChanged:Fire(self.SpeedRatio)
	end
end

function Unit:ChangeSpeedRatio(Name: string, SpeedRatio: number, Duration: number)
	local PromiseName = "SpeedRatio" .. Name
	self:CancelPromise(PromiseName)
	local Data = { SpeedRatio = SpeedRatio, EndTime = workspace:GetServerTimeNow() + Duration }
	self.SpeedRatioData[Name] = Data
	SpeedRatioEvent.FireList(self.ReplicateTo, self.UniqueId, Name, Data)
	self:_CalculateSpeedRatio()
	self:AddPromise(
		Promise.delay(Duration):andThen(function()
			self.SpeedRatioData[Name] = nil
			self:_CalculateSpeedRatio()
		end),
		PromiseName
	)
end

function Unit:AddPromise(UnitPromise: Promise.Promise, PromiseName: string)
	self:CancelPromise(PromiseName)
	self.Promises[PromiseName] = UnitPromise

	self._Trove:AddPromise(UnitPromise :: any)

	UnitPromise:finally(function()
		self.Promises[PromiseName] = nil
	end)
end

function Unit:AddAttackPromise(AttackPromise: Promise.Promise, PromiseName: string)
	self:CancelPromise(PromiseName)
	self.Promises[PromiseName] = AttackPromise

	self.AttackTrove:AddPromise(AttackPromise :: any)

	AttackPromise:finally(function()
		self.Promises[PromiseName] = nil
	end)
end

function Unit:CancelPromise(PromiseName: string)
	local UnitPromise: Promise.Promise = self.Promises[PromiseName]
	if UnitPromise then
		UnitPromise:cancel()
		self.Promises[PromiseName] = nil
	end
end

function Unit:Watch(Time: number, Funcs: { { Func: () -> (), TimeRatio: number } })
	for _, FuncData in ipairs(Funcs) do
		local NewTime: number = (Time * self.SpeedRatio) * FuncData.TimeRatio
		self.AttackTrove:Add(task.delay(NewTime, FuncData.Func))
	end
end

function Unit:AddSpectator(Player: Player)
	local Index: number? = table.find(self.ReplicateTo, Player)

	if not Index then
		table.insert(self.ReplicateTo, Player)
	end
end

function Unit:RemoveSpectator(Player: Player)
	local Index: number? = table.find(self.ReplicateTo, Player)

	if Index then
		table.remove(self.ReplicateTo, Index)
	end
end

function Unit:IsOwnedBy(Player: Player)
	return self.Owner == Player
end

function Unit:Delete()
	self.Destroying:Fire()
	DestroyEvent.FireList(self.ReplicateTo, { self.UniqueId })
	Units[self.UniqueId] = nil
	GenerateId.RemoveId(self.UniqueId)
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
		for _, self in pairs(Units) do
			if self.Owner == Player then
				table.insert(Data, self)
			end
		end
	else
		for _, self in pairs(Units) do
			if self.Owner == Player then
				Data[self.UniqueId] = self
			end
		end
	end

	return Data
end

function Unit.SyncUnits(PlayerList: { Player }, UnitList: { [string]: Unit }, Spawn: boolean)
	if Spawn then
		SendInfo(UnitList, PlayerList, false)
	else
		local Data: { string } = {}
		for Id, _ in pairs(UnitList) do
			table.insert(Data, Id)
		end
		DestroyEvent.FireList(PlayerList, Data)
	end
end

function Unit.GetUnits()
	return Units
end

SafePlayerAdded:Connect(function(Player: Player)
	local UnitsToReplicate: { [string]: Unit } = {}
	for _, self in pairs(Units) do
		if self.OwnerId == Player.UserId then
			self.Owner = Player
		end
		if self.IsGlobal then
			table.insert(self.ReplicateTo, Player)
		end

		if table.find(self.ReplicateTo, Player) then
			UnitsToReplicate[self.UniqueId] = self
		end
	end

	if HelperFunctions.Len(UnitsToReplicate) ~= 0 then
		SendInfo(UnitsToReplicate, { Player }, false)
	end
end, true)

SafePlayerRemoving:Connect(function(Player: Player)
	for _, self in pairs(Units) do
		local Index: number? = table.find(self.ReplicateTo, Player)

		if Index then
			table.remove(self.ReplicateTo, Index)
		end
	end
end)

return Unit
