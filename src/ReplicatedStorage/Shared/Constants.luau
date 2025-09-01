--!strict

-- By Wa1er_God --

local Constants = {
	BOOTHTOUCHDELAY = 0.5,
	BOOTHMAPCHOSETIME = 15,
	BOOTHWAITTIME = 15,
	BOOTHRELOADWAITTIME = 5,

	BEZIERCURVE = 5,

	INFORMATIONHASHMAP = "TOWERDEFENCEHASHMAP",

	UpdateDelay = 100,
	MainDataStore = "MainDataStorev0.03",
	LevelXPStore = "LevelXPStorev0.01",
	TotalGoldStore = "TotalGoldv0.01",
	RobuxSpentStore = "RobuxSpentStorev0.01",
	DamageStore = "DamageStorev0.01",

	LOBBYICON = "rbxassetid://82602981298420",

	WarningTime = 3,
	CostDivider = 2,
	MaxUnitCount = 15,

	CurrentEvent = "None",
	EndTime = 1, -- Unix Timestamp of event end time

	ROLLDELAYTIME = 3,
	STARTCOINS = 2000,
	ROLLCOSTS = { MAIN = 40 },
	ROLLPERCENT = 1,
	GroupId = 34745901,

	GoldReferral = 100,
	MaxReferrals = 5,
}

return table.freeze(Constants)
