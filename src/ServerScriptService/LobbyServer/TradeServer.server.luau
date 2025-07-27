--!strict

-- By Wa1er_God --

local TradeRequestTime: number = 15

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

if not require(ReplicatedStorage.Shared.IsLobby) then
	return
end

local Network = require(ReplicatedStorage.Network.Server)

local TradeStart = Network.TradeStart
local TradeEnd = Network.TradeEnd
local TradeRequestServer = Network.TradeRequestServer
local TradeRequestClient = Network.TradeRequestClient
local TradeAccept = Network.TradeAccept
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

local SendWarning = Network.SendWarning

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

local GlobalModules = ServerScriptService.GlobalModules
local LobbyModules = ServerScriptService.LobbyModules
local Trade = require(LobbyModules.Trade)
local PlayerData = require(GlobalModules.PlayerData)

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

	if next(SentData) then
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
	TradeRequestServer.Fire(Player, OtherPlayer, Time)
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

	local Data = PlayerTradeData[Player]
	local OtherData = PlayerTradeData[OtherPlayer]

	if not Data or not OtherData then
		return
	end

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
		Data.Trade = NewTrade
		OtherData.Trade = NewTrade

		local SentData = {
			Player1 = NewTrade.Player1,
			Player2 = NewTrade.Player2,
		}

		TradeStart.Fire(NewTrade.Player1, SentData)
		TradeStart.Fire(NewTrade.Player2, SentData)

		NewTrade.Destroying:Once(function()
			TradeEnd.Fire(NewTrade.Player1)
			TradeEnd.Fire(NewTrade.Player2)
			Data.Trade = nil
			OtherData.Trade = nil

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

		NewTrade.UnitRemoving:Connect(function(UniqueId: string, NewPlayer: Player)
			UnitChanged.Fire(NewTrade.Player1, NewPlayer, UniqueId, "Removing")
			UnitChanged.Fire(NewTrade.Player2, NewPlayer, UniqueId, "Removing")
		end)

		local function HandleProduct(UniqueId: string, Count: number, NewPlayer: Player)
			local PData = PlayerData.GetPlayerData(NewPlayer)
			if PData then
				local ProductData = PData:GetProductFromId(UniqueId)
				if ProductData then
					ProductChanged.Fire(NewTrade.Player1, NewPlayer, {
						UniqueId = UniqueId,
						Product = ProductData.ProductId,
						Count = Count,
					})
					ProductChanged.Fire(NewTrade.Player2, NewPlayer, {
						UniqueId = UniqueId,
						Product = ProductData.ProductId,
						Count = Count,
					})
				end
			end
		end

		NewTrade.ProductAdded:Connect(HandleProduct)
		NewTrade.ProductRemoving:Connect(HandleProduct)

		local function HandleResource(UniqueId: string, Count: number, NewPlayer: Player)
			local PData = PlayerData.GetPlayerData(NewPlayer)
			if PData then
				local ResourceData = PData:GetResourceFromId(UniqueId)
				if ResourceData then
					ResourceChanged.Fire(NewTrade.Player1, NewPlayer, {
						UniqueId = UniqueId,
						Resource = ResourceData.Resource,
						Count = Count,
					})
					ResourceChanged.Fire(NewTrade.Player2, NewPlayer, {
						UniqueId = UniqueId,
						Resource = ResourceData.Resource,
						Count = Count,
					})
				end
			end
		end

		NewTrade.ResourceAdded:Connect(HandleResource)
		NewTrade.ResourceRemoving:Connect(HandleResource)

		NewTrade.StatusChanged:Connect(function()
			local SendData = {
				Status = NewTrade.Status,
			}

			StatusChanged.Fire(NewTrade.Player1, SendData)
			StatusChanged.Fire(NewTrade.Player2, SendData)
		end)

		NewTrade.Player1StatusChanged:Connect(function()
			local SendData = {
				Player = NewTrade.Player1,
				Status = NewTrade.Player1Status,
			}

			StatusChanged.Fire(NewTrade.Player1, SendData)
			StatusChanged.Fire(NewTrade.Player2, SendData)
		end)

		NewTrade.Player2StatusChanged:Connect(function()
			local SendData = {
				Player = NewTrade.Player2,
				Status = NewTrade.Player2Status,
			}

			StatusChanged.Fire(NewTrade.Player1, SendData)
			StatusChanged.Fire(NewTrade.Player2, SendData)
		end)

		NewTrade.Completed:Connect(function()
			SendWarning.Fire(Player, "Trade completed successfully", Color3.fromRGB(0, 255, 0))
			SendWarning.Fire(OtherPlayer, "Trade completed successfully", Color3.fromRGB(0, 255, 0))
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

ChangeProduct.SetCallback(function(Player: Player, Id: string, Count: number)
	local Data = PlayerTradeData[Player]

	if Data and Data.Trade then
		Data.Trade:ChangeProduct(Player, Id, Count)
	end
end)

ChangeResource.SetCallback(function(Player: Player, Id: string, Count: number)
	local Data = PlayerTradeData[Player]

	if Data and Data.Trade then
		Data.Trade:ChangeResource(Player, Id, Count)
	end
end)

ToggleStatus.SetCallback(function(Player: Player, Progress: boolean)
	local Data = PlayerTradeData[Player]

	if Data and Data.Trade then
		Data.Trade:TogglePlayerStatus(Player, Progress)
	end
end)

EndTrade.SetCallback(function(Player: Player)
	local Data = PlayerTradeData[Player]

	if Data and Data.Trade then
		local OtherPlayer = Data.Trade:GetOtherPlayer(Player)
		SendWarning.Fire(Player, string.format("Trade Canceled by %s", Player.Name), Color3.fromRGB(255, 0, 0))
		if OtherPlayer then
			SendWarning.Fire(OtherPlayer, string.format("Trade Canceled by %s", Player.Name), Color3.fromRGB(255, 0, 0))
		end
		Data.Trade:Delete()
	end
end)

local function OnDestroying(Player: Player, _: TradeData)
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
		local OtherTradeData = PlayerTradeData[Data.Player]

		if OtherTradeData then
			OnDestroying(Data.Player, OtherTradeData)
			OtherTradeData.Trove:Destroy()
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

	TradeSync.FireExcept(Data.Player, OtherSentData)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	OnAdded(Data)
end

PlayerData.DataAdded:Connect(OnAdded)
