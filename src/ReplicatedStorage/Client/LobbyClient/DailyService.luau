--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Network = require(ReplicatedStorage.Network.Client)
local RedeemDailyReward = Network.RedeemDailyReward
local DailySync = Network.DailySync
local DailyRedeemed = Network.DailyRedeemed

export type DailyData = {
	Day: number,
	LastRedeemed: number,
}

local function RedeemDaily()
	RedeemDailyReward.Fire()
end

local Module: {
	RedeemDaily: () -> (),
	Day: number,
	LastRedeemed: number,
	IsSynced: boolean,
	Synced: Signal.Signal<DailyData>,
	Redeemed: Signal.Signal<DailyData>,
} =
	{
		RedeemDaily = RedeemDaily,
		Day = 1,
		LastRedeemed = workspace:GetServerTimeNow(),
		IsSynced = false,
		Synced = Signal.new(),
		Redeemed = Signal.new(),
	}

DailySync.SetCallback(function(Data: DailyData)
	Module.Day = Data.Day
	Module.LastRedeemed = Data.LastRedeemed
	Module.IsSynced = true
	Module.Synced:Fire(Data)
	return
end)

DailyRedeemed.SetCallback(function(Data: DailyData)
	Module.Day = Data.Day
	Module.LastRedeemed = Data.LastRedeemed
	Module.Redeemed:Fire(Data)
end)

return Module
