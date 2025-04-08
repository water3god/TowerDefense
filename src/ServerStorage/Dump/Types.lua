--!strict

local GoodSignal = require(game:GetService("ReplicatedStorage").Modules.GoodSignal);

export type EnemyServerData = {
	UniqueId: string;
	ModelName: string;
	CFrame: CFrame;
	Delay: number;
	
	TranslatedY: number;

	Health: number;
	MaxHealth: number;
	Speed: number;
	Reverse: boolean;
	IsBoss: boolean;
	Ally: boolean;
	
	Nodes: {BasePart};

	Node: number;

	Stuned: boolean;
};

export type EnemyClientData = {
	Character: Model;
	Humanoid: Humanoid;
	Animator: Animator;
	Root: BasePart;
	EnemyTranslate: AlignPosition;
	EnemyRotate: AlignOrientation;
	StandardPosition: Vector3;
	
	PositionOffset: Vector3;

	CurrentCFrame: "FirstCFrame" | "SecondCFrame";
	FirstCFrame: CFrame;
	SecondCFrame: CFrame;
	
	OldCFrame: CFrame;

	StateConnection: RBXScriptConnection;

	OldPosition: Vector3;
	
	HealthChanged: GoodSignal.GoodSignal;
};

export type UnitServerData = {
	ModelName: string;
	CFrame: CFrame;
	OwnerId: number;
	AttackPriority: string;
	Level: number;
	UpgradeData: {
		[string]: {
			Range: number;
			Damage: {number};
			FireRate: number;
			Armor: string?;
			Animations: {[string]: Animation};
		};
	};
	UniqueId: string;
	CollisionRadius: number;
};

export type UnitClientData = {
	Character: Model;
	Root: BasePart;
	Animator: Animator;

	CurrentEnemyId: string?;
	Tracks: {[string]: AnimationTrack};
	
	CurrentAdornment: Model?;

	UnitTranslate: AlignPosition;
	UnitRotate: AlignOrientation;

	LookAtConnection: RBXScriptConnection;
	CollideConnection: RBXScriptConnection;
	
	LevelChanged: GoodSignal.GoodSignal;
};

export type Param = {
	ServerData: UnitClientData;
	ClientData: UnitClientData;
	EnemyData: {
		ServerData: EnemyServerData;
		ClientData: EnemyClientData;
	},
	TimeFired: number;
};

return {};