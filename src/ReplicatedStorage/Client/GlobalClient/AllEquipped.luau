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

local function GetEquipped(player: Player): { string }
	return Equipped[player] or {}
end

local Module: {
	Equipped: { [Player]: { string } },
	Changed: Signal.Signal<Player, { string }>,
	GetEquipped: (Player: Player) -> { string },
} =
	{
		Equipped = Equipped,
		Changed = Signal.new(),
		GetEquipped = GetEquipped,
	}

AllEquippedSync.SetCallback(function(Data: { [Player]: { string } })
	for Player, EquippedUnits in pairs(Data) do
		Equipped[Player] = EquippedUnits
		Module.Changed:Fire(Player, EquippedUnits)
	end
end)

task.spawn(function()
	if not InventoryService.IsSynced then
		InventoryService.Synced:Wait()
	end
	Equipped[LocalPlayer] = InventoryService.EquippedUnits
	Module.Changed:Fire(LocalPlayer, Equipped[LocalPlayer])
end)

InventoryService.UnitEquipChanged:Connect(function()
	Equipped[LocalPlayer] = InventoryService.EquippedUnits
	Module.Changed:Fire(LocalPlayer, Equipped[LocalPlayer])
end)

Players.PlayerRemoving:Connect(function(Player: Player)
	if Equipped[Player] then
		Equipped[Player] = nil
	end
end)

return Module
