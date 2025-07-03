--!strict

-- By Wa1er_God --

local TradeRequestTime: number = 15

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Types = require(ReplicatedStorage.Shared.Types)

local Network = require(ReplicatedStorage.Network.Client)

local ChangeProduct = Network.ChangeProduct
local ChangeUnit = Network.ChangeUnit
local TradeAccept = Network.TradeAccept
local TradeEnd = Network.TradeEnd
local TradeRequestClient = Network.TradeRequestClient
local TradeRequestServer = Network.TradeRequestServer
local TradeStart = Network.TradeStart
local TradeSync = Network.TradeSync

local UnitChanged = Network.UnitChanged
local ProductChanged = Network.ProductChanged

local Data = {}

Data.NewTradeRequest = Signal.new()
Data.RequestEnded = Signal.new()

Data.NewTrade = Signal.new()
Data.Ended = Signal.new()

Data.UnitAdded = Signal.new()
Data.UnitRemoving = Signal.new()
Data.ProductAdded = Signal.new()
Data.ProductRemoving = Signal.new()

local TradeStatuses: { [Player]: Types.TradeStatusMessage } = {}
Data.TradeStatuses = TradeStatuses

Data.SyncedStatus = Signal.new()

Data.TradeRequests = {}

Data.TradeRequestTime = TradeRequestTime

local CurrentTradeData: Types.TradeData? = nil

export type TradeData = Types.TradeData
export type VisualUnitData = Types.VisualUnitData
export type TradeStatusMessage = Types.TradeStatusMessage

function Data.SendTradeRequest(PlayerInput: Player)
	TradeRequestClient.Fire(PlayerInput)
end

function Data.AcceptTrade(PlayerInput: Player)
	TradeAccept.Fire(PlayerInput)
end

function Data.GetTradeData()
	return CurrentTradeData
end

function Data.AddUnit(UniqueId: string)
	ChangeUnit.Fire(UniqueId, "Add")
end

function Data.RemoveUnit(UniqueId: string)
	ChangeUnit.Fire(UniqueId, "Remove")
end

function Data.AddProduct()
	ChangeProduct.Fire()
end

function Data.RemoveProduct()
	ChangeProduct.Fire()
end

TradeStart.SetCallback(function(PlayerData: { Player1: Player, Player2: Player })
	CurrentTradeData = {
		OtherPlayer = if Player == PlayerData.Player1 then PlayerData.Player1 else PlayerData.Player2,
		YourUnits = {},
		OtherUnits = {},
		Status = "InTrade",
		YourStatus = "InTrade",
		OtherStatus = "InTrade",
	}
	Data.CurrentTradeData = CurrentTradeData
	Data.NewTrade:Fire(CurrentTradeData)
end)

TradeEnd.SetCallback(function()
	CurrentTradeData = nil
	Data.Ended:Fire()
end)

TradeSync.SetCallback(function(SentData: { [number]: { Status: Types.TradeStatusMessage } })
	for UserId, DataSent in pairs(SentData) do
		if tonumber(UserId) == Player.UserId then
			continue
		end

		local NewPlayer = Players:GetPlayerByUserId(UserId)
		local OldValue = TradeStatuses[NewPlayer]
		if Player then
			TradeStatuses[NewPlayer] = DataSent.Status
		end

		if OldValue ~= DataSent.Status then
			Data.SyncedStatus:Fire(NewPlayer, DataSent.Status)
		end
	end
end)

UnitChanged.SetCallback(function(OtherPlayer: Player, SentData: any, OtherStatus: string)
	if not OtherPlayer then
		return
	end

	if not CurrentTradeData then
		return
	end

	if OtherStatus == "Added" then
		local UnitData: Types.VisualUnitData = SentData
		if OtherPlayer == Player then
			CurrentTradeData.YourUnits[SentData.UniqueId] = SentData
		elseif OtherPlayer == CurrentTradeData.OtherPlayer then
			CurrentTradeData.OtherUnits[SentData.UniqueId] = SentData
		end
		Data.UnitAdded:Fire(UnitData, OtherPlayer)
	elseif OtherStatus == "Removing" then
		local UniqueId: string = SentData
		if OtherPlayer == Player then
			CurrentTradeData.YourUnits[UniqueId] = nil
		elseif OtherPlayer == CurrentTradeData.OtherPlayer then
			CurrentTradeData.OtherUnits[UniqueId] = nil
		end
		Data.UnitRemoving:Fire(UniqueId, OtherPlayer)
	end
end)

ProductChanged.SetCallback(function() end)

TradeRequestServer.SetCallback(function(OtherPlayer: Player, Time: number)
	Data.TradeRequests[OtherPlayer] = Time
	Data.NewTradeRequest:Fire(OtherPlayer, Time)

	local Diff = Time - workspace:GetServerTimeNow()

	task.delay(Diff + TradeRequestTime, function()
		if Data.TradeRequests[OtherPlayer] then
			Data.TradeRequests[OtherPlayer] = nil
			Data.RequestEnded:Fire(OtherPlayer)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(NewPlayer: Player)
	if TradeStatuses[NewPlayer] then
		TradeStatuses[NewPlayer] = nil
	end
	if Data.TradeRequests[NewPlayer] then
		Data.TradeRequests[NewPlayer] = nil
		Data.RequestEnded:Fire(NewPlayer)
	end
end)

return Data
