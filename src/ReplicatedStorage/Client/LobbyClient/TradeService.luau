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

local TradeAccept = Network.TradeAccept
local TradeEnd = Network.TradeEnd
local TradeRequestClient = Network.TradeRequestClient
local TradeRequestServer = Network.TradeRequestServer
local TradeStart = Network.TradeStart
local TradeSync = Network.TradeSync
local StatusChanged = Network.StatusChanged

local ToggleStatus = Network.ToggleStatus
local EndTrade = Network.EndTrade

local ChangeProduct = Network.ChangeProduct
local ChangeUnit = Network.ChangeUnit
local ChangeResource = Network.ChangeResource

local UnitChanged = Network.UnitChanged
local ProductChanged = Network.ProductChanged
local ResourceChanged = Network.ResourceChanged

local Data = {}

Data.CurrentTradeData = nil :: TradeData?

Data.NewTradeRequest = Signal.new()
Data.RequestEnded = Signal.new()

Data.NewTrade = Signal.new()
Data.Ended = Signal.new()

Data.UnitAdded = Signal.new()
Data.UnitRemoving = Signal.new()
Data.ProductChanged = Signal.new()
Data.ResourceChanged = Signal.new()
Data.StatusChanged = Signal.new()

local TradeStatuses: { [Player]: Types.TradeStatusMessage } = {}
Data.TradeStatuses = TradeStatuses

Data.SyncedStatus = Signal.new()

Data.TradeRequests = {}

Data.TradeRequestTime = TradeRequestTime

export type TradeData = Types.TradeData
export type VisualUnitData = Types.VisualUnitData
export type TradeStatusMessage = Types.TradeStatusMessage

function Data.SendTradeRequest(PlayerId: number)
	local OtherPlayer = Players:GetPlayerByUserId(PlayerId)
	if not OtherPlayer then
		warn("Trade request failed: Player not found")
		return
	end
	TradeRequestClient.Fire(OtherPlayer)
end

function Data.AcceptTrade(PlayerId: number)
	local OtherPlayer = Players:GetPlayerByUserId(PlayerId)
	if not OtherPlayer then
		warn("Trade accept failed: Player not found")
		return
	end
	TradeAccept.Fire(OtherPlayer)
	if Data.TradeRequests[OtherPlayer] then
		Data.TradeRequests[OtherPlayer] = nil
	end
	Data.RequestEnded:Fire(OtherPlayer, false)
end

function Data.DeclineTrade(PlayerId: number)
	local OtherPlayer = Players:GetPlayerByUserId(PlayerId)
	if not OtherPlayer then
		warn("Trade decline failed: Player not found")
		return
	end
	if Data.TradeRequests[OtherPlayer] then
		Data.TradeRequests[OtherPlayer] = nil
	end
	Data.RequestEnded:Fire(OtherPlayer, false)
end

function Data.GetTradeData()
	return Data.CurrentTradeData
end

function Data.AddUnit(UniqueId: string)
	ChangeUnit.Fire(UniqueId, "Add")
end

function Data.RemoveUnit(UniqueId: string)
	ChangeUnit.Fire(UniqueId, "Remove")
end

function Data.ChangeProduct(UniqueId: string, Count: number)
	ChangeProduct.Fire(UniqueId, Count)
end

function Data.ChangeResource(UniqueId: string, Count: number)
	ChangeResource.Fire(UniqueId, Count)
end

function Data.ToggleStatus(Progress: boolean)
	ToggleStatus.Fire(Progress)
end

function Data.EndTrade()
	EndTrade.Fire()
end

TradeStart.SetCallback(function(PlayerData: { Player1: Player, Player2: Player })
	Data.CurrentTradeData = {
		OtherPlayer = if Player == PlayerData.Player1 then PlayerData.Player2 else PlayerData.Player1,
		YourUnits = {},
		OtherUnits = {},
		YourProducts = {},
		OtherProducts = {},
		YourResources = {},
		OtherResources = {},
		Status = "InTrade",
		YourStatus = "InTrade",
		OtherStatus = "InTrade",
	}
	Data.CurrentTradeData = Data.CurrentTradeData
	Data.NewTrade:Fire(Data.CurrentTradeData)
end)

