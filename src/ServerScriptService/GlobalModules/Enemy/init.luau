--!strict
--!native

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)

local Modules = ReplicatedStorage.Modules
local BezierPath = require(Modules.BezierPath)
local GenerateId = require(Modules.GenerateId)

local Shared = ReplicatedStorage.Shared
local Debuffs = require(Shared.DeBuffs)
local UnitInfo = require(Shared.UnitInfo)

local Random: Random = Random.new()

export type EnemyInfo = {
	ModelName: string,
	Health: number,
	Speed: number,
	IsBoss: boolean,
	Ally: boolean,
	AdornmentName: string?,
	PlayFunc: ((Enemy: Enemy) -> ())?,
	DestroyFunc: ((Enemy: Enemy) -> ())?,
}

export type EnemyInput = {
	EnemyInfo: EnemyInfo,
	BezierId: string,
	Players: { Player }?,
}

type EnemyData = {
	UniqueId: string,
	Trove: Trove.Trove,

	CFrame: CFrame,
	TimePosition: number,

	Bezier: BezierPath.Path,
	BezierId: string,

	PathLength: number,

	ModelName: string,
	Health: number,
	MaxHealth: number,
	Speed: number,
	IsBoss: boolean,
	Ally: boolean,

	ReplicateTo: { Player },
	IsGlobal: boolean,

	Promises: { [string]: Promise.Promise },

	PlayFunc: ((Enemy: Enemy) -> ())?,
	DestroyFunc: ((Enemy: Enemy) -> ())?,

	AdornmentName: string?,
	OriginalSpeed: number,
	VectorOffset: Vector3,

	Debuffs: { [string]: { { Strength: number, Duration: number, TimeStart: number } } },
	SpeedChanges: { { TimeStart: number, Speed: number, TimeEnd: number? } },
	SpeedMultipliers: { [string]: { number } },

	Damaged: Signal.Signal<number>,
	Healed: Signal.Signal<number>,

	HealthChanged: Signal.Signal<number>,
	MaxHealthChanged: Signal.Signal<number>,
	SpeedChanged: Signal.Signal<number, number>,
	SpeedMultiplierChanged: Signal.Signal<>,
	ReachedEnd: Signal.Signal<>,

	SpectatorAdded: Signal.Signal<>,
	SpectatorRemoving: Signal.Signal<>,

	Destroying: Signal.Signal<boolean>,
}

type EnemyImpl = {
	new: (EnemyInput: EnemyInput) -> Enemy,

	AdjustSpeed: (self: Enemy, Speed: number) -> (),
	SetHealth: (self: Enemy, Health: number) -> (),
	SetMaxHealth: (self: Enemy, MaxHealth: number) -> (),
	Damage: (self: Enemy, Damage: number) -> (),
	Heal: (self: Enemy, Health: number) -> (),

	ChangeMultiplier: (self: Enemy, Name: string, Multiplier: number, Time: number) -> (),
	ApplyDebuff: (self: Enemy, Debuff: string, Seconds: number, Strength: number) -> (),

	IsInRange: (self: Enemy, Position: Vector2, Range: number) -> boolean,

	AddPromise: (self: Enemy, Promise: Promise.Promise, Name: string) -> Promise.Promise,
	CancelPromise: (self: Enemy, Name: string) -> (),

	Destroy: (self: Enemy, Animate: boolean) -> (),

	GetEnemy: (UniqueId: string) -> Enemy?,
	GetEnemies: () -> { [string]: Enemy },
	GetBeziers: () -> { [string]: BezierPath.Path },
	GetSortTypes: () -> { UnitInfo.SortType },

	GetSortedEnemy: (EnemiesInput: { Enemy }, SortType: UnitInfo.SortType | string) -> Enemy?,
	GetEnemiesInRange: (Position: Vector3, Range: number) -> { Enemy },

	RemoveBezier: (UniqueId: string) -> (),
	AddBezier: (UniqueId: string, Bezier: BezierPath.Path) -> (),

	Spawned: Signal.Signal<Enemy>,
	BezierAdded: Signal.Signal<BezierPath.Path, string>,
	BezierRemoving: Signal.Signal<string>,
	Damaged: Signal.Signal<number>,

	__eq: (a: Enemy, b: Enemy) -> boolean,
	__index: EnemyImpl,
}

