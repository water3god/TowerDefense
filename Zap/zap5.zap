-- By Wa1er_God --

opt server_output = "../src/ReplicatedStorage/Network/Server/Server5.luau"
opt client_output = "../src/ReplicatedStorage/Network/Client/Client5.luau"
opt remote_folder = "Zap5"

type Level = u16
type XP = f64
type ProductId = f64
type Health = u32

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

event InventorySpaceChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: u32,
}
