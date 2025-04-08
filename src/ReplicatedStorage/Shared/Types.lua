--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Modules = ReplicatedStorage.Modules;
local Trove = require(Modules.Trove);
local Signal = require(Modules.Signal);
local BezierPath = require(Modules.BezierPath);

local ModelStorage = ReplicatedStorage.ModelStorage;
local Extra = ModelStorage.Extra;
local CollisionRadius = Extra.CollisionRadius;
local Rig = Extra.Rig;

export type Status = "InTrade" | "Finalized" | "Accepted";
export type TradeStatusMessage = "Trading" | "CanTrade" | "TradeDisabled";

-- Inventory Types --

export type VisualUnitData = {
	Unit: string;
	Level: number;
	UniqueId: string;
	XP: number;
	NeededXP: number;
};

export type RawUnitData = {
	Unit: string;
	Level: number;
};

export type RewardData = {
	Reward: string;
	Count: number;
};

-- Trade Type --

export type TradeData = {
	OtherPlayer: Player;
	YourUnits: {};
	OtherUnits: {};
	Status: Status;
	YourStatus: Status;
	OtherStatus: Status;
};

-- Enemy Types --

export type EnemyInput = {
	UniqueId: string;
	ModelName: string;
	Health: number;
	MaxHealth: number;
	Speed: number;
	Reverse: boolean;
	IsBoss: boolean;
	OriginalSpeed: number;
	VectorOffset: Vector3;
	BezierId: string;
	TimePosition: number;
	Time: number;
	AdornmentName: string?;
	SpeedChanges: {{TimeStart: number, Speed: number, TimeEnd: number?}};
};

type EnemyData = {
	UniqueId: string;
	Trove: Trove.Trove;

	Character: typeof(Rig);
	Root: typeof(Rig.HumanoidRootPart);
	Humanoid: typeof(Rig.Humanoid);
	Animator: typeof(Rig.Humanoid.Animator);
	Adornment: Model?;
	SizeRatio: number;
	CFrame: CFrame;

	ModelName: string;
	Health: number;
	MaxHealth: number;
	Speed: number;
	Reverse: boolean;
	IsBoss: boolean;
	
	OriginalSpeed: number;
	VectorOffset: Vector3;

	TimePosition: number;
	SpeedChanges: {{TimeStart: number, Speed: number, TimeEnd: number?}};
	Bezier: BezierPath.Path;
	PathLength: number;

	YOffset: number;
	Animations: {[string]: AnimationTrack};

	SpeedChanged: Signal.Signal<number>;
	HealthChanged: Signal.Signal<number>;
	MaxHealthChanged: Signal.Signal<number>;
	ReachedEnd: Signal.Signal<>;
	Destroying: Signal.Signal<>;
};

export type EnemyModule = {
	GetAnimationRatio: (self: EnemyClient) -> number;
	
	GetEnemy: (UniqueId: string) -> EnemyClient?;

	GetEnemies: () -> {[string]: EnemyClient};

	NewEnemy: Signal.Signal<EnemyClient>;

	__index: EnemyModule;
};

export type EnemyClient = typeof(setmetatable({} :: EnemyData, {} :: EnemyModule));

-- Unit Types --

export type UnitInput = {
	UniqueId: string;
	ModelName: string;
	CFrame: CFrame;
	OwnerId: number?;
	AttackPriority: string;
	Level: number;
	CollisionRadius: number;
	SpeedRatio: number;
	UpgradeData: UpgradeData;
};


type UnitData = {
	UniqueId: string;
	Trove: Trove.Trove;

	AttackTrove: Trove.Trove;
	
	Character: typeof(Rig);
	Armor: Model?;
	Root: typeof(Rig.HumanoidRootPart);
	CenterPart: BasePart;
	Humanoid: typeof(Rig.Humanoid);
	Animator: typeof(Rig.Humanoid.Animator);
	RadiusPart: typeof(CollisionRadius);
	
	VisualCFrame: CFrame;
	VectorOffset: Vector3;

	ModelName: string;
	CFrame: CFrame;
	OwnerId: number?;
	AttackPriority: string;
	Level: number;	
	CollisionRadius: number;
	UpgradeData: UpgradeData;
	
	SpeedRatio: number;
	SizeRatio: number;

	UnitAttacks: {[number]: {(Unit: Unit, AttackInput: UnitAttackInput, Enemy: EnemyClient?, Delay: number) -> ()}};
	Animations: {[string]: AnimationTrack};

	Attacked: Signal.Signal<>;
	Upgraded: Signal.Signal<number>;
	Destroying: Signal.Signal<>;
};

export type UnitModule = {
	TPToRootPosition: (self: Unit) -> ();
	PlayAnimation: (self: Unit, AnimationName: string, SecondsAfter: number?, SpeedRatio: number?) -> AnimationTrack?;
	Watch: (self: Unit, Anim: AnimationTrack, Funcs: {{TimeRatio: number, PlayAfter: boolean, Func: () -> ()}}) -> ();
	RotateToEnemy: (self: Unit, Enemy: EnemyClient) -> ();
	RotateTo: (self: Unit, Degree: number) -> ();
	
	ApplyDetail: (self: Unit) -> ();
	
	LevelUp: (self: Unit) -> ();
	OnUpgrade: (self: Unit, Level: number) -> ();
	OnAttack: (self: Unit, Input: UnitAttackInput) -> ();

	NewUnit: Signal.Signal<Unit>;
	
	GetUnit: (UniqueId: string) -> Unit?;
	GetUnits: () -> {[string]: Unit};
	
	InitPlacement: (Unit: string) -> Trove.Trove;

	__index: UnitModule;
};

export type Unit = typeof(setmetatable({} :: UnitData, {} :: UnitModule));

export type UpgradeData = {
	[number]: {
		Range: number;
		Damage: number;
		Animations: any;
		FireRate: number;
		Armor: string?;
		Vector3Offset: Vector3?;
	};
};

export type UnitAttackInput = {
	UniqueId: string;
	Index: number;
	EnemyId: string;
	Firetime: number;
	SpeedRatio: number;
}

export type SentData = {
	MapId: string;
	LevelId: string;
	Difficulty: string;
	Players: {Player};
};

export type RecieveData = {
	LevelId: string;
	Difficulty: string;
};

return {};