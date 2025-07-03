--!strict

-- By Wa1er_God --

local TradeRequestTime: number = 15

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

if not require(ReplicatedStorage.Shared.IsLobby) then
	return
end

local Network = require(ReplicatedStorage.Network.Server)

local ChangeProduct = Network.ChangeProduct
local ChangeUnit = Network.ChangeUnit
local TradeStart = Network.TradeStart
local TradeEnd = Network.TradeEnd
local TradeRequestServer = Network.TradeRequestServer
local TradeRequestClient = Network.TradeRequestClient
local TradeAccept = Network.TradeAccept
local TradeSync = Network.TradeSync

local UnitChanged = Network.UnitChanged
local ProductChanged = Network.ProductChanged

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local GlobalModules = ServerScriptService.GlobalModules
local LobbyModules = ServerScriptService.LobbyModules
local Trade = require(LobbyModules.Trade)
local PlayerData = require(GlobalModules.PlayerData)
local GlobalWave = require(GlobalModules.GlobalWave)

type TradeData = {
	Trade: Trade.Trade?,
	CanTrade: boolean,
	TradeEnabled: boolean,
	LastTradedPlayers: { [Player]: number },
	RequestThreads: { thread },

	Trove: Trove.Trove,
}

local PlayerTradeData: { [Player]: TradeData } = {}

local function GetStatusFromData(Data: TradeData)
	if Data.Trade then
		return "Trading"
	elseif not Data.TradeEnabled or not Data.CanTrade then
		return "TradeDisabled"
	else
		return "CanTrade"
	end
end

local function UpdateStatus(TradeDatas: { Player })
	local SentData = {}
	if TradeDatas then
		for _, Player in pairs(TradeDatas) do
			local Data = PlayerTradeData[Player]
			SentData[Player.UserId] = {
				Status = GetStatusFromData(Data) :: Status,
			}
		end
	end

	if HelperFunctions.Len(SentData) ~= 0 then
		TradeSync.FireAll(SentData)
	end
end

TradeRequestClient.SetCallback(function(Player: Player, OtherPlayer: Player)
	if not OtherPlayer then
		return
	end

	local Data = PlayerTradeData[OtherPlayer]

	if Data.Trade or not Data.CanTrade or not Data.TradeEnabled then
		return
	end

	if Data.LastTradedPlayers[Player] then
		return
	end

	local Time = workspace:GetServerTimeNow()

	TradeRequestServer.Fire(OtherPlayer, Player, Time)
	Data.LastTradedPlayers[Player] = Time

	local thread: thread = nil

	thread = task.delay(Time + TradeRequestTime, function()
		Data.LastTradedPlayers[Player] = nil

		local Index = table.find(Data.RequestThreads, thread)
		if Index then
			table.remove(Data.RequestThreads, Index)
		end
	end)

	table.insert(Data.RequestThreads, thread)

	Data.Trove:Add(thread)
end)

TradeAccept.SetCallback(function(Player: Player, OtherPlayer: Player)
	if not OtherPlayer:IsA("Player") then
		return
	end

	local Data = PlayerTradeData[OtherPlayer]

	if Data.Trade or not Data.CanTrade or not Data.TradeEnabled then
		return
	end

	if not Data.LastTradedPlayers[OtherPlayer] then
		return
	end

	table.clear(Data.LastTradedPlayers)
	for _, thread in ipairs(Data.RequestThreads) do
		if coroutine.status(thread) ~= "running" and coroutine.status(thread) ~= "dead" then
			task.cancel(thread)
		end
	end

	table.clear(Data.RequestThreads)

	local NewTrade = Trade.new(Player, OtherPlayer)

	if NewTrade then
		print("Trade Started")
		Data.Trade = NewTrade

		local SentData = {
			Player1 = NewTrade.Player1,
			Player2 = NewTrade.Player2,
		}

		TradeStart.Fire(NewTrade.Player1, SentData)
		TradeStart.Fire(NewTrade.Player2, SentData)

		NewTrade.Destroying:Once(function()
			TradeEnd.Fire(NewTrade.Player1)
			TradeEnd.Fire(NewTrade.Player2)
			print("Trade Completed")
			Data.Trade = nil

			UpdateStatus({ NewTrade.Player1, NewTrade.Player2 })
		end)

		UpdateStatus({ NewTrade.Player1, NewTrade.Player2 })

		NewTrade.UnitAdded:Connect(function(Unit: string, NewPlayer: Player)
			local PData = PlayerData.GetPlayerData(NewPlayer)

			if PData then
				local UnitData = PData:GetUnitFromId(Unit)

				if UnitData then
					UnitChanged.Fire(NewTrade.Player1, NewPlayer, UnitData, "Added")
					UnitChanged.Fire(NewTrade.Player2, NewPlayer, UnitData, "Added")
				end
			end
		end)

		NewTrade.UnitRemoving:Connect(function(Unit: string, NewPlayer: Player)
			UnitChanged.Fire(NewTrade.Player1, NewPlayer, Unit, "Removing")
			UnitChanged.Fire(NewTrade.Player2, NewPlayer, Unit, "Removing")
		end)
	end
end)

ChangeUnit.SetCallback(function(Player: Player, Id: string, Type: string)
	if not Player:IsA("Instance") or typeof(Id) ~= "string" or typeof(Type) ~= "string" then
		return
	end

	local Data = PlayerTradeData[Player]

	if Data and Data.Trade then
		if Type == "Add" then
			Data.Trade:AddUnit(Player, Id)
		elseif Type == "Remove" then
			Data.Trade:RemoveUnit(Player, Id)
		end
	end
end)

ChangeProduct.SetCallback(function(NewPlayer: Player) end)

local function OnDestroying(Player: Player, TradeData: TradeData)
	for OtherPlayer, OtherData in pairs(PlayerTradeData) do
		if Player ~= OtherPlayer then
			if OtherData.LastTradedPlayers[Player] then
				OtherData.LastTradedPlayers[Player] = nil
			end
		end
	end
end

local function OnAdded(Data: PlayerData.PlayerData)
	PlayerTradeData[Data.Player] = {
		Trade = nil,
		CanTrade = if Data.CurrentWave then false else true,
		TradeEnabled = Data:GetSetting("CanTrade"),
		LastTradedPlayers = {},
		RequestThreads = {},
		Trove = Trove.new(),
	}

	local TradeData = PlayerTradeData[Data.Player]

	local CanTradeSignal = Data:GetSettingChangedSignal("CanTrade")

	TradeData.Trove:Connect(CanTradeSignal, function(Value: boolean)
		TradeData.TradeEnabled = Value
		UpdateStatus({ Data.Player })
	end)

	Data.Destroying:Once(function()
		local TradeData = PlayerTradeData[Data.Player]

		if TradeData then
			OnDestroying(Data.Player, TradeData)
			TradeData.Trove:Destroy()
			PlayerTradeData[Data.Player] = nil
		end
	end)

	local SentData = {}

	for Player, OtherTradeData in pairs(PlayerTradeData) do
		SentData[Player.UserId] = {
			Status = GetStatusFromData(OtherTradeData) :: Status,
		}
	end

	TradeSync.Fire(Data.Player, SentData)

	local OtherSentData = {
		[Data.Player.UserId] = {
			Status = GetStatusFromData(TradeData) :: Status,
		},
	}

	TradeSync.FireAll(OtherSentData)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	OnAdded(Data)
end

PlayerData.DataAdded:Connect(OnAdded)
