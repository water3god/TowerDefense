--!strict

-- By Wa1er_God --

local TradeRequestTime: number = 15

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Types = require(ReplicatedStorage.Shared.Types)

local Remotes = ReplicatedStorage.Remotes
local TradeEvents = Remotes.Trade

local ChangeProduct = TradeEvents.ChangeProduct
local ChangeUnit = TradeEvents.ChangeUnit
local TradeAccept = TradeEvents.TradeAccept
local TradeEnd = TradeEvents.TradeEnd
local TradeRequest = TradeEvents.TradeRequest
local TradeStart = TradeEvents.TradeStart
local TradeSync = TradeEvents.TradeSync

local UnitChanged = TradeEvents.UnitChanged
local ProductChanged = TradeEvents.ProductChanged

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
	TradeRequest:FireServer(PlayerInput)
end

function Data.AcceptTrade(PlayerInput: Player)
	TradeAccept:FireServer(PlayerInput)
end

function Data.GetTradeData()
	return CurrentTradeData
end

function Data.AddUnit(UniqueId: string)
	ChangeUnit:FireServer(UniqueId, "Add")
end

function Data.RemoveUnit(UniqueId: string)
	ChangeUnit:FireServer(UniqueId, "Remove")
end

function Data.AddProduct()
	ChangeProduct:FireServer()
end

function Data.RemoveProduct()
	ChangeProduct:FireServer()
end

TradeStart.OnClientEvent:Connect(function(NewPlayer: Player)
	CurrentTradeData = {
		OtherPlayer = NewPlayer,
		YourUnits = {},
		OtherUnits = {},
		Status = "InTrade",
		YourStatus = "InTrade",
		OtherStatus = "InTrade",
	}
	Data.NewTrade:Fire(CurrentTradeData)
end)

TradeEnd.OnClientEvent:Connect(function()
	CurrentTradeData = nil
	Data.Ended:Fire()
end)

TradeSync.OnClientEvent:Connect(function(SentData: { [number]: { Status: Types.TradeStatusMessage } })
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

UnitChanged.OnClientEvent:Connect(function(SentData: any, OtherPlayer: Player, OtherStatus: string)
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

ProductChanged.OnClientEvent:Connect(function() end)

TradeRequest.OnClientEvent:Connect(function(OtherPlayer: Player, Time: number)
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
