--!strict

-- By Wa1er_God --

local Version = 0.99

local Constants = {
	BOOTHTOUCHDELAY = 0.5,
	BOOTHMAPCHOSETIME = 15,
	BOOTHWAITTIME = 15,
	BOOTHRELOADWAITTIME = 5,

	MAPSTORETIME = 172800,

	BEZIERCURVE = 5,

	INFORMATIONHASHMAP = "TOWERDEFENCEHASHMAP",

	BASEINVENTORYUNITSPACE = 100,

	UpdateDelay = 100,
	MainDataStore = "MainDataStorev" .. Version,
	LevelXPStore = "LevelXPStorev" .. Version,
	TotalGoldStore = "TotalGoldv" .. Version,
	RobuxSpentStore = "RobuxSpentStorev" .. Version,
	DamageStore = "DamageStorev" .. Version,

	LOBBYICON = "rbxassetid://82602981298420",

	WarningTime = 3,
	CostDivider = 2,
	MaxUnitCount = 15,

	CurrentEvent = "None",
	EndTime = 1, -- Unix Timestamp of event end time

	ROLLDELAYTIME = 3,
	STARTCOINS = 400,
	ROLLCOSTS = { MAIN = 40 },
	ROLLPERCENT = 1,
	GroupId = 34745901,

	GoldReferral = 100,
	MaxReferrals = 5,
}

return table.freeze(Constants)
