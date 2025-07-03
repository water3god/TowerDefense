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
export type UnitDataSent = {
	Id: string,
	Level: number,
	UnitName: string,
}

local function GetEquipped(player: Player): { UnitDataSent }
	return Equipped[player] or {}
end

local Module: {
	Equipped: { [Player]: { UnitDataSent } },
	Changed: Signal.Signal<Player, { UnitDataSent }>,
	GetEquipped: (Player: Player) -> { UnitDataSent },
} =
	{
		Equipped = Equipped,
		Changed = Signal.new(),
		GetEquipped = GetEquipped,
	}

AllEquippedSync.SetCallback(function(Data: { [Player]: { UnitDataSent } })
	for Player, EquippedUnits in pairs(Data) do
		Equipped[Player] = EquippedUnits
		Module.Changed:Fire(Player, EquippedUnits)
	end
end)

local function GetUnitData(Data: { string })
	local NewData = {}
	local Inventory = InventoryService:GetInventory()
	for Index, Id in pairs(Data) do
		local UnitData = Inventory.Units[Id]
		if UnitData then
			NewData[Index] = {
				Id = Id,
				Level = UnitData.Level,
				UnitName = UnitData.Unit,
			}
		end
	end

	return NewData
end

task.spawn(function()
	if not InventoryService.IsSynced then
		InventoryService.Synced:Wait()
	end
	Equipped[LocalPlayer] = GetUnitData(InventoryService.EquippedUnits)
	Module.Changed:Fire(LocalPlayer, Equipped[LocalPlayer])
end)

InventoryService.UnitEquipChanged:Connect(function()
	Equipped[LocalPlayer] = GetUnitData(InventoryService.EquippedUnits)
	Module.Changed:Fire(LocalPlayer, Equipped[LocalPlayer])
end)

Players.PlayerRemoving:Connect(function(Player: Player)
	if Equipped[Player] then
		Equipped[Player] = nil
	end
end)

return Module