TradeEnd.SetCallback(function()
	Data.CurrentTradeData = nil
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

StatusChanged.SetCallback(function(Input: { Player: Player?, Status: Types.Status })
	if not Data.CurrentTradeData then
		return
	end

	if Input.Player == Player then
		Data.CurrentTradeData.YourStatus = Input.Status
		Data.StatusChanged:Fire(Input.Status, Player)
	elseif Input.Player == Data.CurrentTradeData.OtherPlayer then
		Data.CurrentTradeData.OtherStatus = Input.Status
		Data.StatusChanged:Fire(Input.Status, Data.CurrentTradeData.OtherPlayer)
	else
		Data.CurrentTradeData.Status = Input.Status
		Data.StatusChanged:Fire(Input.Status)
	end
end)

local function UnitFindAndRemove(Table: { VisualUnitData }, UniqueId: string)
	for i, Unit in ipairs(Table) do
		if Unit.UniqueId == UniqueId then
			table.remove(Table, i)
			return
		end
	end
end

UnitChanged.SetCallback(function(OtherPlayer: Player, SentData: Types.VisualUnitData | string, OtherStatus: string)
	if not OtherPlayer then
		return
	end

	if not Data.CurrentTradeData then
		return
	end

	if OtherStatus == "Added" then
		local UnitData: Types.VisualUnitData = SentData :: any
		if OtherPlayer == Player then
			table.insert(Data.CurrentTradeData.YourUnits, UnitData)
		elseif OtherPlayer == Data.CurrentTradeData.OtherPlayer then
			table.insert(Data.CurrentTradeData.OtherUnits, UnitData)
		end
		Data.UnitAdded:Fire(UnitData, OtherPlayer)
	elseif OtherStatus == "Removing" then
		local UniqueId: string = SentData :: any
		if OtherPlayer == Player then
			UnitFindAndRemove(Data.CurrentTradeData.YourUnits, UniqueId)
		elseif OtherPlayer == Data.CurrentTradeData.OtherPlayer then
			UnitFindAndRemove(Data.CurrentTradeData.OtherUnits, UniqueId)
		end
		Data.UnitRemoving:Fire(UniqueId, OtherPlayer)
	end
end)

ProductChanged.SetCallback(function(OtherPlayer: Player, ProductData: Types.TradeProductData)
	if not OtherPlayer then
		return
	end
	if not Data.CurrentTradeData then
		return
	end
	if OtherPlayer == Player then
		table.insert(Data.CurrentTradeData.YourProducts, ProductData)
	else
		table.insert(Data.CurrentTradeData.OtherProducts, ProductData)
	end
	Data.ProductChanged:Fire(OtherPlayer, ProductData)
end)

ResourceChanged.SetCallback(function(OtherPlayer: Player, ResourceData: Types.TradeResourceData)
	if not OtherPlayer then
		return
	end
	if not Data.CurrentTradeData then
		return
	end
	if OtherPlayer == Player then
		table.insert(Data.CurrentTradeData.YourResources, ResourceData)
	else
		table.insert(Data.CurrentTradeData.OtherResources, ResourceData)
	end
	Data.ResourceChanged:Fire(OtherPlayer, ResourceData)
end)

TradeRequestServer.SetCallback(function(OtherPlayer: Player, Time: number)
	print(OtherPlayer)
	if OtherPlayer == Player then
		local Diff = Time - workspace:GetServerTimeNow()

		task.delay(Diff + TradeRequestTime, function()
			Data.RequestEnded:Fire(OtherPlayer, true)
		end)
	else
		Data.TradeRequests[OtherPlayer] = Time
		Data.NewTradeRequest:Fire(OtherPlayer, Time)

		local Diff = Time - workspace:GetServerTimeNow()

		task.delay(Diff + TradeRequestTime, function()
			if Data.TradeRequests[OtherPlayer] then
				Data.TradeRequests[OtherPlayer] = nil
			end
			Data.RequestEnded:Fire(OtherPlayer, true)
		end)
	end
end)

Players.PlayerRemoving:Connect(function(NewPlayer: Player)
	if TradeStatuses[NewPlayer] then
		TradeStatuses[NewPlayer] = nil
	end
	if Data.TradeRequests[NewPlayer] then
		Data.TradeRequests[NewPlayer] = nil
	end
	Data.RequestEnded:Fire(NewPlayer, true)
end)

return Data
