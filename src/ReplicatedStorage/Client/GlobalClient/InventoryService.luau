--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Remotes = ReplicatedStorage.Remotes
local InventoryEvents = Remotes.Inventory
local InventorySync = InventoryEvents.InventorySync
local ItemChanged = InventoryEvents.ItemChanged
local UnitEquipped = InventoryEvents.UnitEquipped
local EquipUnit = InventoryEvents.EquipUnit
local SellUnits = InventoryEvents.SellUnit

local LevelEvents = Remotes.Level
local LevelChangedEvent = LevelEvents.LevelChanged
local XPChangedEvent = LevelEvents.XPChanged

local Shared = ReplicatedStorage.Shared
local Types = require(Shared.Types)

local CurrentInventory: {
	Units: {
		[string]: Types.VisualUnitData,
	},
	Products: {
		[string]: Types.ProductData,
	},
	Resources: {
		[string]: Types.ResourceData,
	},
} =
	{
		Units = {},
		Products = {},
		Resources = {},
	}
local Synced = Signal.new()
local UnitAdded = Signal.new()
local UnitChanged = Signal.new()
local UnitRemoved = Signal.new()

local UnitEquipChanged = Signal.new()

local ProductAdded = Signal.new()
local ProductChanged = Signal.new()
local ProductRemoved = Signal.new()

local ResourceAdded = Signal.new()
local ResourceChanged = Signal.new()
local ResourceRemoved = Signal.new()

local LevelChanged = Signal.new()
local XPChanged = Signal.new()

local IsSynced = false

ItemChanged.OnClientEvent:Connect(function(Type: string, UniqueId: string, Data: any)
	CurrentInventory[Type][UniqueId] = Data
	if Type == "Units" then
		if Data == nil then
			UnitRemoved:Fire(UniqueId)
		elseif not CurrentInventory[Type][UniqueId] then
			UnitAdded:Fire(Data)
		else
			UnitChanged:Fire(Data)
		end
	elseif Type == "Gamepasses" then
		if Data == nil then
			ProductRemoved:Fire(UniqueId)
		elseif not CurrentInventory[Type][UniqueId] then
			ProductAdded:Fire(Data)
		else
			ProductChanged:Fire(Data)
		end
	elseif Type == "Resources" then
		if Data == nil then
			ResourceRemoved:Fire(UniqueId)
		elseif not CurrentInventory[Type][UniqueId] then
			ResourceAdded:Fire(Data)
		else
			ResourceChanged:Fire(Data)
		end
	end
end)

local Data = {}

Data.Synced = Synced

Data.UnitAdded = UnitAdded
Data.UnitRemoved = UnitRemoved
Data.UnitChanged = UnitChanged

Data.UnitEquipChanged = UnitEquipChanged

Data.ProductAdded = ProductAdded
Data.ProductRemoved = ProductRemoved
Data.ProductChanged = ProductChanged

Data.ResourceAdded = ResourceAdded
Data.ResourceRemoved = ResourceRemoved
Data.ResourceChanged = ResourceChanged

Data.LevelChanged = LevelChanged
Data.XPChanged = XPChanged

Data.GetItemRequest = Signal.new()

Data.IsSynced = IsSynced

Data.EquippedUnits = {} :: { string }

UnitEquipped.OnClientEvent:Connect(function(SentData: { UniqueId: string, Index: number, Equip: boolean })
	Data.EquippedUnits[SentData.Index] = if SentData.Equip then SentData.UniqueId else nil :: any
	UnitEquipChanged:Fire(SentData)
end)

InventorySync.OnClientEvent:Connect(function(SentData: any, EquippedUnits: { string }, LevelData: any)
	Data.IsSynced = true
	CurrentInventory = SentData
	Data.EquippedUnits = EquippedUnits

	Data.Level = LevelData.Level
	Data.XP = LevelData.XP
	Data.NeededXP = LevelData.NeededXP
	Synced:Fire()
end)

LevelChangedEvent.OnClientEvent:Connect(function(Level: number)
	Data.Level = Level
	LevelChanged:Fire(Level)
end)

XPChangedEvent.OnClientEvent:Connect(function(XP: number)
	Data.XP = XP
	XPChanged:Fire(XP)
end)

function Data:GetInventory()
	return CurrentInventory
end

function Data.UnitIsEquipped(UniqueId: string): number?
	for Index, Id in ipairs(Data.EquippedUnits) do
		if Id == UniqueId then
			return Index
		end
	end
	return
end

function Data.EquipUnit(Id: string, Equip: boolean)
	EquipUnit:FireServer({ UniqueId = Id, Equip = Equip })
end

function Data.SellUnits(Ids: { string })
	SellUnits:FireServer(Ids)
end

function Data.RequestForItem(Type: string?)
	Data.GetItemRequest:Fire(Type)
end

return Data
