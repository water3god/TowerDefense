--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Network = require(ReplicatedStorage.Network.Client)
local AllEquippedSync = Network.AllEquippedSync

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local InventoryService = require(GlobalClient.InventoryService)

local Equipped = {}
local ChangedSignals: { [Player]: Signal.Signal<DataSent> } = {}

export type UnitDataSent = {
	Id: string,
	Level: number,
	UnitName: string,
}

export type DataSent = {
	Title: string,
	Level: number,
	EquippedUnits: { UnitDataSent? },
}

export type AllDataSent = { [Player]: DataSent }

local function GetEquipped(player: Player): DataSent
	return Equipped[player] or {}
end

local Module: {
	Equipped: AllDataSent,
	Changed: Signal.Signal<Player, DataSent>,
	GetEquipped: (Player: Player) -> DataSent,
	GetChangedSignal: (Player: Player) -> Signal.Signal<DataSent>,
} =
	{
		Equipped = Equipped,
		Changed = Signal.new(),
		GetEquipped = GetEquipped,
		GetChangedSignal = function(player: Player): Signal.Signal<DataSent>
			if not ChangedSignals[player] then
				ChangedSignals[player] = Signal.new()
			end
			return ChangedSignals[player]
		end,
	}

AllEquippedSync.SetCallback(function(Data: { [Player]: DataSent })
	for Player, EquippedUnits in pairs(Data) do
		Equipped[Player] = EquippedUnits
		Module.Changed:Fire(Player, EquippedUnits)
		if ChangedSignals[Player] then
			ChangedSignals[Player]:Fire(EquippedUnits)
		end
	end
end)

local function GetUnitData(Data: { string? })
	local NewData = {}
	local Inventory = InventoryService:GetInventory()
	for Index, Id in pairs(Data) do
		if Id then
			local UnitData = Inventory.Units[Id]
			if UnitData then
				NewData[Index] = {
					Id = Id,
					Level = UnitData.Level,
					UnitName = UnitData.Unit,
				}
			end
		end
	end

	return NewData
end

local function OnLocalChanged()
	Equipped[LocalPlayer] = {
		Title = InventoryService.TitleData.EquippedTitle,
		Level = InventoryService.Level,
		EquippedUnits = GetUnitData(InventoryService.EquippedUnits),
	}
	Module.Changed:Fire(LocalPlayer, Equipped[LocalPlayer])
	if ChangedSignals[LocalPlayer] then
		ChangedSignals[LocalPlayer]:Fire(Equipped[LocalPlayer])
	end
end

task.spawn(function()
	if not InventoryService.IsSynced then
		InventoryService.Synced:Wait()
	end
	OnLocalChanged()
end)

InventoryService.UnitEquipChanged:Connect(OnLocalChanged)
InventoryService.TitleChanged:Connect(OnLocalChanged)

Players.PlayerRemoving:Connect(function(Player: Player)
	if Equipped[Player] then
		Equipped[Player] = nil
	end
end)

return Module
