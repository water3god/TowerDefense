--!strict

-- By Wa1er_God --

local DelayTime: number = 3

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)

local Modules = ReplicatedStorage.Modules
local GenerateId = require(Modules.GenerateId)

local Types = require(ReplicatedStorage.Shared.Types)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Template = require(ServerStorage.Data.DefaultData)

local function CheckPlayer(Player: Player)
	if Player:IsA("Player") then
		if Player:IsDescendantOf(Players) then
			return true
		end
	end

	return false
end

type TradeData = {
	UniqueId: string,
	_Trove: Trove.Trove,

	Player1: Player,
	Player2: Player,

	Player1Units: { string },
	Player2Units: { string },

	Player1Status: Types.Status,
	Player2Status: Types.Status,

	Status: Types.Status,

	Completionthread: thread?,

	UnitAdded: Signal.Signal<string, Player>,
	UnitRemoving: Signal.Signal<string, Player>,

	Player1StatusChanged: Signal.Signal<>,
	Player2StatusChanged: Signal.Signal<>,

	StatusChanged: Signal.Signal<>,

	Destroying: Signal.Signal<>,
}

type TradeImpl = {
	new: (Player1: Player, Player2: Player) -> Trade?,

	AddUnit: (self: Trade, Player: Player, UniqueId: string) -> (),
	RemoveUnit: (self: Trade, Player: Player, UniqueId: string) -> (),

	TogglePlayerStatus: (self: Trade, Player: Player) -> (),

	_UpdateStatus: (self: Trade, Player1Old: Types.Status, Player2Old: Types.Status, OldStatus: Types.Status) -> (),
	_Complete: (self: Trade) -> (),

	Delete: (self: Trade) -> (),

	GetTradeFromPlayer: (Player: Player) -> Trade?,
	GetTrades: () -> { [string]: Trade },

	Added: Signal.Signal<Trade>,

	__index: TradeImpl,
	__eq: (a: Trade, b: Trade) -> boolean,
}

export type Trade = typeof(setmetatable({} :: TradeData, {} :: TradeImpl))

local Trades: { [string]: Trade } = {}

local Trade: TradeImpl = {} :: TradeImpl
Trade.__index = Trade

function Trade.__eq(a: Trade, b: Trade)
	return rawequal(a.UniqueId, b.UniqueId)
end

Trade.Added = Signal.new()

function Trade.new(Player1: Player, Player2: Player)
	local IsPlayer1 = CheckPlayer(Player1)
	local IsPlayer2 = CheckPlayer(Player2)

	if not IsPlayer1 or not IsPlayer2 then
		return
	end

	local Data1 = PlayerData.GetPlayerData(Player1)
	local Data2 = PlayerData.GetPlayerData(Player2)

	if not Data1 or not Data2 then
		return
	end

	local self = setmetatable({}, Trade) :: Trade

	self.UniqueId = GenerateId.GenerateId()
	self._Trove = Trove.new()

	self.UnitAdded = self._Trove:Add(Signal.new(), "DisconnectAll")
	self.UnitRemoving = self._Trove:Add(Signal.new(), "DisconnectAll")

	self.Player1StatusChanged = self._Trove:Add(Signal.new(), "DisconnectAll")
	self.Player2StatusChanged = self._Trove:Add(Signal.new(), "DisconnectAll")
	self.StatusChanged = self._Trove:Add(Signal.new(), "DisconnectAll")

	self.Destroying = self._Trove:Add(Signal.new(), "DisconnectAll")

	self.Player1 = Player1
	self.Player2 = Player2

	self.Player1Units = {}
	self.Player2Units = {}

	self.Player1Status = "InTrade"
	self.Player1Status = "InTrade"

	self.Status = "InTrade"

	local function Cancel()
		if self.Status == "Finalized" or self.Status == "Accepted" then
			local OldStatus: Types.Status = self.Status
			self.Status = "InTrade"
			self:_UpdateStatus(self.Player1Status, self.Player2Status, OldStatus)
		end
	end

	self._Trove:Connect(Players.PlayerRemoving, function(Player: Player)
		if Player == self.Player1 or Player == self.Player2 then
			self:Delete()
		end
	end)

	self._Trove:Connect(Data1.UnitRemoved, function(Data: Template.UnitData)
		local Index = table.find(self.Player1Units, Data.UniqueId)

		if Index then
			table.remove(self.Player1Units, Index)
			self.UnitRemoving:Fire(Data.UniqueId, self.Player1)
			Cancel()
		end
	end)

	self._Trove:Connect(Data2.UnitRemoved, function(Data: Template.UnitData)
		local Index = table.find(self.Player2Units, Data.UniqueId)

		if Index then
			table.remove(self.Player2Units, Index)
			self.UnitRemoving:Fire(Data.UniqueId, self.Player2)
			Cancel()
		end
	end)

	Trades[self.UniqueId] = self
	Trade.Added:Fire(self)

	return self
