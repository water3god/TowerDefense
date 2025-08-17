-- By Wa1er_God --
opt server_output = "../src/ReplicatedStorage/Network/Server/Server2.luau"
opt client_output = "../src/ReplicatedStorage/Network/Client/Client2.luau"
opt remote_folder = "Zap2"

type Level = u16
type XP = f64
type ProductId = f64
type Health = u32

type Time = f64

-- Trade --

-- TBD NOT DONE --
type TradeStatus = enum { InTrade, Finalized, Accepted }
type TradeStatusMessage = enum { Trading, CanTrade, TradeDisabled }

type UnitData = struct {
	Unit: string.binary,
	Level: Level,
	Trait: string.binary?,
	UniqueId: string.binary,
	XP: XP,
	NeededXP: XP,
}

type ProductData = struct {
	UniqueId: string.binary,
	Product: ProductId,
	Count: u16,
}

type ResourceData = struct {
	UniqueId: string.binary,
	Resource: string.binary,
	Count: u16,
}

-- Requests --

event TradeRequestServer = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		Instance.Player,
		f64,
	),
}

event TradeRequestClient = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: Instance.Player,
}

event TradeSync = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: map { [f64]: struct {
		Status: TradeStatusMessage,
	} },
}

-- Start Trade Event --

event TradeAccept = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: Instance.Player,
}

-- In Trade Events --

event TradeStart = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		Player1: Instance.Player,
		Player2: Instance.Player,
	},
}

event ChangeUnit = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: (
		string.binary,
		string.binary,
	),
}

event UnitChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		Instance.Player,
		(UnitData | string.binary),
		string.binary,
	),
}

event ChangeProduct = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: (
		string.binary,
		u16,
	),
}

event ProductChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		Instance.Player,
		ProductData,
	),
}

event ChangeResource = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: (
		string.binary,
		u16,
	),
}

event ResourceChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		Instance.Player,
		ResourceData,
	),
}

event ToggleStatus = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: boolean,
}

event StatusChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		Player: Instance.Player?,
		Status: TradeStatus,
	},
}

event EndTrade = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

event TradeEnd = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
}

-- Unit --

type SortType = enum { First, Last, Strongest, Weakest }
type AbilityIndex = u8

type UnitInput = struct {
	UniqueId: string.binary,
	UnitName: string.binary,
	CFrame: CFrame,
	OwnerId: f64?,
	AttackPriority: string.binary,
	Level: Level,
	RatioData: map { [string.binary]: map { [string.binary]: struct {
		Type: string.binary,
		Ratio: f32,
		EndTime: Time,
	} } },
	Trait: string.binary?,
	Abilities: f64[],
}

type UnitAttackInput = struct {
	UniqueId: string.binary,
	Index: u16,
	EnemyId: string.binary,
	Firetime: Time,
	SpeedRatio: f32,
}

type PlacementData = struct {
	Unit: string.binary,
	UnitPosition: Vector3,
	RotationIndex: u8,
}

event UnitAbilityEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string.binary,
		AbilityIndex,
		f64,
	),
}

event UnitAnimationEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		struct {
			UniqueId: string.binary,
			AnimationName: string.binary,
			SecondsAfter: f32?,
			SpeedRatio: f32?,
			FadeTime: f32?,
			Length: f32?,
			SentTime: f32,
		},
		boolean,
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
	data: string.binary[],
}

event UnitPlacementEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		map { [string.binary]: UnitInput },
		boolean,
	),
}

event UnitPriorityChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		UniqueId: string.binary,
		Priority: SortType,
	},
}

event RatioEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string.binary,
		string.binary,
		string.binary,
		struct {
			Type: string.binary,
			Ratio: f32,
			EndTime: Time,
		}?,
	),
}
event UnitUpgradeEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		UniqueId: string.binary,
		Level: Level,
	},
}

event UnitCoinsEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		UniqueId: string.binary,
		Coins: f64,
	},
}

event ChangeUnitPriority = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: string.binary,
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
	data: string.binary,
}

event UpgradeUnit = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: string.binary,
}

event UseUnitAbility = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: (
		string.binary,
		AbilityIndex,
	),
}


