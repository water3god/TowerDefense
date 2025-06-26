-- By Wa1er_God --

opt server_output = "./src/ReplicatedStorage/Network/Server.luau"
opt client_output = "./src/ReplicatedStorage/Network/Client.luau"
opt types_output = "./src/ReplicatedStorage/Network/Types.luau"
opt remote_folder = "Zap"

type Level = u16
type XP = f64
type ProductId = f64
type Health = u32

type Time = f64

-- Booth --

type Difficulty = enum { Normal, Hard, Insane }

type StageData = struct {
	FastestTime: Time,
	FinishedCount: u16,
}

type TimeData = struct {
	StartTime: Time,
	EndTime: Time,
}

type BoothData = struct {
	OwnerId: u32,
	MapId: string,
	LevelId: string,
	Difficulty: string,
	Players: Instance(Player)[],
	StartTime: Time,
	EndTime: Time,
}

event ChooseMap = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		MapId: string,
		LevelId: string,
		Difficulty: Difficulty,
	},
}

event LeaveBooth = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

event OwnerStart = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

event TPGuiSet = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		MapName: string,
		ImageId: string,
	},
}

event StoryDataSync = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: map { [string]: map { [u8]: map { [Difficulty]: StageData } } },
}

event BoothChoosing = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: TimeData,
}

event BoothMapLoading = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
}

event BoothRestarted = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
}

event BoothWaiting = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		BoothData: BoothData,
	),
}

event BoothPlayerChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		u32,
		boolean,
	),
}

-- Enemy --

type SpeedChange = struct {
	TimeStart: Time,
	Speed: f64,
	TimeEnd: Time?,
}

type EnemyInput = struct {
	UniqueId: string,
	ModelName: string,
	Health: Health,
	MaxHealth: Health,
	Speed: f64,
	IsBoss: boolean,
	Ally: boolean,
	OriginalSpeed: f64,
	VectorOffset: Vector3,
	BezierId: string,
	TimePosition: Time,
	Time: Time,
	AdornmentName: string?,
	SpeedChanges: SpeedChange[],
}

event EnemyDestroyEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string[],
		boolean,
	),
}

event EnemyHealthEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string,
		f64,
		f64,
	),
}

event EnemyLocationEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string,
		Vector3[],
	),
}

event EnemySpawnEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		EnemyInput,
		boolean,
	),
}

event EnemySpeedEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: SpeedChange,
}

-- Inventory --

type VisualUnitData = struct {
	Unit: string,
	Level: Level,
	UniqueId: string,
	XP: f64,
	NeededXP: f64,
}

type ProductData = struct {
	ProductId: ProductId,
	IsGamepass: boolean,
	Count: u16,
	UniqueId: string,
}

type ResourceData = struct {
	Resource: string,
	Count: u32,
	UniqueId: string,
	PartialOneLose: boolean?,
}

type Inventory = struct {
	Units: map { [string]: VisualUnitData },
	Products: map { [string]: ProductData },
	Resources: map { [string]: ResourceData },
}

type LevelData = struct {
	Level: Level,
	XP: XP,
	NeededXP: XP,
}

type Item = enum { Units, Products, Resources }

event EquipUnit = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		UniqueId: string,
		Equip: boolean,
	},
}

event InventorySync = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		Inventory,
		string[],
		LevelData,
		u16,
	),
}

event ItemChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		Item,
		string,
		unknown,
	),
}

event ItemSell = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: string[],
}

event UnitEquipped = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		UniqueId: string,
		Index: u8,
		Equip: boolean,
	},
}

-- Level --

event LevelChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: Level,
}

event LevelXPChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: XP,
}

-- Marketplace --

-- Maybe don't use --
event ProductPurchased = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
}

event UseProduct = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: (
		ProductId,
		boolean,
	),
}

-- Roll --

type RollData = struct {
	SentTime: Time,
	Data: string[],
	AutoRoll: boolean,
}

event AutoRoll = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: boolean,
}

event RollEventServer = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: RollData,
}

event RollEventClient = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: u8,
}

event StopAutoRoll = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

