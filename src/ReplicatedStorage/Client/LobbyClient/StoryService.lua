--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Modules = ReplicatedStorage.Modules
local Signal = require(Modules.Signal)

local Remotes = ReplicatedStorage.Remotes
local BoothEvents = Remotes.Booth

local ClientFires = BoothEvents.ClientFires
local ChooseMap: RemoteEvent = ClientFires.ChooseMap
local LeaveBooth: RemoteEvent = ClientFires.LeaveBooth
local OwnerStart: RemoteEvent = ClientFires.OwnerStart

local ServerFires = BoothEvents.ServerFires
local BoothChoosing: RemoteEvent = ServerFires.BoothChoosing
local BoothMapLoading: RemoteEvent = ServerFires.BoothMapLoading
local BoothRestarted: RemoteEvent = ServerFires.BoothRestarted
local BoothWaiting: RemoteEvent = ServerFires.BoothWaiting
local PlayerChanged: RemoteEvent = ServerFires.PlayerChanged
--local TPGuiSet = ServerFires.TPGuiSet

local DataEvents = BoothEvents.DataEvents
local DataSync: RemoteEvent = DataEvents.DataSync

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

-- First is MapId, then is Stage number, then Difficulty
export type MapData = { [string]: { [number]: { [string]: StageData } } }

local Module: {
	MapData: MapData,
	MapDataChanged: Signal.Signal<MapData>,
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
		MapDataChanged = Signal.new(),
		BoothChoosing = Signal.new(),
		BoothMapLoading = Signal.new(),
		BoothRestarted = Signal.new(),
		BoothWaiting = Signal.new(),
		PlayerChanged = Signal.new(),
		ChooseMap = function(Data: MapCrossData)
			ChooseMap:FireServer(Data)
		end,
		LeaveBooth = function()
			LeaveBooth:FireServer()
		end,
		OwnerStart = function()
			OwnerStart:FireServer()
		end,
	}

BoothChoosing.OnClientEvent:Connect(function(Data)
	Module.BoothChoosing:Fire(Data)
end)

BoothMapLoading.OnClientEvent:Connect(function()
	Module.BoothMapLoading:Fire()
end)

BoothRestarted.OnClientEvent:Connect(function()
	Module.BoothRestarted:Fire()
	Module.Data = nil
end)

BoothWaiting.OnClientEvent:Connect(function(Data)
	Module.Data = Data
	Module.BoothWaiting:Fire(Data)
end)

PlayerChanged.OnClientEvent:Connect(function(PlayerId: number, Added: boolean)
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

DataSync.OnClientEvent:Connect(function(Data: MapData)
	Module.MapData = Data
	Module.MapDataChanged:Fire(Data)
end)

return Module
