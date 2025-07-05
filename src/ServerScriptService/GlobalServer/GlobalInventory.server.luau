--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Network = require(ReplicatedStorage.Network.Server)

local ItemChanged = Network.ItemChanged
local InventorySync = Network.InventorySync
local UnitEquipped = Network.UnitEquipped

local LevelChangedEvent = Network.LevelChanged
local XPChangedEvent = Network.LevelXPChanged

local TitleChangedEvent = Network.TitleChanged
local TitleAddedEvent = Network.TitleAdded

local function OnDataAdded(Data: PlayerData.PlayerData)
	local Player = Data.Player
	local GivenData = Data.Profile.Data
	InventorySync.Fire(
		Player,
		{
			Units = GivenData.Units,
			Gamepasses = GivenData.Gamepasses,
			Products = GivenData.Products,
			Resources = GivenData.Resources,
		},
		GivenData.EquippedUnits,
		{ Level = GivenData.Level, XP = GivenData.XP, NeededXP = Data.NeededXP },
		GivenData.MaxUnitCount,
		{
			EquippedTitle = GivenData.EquippedTitle,
			Titles = GivenData.Titles,
		}
	)

	Data.UnitEquipped:Connect(function(Unit: string, Index: number)
		UnitEquipped.Fire(Player, { UniqueId = Unit, Index = Index, Equip = true })
	end)

	Data.UnitUnequipped:Connect(function(Unit: string, Index: number)
		UnitEquipped.Fire(Player, { UniqueId = Unit, Index = Index, Equip = false })
	end)

	Data.UnitAdded:Connect(function(Unit)
		ItemChanged.Fire(Player, "Units", Unit.UniqueId, Unit)
	end)

	Data.UnitChanged:Connect(function(Unit)
		ItemChanged.Fire(Player, "Units", Unit.UniqueId, Unit)
	end)

	Data.UnitRemoved:Connect(function(Unit)
		ItemChanged.Fire(Player, "Units", Unit.UniqueId, nil)
	end)

	Data.ProductChanged:Connect(function(Type, ProductData)
		local IsNil = Type == "Removed"
		ItemChanged.Fire(Player, "Products", ProductData.UniqueId, not IsNil and ProductData)
	end)

	Data.ResourceChanged:Connect(function(Type, ResourceData)
		local IsNil = Type == "Removed"
		ItemChanged.Fire(Player, "Resources", ResourceData.UniqueId, not IsNil and ResourceData)
	end)

	Data.LeveledUp:Connect(function(Level: number)
		LevelChangedEvent.Fire(Player, Level)
	end)

	Data.XPChanged:Connect(function(XP: number)
		XPChangedEvent.Fire(Player, XP)
	end)

	Data.TitleChanged:Connect(function(Title: string)
		TitleChangedEvent.Fire(Player, Title)
	end)

	Data.TitleAdded:Connect(function(Title: string)
		TitleAddedEvent.Fire(Player, Title)
	end)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	OnDataAdded(Data)
end

PlayerData.DataAdded:Connect(OnDataAdded)
