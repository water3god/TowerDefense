--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WaveEvents = ReplicatedStorage.Remotes.Waves
local HealthChanged = WaveEvents.HealthChanged
local TimeChanged = WaveEvents.TimeChanged
local WaveEnded = WaveEvents.WaveEnded
local Passed = WaveEvents.Passed
local Added = WaveEvents.Added

local VoteEvents = WaveEvents.Votes
local PlayerVoted = VoteEvents.PlayerVoted
local VoteRequest = VoteEvents.VoteRequest
local Vote = VoteEvents.Vote

local Modules = ReplicatedStorage.Modules
local Signal = require(Modules.Signal)

export type WaveData = {
	Wave: number,
	BaseHealth: number,
	MaxHealth: number,
	Time: number,
	StartTime: number,
}

local WaveData: WaveData? = nil
local VoteData: VoteData? = nil

export type VoteData = {
	Time: number,
	StartTime: number,
	CurrentCount: number,
	NeededCount: number,
}

local Module: {
	Added: Signal.Signal<WaveData>,
	HealthChanged: Signal.Signal<number, number>,
	Passed: Signal.Signal<number>,
	TimeChanged: Signal.Signal<number, number>,
	Ended: Signal.Signal<boolean>,
	Win: boolean?,

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
			Vote:FireServer()
		end,
	}

Added.OnClientEvent:Connect(function(Data: WaveData)
	WaveData = Data
	Module.Added:Fire(Data)
end)

HealthChanged.OnClientEvent:Connect(function(Data: { BaseHealth: number, MaxHealth: number })
	if WaveData then
		WaveData.BaseHealth = Data.BaseHealth
		WaveData.MaxHealth = Data.MaxHealth
		Module.HealthChanged:Fire(Data.BaseHealth, Data.MaxHealth)
	end
end)

Passed.OnClientEvent:Connect(function(Wave: number)
	if WaveData then
		WaveData.Wave = Wave
		Module.Passed:Fire(Wave)
	end
end)

TimeChanged.OnClientEvent:Connect(function(Data: { Time: number, StartTime: number })
	if WaveData then
		WaveData.Time = Data.Time
		WaveData.StartTime = Data.StartTime
		Module.TimeChanged:Fire(Data.Time, Data.StartTime)
	end
end)

WaveEnded.OnClientEvent:Connect(function(Win: boolean)
	Module.Win = Win
	if WaveData then
		Module.Ended:Fire(Win)
		WaveData = nil
	end
end)

-- Votes --

VoteRequest.OnClientEvent:Connect(function(SentData: VoteData?)
	if SentData then
		VoteData = SentData
		Module.VoteData.VoteStarted:Fire(SentData)
	else
		Module.VoteData.VoteEnded:Fire()
		VoteData = nil
	end
end)

PlayerVoted.OnClientEvent:Connect(function(Data: { CurrentCount: number, NeededCount: number })
	if VoteData then
		VoteData.CurrentCount = Data.CurrentCount
		VoteData.NeededCount = Data.NeededCount
		Module.VoteData.VoteChanged:Fire(Data.CurrentCount, Data.NeededCount)
	end
end)

return Module
