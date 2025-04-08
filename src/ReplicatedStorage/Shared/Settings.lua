--!strict

-- By Wa1er_God --

export type Settings = {};

export type Setting = "Music" | "MusicVolume" | "AutoRoll" | "CanTrade";

local Settings = {};

Settings.SettingIndexes = {
	"Music";
	"MusicVolume";
	"AutoRoll";
	"RollFrameLeft";
	"CommonSkip";
	"RareSkip";
	"EpicSkip";
	"LegendarySkip";
	"MythicSkip";
	"CanTrade";
};
Settings.SettingTypes = {
	Music = "boolean";
	MusicVolume = "number";
	AutoRoll = "boolean";
	RollFrameLeft = "boolean";
	CommonSkip = "boolean";
	RareSkip = "boolean";
	EpicSkip = "boolean";
	LegendarySkip = "boolean";
	MythicSkip = "boolean";
	CanTrade = "boolean";
};

return Settings;