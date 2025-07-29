--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)
local Promise = require(Packages.Promise)

local Modules = ReplicatedStorage.Modules
local BezierPath = require(Modules.BezierPath)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)

local ModelStorage = ReplicatedStorage.ModelStorage
local Extra = ModelStorage.Extra
local _CollisionRadius = Extra.CollisionRadius
local _Rig = Extra.Rig

export type Status = "InTrade" | "Finalized" | "Accepted"
export type TradeStatusMessage = "Trading" | "CanTrade" | "TradeDisabled"

-- Inventory Types --

export type VisualUnitData = {
	Unit: string,
	Level: number,
	Trait: string?,
	UniqueId: string,
	XP: number,
	NeededXP: number,
}

export type ProductData = {
	ProductId: number,
	IsGamepass: boolean,
	Count: number,
	UniqueId: string,
}

export type ResourceData = {
	Resource: string,
	Count: number,
	UniqueId: string,
	PartialOneLose: boolean?,
}

export type RawUnitData = {
	Unit: string,
	Level: number,
}

export type RewardData = {
	Resource: string,
	Count: number,
}

-- Trade Type --

export type TradeProductData = {
	UniqueId: string,
	Product: number,
	Count: number,
}

export type TradeResourceData = {
	UniqueId: string,
	Resource: string,
	Count: number,
}

export type TradeData = {
	OtherPlayer: Player,
	YourUnits: { VisualUnitData },
	OtherUnits: { VisualUnitData },
	YourProducts: { TradeProductData },
	OtherProducts: { TradeProductData },
	YourResources: { TradeResourceData },
	OtherResources: { TradeResourceData },
	Status: Status,
	YourStatus: Status,
	OtherStatus: Status,
}

-- Enemy Types --

export type EnemyInput = {
	UniqueId: string,
	ModelName: string,
	Health: number,
	MaxHealth: number,
	Speed: number,
	IsBoss: boolean,
	Ally: boolean,
	OriginalSpeed: number,
	VectorOffset: Vector3,
	BezierId: string,
	TimePosition: number,
	Time: number,
	AdornmentName: string?,
	SpeedChanges: { { TimeStart: number, Speed: number, TimeEnd: number? } },
}

type EnemyData = {
	UniqueId: string,
	Trove: Trove.Trove,

	Character: typeof(_Rig),
	Root: typeof(_Rig.HumanoidRootPart),
	Humanoid: typeof(_Rig.Humanoid),
	Animator: typeof(_Rig.Humanoid.Animator),
	Adornment: Model?,
	SizeRatio: number,
	CFrame: CFrame,

	ModelName: string,
	Health: number,
	MaxHealth: number,
	Speed: number,
	IsBoss: boolean,
	Ally: boolean,

	OriginalSpeed: number,
	VectorOffset: Vector3,

	TimePosition: number,
	SpeedChanges: { { TimeStart: number, Speed: number, TimeEnd: number? } },
	Bezier: BezierPath.Path,
	PathLength: number,

	YOffset: number,
	Animations: { [string]: AnimationTrack },

	SpeedChanged: Signal.Signal<number>,
	HealthChanged: Signal.Signal<number>,
	MaxHealthChanged: Signal.Signal<number>,
	ReachedEnd: Signal.Signal<>,
	Destroying: Signal.Signal<boolean>,
}

export type EnemyModule = {
	GetAnimationRatio: (self: EnemyClient) -> number,
	PartIsDescendantOf: (self: EnemyClient, Part: BasePart) -> boolean,

	GetEnemy: (UniqueId: string) -> EnemyClient?,

	GetEnemies: () -> { [string]: EnemyClient },
	GetBeziers: () -> { [string]: BezierPath.Path },

	NewEnemy: Signal.Signal<EnemyClient, boolean>,

	__index: EnemyModule,
}

export type EnemyClient = typeof(setmetatable({} :: EnemyData, {} :: EnemyModule))

-- Unit Types --

export type UnitInput = {
	UniqueId: string,
	UnitName: string,
	CFrame: CFrame,
	OwnerId: number?,
	AttackPriority: string,
	Level: number,

	Trait: string?,
	RatioData: {
		[string]: {
			[string]: {
				Type: string,
				Ratio: number,
				EndTime: number,
			},
		},
	},
	Abilities: { number },
}

export type AbilityData = {
	MinimumLevel: number,
	LastUsed: number,
	Name: string,
	Icon: string,
	Length: number,
	Cooldown: number,
	BackgroundColor: ColorSequence,
	Func: (Unit: Unit, Data: {
		LastUsed: number,
		Length: number,
		Cooldown: number,
	}) -> (),
}