end

function Trade:AddUnit(Player: Player, UniqueId: string)
	if self.Status ~= "InTrade" then
		return
	end

	local Data = PlayerData.GetPlayerData(Player)

	if Data then
		local OwnedUnits = Data:GetOwnedUnits()

		if OwnedUnits[UniqueId] then
			if Player == self.Player1 then
				table.insert(self.Player1Units, UniqueId)
				self.UnitAdded:Fire(UniqueId, self.Player1)
			elseif Player == self.Player2 then
				table.insert(self.Player2Units, UniqueId)
				self.UnitAdded:Fire(UniqueId, self.Player2)
			end
		end
	end
end

function Trade:RemoveUnit(Player: Player, UniqueId: string)
	if self.Status ~= "InTrade" then
		return
	end
	if Player == self.Player1 then
		local Index = table.find(self.Player1Units, UniqueId)

		if Index then
			table.remove(self.Player1Units, Index)
			self.UnitRemoving:Fire(UniqueId, self.Player1)
		end
	elseif Player == self.Player2 then
		local Index = table.find(self.Player1Units, UniqueId)

		if Index then
			table.remove(self.Player1Units, Index)
			self.UnitRemoving:Fire(UniqueId, self.Player2)
		end
	end
end

function Trade:TogglePlayerStatus(Player: Player)
	if Player ~= self.Player1 and Player ~= self.Player2 then
		return
	end
	local SelfStatus: Types.Status = if self.Player1 == Player then self.Player1Status else self.Player2Status
	local Value: string = if self.Player1 == Player then "Player1Status" else "Player2Status"

	local Player1Old: Types.Status = self.Player1Status
	local Player2Old: Types.Status = self.Player2Status

	if self.Status == "InTrade" then
		if SelfStatus == "InTrade" then
			self[Value] = "Finalized"
		else
			self[Value] = "InTrade"
		end
	elseif self.Status == "Finalized" then
		if SelfStatus == "Finalized" then
			self[Value] = "Accepted"
		else
			self[Value] = "InTrade"
		end
	elseif self.Status == "Accepted" then
		self[Value] = "InTrade"
	end

	self:_UpdateStatus(Player1Old, Player2Old, self.Status)
end

function Trade:_UpdateStatus(Player1Old: Types.Status, Player2Old: Types.Status, OldStatus: Types.Status)
	if self.Status == "InTrade" then
		if self.Player1Status == "Finalized" and self.Player2Status == "Finalized" then
			self.Status = "Finalized"
		else
			self.Status = "InTrade"
		end
	elseif self.Status == "Finalized" then
		if self.Player1Status == "Accepted" and self.Player2Status == "Accepted" then
			self.Status = "Accepted"
		else
			self.Status = "InTrade"
		end
	elseif self.Status == "Accepted" then
		if self.Player1Status ~= "Accepted" or self.Player2Status ~= "Accepted" then
			self.Player1Status = "Finalized"
			self.Player2Status = "Finalized"
			self.Status = "Finalized"
		end
	end

	if self.Player1Status ~= Player1Old then
		self.Player1StatusChanged:Fire()
	end
	if self.Player2Status ~= Player2Old then
		self.Player2StatusChanged:Fire()
	end
	if self.Status ~= OldStatus then
		self.StatusChanged:Fire()
		if self.Status == "Accepted" then
			self.Completionthread = self._Trove:Add(task.delay(DelayTime, function()
				self:_Complete()
			end))
		else
			if self.Completionthread then
				self._Trove:Remove(self.Completionthread)
				self.Completionthread = nil
			end
		end
	end
end

function Trade:_Complete()
	if self.Status ~= "Accepted" then
		return
	end

	local Data1 = PlayerData.GetPlayerData(self.Player1)
	local Data2 = PlayerData.GetPlayerData(self.Player2)

	if not Data1 or not Data2 then
		return
	end

	for _, UniqueId in ipairs(self.Player1Units) do
		local UnitData = Data1:GetUnitFromId(UniqueId)

		if UnitData then
			Data2:AddUnitFromExisting(UnitData)
			Data1:DeleteUnit(UniqueId)
		end
	end

	for _, UniqueId in ipairs(self.Player2Units) do
		local UnitData = Data1:GetUnitFromId(UniqueId)

		if UnitData then
			Data1:AddUnitFromExisting(UnitData)
			Data2:DeleteUnit(UniqueId)
		end
	end

	self:Delete()
end

function Trade:Delete()
	self.Destroying:Fire()
	self._Trove:Destroy()

	table.clear(self :: any)
	setmetatable(self :: any, nil)
end

function Trade.GetTradeFromPlayer(Player: Player)
	for UniqueId, Trade in pairs(Trades) do
		if Trade.Player1 == Player or Trade.Player2 == Player then
			return Trade
		end
	end

	return
end

function Trade.GetTrades()
	return Trades
end

return Trade
