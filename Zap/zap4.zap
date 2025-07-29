-- By Wa1er_God --
opt server_output = "../src/ReplicatedStorage/Network/Server/Server4.luau"
opt client_output = "../src/ReplicatedStorage/Network/Client/Client4.luau"
opt remote_folder = "Zap4"

type Level = u16

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