type UnitData = {
	UniqueId: string,
	Trove: Trove.Trove,

	AttackTrove: Trove.Trove,

	Character: typeof(_Rig),
	AdornmentLevel: number?,
	Adornment: Model?,
	Root: typeof(_Rig.HumanoidRootPart),
	CenterPart: BasePart,
	Humanoid: typeof(_Rig.Humanoid),
	Animator: typeof(_Rig.Humanoid.Animator),
	RadiusPart: typeof(_CollisionRadius),
	RangePart: BasePart,

	VisualCFrame: CFrame,
	VectorOffset: Vector3,

	UnitName: string,
	CFrame: CFrame,
	OwnerId: number?,
	AttackPriority: UnitInfo.SortType | string,
	Level: number,
	TotalCost: number,
	CollisionRadius: number,
	UnitData: UnitInfo.UnitInfo,
	Trait: string?,

	RatioData: { [string]: { [string]: { Type: string, Ratio: number, EndTime: number } } },
	Ratios: {
		Damage: number,
		FireRate: number,
		Range: number,
		Coins: number,
	},

	SizeRatio: number,

	UnitAttacks: {
		[number]: { (Unit: Unit, AttackInput: UnitAttackInput, Enemy: EnemyClient?, Delay: number) -> () },
	},
	DefaultRuns: { [number]: (Unit: Unit) -> () },
	Abilities: { AbilityData },
	Animations: { [string]: AnimationTrack },

	Promises: { [string]: Promise.Promise },

	IsClicked: boolean,

	AnimationPlayed: Signal.Signal<string>,

	Attacked: Signal.Signal<>,
	CharacterClicked: Signal.Signal<boolean>,
	Upgraded: Signal.Signal<number>,
	AbilityUsed: Signal.Signal<number, number>, -- First Index, Second TimeUsed --
	PriorityChanged: Signal.Signal<UnitInfo.SortType | string>,
	PropertyChanged: Signal.Signal<string, number>, -- Does not fire on Upgrade --
	CoinsAdded: Signal.Signal<number>,
	Destroying: Signal.Signal<>,
}

export type UnitModule = {
	TPToRootPosition: (self: Unit) -> (),
	PlayAnimation: (
		self: Unit,
		AnimationName: string,
		SecondsAfter: number?,
		SpeedRatio: number?,
		FadeTime: number?,
		Length: number?
	) -> AnimationTrack?,
	StopAnimation: (self: Unit, AnimationName: string, FadeTime: number?) -> AnimationTrack?,
	Watch: (
		self: Unit,
		AnimationName: string,
		Funcs: { { TimeRatio: number, PlayAfter: boolean, Func: () -> () } }
	) -> (),
	RotateToEnemy: (self: Unit, Enemy: EnemyClient) -> (),
	RotateTo: (self: Unit, Degree: number) -> (),
	PartIsDescendantOf: (self: Unit, Part: BasePart) -> boolean,
	ClickCharacter: (self: Unit, Enabled: boolean) -> (),

	_CalculateRatio: (self: Unit) -> (),

	WeldAdornment: (self: Unit, Adornment: Model) -> Model,

	AddPromise: (self: Unit, Promise: Promise.Promise, PromiseName: string) -> (),
	AddAttackPromise: (self: Unit, Promise: Promise.Promise, PromiseName: string) -> (),
	CancelPromise: (self: Unit, PromiseName: string) -> (),

	ApplyDetail: (self: Unit) -> (),

	ChangePriority: (self: Unit) -> (),
	LevelUp: (self: Unit) -> (),
	OnUpgrade: (self: Unit, Level: number) -> (),
	OnAttack: (self: Unit, Input: UnitAttackInput) -> (),
	UseAbility: (self: Unit, Index: number) -> (),
	Sell: (self: Unit) -> (),

	GetProperties: (self: Unit) -> { [UnitInfo.StatProperty]: number },
	GetNextProperties: (self: Unit) -> { [UnitInfo.StatProperty]: number }?,
	GetSpecial: (self: Unit) -> string?,

	NewUnit: Signal.Signal<Unit, boolean>,

	GetUnit: (UniqueId: string) -> Unit?,
	GetUnits: () -> { [string]: Unit },

	InitCharacter: (
		Unit: string,
		CFrame: CFrame?
	) -> {
		UnitModel: Model & any,
		Trove: Trove.Trove,
		CenterPart: BasePart,
		PlayWalk: (Enabled: boolean) -> (),
	},
	InitPlacement: (Unit: string) -> {
		Trove: Trove.Trove,
		Clicked: Signal.Signal<>,
	},

	__index: UnitModule,
}

export type Unit = typeof(setmetatable({} :: UnitData, {} :: UnitModule))

export type UnitAttackInput = {
	UniqueId: string,
	Index: number,
	EnemyId: string,
	Firetime: number,
	SpeedRatio: number,
}

export type SentData = {
	MapId: string,
	LevelId: string,
	Difficulty: string,
	Players: { Player },
}

export type RecieveData = {
	PlayerIds: { number },
	MapId: string,
	LevelId: string,
	Difficulty: string,
}

return {}