export type Enemy = typeof(setmetatable({} :: EnemyData, {} :: EnemyImpl))

local Enemies: { [string]: Enemy } = {}
local Beziers: { [string]: BezierPath.Path } = {}

local Enemy: EnemyImpl = {} :: EnemyImpl
Enemy.__index = Enemy

function Enemy.__eq(a: Enemy, b: Enemy)
	return rawequal(a.UniqueId, b.UniqueId)
end

Enemy.Spawned = Signal.new()
Enemy.BezierAdded = Signal.new()
Enemy.BezierRemoving = Signal.new()

function Enemy.new(Input: EnemyInput)
	local self = setmetatable({}, Enemy) :: Enemy

	self.UniqueId = GenerateId.GenerateId()
	self.Trove = Trove.new()

	self.SpectatorAdded = self.Trove:Construct(Signal)
	self.SpectatorRemoving = self.Trove:Construct(Signal)

	self.Damaged = self.Trove:Construct(Signal)
	self.Healed = self.Trove:Construct(Signal)

	self.HealthChanged = self.Trove:Construct(Signal)
	self.MaxHealthChanged = self.Trove:Construct(Signal)
	self.SpeedChanged = self.Trove:Construct(Signal)
	self.SpeedMultiplierChanged = self.Trove:Construct(Signal)
	self.ReachedEnd = self.Trove:Construct(Signal)
	self.Damaged = self.Trove:Construct(Signal)
	self.Destroying = self.Trove:Construct(Signal)

	self.ModelName = Input.EnemyInfo.ModelName
	self.Health = Input.EnemyInfo.Health
	self.MaxHealth = self.Health
	self.Speed = Input.EnemyInfo.Speed
	self.IsBoss = Input.EnemyInfo.IsBoss
	self.Ally = Input.EnemyInfo.Ally

	self.Promises = {}
	self.Debuffs = {}

	self.ReplicateTo = Input.Players or Players:GetPlayers()
	self.IsGlobal = Input.Players == nil

	self.AdornmentName = Input.EnemyInfo.AdornmentName

	self.PlayFunc = Input.EnemyInfo.PlayFunc
	self.DestroyFunc = Input.EnemyInfo.DestroyFunc

	if self.Ally then
		self.TimePosition = 1
	else
		self.TimePosition = 0
	end

	self.SpeedChanges = { { TimeStart = workspace:GetServerTimeNow(), Speed = self.Speed } }
	self.SpeedMultipliers = {}
	self.OriginalSpeed = self.Speed
	self.VectorOffset = Vector3.zero
	self.VectorOffset = Vector3.new(Random:NextNumber(-0.1, 0.1), 0, Random:NextNumber(-0.1, 0.1))

	self.Bezier = Beziers[Input.BezierId]
	self.BezierId = Input.BezierId

	if not Beziers[Input.BezierId] then
		Beziers[Input.BezierId] = self.Bezier
	end

	self.PathLength = self.Bezier:GetPathLength()
	self.CFrame = self.Bezier:CalculateUniformCFrame(self.TimePosition)

	local OldHP: number = self.Health

	self.HealthChanged:Connect(function(Health: number)
		if OldHP > Health then
			self.Damaged:Fire(OldHP - Health)
		elseif OldHP < Health then
			self.Healed:Fire(Health - OldHP)
		end
		OldHP = Health
	end)

	self.MaxHealthChanged:Connect(function(MaxHealth: number)
		if MaxHealth > self.Health then
			self:SetHealth(MaxHealth)
		end
	end)

	self.ReachedEnd:Once(function()
		if self.Destroy then
			self:Destroy(false)
		end
	end)

	self.Destroying:Connect(function()
		if self.DestroyFunc then
			self.DestroyFunc(self)
		end
	end)

	self.SpeedMultiplierChanged:Connect(function()
		local Multiplier: number = 1
		for _, Value in pairs(self.SpeedMultipliers) do
			if #Value == 0 then
				continue
			end
			local SmallestNumber = Value[1]
			for _, Num in pairs(Value) do
				if Num < SmallestNumber then
					SmallestNumber = Num
				end
			end
			Multiplier *= SmallestNumber
		end
		self:AdjustSpeed(self.OriginalSpeed * Multiplier)
	end)

	if self.IsGlobal then
		self.Trove:Connect(Players.PlayerAdded, function(Player: Player)
			if self.ReplicateTo then
				table.insert(self.ReplicateTo, Player)
			end
		end)

		self.Trove:Connect(Players.PlayerRemoving, function(Player: Player)
			if self.ReplicateTo then
				local Index = table.find(self.ReplicateTo, Player)

				if Index then
					table.remove(self.ReplicateTo, Index)
				end
			end
		end)
	end

	self.Spawned:Fire(self)

	if self.PlayFunc then
		self.PlayFunc(self)
	end

	Enemies[self.UniqueId] = self

	return self
