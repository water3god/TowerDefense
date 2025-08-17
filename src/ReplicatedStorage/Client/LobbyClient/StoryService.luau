--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Network = require(ReplicatedStorage.Network.Client)

local ChooseMap = Network.ChooseMap
local LeaveBooth = Network.LeaveBooth
local OwnerStart = Network.OwnerStart

local BoothChoosing = Network.BoothChoosing
local BoothMapLoading = Network.BoothMapLoading
local BoothRestarted = Network.BoothRestarted
local BoothWaiting = Network.BoothWaiting
local PlayerChanged = Network.BoothPlayerChanged

local DataSync = Network.StoryDataSync

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)

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

export type MapCrossData = {
	MapId: string,
	LevelId: string,
	Difficulty: string,
}

export type StageData = {
	FastestTime: number,
	FinishedCount: number,
}

export type InfiniteStageData = {
	Wave: number,
	Damage: number,
}

-- First is MapId, then is Stage number, then Difficulty
export type MapData = { [string]: { [number]: { [string]: StageData } } }
export type InfiniteMapData = { [string]: { [number]: { [string]: InfiniteStageData } } }

local Module: {
	MapData: MapData,
	InfiniteMapData: InfiniteMapData,
	MapDataChanged: Signal.Signal<MapData>,
	InfiniteMapDataChanged: Signal.Signal<InfiniteMapData>,
	Data: BoothData?,
	-- Owner has been initated and he is chooing the map (No one else can join)
	BoothChoosing: Signal.Signal<TimeData>,
	-- Map has started and is in Loading phase --
	BoothMapLoading: Signal.Signal<>,
	-- Map has fully sent players and can load new players --
	BoothRestarted: Signal.Signal<>,
	-- Waiting for Players to Join Booth already Inititiated --
	BoothWaiting: Signal.Signal<BoothData>,
	-- Player Added or Removed from Booth --
	PlayerChanged: Signal.Signal<number, boolean, boolean>,

	ChooseMap: (Data: MapCrossData) -> (),
	LeaveBooth: () -> (),
	OwnerStart: () -> (),
} =
	{
		MapData = {},
		InfiniteMapData = {},
		MapDataChanged = Signal.new(),
		InfiniteMapDataChanged = Signal.new(),
		BoothChoosing = Signal.new(),
		BoothMapLoading = Signal.new(),
		BoothRestarted = Signal.new(),
		BoothWaiting = Signal.new(),
		PlayerChanged = Signal.new(),
		ChooseMap = function(Data: MapCrossData)
			ChooseMap.Fire(Data)
		end,
		LeaveBooth = function()
			LeaveBooth.Fire()
		end,
		OwnerStart = function()
			OwnerStart.Fire()
		end,
	}

BoothChoosing.SetCallback(function(Data)
	Module.BoothChoosing:Fire(Data)
end)

BoothMapLoading.SetCallback(function()
	Module.BoothMapLoading:Fire()
end)

BoothRestarted.SetCallback(function()
	Module.BoothRestarted:Fire()
	Module.Data = nil
end)

BoothWaiting.SetCallback(function(Data: any)
	print("Set")
	Module.Data = Data
	Module.BoothWaiting:Fire(Data)
end)

PlayerChanged.SetCallback(function(PlayerId: number, Added: boolean)
	local Changed = false
	local Player = Players:GetPlayerByUserId(PlayerId)

	if Module.Data then
		local Data = Module.Data
		if Player then
			if Added then
				if not table.find(Data.Players, Player) then
					table.insert(Data.Players, Player)
					Changed = true
				end
			else
				if Player == LocalPlayer then
					Module.BoothRestarted:Fire()
					Module.Data = nil
					return
				end
				local Index = table.find(Data.Players, Player)
				if Index then
					table.remove(Data.Players, Index)
					Changed = true
				end
			end
		end
	end
	Module.PlayerChanged:Fire(PlayerId, Added, Changed)
end)

DataSync.SetCallback(function(Data: MapData, InfiniteData: InfiniteMapData)
	Module.MapData = Data
	Module.InfiniteMapData = InfiniteData
	Module.MapDataChanged:Fire(Data)
	Module.InfiniteMapDataChanged:Fire(InfiniteData)
end)

return Module
