--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Remotes = ReplicatedStorage.Remotes

-- Inventory --

local InventoryEvents = Remotes.Inventory
local ItemChanged = InventoryEvents.ItemChanged
local InventorySync = InventoryEvents.InventorySync
local UnitEquipped = InventoryEvents.UnitEquipped

local UnitData = require(ServerStorage.Data.UnitData)

local function OnDataAdded(Data: PlayerData.PlayerData)
	local Player = Data.Player
	local GivenData = Data.Profile.Data
	InventorySync:FireClient(
		Player,
		{
			Units = GivenData.Units,
			Gamepasses = GivenData.Gamepasses,
			Products = GivenData.Products,
			Resources = GivenData.Resources,
		},
		GivenData.EquippedUnits,
		{ Level = GivenData.Level, XP = GivenData.XP, NeededXP = Data.NeededXP },
		GivenData.MaxUnitCount
	)

	Data.UnitEquipped:Connect(function(Unit: string, Index: number)
		UnitEquipped:FireClient(Player, { UniqueId = Unit, Index = Index, Equip = true })
	end)

	Data.UnitUnequipped:Connect(function(Unit: string, Index: number)
		UnitEquipped:FireClient(Player, { UniqueId = Unit, Index = Index, Equip = false })
	end)

	Data.UnitAdded:Connect(function(Unit)
		ItemChanged:FireClient(Player, "Units", Unit.UniqueId, Unit)
	end)

	Data.UnitChanged:Connect(function(Unit)
		ItemChanged:FireClient(Player, "Units", Unit.UniqueId, Unit)
	end)

	Data.UnitRemoved:Connect(function(Unit)
		ItemChanged:FireClient(Player, "Units", Unit.UniqueId, nil)
	end)

	Data.ProductChanged:Connect(function(Type, Data)
		local IsNil = Type == "Removed"
		ItemChanged:FireClient(Player, "Products", Data.UniqueId, not IsNil and Data)
	end)

	Data.ResourceChanged:Connect(function(Type, Data)
		local IsNil = Type == "Removed"
		ItemChanged:FireClient(Player, "Resources", Data.UniqueId, not IsNil and Data)
	end)
end

for Id, Data in pairs(PlayerData.GetDatas()) do
	OnDataAdded(Data)
end

PlayerData.DataAdded:Connect(OnDataAdded)