-- Settings --

event ChangeSettingClient = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: (
		string,
		unknown,
	),
}

event ChangeSettingServer = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string,
		unknown,
	),
}

event SendSettings = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: unknown[],
}

event SettingSync = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: map { [string]: unknown },
}

-- Trade --

-- TBD NOT DONE --

type TradeStatus = enum { InTrade, Finalized, Accepted }
type TradeStatusMessage = enum { Trading, CanTrade, TradeDisabled }

event ChangeProduct = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

event ChangeUnit = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: (
		string,
		string,
	),
}

event ProductChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
}

event TradeAccept = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: Instance(Player),
}

event TradeEnd = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
}

event TradeRequestServer = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		Instance(Player),
		f64,
	),
}

event TradeRequestClient = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: Instance(Player),
}

event TradeStart = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		Player1: Instance(Player),
		Player2: Instance(Player),
	},
}

event TradeSync = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: map { [f64]: struct {
		Status: TradeStatusMessage,
	} },
}

event UnitChanged = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: (
		unknown,
		Instance(Player),
		string,
	),
}

-- Unit --

type SortType = enum { First, Last, Strongest, Weakest }
type AbilityIndex = u8

type UnitInput = struct {
	UniqueId: string,
	UnitName: string,
	CFrame: CFrame,
	OwnerId: f64?,
	AttackPriority: string,
	Level: Level,
	CollisionRadius: f32,
	SpeedRatio: f32,
	Abilities: f64[],
}

type UnitAttackInput = struct {
	UniqueId: string,
	Index: u16,
	EnemyId: string,
	Firetime: Time,
	SpeedRatio: f32,
}

type PlacementData = struct {
	Unit: string,
	UnitPosition: Vector3,
	RotationIndex: u8,
}

event UnitAbilityEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string,
		AbilityIndex,
		f64,
	),
}

event UnitAnimationEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string,
		string,
		f32?,
		f32?,
		f32?,
		f32?,
		f32,
	),
}

event UnitAttack = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: UnitAttackInput,
}

event UnitDestroyEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: string[],
}

event UnitPlacementEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		map { [string]: UnitInput },
		boolean,
	),
}

event UnitPriorityChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		UniqueId: string,
		Priority: SortType,
	},
}

event SpeedRatioEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string,
		string,
		struct {
			SpeedRatio: f32,
			EndTime: Time,
		},
	),
}

event UnitUpgradeEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		UniqueId: string,
		Level: Level,
	},
}

event ChangeUnitPriority = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: string,
}

event PlaceUnit = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: PlacementData,
}

event SellUnit = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: string,
}

event UpgradeUnit = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: string,
}

event UseUnitAbility = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: (
		string,
		AbilityIndex,
	),
}

-- Game End --

type Vote = u16

event OnEnd = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		VotedCount: Vote,
		Win: boolean,
	},
}

event OnEndVote = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: Vote,
}

event EndVoteAction = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

-- Votes --

type Wave = u16

type VoteData = struct {
	Time: Time,
	StartTime: Time,
	CurrentCount: Vote,
	NeededCount: Vote,
}

event PlayerVoted = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		CurrenctCount: Vote,
		NeededCount: Vote,
	},
}

event VoteSkip = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

event VoteRequest = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: VoteData?,
}

-- Wave --

type WaveData = struct {
	Wave: Wave,
	BaseHealth: Health,
	MaxHealth: Health,
	Time: Time,
	StartTime: Time,
}

event WaveAdded = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: WaveData,
}

event WaveHealthChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		BaseHealth: Health,
		MaxHealth: Health,
	},
}

event WavePassed = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: Wave,
}

event TimeChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		Time: Time,
		StartTime: Time,
	},
}

event WaveEnded = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		boolean,
		unknown,
		unknown,
		f64,
	),
}

-- Warning --

event SendWarning = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string,
		Color3?,
	),
}

-- Currency --

event CurrencyChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: f64,
}

-- Misc --

event AllEquippedSync = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: map { [Instance(Player)]: string[] },
}

event TeleportBack = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}
