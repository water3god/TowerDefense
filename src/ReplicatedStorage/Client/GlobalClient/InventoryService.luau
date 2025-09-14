--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Network = require(ReplicatedStorage.Network.Client)
local InventorySync = Network.InventorySync
local ItemChanged = Network.ItemChanged
local UnitEquipped = Network.UnitEquipped
local EquipUnit = Network.EquipUnit
local Sell = Network.ItemSell

local LevelChangedEvent = Network.LevelChanged
local XPChangedEvent = Network.LevelXPChanged

local TitleChangedEvent = Network.TitleChanged
local TitleAddedEvent = Network.TitleAdded
local EquipTitle = Network.EquipTitle

local InventorySpaceChanged = Network.InventorySpaceChanged

local Shared = ReplicatedStorage.Shared
local Types = require(Shared.Types)
local GameInfo = require(Shared.GameInfo)

export type VisualUnitData = Types.VisualUnitData
export type ProductData = Types.ProductData
export type ResourceData = Types.ResourceData

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

ItemChanged.SetCallback(function(Type: string, UniqueId: string, Data: any)
	CurrentInventory[Type][UniqueId] = Data
	if Type == "Units" then
		if Data == nil then
			UnitRemoved:Fire(UniqueId)
		elseif not CurrentInventory[Type][UniqueId] then
			UnitAdded:Fire(Data)
		else
			UnitChanged:Fire(Data)
		end
	elseif Type == "Products" then
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

Data.TitleChanged = Signal.new()
Data.TitleAdded = Signal.new()

Data.InventorySpaceChanged = Signal.new()

Data.GetItemRequest = Signal.new()

Data.IsSynced = IsSynced

Data.EquippedUnits = {} :: { string? }
Data.MaxUnitCount = 100

UnitEquipped.SetCallback(function(SentData: { UniqueId: string, Index: number, Equip: boolean })
	Data.EquippedUnits[SentData.Index] = if SentData.Equip then SentData.UniqueId else nil :: any
	UnitEquipChanged:Fire(SentData)
end)

InventorySync.SetCallback(
	function(
		SentData: any,
		EquippedUnits: { string? },
		LevelData: any,
		MaxUnitCount: number,
		TitleData: { EquippedTitle: string, Titles: { string } }
	)
		CurrentInventory = SentData
		Data.EquippedUnits = EquippedUnits

		Data.Level = LevelData.Level
		Data.XP = LevelData.XP
		Data.NeededXP = LevelData.NeededXP

		Data.TitleData = TitleData

		Data.MaxUnitCount = MaxUnitCount
		Data.IsSynced = true
		Synced:Fire()
	end
)

LevelChangedEvent.SetCallback(function(Level: number)
	Data.Level = Level
	Data.NeededXP = GameInfo.XPData.CalculateUnitXP(Level)
	LevelChanged:Fire(Level)
end)

XPChangedEvent.SetCallback(function(XP: number)
	Data.XP = XP
	XPChanged:Fire(XP)
end)

TitleAddedEvent.SetCallback(function(Title: string)
	if Data.TitleData then
		table.insert(Data.TitleData.Titles, Title)
		Data.TitleAdded:Fire(Title)
	end
end)

TitleChangedEvent.SetCallback(function(Title: string)
	if Data.TitleData then
		Data.TitleData.EquippedTitle = Title
		Data.TitleChanged:Fire(Title)
	end
end)

InventorySpaceChanged.SetCallback(function(Space: number)
	Data.MaxUnitCount = Space
	Data.InventorySpaceChanged:Fire(Space)
end)

function Data:GetInventory()
	return CurrentInventory
end

function Data.UnitIsEquipped(UniqueId: string): number?
	for Index, Id in pairs(Data.EquippedUnits) do
		if Id == UniqueId then
			return Index
		end
	end
	return
end

function Data.EquipUnit(Id: string, Equip: boolean)
	EquipUnit.Fire({ UniqueId = Id, Equip = Equip })
end

function Data.SellUnits(Ids: { string })
	Sell.Fire("Unit", Ids)
end

function Data.SellProducts(Ids: { string })
	Sell.Fire("Product", Ids)
end

function Data.SellResources(Ids: { string })
	Sell.Fire("Resource", Ids)
end

function Data.RequestForItem(Type: string?)
	Data.GetItemRequest:Fire(Type)
end

function Data.EquipTitle(Title: string)
	EquipTitle.Fire(Title)
end

return Data
