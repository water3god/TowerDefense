---!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)

local Modules = ReplicatedStorage.Modules
local BezierPath = require(Modules.BezierPath)
local GenerateId = require(Modules.GenerateId)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)

local Random = Random.new()

export type EnemyInfo = {
	ModelName: string,
	Health: number,
	Speed: number,
	Reverse: boolean,
	IsBoss: boolean,
	Ally: boolean,
	AdornmentName: string?,
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
	Reverse: boolean,
	IsBoss: boolean,
	Ally: boolean,

	ReplicateTo: { Player },
	IsGlobal: boolean,

	AdornmentName: string?,
	OriginalSpeed: number,
	VectorOffset: Vector3,

	SpeedChanges: { { TimeStart: number, Speed: number, TimeEnd: number? } },

	Damaged: Signal.Signal<number>,
	Healed: Signal.Signal<number>,

	HealthChanged: Signal.Signal<number>,
	MaxHealthChanged: Signal.Signal<number>,
	SpeedChanged: Signal.Signal<number, number>,
	ReachedEnd: Signal.Signal<>,

	Destroying: Signal.Signal<>,
}

type EnemyImpl = {
	new: (EnemyInput: EnemyInput) -> Enemy,

	AdjustSpeed: (self: Enemy, Speed: number) -> (),
	SetHealth: (self: Enemy, Health: number) -> (),
	SetMaxHealth: (self: Enemy, MaxHealth: number) -> (),
	Damage: (self: Enemy, Damage: number) -> (),
	Heal: (self: Enemy, Health: number) -> (),

	IsInRange: (self: Enemy, Position: Vector2, Range: number) -> boolean,

	Destroy: (self: Enemy) -> (),

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
	self.ReachedEnd = self.Trove:Construct(Signal)
	self.Destroying = self.Trove:Construct(Signal)

	self.ModelName = Input.EnemyInfo.ModelName
	self.Health = Input.EnemyInfo.Health
	self.MaxHealth = self.Health
	self.Speed = Input.EnemyInfo.Speed
	self.Reverse = Input.EnemyInfo.Reverse
	self.IsBoss = Input.EnemyInfo.IsBoss
	self.Ally = Input.EnemyInfo.Ally

	self.Players = Input.Players or Players:GetPlayers()
	self.IsGlobal = Input.Players == nil

	self.AdornmentName = Input.EnemyInfo.AdornmentName

	if self.Reverse then
		self.TimePosition = 1
	else
		self.TimePosition = 0
	end

	self.SpeedChanges = { { TimeStart = workspace:GetServerTimeNow(), Speed = self.Speed } }
	self.OriginalSpeed = self.Speed
	self.VectorOffset = Vector3.zero
	--self.VectorOffset = Vector3.new(Random:NextNumber(-0.5, 0.5), 0, Random:NextNumber(-0.5, 0.5))

	self.Bezier = Beziers[Input.BezierId]
	self.BezierId = Input.BezierId

	if not Beziers[Input.BezierId] then
		Beziers[Input.BezierId] = self.Bezier
	end

	self.PathLength = self.Bezier:GetPathLength()
	self.CFrame = self.Bezier:CalculateUniformCFrame(self.TimePosition)

	local OldHP = self.Health

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
		if self.Delete then
			self:Destroy()
		end
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

	Enemies[self.UniqueId] = self

	return self
end

function Enemy:AdjustSpeed(Speed: number)
	self.Speed = Speed
	local Time = workspace:GetServerTimeNow()
	self.SpeedChanges[#self.SpeedChanges].TimeEnd = Time
	table.insert(self.SpeedChanges, { TimeStart = Time, Speed = Speed })

	self.SpeedChanged:Fire(Speed, Time)
end

function Enemy:SetHealth(Health: number)
	self.Health = math.clamp(Health, 0, self.MaxHealth)
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

function Enemy:IsInRange(StandardPos: Vector2, Range: number)
	local SelfPos = Vector2.new(self.CFrame.X, self.CFrame.Z)

	return (SelfPos - StandardPos).Magnitude <= Range / 2
end

function Enemy:Destroy()
	self.Destroying:Fire()
	self.Trove:Destroy()
	Enemies[self.UniqueId] = nil
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
	return UnitInfo.SortTypes
end

function Enemy.GetSortedEnemy(EnemiesInput: { Enemy }, SortType: UnitInfo.SortType | string)
	if #EnemiesInput == 0 then
		return
	end

	local ClosestEnemy: Enemy = EnemiesInput[1]
	local ClosestValue: number? = nil

	if SortType == "First" then
		ClosestValue = 0
		for _, Enemy in ipairs(EnemiesInput) do
			if ClosestValue < ClosestEnemy.TimePosition then
				ClosestEnemy = Enemy
				ClosestValue = Enemy.TimePosition
			end
		end
	elseif SortType == "Last" then
		ClosestValue = 1
		for _, Enemy in ipairs(EnemiesInput) do
			if ClosestValue > ClosestEnemy.TimePosition then
				ClosestEnemy = Enemy
				ClosestValue = Enemy.TimePosition
			end
		end
	elseif SortType == "Strongest" then
		ClosestValue = 0
		for _, Enemy in ipairs(EnemiesInput) do
			if ClosestValue < ClosestEnemy.Health then
				ClosestEnemy = Enemy
				ClosestValue = Enemy.Health
			end
		end
	elseif SortType == "Weakest" then
		ClosestValue = math.huge
		for _, Enemy in ipairs(EnemiesInput) do
			if ClosestValue > ClosestEnemy.Health then
				ClosestEnemy = Enemy
				ClosestValue = Enemy.Health
			end
		end
	end

	return ClosestEnemy
end

function Enemy.GetEnemiesInRange(Position: Vector3, Range: number)
	local StandardizedPos = Vector2.new(Position.X, Position.Z)
	local EnemiesTable = {}

	for _, Enemy in pairs(Enemies) do
		if Enemy:IsInRange(StandardizedPos, Range) then
			table.insert(EnemiesTable, Enemy)
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
end

return Enemy
