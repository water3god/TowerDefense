--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Modules = ReplicatedStorage.Modules
local Signal = require(Modules.Signal)
local HelperFunctions = require(Modules.HelperFunctions)

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
local UnitInfo = require(Shared.UnitInfo)
local GameInfo = require(Shared.GameInfo)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local GUI = GlobalClient.GUI
local UnitFrame = GUI.UnitFrame
local RewardFrame = GUI.Reward

local CurrentInventory = {
	Units = {},
	--Gamepasses = {};
}

local LevelData: { [number]: number } = {
	[1] = 3,
	[10] = 4,
	[20] = 5,
}

local Synced = Signal.new()
local UnitAdded = Signal.new()
local UnitChanged = Signal.new()
local UnitRemoved = Signal.new()

local UnitEquipChanged = Signal.new()

local GamepassAdded = Signal.new()
local GamepassChanged = Signal.new()
local GamepassRemoved = Signal.new()

local LevelChanged = Signal.new()
local XPChanged = Signal.new()

local IsSynced = false

ItemChanged.OnClientEvent:Connect(function(Type: string, UniqueId: string, Data: any)
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
			GamepassRemoved:Fire(UniqueId)
		elseif not CurrentInventory[Type][UniqueId] then
			GamepassAdded:Fire(Data)
		else
			GamepassChanged:Fire(Data)
		end
	end
	CurrentInventory[Type][UniqueId] = Data
end)

local Data = {}

Data.Synced = Synced

Data.UnitAdded = UnitAdded
Data.UnitRemoved = UnitRemoved
Data.UnitChanged = UnitChanged

Data.UnitEquipChanged = UnitEquipChanged

Data.GamepassAdded = GamepassAdded
Data.GamepassRemoved = GamepassRemoved
Data.GamepassChanged = GamepassChanged

Data.LevelChanged = LevelChanged
Data.XPChanged = XPChanged

Data.GetItemRequest = Signal.new()

Data.IsSynced = IsSynced

Data.UnitFrame = UnitFrame

Data.EquippedUnits = {}

UnitEquipped.OnClientEvent:Connect(function(SentData: { UniqueId: string, Index: number, Equip: boolean })
	Data.EquippedUnits[SentData.Index] = if SentData.Equip then SentData.UniqueId else nil
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

local Frames = {}

function Data.ApplyDataUnitRaw(InputData: Types.RawUnitData, Frame: typeof(UnitFrame)?)
	local Frame = Frame or UnitFrame:Clone()

	local UnitData = UnitInfo.UnitInfo[InputData.Unit]
	local RarityData = UnitInfo.RarityInfo[UnitData.Rarity]
	local LevelData = UnitInfo.LevelInfo[HelperFunctions.GetSmallestNumber(UnitInfo.LevelInfo, InputData.Level)]

	local Container = Frame.Container

	local UnitNameLabel = Container.UnitName
	local NameGradient = UnitNameLabel.UIStroke.UIGradient
	local NameCoreGradient = UnitNameLabel.UIGradient

	local LevelLabel = Container.LevelLabel
	local LevelGradient = LevelLabel.UIStroke.UIGradient
	local LevelCoreGradient = LevelLabel.UIGradient

	local CostLabel = Container.CostLabel

	local BackgroundImage = Container.BackgroundImage
	local FrameUnderlayGrad = BackgroundImage.UIGradient

	local UnitImage = Container.UnitImage
	--UnitImage.Image = UnitData.

	Container.UnitName.Text = InputData.Unit
	Container.LevelLabel.Text = InputData.Level

	local function Update()
		UnitNameLabel.Text = InputData.Unit
		LevelLabel.Text = InputData.Level
		CostLabel.Text = string.format("$%u", UnitData.PlacementCost)
		FrameUnderlayGrad.Color = RarityData.BackgroundColor

		NameGradient.Color = RarityData.StrokeColor
		NameCoreGradient.Color = RarityData.UnitColor

		LevelGradient.Color = RarityData.StrokeColor
		LevelCoreGradient.Color = LevelData.MainColor
	end

	Update()

	return Frame, Update
end

function Data.ApplyDataUnitFrame(InputData: Types.VisualUnitData, Frame: typeof(UnitFrame)?)
	local Frame, Update = Data.ApplyDataUnitRaw(InputData, Frame)

	local Connection = Data.UnitChanged:Connect(function(SentUnitData)
		if SentUnitData.UniqueId == InputData.UniqueId then
			Update()
		end
	end)

	if Frames[Frame] then
		HelperFunctions.DisconnectAll(Frames[Frame])
	end

	HelperFunctions.InstanceAddkey(Frames, Frame, { Connection })

	return Frame
end

function Data.ApplyDataRewardRaw(InputData: Types.RewardData, Frame: typeof(RewardFrame)?)
	local Frame = Frame or RewardFrame:Clone()

	local RewardData = GameInfo.RewardInfo[InputData.Reward]

	local Container = Frame.Container

	local RewardType = Container.RewardType
	local NameGradient = RewardType.UIStroke.UIGradient
	local NameCoreGradient = RewardType.UIGradient

	local CountLabel = Container.CountLabel
	local CountGradient = CountLabel.UIStroke.UIGradient
	local CountCoreGradient = CountLabel.UIGradient

	local BackgroundImage = Container.BackgroundImage
	local FrameUnderlayGrad = BackgroundImage.UIGradient

	local function Update()
		RewardType.Text = InputData.Reward
		CountLabel.Text = string.format("%ux", InputData.Count)

		FrameUnderlayGrad.Color = RewardData.BackgroundColor

		CountGradient.Color = RewardData.StrokeColor
		CountCoreGradient.Color = RewardData.RewardColor

		NameGradient.Color = RewardData.StrokeColor
		NameCoreGradient.Color = RewardData.RewardColor
	end

	Update()

	return Frame, Update
end

function Data.ApplyDataOnRewardFrame() end

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
