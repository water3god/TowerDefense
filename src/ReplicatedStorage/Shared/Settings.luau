--!strict

-- By Wa1er_God --

export type Settings = {}

export type Setting = "Music" | "MusicVolume" | "AutoRoll" | "CanTrade"

local Settings = {}

Settings.PreSync = {
	Music = false,
	MusicVolume = 1,
	AutoRoll = false,
	CommonSkip = false,
	RareSkip = false,
	EpicSkip = false,
	LegendarySkip = false,
	MythicSkip = false,
	CanTrade = false,
}

Settings.Default = {
	Music = true,
	MusicVolume = 1,
	AutoRoll = false,
	CommonSkip = false,
	RareSkip = false,
	EpicSkip = false,
	LegendarySkip = false,
	MythicSkip = false,
	CanTrade = true,
}

Settings.SettingIndexes = {
	"Music",
	"MusicVolume",
	"AutoRoll",
	"CommonSkip",
	"RareSkip",
	"EpicSkip",
	"LegendarySkip",
	"MythicSkip",
	"CanTrade",
}
Settings.SettingTypes = {
	Music = "boolean",
	MusicVolume = "number",
	AutoRoll = "boolean",
	CommonSkip = "boolean",
	RareSkip = "boolean",
	EpicSkip = "boolean",
	LegendarySkip = "boolean",
	MythicSkip = "boolean",
	CanTrade = "boolean",
}

return Settings
