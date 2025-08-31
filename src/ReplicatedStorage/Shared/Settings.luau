--!strict

-- By Wa1er_God --

export type Settings = {}

export type Setting = "Music" | "MusicVolume" | "AutoRoll" | "CanTrade"

local Settings = {}

Settings.PreSync = {
	Music = false,
	MusicVolume = 1,
	SFXVolume = 1,
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
	SFXVolume = 1,
	AutoRoll = false,
	CommonSkip = false,
	RareSkip = false,
	EpicSkip = false,
	LegendarySkip = false,
	MythicSkip = false,
	CanTrade = true,
}

Settings.NotVisible = {
	"AutoRoll",
}

Settings.SettingIndexes = {
	"Music",
	"MusicVolume",
	"SFXVolume",
	"AutoRoll",
	"CommonSkip",
	"RareSkip",
	"EpicSkip",
	"LegendarySkip",
	"MythicSkip",
	"CanTrade",
}

Settings.Displays = {
	MusicVolume = "Music Volume",
	SFXVolume = "Sound Effect Volume",
	CommonSkip = "Common Sell",
	RareSkip = "Rare AutoSell",
	EpicSkip = "Epic AutoSell",
	LegendarySkip = "Legendary AutoSell",
	MythicSkip = "Mythic AutoSell",
}

Settings.SettingTypes = {
	Music = "boolean",
	MusicVolume = "number",
	SFXVolume = "number",
	AutoRoll = "boolean",
	CommonSkip = "boolean",
	RareSkip = "boolean",
	EpicSkip = "boolean",
	LegendarySkip = "boolean",
	MythicSkip = "boolean",
	CanTrade = "boolean",
}

return table.freeze(Settings)
