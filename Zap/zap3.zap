opt server_output = "../src/ReplicatedStorage/Network/Server/Server3.luau"
opt client_output = "../src/ReplicatedStorage/Network/Client/Client3.luau"
opt remote_folder = "Zap3"

type Level = u16
type XP = f64
type ProductId = f64
type Health = u32

type Time = f64

-- Game End --

type Wave = u16
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
		Rewards: map { [u8]: map { [string]: unknown } },
		-- Rewards for each day
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
