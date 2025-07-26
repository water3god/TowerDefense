-- By Wa1er_God --

opt server_output = "../src/ReplicatedStorage/Network/Server/Server1.luau"
opt client_output = "../src/ReplicatedStorage/Network/Client/Client1.luau"
opt remote_folder = "Zap1"

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
	MapId: string.binary,
	LevelId: string.binary,
	Difficulty: string.binary,
	Players: Instance.Player[],
	StartTime: Time,
	EndTime: Time,
}

event ChooseMap = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		MapId: string.binary,
		LevelId: string.binary,
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
		MapName: string.binary,
		ImageId: string.binary,
	},
}

event StoryDataSync = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: map { [string.binary]: map { [u8]: map { [Difficulty]: StageData } } },
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

type SpeedChangeData = struct {
	TimeStart: Time,
	Speed: f64,
	TimeEnd: Time?,
}

type SpeedChange = struct {
	UniqueId: string.binary,
	Speed: f32,
	Time: f64,
}

type EnemyInput = struct {
	UniqueId: string.binary,
	ModelName: string.binary,
	Health: Health,
	MaxHealth: Health,
	Speed: f64,
	IsBoss: boolean,
	Ally: boolean,
	OriginalSpeed: f64,
	VectorOffset: Vector3,
	BezierId: string.binary,
	TimePosition: Time,
	Time: Time,
	AdornmentName: string.binary?,
	SpeedChanges: SpeedChangeData[],
}

event EnemyDestroyEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string.binary[],
		boolean,
	),
}
event EnemyHealthEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string.binary,
		f64,
		f64,
	),
}

event EnemyLocationEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string.binary,
		Vector3[]?,
	),
}

event EnemySpawnEvent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		map { [string.binary]: EnemyInput },
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
	Unit: string.binary,
	Level: Level,
	Trait: string.binary?,
	UniqueId: string.binary,
	XP: f64,
	NeededXP: f64,
}

type ProductData = struct {
	ProductId: ProductId,
	IsGamepass: boolean,
	Count: u16,
	UniqueId: string.binary,
}

type ResourceData = struct {
	Resource: string.binary,
	Count: u32,
	UniqueId: string.binary,
	PartialOneLose: boolean?,
}

type Inventory = struct {
	Units: map { [string.binary]: VisualUnitData },
	Products: map { [string.binary]: ProductData },
	Resources: map { [string.binary]: ResourceData },
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
		UniqueId: string.binary,
		Equip: boolean,
	},
}

event InventorySync = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		Inventory,
		string.binary?[],
		LevelData,
		u16,
		struct {
			EquippedTitle: string.binary,
			Titles: string.binary[],
		},
	),
}

event ItemChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		Item,
		string.binary,
		unknown,
	),
}

event ItemSell = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: (
		string.binary,
		string.binary[],
	),
}

event UnitEquipped = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		UniqueId: string.binary,
		Index: u8,
		Equip: boolean,
	},
}

event TitleChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: string.binary,
}

event TitleAdded = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: string.binary,
}

event EquipTitle = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: string.binary,
}
