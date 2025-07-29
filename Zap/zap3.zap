-- By Wa1er_God --
opt server_output = "../src/ReplicatedStorage/Network/Server/Server3.luau"
opt client_output = "../src/ReplicatedStorage/Network/Client/Client3.luau"
opt remote_folder = "Zap3"

type Level = u16
type XP = f64
type ProductId = f64
type Health = u32

type Time = f64

-- Roll --

type RollData = struct {
	SentTime: Time,
	Data: struct {
		Name: string.binary,
		Id: string.binary,
	}[],
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

event StopAutoRollServer = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
}

event StopAutoRollClient = {
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
		string.binary,
		unknown,
	),
}

event ChangeSettingServer = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string.binary,
		unknown,
	),
}

event SendSettings = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: unknown,
}

event SettingSync = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: map { [string.binary]: unknown },
}

-- Game End --

type Wave = u16
type Vote = u16

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

event OnEnd = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		VotedCount: Vote,
		Win: boolean,
		Players: Instance.Player[],
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
		CurrentCount: Vote,
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

type WaveData = struct {
	Wave: Wave,
	BaseHealth: Health,
	MaxHealth: Health,
	Time: Time,
	StartTime: Time,
}

type ResourceData = struct {
	Units: string.binary[],
	Resources: struct {
		Resource: string.binary,
		Count: u32,
	}[],
	ExistingUnits: struct {
		Name: string.binary,
		OldLevel: Level,
		NewLevel: Level,
		OldXP: XP,
		NewXP: XP,
	}[],
}

type MainXPData = struct {
	OldXP: XP,
	NewXP: XP,
	OldLevel: Level,
	NewLevel: Level,
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
		ResourceData,
		MainXPData,
		f64,
	),
}

-- Warning --

event SendWarning = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: (
		string.binary,
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

-- Daily --

event RedeemDailyReward = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

event DailySync = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		Day: u8,
		LastRedeemed: Time,
	},
}

event DailyRedeemed = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		Day: u8,
		LastRedeemed: Time,
	},
}
