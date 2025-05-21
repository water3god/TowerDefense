--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

if not require(ReplicatedStorage.Shared.IsLobby) then
	return
end

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Remotes = ReplicatedStorage.Remotes

local InventoryEvents = Remotes.Inventory
local ItemChanged = InventoryEvents.ItemChanged
local InventorySync = InventoryEvents.InventorySync
local UnitEquipped = InventoryEvents.UnitEquipped
local EquipUnit = InventoryEvents.EquipUnit
local Sell = InventoryEvents.Sell

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)

EquipUnit.OnServerEvent:Connect(function(Player: Player, Data: { UniqueId: string, Equip: boolean })
	if typeof(Data) ~= "table" then
		return
	end
	if typeof(Data.UniqueId) ~= "string" then
		return
	end

	if typeof(Data.Equip) ~= "boolean" then
		return
	end

	local PlayerData = PlayerData.GetPlayerDataAsync(Player)

	if PlayerData then
		if PlayerData.CurrentWave then
			return
		end
		if Data.Equip then
			PlayerData:EquipUnit(Data.UniqueId)
		else
			PlayerData:UnequipUnit(Data.UniqueId)
		end
	end
end)

Sell.OnServerEvent:Connect(function(Player: Player, Type: string, Data: { string })
	if typeof(Data) ~= "table" then
		return
	end

	if #Data == 0 then
		return
	end

	local PlayerData = PlayerData.GetPlayerDataAsync(Player)

	if PlayerData then
		if PlayerData.CurrentWave then
			return
		end
		local TotalCost = 0
		if Type == "Unit" then
			local PlayerUnits = PlayerData.Profile.Data.Units
			for _, UniqueId in ipairs(Data) do
				if typeof(UniqueId) ~= "string" then
					continue
				end
				local Unit = PlayerUnits[UniqueId]
				if not Unit then
					continue
				end
				local Rarity = UnitInfo.UnitInfo[Unit.Unit].Rarity
				TotalCost += RarityInfo[Rarity :: any].Value
				PlayerData:DeleteUnit(UniqueId)
			end
		elseif Type == "Product" then
			local PlayerProducts = PlayerData.Profile.Data.Products
			for _, UniqueId in ipairs(Data) do
				if typeof(UniqueId) ~= "string" then
					continue
				end
				local Product = PlayerProducts[UniqueId]
				if not Product then
					continue
				end
				local Rarity = UnitInfo.UnitInfo[Product.UniqueId].Rarity
				TotalCost += RarityInfo[Rarity :: any].Value
				PlayerData:DeleteUnit(UniqueId)
			end
		elseif Type == "Resource" then
			local PlayerResources = PlayerData.Profile.Data.Resources
			for _, UniqueId in ipairs(Data) do
				if typeof(UniqueId) ~= "string" then
					continue
				end

				local Product = PlayerResources.Products[UniqueId]
				if not Product then
					continue
				end
				local Rarity = UnitInfo.UnitInfo[Product.UniqueId].Rarity
				TotalCost += RarityInfo[Rarity :: any].Value
				PlayerData:DeleteUnit(UniqueId)
			end
		end

		PlayerData:AddGold(TotalCost)
	end
end)
