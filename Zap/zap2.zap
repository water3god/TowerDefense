opt server_output = "../src/ReplicatedStorage/Network/Server/Server2.luau"
opt client_output = "../src/ReplicatedStorage/Network/Client/Client2.luau"
opt remote_folder = "Zap2"

type Level = u16
type XP = f64
type ProductId = f64
type Health = u32

type Time = f64

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
