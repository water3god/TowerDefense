--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require(ReplicatedStorage.Network.Client)

local HealthChanged = Network.WaveHealthChanged
local TimeChanged = Network.TimeChanged
local WaveEnded = Network.WaveEnded
local Passed = Network.WavePassed
local Added = Network.WaveAdded

local PlayerVoted = Network.PlayerVoted
local VoteRequest = Network.VoteRequest
local Vote = Network.VoteSkip

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)

export type WaveData = {
	Wave: number,
	BaseHealth: number,
	MaxHealth: number,
	WaveSpeed: number,
	Time: number,
	StartTime: number,
	MapId: string,
	StageId: string,
}

local WaveData: WaveData? = nil
local VoteData: VoteData? = nil

export type VoteData = {
	Time: number,
	StartTime: number,
	CurrentCount: number,
	NeededCount: number,
}

export type MainXPData = {
	OldXP: number,
	NewXP: number,
	OldLevel: number,
	NewLevel: number,
}

export type UnitXPData = {
	Trait: string,
	OldXP: number,
	NewXP: number,
	OldLevel: number,
	NewLevel: number,
}

local Module: {
	Added: Signal.Signal<WaveData>,
	HealthChanged: Signal.Signal<number, number>,
	Passed: Signal.Signal<number>,
	TimeChanged: Signal.Signal<number, number>,
	Ended: Signal.Signal<boolean, GameInfo.ResourceData, any, number>,
	Win: boolean?,
	Percentage: number?,
	EndData: GameInfo.ResourceData?,
	MainXPData: MainXPData?,

	VoteData: {
		VoteStarted: Signal.Signal<VoteData>,
		VoteChanged: Signal.Signal<number, number>,
		VoteEnded: Signal.Signal<>,
	},

	GetWaveData: () -> WaveData?,
	GetVoteData: () -> VoteData?,
	Vote: () -> (),
} =
	{
		Added = Signal.new(),
		HealthChanged = Signal.new(),
		Passed = Signal.new(),
		TimeChanged = Signal.new(),
		Ended = Signal.new(),
		Win = nil,
		Percentage = nil,
		EndData = nil,

		VoteData = {
			VoteStarted = Signal.new(),
			VoteChanged = Signal.new(),
			VoteEnded = Signal.new(),
		},

		GetWaveData = function()
			return WaveData
		end,
		GetVoteData = function()
			return VoteData
		end,
		Vote = function()
			Vote.Fire()
		end,
	}

Added.SetCallback(function(Data: WaveData)
	WaveData = Data
	Module.Added:Fire(Data)
end)

HealthChanged.SetCallback(function(Data: { BaseHealth: number, MaxHealth: number })
	if WaveData then
		WaveData.BaseHealth = Data.BaseHealth
		WaveData.MaxHealth = Data.MaxHealth
		Module.HealthChanged:Fire(Data.BaseHealth, Data.MaxHealth)
	end
end)

Passed.SetCallback(function(Wave: number)
	if WaveData then
		WaveData.Wave = Wave
		Module.Passed:Fire(Wave)
	end
end)

TimeChanged.SetCallback(function(Data: { Time: number, StartTime: number })
	if WaveData then
		WaveData.Time = Data.Time
		WaveData.StartTime = Data.StartTime
		Module.TimeChanged:Fire(Data.Time, Data.StartTime)
	end
end)

WaveEnded.SetCallback(function(Win: boolean, Data: GameInfo.ResourceData, OtherData: MainXPData, Percentage: number)
	Module.Win = Win
	Module.EndData = Data
	Module.MainXPData = OtherData
	Module.Percentage = Percentage
	if WaveData then
		Module.Ended:Fire(Win, Data, OtherData, Percentage)
		WaveData = nil
	end
end)

-- Votes --

VoteRequest.SetCallback(function(SentData: VoteData?)
	if SentData then
		VoteData = SentData
		Module.VoteData.VoteStarted:Fire(SentData)
	else
		Module.VoteData.VoteEnded:Fire()
		VoteData = nil
	end
end)

PlayerVoted.SetCallback(function(Data: { CurrentCount: number, NeededCount: number })
	if VoteData then
		VoteData.CurrentCount = Data.CurrentCount
		VoteData.NeededCount = Data.NeededCount
		Module.VoteData.VoteChanged:Fire(Data.CurrentCount, Data.NeededCount)
	end
end)

return Module
