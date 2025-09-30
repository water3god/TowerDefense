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
	Player1Products: { [string]: number },
	Player2Products: { [string]: number },
	Player1Resources: { [string]: number },
	Player2Resources: { [string]: number },

	Player1Status: Types.Status,
	Player2Status: Types.Status,

	Status: Types.Status,

	Completionthread: thread?,

	UnitAdded: Signal.Signal<string, Player>,
	UnitRemoving: Signal.Signal<string, Player>,
	ProductAdded: Signal.Signal<string, number, Player>,
	ProductRemoving: Signal.Signal<string, number, Player>,
	ResourceAdded: Signal.Signal<string, number, Player>,
	ResourceRemoving: Signal.Signal<string, number, Player>,

	Player1StatusChanged: Signal.Signal<>,
	Player2StatusChanged: Signal.Signal<>,

	StatusChanged: Signal.Signal<>,

	Completed: Signal.Signal<>,
	Destroying: Signal.Signal<>,
}

type TradeImpl = {
	new: (Player1: Player, Player2: Player) -> Trade?,

	GetOtherPlayer: (self: Trade, Player: Player) -> Player?,

	AddUnit: (self: Trade, Player: Player, UniqueId: string) -> (),
	RemoveUnit: (self: Trade, Player: Player, UniqueId: string) -> (),
	AddProduct: (self: Trade, Player: Player, UniqueId: string, Count: number) -> (),
	RemoveProduct: (self: Trade, Player: Player, UniqueId: string, Count: number) -> (),
	AddResource: (self: Trade, Player: Player, UniqueId: string, Count: number) -> (),
	RemoveResource: (self: Trade, Player: Player, UniqueId: string, Count: number) -> (),

	ChangeProduct: (self: Trade, Player: Player, UniqueId: string, Count: number) -> (),
	ChangeResource: (self: Trade, Player: Player, UniqueId: string, Count: number) -> (),

	TogglePlayerStatus: (self: Trade, Player: Player, Progress: boolean) -> (),

	LowerThanMaxCount: (self: Trade, Player: Player) -> boolean,

	_UpdateStatus: (self: Trade, Player1Old: Types.Status, Player2Old: Types.Status, OldStatus: Types.Status) -> (),
	_Complete: (self: Trade) -> (),

	Delete: (self: Trade) -> (),
	Destroy: (self: Trade) -> (),

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

	self.UnitAdded = self._Trove:Construct(Signal)
	self.UnitRemoving = self._Trove:Construct(Signal)

	self.Player1StatusChanged = self._Trove:Construct(Signal)
	self.Player2StatusChanged = self._Trove:Construct(Signal)
	self.StatusChanged = self._Trove:Construct(Signal)

	self.ProductAdded = self._Trove:Construct(Signal)
	self.ProductRemoving = self._Trove:Construct(Signal)
	self.ResourceAdded = self._Trove:Construct(Signal)
	self.ResourceRemoving = self._Trove:Construct(Signal)

	self.Completed = self._Trove:Construct(Signal)
	self.Destroying = self._Trove:Construct(Signal)

	self.Player1 = Player1
	self.Player2 = Player2

	self.Player1Units = {}
	self.Player2Units = {}

	self.Player1Products = {}
	self.Player2Products = {}

	self.Player1Resources = {}
	self.Player2Resources = {}

	self.Player1Status = "InTrade"
	self.Player2Status = "InTrade"

	self.Status = "InTrade"

	local function Cancel()
		if self.Status == "Finalized" or self.Status == "Accepted" then
			self:TogglePlayerStatus(self.Player1, false)
			self:TogglePlayerStatus(self.Player2, false)
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

	self._Trove:Connect(Data1.ProductChanged, function(Type: string, Data: Template.ProductData)
		if Type == "Changed" then
			local ProductCount = self.Player1Products[Data.UniqueId]

			if ProductCount then
				local Difference = ProductCount - Data.Count

				if Difference > 0 then
					self:RemoveProduct(self.Player1, Data.UniqueId, Difference)
					Cancel()
				end
			end
		elseif Type == "Removed" then
			local ProductCount = self.Player1Products[Data.UniqueId]

			if ProductCount then
				self:RemoveProduct(self.Player1, Data.UniqueId, ProductCount)
				Cancel()
			end
		end
	end)

	self._Trove:Connect(Data2.ProductChanged, function(Type: string, Data: Template.ProductData)
		if Type == "Changed" then
			local ProductCount = self.Player2Products[Data.UniqueId]

			if ProductCount then
				local Difference = ProductCount - Data.Count

				if Difference > 0 then
					self:RemoveProduct(self.Player2, Data.UniqueId, Difference)
					Cancel()
				end
			end
		elseif Type == "Removed" then
			local ProductCount = self.Player2Products[Data.UniqueId]

			if ProductCount then
				self:RemoveProduct(self.Player2, Data.UniqueId, ProductCount)
				Cancel()
			end
		end
	end)

	self._Trove:Connect(Data1.ResourceChanged, function(Type: string, Data: Template.ResourceData)
		if Type == "Changed" then
			local ResourceCount = self.Player1Resources[Data.UniqueId]

			if ResourceCount then
				local Difference = ResourceCount - Data.Count

				if Difference > 0 then
					self:RemoveResource(self.Player1, Data.UniqueId, Difference)
					Cancel()
				end
			end
		elseif Type == "Removed" then
			local ResourceCount = self.Player1Resources[Data.UniqueId]

			if ResourceCount then
				self:RemoveResource(self.Player1, Data.UniqueId, ResourceCount)
				Cancel()
			end
		end
	end)

	self._Trove:Connect(Data2.ResourceChanged, function(Type: string, Data: Template.ResourceData)
		if Type == "Changed" then
			local ResourceCount = self.Player2Resources[Data.UniqueId]

			if ResourceCount then
				local Difference = ResourceCount - Data.Count

				if Difference > 0 then
					self:RemoveResource(self.Player2, Data.UniqueId, Difference)
					Cancel()
				end
			end
		elseif Type == "Removed" then
			local ResourceCount = self.Player2Resources[Data.UniqueId]

			if ResourceCount then
				self:RemoveResource(self.Player2, Data.UniqueId, ResourceCount)
				Cancel()
			end
		end
	end)

	Trades[self.UniqueId] = self
	Trade.Added:Fire(self)

	return self
end

function Trade:GetOtherPlayer(Player: Player)
	if Player == self.Player1 then
		return self.Player2
	elseif Player == self.Player2 then
		return self.Player1
	end

	return nil
end

function Trade:AddUnit(Player: Player, UniqueId: string)
	if self.Status ~= "InTrade" then
		return
	end

	local Data = PlayerData.GetPlayerData(Player)

	if Data then
		local OwnedUnits = Data:GetOwnedUnits()

		if OwnedUnits[UniqueId] then
			if not self:LowerThanMaxCount(Player) then
				return
			end
			if Player == self.Player1 then
				if table.find(self.Player1Units, UniqueId) then
					return
				end
				table.insert(self.Player1Units, UniqueId)
				self.UnitAdded:Fire(UniqueId, self.Player1)
			elseif Player == self.Player2 then
				if table.find(self.Player2Units, UniqueId) then
					return
				end
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
		local Index = table.find(self.Player2Units, UniqueId)

		if Index then
			table.remove(self.Player2Units, Index)
			self.UnitRemoving:Fire(UniqueId, self.Player2)
		end
	end
end

function Trade:AddProduct(Player: Player, UniqueId: string, Count: number)
	if self.Status ~= "InTrade" then
		return
	end

	local Data = PlayerData.GetPlayerData(Player)

	if Data and Data:GetProductFromId(UniqueId) then
		if Player == self.Player1 then
			if not self.Player1Products[UniqueId] then
				if not self:LowerThanMaxCount(Player) then
					return
				end
			end
			self.Player1Products[UniqueId] = (self.Player1Products[UniqueId] or 0) + Count
			self.ProductAdded:Fire(UniqueId, self.Player1Products[UniqueId], self.Player1)
		elseif Player == self.Player2 then
			if not self.Player2Products[UniqueId] then
				if not self:LowerThanMaxCount(Player) then
					return
				end
			end
			self.Player2Products[UniqueId] = (self.Player2Products[UniqueId] or 0) + Count
			self.ProductAdded:Fire(UniqueId, self.Player2Products[UniqueId], self.Player2)
		end
	end
end

function Trade:RemoveProduct(Player: Player, UniqueId: string, Count: number)
	if self.Status ~= "InTrade" then
		return
	end

	if Player == self.Player1 then
		if self.Player1Products[UniqueId] and self.Player1Products[UniqueId] > 0 then
			self.Player1Products[UniqueId] = self.Player1Products[UniqueId] - Count
			if self.Player1Products[UniqueId] <= 0 then
				self.Player1Products[UniqueId] = nil
			end
			self.ProductRemoving:Fire(UniqueId, self.Player1Products[UniqueId] or 0, self.Player1)
		end
	elseif Player == self.Player2 then
		if self.Player2Products[UniqueId] and self.Player2Products[UniqueId] > 0 then
			self.Player2Products[UniqueId] = self.Player2Products[UniqueId] - Count
			if self.Player2Products[UniqueId] <= 0 then
				self.Player2Products[UniqueId] = nil
			end
			self.ProductRemoving:Fire(UniqueId, self.Player2Products[UniqueId] or 0, self.Player2)
		end
	end
end

function Trade:AddResource(Player: Player, UniqueId: string, Count: number)
	if self.Status ~= "InTrade" then
		return
	end

	local Data = PlayerData.GetPlayerData(Player)

	if Data and Data:GetResourceFromId(UniqueId) then
		if Player == self.Player1 then
			if not self.Player1Resources[UniqueId] then
				if not self:LowerThanMaxCount(Player) then
					return
				end
			end
			self.Player1Resources[UniqueId] = (self.Player1Resources[UniqueId] or 0) + Count
			self.ResourceAdded:Fire(UniqueId, self.Player1Resources[UniqueId], self.Player1)
		elseif Player == self.Player2 then
			if not self.Player2Resources[UniqueId] then
				if not self:LowerThanMaxCount(Player) then
					return
				end
			end
			self.Player2Resources[UniqueId] = (self.Player2Resources[UniqueId] or 0) + Count
			self.ResourceAdded:Fire(UniqueId, self.Player2Resources[UniqueId], self.Player2)
		end
	end
end

function Trade:RemoveResource(Player: Player, UniqueId: string, Count: number)
	if self.Status ~= "InTrade" then
		return
	end

	if Player == self.Player1 then
		if self.Player1Resources[UniqueId] and self.Player1Resources[UniqueId] > 0 then
			self.Player1Resources[UniqueId] = self.Player1Resources[UniqueId] - Count
			if self.Player1Resources[UniqueId] <= 0 then
				self.Player1Resources[UniqueId] = nil
			end
			self.ResourceRemoving:Fire(UniqueId, self.Player1Resources[UniqueId] or 0, self.Player1)
		end
	elseif Player == self.Player2 then
		if self.Player2Resources[UniqueId] and self.Player2Resources[UniqueId] > 0 then
			self.Player2Resources[UniqueId] = self.Player2Resources[UniqueId] - Count
			if self.Player2Resources[UniqueId] <= 0 then
				self.Player2Resources[UniqueId] = nil
			end
			self.ResourceRemoving:Fire(UniqueId, self.Player2Resources[UniqueId] or 0, self.Player2)
		end
	end
end

function Trade:ChangeProduct(Player: Player, UniqueId: string, Count: number)
	if Player == self.Player1 then
		local CurrentCount = self.Player1Products[UniqueId]
		if CurrentCount then
			if CurrentCount > Count then
				self:RemoveProduct(Player, UniqueId, CurrentCount - Count)
			elseif CurrentCount < Count then
				self:AddProduct(Player, UniqueId, Count - CurrentCount)
			end
		else
			self:AddProduct(Player, UniqueId, Count)
		end
	elseif Player == self.Player2 then
		local CurrentCount = self.Player2Products[UniqueId]
		if CurrentCount then
			if CurrentCount > Count then
				self:RemoveProduct(Player, UniqueId, CurrentCount - Count)
			elseif CurrentCount < Count then
				self:AddProduct(Player, UniqueId, Count - CurrentCount)
			end
		else
			self:AddProduct(Player, UniqueId, Count)
		end
	end
end

function Trade:ChangeResource(Player: Player, UniqueId: string, Count: number)
	if Player == self.Player1 then
		local CurrentCount = self.Player1Resources[UniqueId]
		if CurrentCount then
			if CurrentCount > Count then
				self:RemoveResource(Player, UniqueId, CurrentCount - Count)
			elseif CurrentCount < Count then
				self:AddResource(Player, UniqueId, Count - CurrentCount)
			end
		else
			self:AddResource(Player, UniqueId, Count)
		end
	elseif Player == self.Player2 then
		local CurrentCount = self.Player2Resources[UniqueId]
		if CurrentCount then
			if CurrentCount > Count then
				self:RemoveResource(Player, UniqueId, CurrentCount - Count)
			elseif CurrentCount < Count then
				self:AddResource(Player, UniqueId, Count - CurrentCount)
			end
		else
			self:AddResource(Player, UniqueId, Count)
		end
	end
end

function Trade:TogglePlayerStatus(Player: Player, Progress: boolean)
	if Player ~= self.Player1 and Player ~= self.Player2 then
		return
	end
	local SelfStatus: Types.Status = if self.Player1 == Player then self.Player1Status else self.Player2Status
	local Value: string = if self.Player1 == Player then "Player1Status" else "Player2Status"

	local Player1Old: Types.Status = self.Player1Status
	local Player2Old: Types.Status = self.Player2Status

	print(SelfStatus, self.Status, Progress)

	if self.Status == "InTrade" then
		if SelfStatus == "InTrade" then
			if Progress then
				self[Value] = "Finalized"
			end
		else
			if not Progress then
				self[Value] = "InTrade"
			end
		end
	elseif self.Status == "Finalized" then
		if SelfStatus == "Finalized" then
			if Progress then
				self[Value] = "Accepted"
			end
		else
			if not Progress then
				self[Value] = "InTrade"
			end
		end
	elseif self.Status == "Accepted" then
		if not Progress then
			self[Value] = "InTrade"
		end
	end

	self:_UpdateStatus(Player1Old, Player2Old, self.Status)
end

function Trade:LowerThanMaxCount(Player: Player): boolean
	if Player == self.Player1 then
		local Count = 0
		Count += #self.Player1Units
		for _, _ in pairs(self.Player1Products) do
			Count += 1
		end
		for _, _ in pairs(self.Player1Resources) do
			Count += 1
		end
		return Count < 5
	elseif Player == self.Player2 then
		local Count = 0
		Count += #self.Player2Units
		for _, _ in pairs(self.Player2Products) do
			Count += 1
		end
		for _, _ in pairs(self.Player2Resources) do
			Count += 1
		end
		return Count < 5
	end
	return false
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
		elseif self.Player1Status == "InTrade" or self.Player2Status == "InTrade" then
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
		local UnitData = Data2:GetUnitFromId(UniqueId)

		if UnitData then
			Data1:AddUnitFromExisting(UnitData)
			Data2:DeleteUnit(UniqueId)
		end
	end

	for UniqueId, Count in pairs(self.Player1Products) do
		local ProductData = Data1:GetProductFromId(UniqueId)
		if ProductData then
			Data2:AddProduct(ProductData.ProductId, Count)
			Data1:RemoveProduct(ProductData.ProductId, Count)
		end
	end

	for UniqueId, Count in pairs(self.Player2Products) do
		local ProductData = Data2:GetProductFromId(UniqueId)
		if ProductData then
			Data1:AddProduct(ProductData.ProductId, Count)
			Data2:RemoveProduct(ProductData.ProductId, Count)
		end
	end

	for UniqueId, Count in pairs(self.Player1Resources) do
		local Resource = Data1:GetResourceFromId(UniqueId)
		if Resource then
			Data2:AddResource(Resource.Resource, Count)
			Data1:RemoveResource(Resource.Resource, Count)
		end
	end

	for UniqueId, Count in pairs(self.Player2Resources) do
		local Resource = Data2:GetResourceFromId(UniqueId)
		if Resource then
			Data1:AddResource(Resource.Resource, Count)
			Data2:RemoveResource(Resource.Resource, Count)
		end
	end

	Data1.Profile:Save()
	Data2.Profile:Save()

	self.Completed:Fire()

	self:Delete()
end

function Trade:Delete()
	self.Destroying:Fire()
	self._Trove:Destroy()
	GenerateId.RemoveId(self.UniqueId)

	table.clear(self :: any)
	setmetatable(self :: any, nil)
end

function Trade:Destroy()
	self:Delete()
end

function Trade.GetTradeFromPlayer(Player: Player)
	for _, OtherTrade in pairs(Trades) do
		if OtherTrade.Player1 == Player or OtherTrade.Player2 == Player then
			return OtherTrade
		end
	end

	return
end

function Trade.GetTrades()
	return Trades
end

return Trade