end

function Enemy:AdjustSpeed(Speed: number)
	self.Speed = Speed
	local Time: number = workspace:GetServerTimeNow()
	self.SpeedChanges[#self.SpeedChanges].TimeEnd = Time
	table.insert(self.SpeedChanges, { TimeStart = Time, Speed = Speed })

	self.SpeedChanged:Fire(Speed, Time)
end

function Enemy:SetHealth(Health: number)
	self.Health = math.floor(math.clamp(Health, 0, self.MaxHealth))
	self.HealthChanged:Fire(self.Health)
end

function Enemy:SetMaxHealth(MaxHealth: number)
	self.MaxHealth = math.max(MaxHealth, 0)
	self.MaxHealthChanged:Fire(self.MaxHealth)
end

function Enemy:Damage(Damage: number)
	self:SetHealth(self.Health - Damage)
end

function Enemy:Heal(Health: number)
	self:SetHealth(self.Health + Health)
end

function Enemy:ChangeMultiplier(Name: string, Multiplier: number, Time: number)
	self:CancelPromise(Name .. Multiplier)
	if Multiplier <= 0 then
		local Index = table.find(self.SpeedMultipliers[Name], Multiplier)
		if Index then
			table.remove(self.SpeedMultipliers[Name], Index)
		end
	else
		table.insert(self.SpeedMultipliers[Name], Multiplier)
	end

	self:AddPromise(Promise.delay(Time), Name .. Multiplier):andThen(function()
		local Index = table.find(self.SpeedMultipliers[Name], Multiplier)
		if Index then
			table.remove(self.SpeedMultipliers[Name], Index)
		end
		if #self.SpeedMultipliers[Name] == 0 then
			self.SpeedMultipliers[Name] = nil
		end
		self.SpeedMultiplierChanged:Fire()
	end)

	self.SpeedMultiplierChanged:Fire()
end

function Enemy:ApplyDebuff(Debuff: string | Debuffs.Debuff, Seconds: number, Strength: number)
	if not Debuffs[Debuff] then
		warn("Debuff does not exist: " .. Debuff)
		return
	end

	if not self.Debuffs[Debuff] then
		self.Debuffs[Debuff] = {}
	end

	local PromiseName = "Debuff_" .. Debuff .. "_" .. tostring(#self.Debuffs[Debuff] + 1)

	if Debuff == "Bleed" then
		local DamagePerTick = Strength * self.MaxHealth

		if self.IsBoss then
			DamagePerTick *= 0.5
		end

		for i = 1, math.floor(Seconds) do
			self:AddPromise(Promise.delay(i), PromiseName .. i):andThen(function()
				self:Damage(DamagePerTick)
			end)
		end
	elseif Debuff == "Slow" then
		self:ChangeMultiplier("Slow", Strength, Seconds)
	end
end

function Enemy:IsInRange(StandardPos: Vector2, Range: number)
	local SelfPos = Vector2.new(self.CFrame.X, self.CFrame.Z)

	return (SelfPos - StandardPos).Magnitude <= Range / 2
end

function Enemy:AddPromise(NewPromise: Promise.Promise, Name: string)
	self:CancelPromise(Name)
	self.Promises[Name] = NewPromise:finally(function()
		self.Promises[Name] = nil
	end)
	self.Trove:AddPromise(self.Promises[Name] :: any)

	return self.Promises[Name]
end

function Enemy:CancelPromise(Name: string)
	local OldPromise: Promise.Promise = self.Promises[Name]
	if OldPromise then
		OldPromise:cancel()
		self.Promises[Name] = nil
	end
end

function Enemy:Destroy(Animate: boolean)
	if self.Destroying then
		self.Destroying:Fire(Animate)
	end

	if self.Trove then
		self.Trove:Destroy()
		Enemies[self.UniqueId] = nil
		task.defer(GenerateId.RemoveId, self.UniqueId)
	end
	table.clear(self :: any)
	setmetatable(self :: any, nil)
end

function Enemy.GetEnemy(UniqueId: string)
	return Enemies[UniqueId]
end

function Enemy.GetEnemies()
	return Enemies
end

function Enemy.GetBeziers()
	return Beziers
end

function Enemy.GetSortTypes()
	return UnitInfo.SortTypes :: any
end

function Enemy.GetSortedEnemy(EnemiesInput: { Enemy }, SortType: UnitInfo.SortType | string)
	if #EnemiesInput == 0 then
		return
	end

	local ClosestEnemy: Enemy = EnemiesInput[1]
	local ClosestValue: number? = nil

	if SortType == "First" then
		ClosestValue = 0
		for _, self in ipairs(EnemiesInput) do
			if ClosestValue < self.TimePosition then
				ClosestEnemy = self
				ClosestValue = self.TimePosition
			end
		end
	elseif SortType == "Last" then
		ClosestValue = 1
		for _, self in ipairs(EnemiesInput) do
			if ClosestValue > self.TimePosition then
				ClosestEnemy = self
				ClosestValue = self.TimePosition
			end
		end
	elseif SortType == "Strongest" then
		ClosestValue = 0
		for _, self in ipairs(EnemiesInput) do
			if ClosestValue < self.Health then
				ClosestEnemy = self
				ClosestValue = self.Health
			end
		end
	elseif SortType == "Weakest" then
		ClosestValue = math.huge
		for _, self in ipairs(EnemiesInput) do
			if ClosestValue > self.Health then
				ClosestEnemy = self
				ClosestValue = self.Health
			end
		end
	end

	return ClosestEnemy
end

function Enemy.GetEnemiesInRange(Position: Vector3, Range: number)
	local StandardizedPos: Vector2 = Vector2.new(Position.X, Position.Z)
	local EnemiesTable = {}

	for _, self in pairs(Enemies) do
		if self:IsInRange(StandardizedPos, Range) and not self.Ally then
			table.insert(EnemiesTable, self)
		end
	end

	return EnemiesTable
end

function Enemy.AddBezier(UniqueId: string, Bezier: BezierPath.Path)
	Beziers[UniqueId] = Bezier
	Enemy.BezierAdded:Fire(Bezier, UniqueId)
end

function Enemy.RemoveBezier(UniqueId: string)
	Beziers[UniqueId] = nil
	Enemy.BezierRemoving:Fire(UniqueId)
	GenerateId.RemoveId(UniqueId)
end

return Enemy
