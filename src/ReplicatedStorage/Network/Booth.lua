--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Red = require(Packages.Red)
local Guard = require(Packages.Guard)
local Signal = require(Packages.Signal)

export type TimeData = {
	StartTime: number,
	EndTime: number,
}

export type BoothData = {
	OwnerId: number,
	MapId: string,
	LevelId: string,
	Difficulty: string,
	Players: { Player },
} & TimeData

local BoothDataInterface = {
	OwnerId = Guard.Number,
	MapId = Guard.String,
	LevelId = Guard.String,
	Difficulty = Guard.String,
	Players = Guard.List(Guard.Instance),
}

local function CheckBoothData(UnknownValue: unknown)
	assert(type(UnknownValue) == "table")
	local Value: any = UnknownValue

	return BoothDataInterface
end

local Data = {
	FromClient = {},
	FromServer = {
		BoothChoosing = Red.Event("BoothChoosing", function(...)
			return ...
		end),
		BoothMapLoading = Red.Event("BoothMapLoading", function(...)
			return ...
		end),
		BoothRestarted = Red.Event("BoothRestarted", function()
			return
		end),
		BoothWaiting = Red.Event("BoothWaiting", function(BoothData)
			assert(typeof(BoothData) == "table")
		end),
		PlayerChanged = Red.Event("PlayerChanged", function(...)
			return ...
		end),
	},
	ClientOnly = {
		TPGuiSet = Signal.new(),
	},
}

return Data
