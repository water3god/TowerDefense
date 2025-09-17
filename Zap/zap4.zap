-- By Wa1er_God --
opt server_output = "../src/ReplicatedStorage/Network/Server/Server4.luau"
opt client_output = "../src/ReplicatedStorage/Network/Client/Client4.luau"
opt remote_folder = "Zap4"

type Level = u16

-- Titles --

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

-- Misc --

event AllEquippedSync = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: map { [Instance.Player]: struct {
		Title: string.binary,
		Level: Level,
		EquippedUnits: struct {
			Id: string.binary,
			Level: Level,
			UnitName: string.binary,
		}?[],
	} },
}

event TeleportBack = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: boolean,
}

-- Quests --

type QuestRemoteInfo = struct {
	Id: string.binary,
	CurrentValue: f64,
	Redeemed: boolean,
	Data: unknown,
}

event QuestSync = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		DailyQuests: QuestRemoteInfo[],
		WeeklyQuests: QuestRemoteInfo[],
		EventQuests: QuestRemoteInfo[],
		GlobalQuests: QuestRemoteInfo[],
	},
}

event QuestChanged = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: QuestRemoteInfo[],
}

event RedeemQuest = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: string.binary,
}

-- Starter --

event FirstJoin = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
}

event ChooseStarter = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: string.binary,
}

event TutorialSent = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		PassedGameTutorial: boolean,
	),
}

event AcceptTutorial = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

-- Evolution --

event EvolveUnit = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		UniqueId: string.binary,
	},
}

event UnitEvolved = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		UnitName: string.binary,
	},
}

-- Traits --

event RollTrait = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		UniqueId: string.binary,
	},
}

event TraitRolled = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		UniqueId: string.binary,
		NewTrait: string.binary,
	},
}

-- Boosts --

event BoostsSync = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: map { [string.binary]: f64 },
}

-- Rejoin --

event RejoinPrompted = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
}

event Rejoin = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}
