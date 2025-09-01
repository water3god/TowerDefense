--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

if not require(ReplicatedStorage.Shared.IsLobby) then
	return
end

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Network = require(ReplicatedStorage.Network.Server)

local EquipUnit = Network.EquipUnit
local Sell = Network.ItemSell
local EquipTitle = Network.EquipTitle
local SendWarning = Network.SendWarning

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local ProductInfo = require(Shared.ProductInfo)
local GameInfo = require(Shared.GameInfo)
local RarityInfo = require(Shared.RarityInfo)

EquipUnit.SetCallback(function(Player: Player, Data: { UniqueId: string, Equip: boolean })
	if typeof(Data) ~= "table" then
		return
	end
	if typeof(Data.UniqueId) ~= "string" then
		return
	end

	if typeof(Data.Equip) ~= "boolean" then
		return
	end

	local PData = PlayerData.GetPlayerDataAsync(Player)

	if PData then
		if PData.CurrentWave then
			return
		end
		local Duplicate = false
		if Data.Equip then
			local CurrentUnit = PData.Profile.Data.Units[Data.UniqueId]
			if CurrentUnit then
				for _, UniqueId in pairs(PData.Profile.Data.EquippedUnits) do
					if UniqueId then
						local Unit = PData.Profile.Data.Units[UniqueId]
						if Unit and CurrentUnit.Unit == Unit.Unit then
							Duplicate = true
							break
						end
					end
				end
			end
			if Duplicate then
				SendWarning.Fire(Player, "You cannot equip duplicate units.")
				return
			end
			PData:EquipUnit(Data.UniqueId)
		else
			PData:UnequipUnit(Data.UniqueId)
		end
	end
end)

Sell.SetCallback(function(Player: Player, Type: string, Data: { string })
	if typeof(Data) ~= "table" then
		return
	end

	if #Data == 0 then
		return
	end

	local PData = PlayerData.GetPlayerDataAsync(Player)

	if PData then
		if PData.CurrentWave then
			return
		end
		local TotalCost = 0
		if Type == "Unit" then
			local PlayerUnits = PData.Profile.Data.Units
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
				PData:DeleteUnit(UniqueId)
			end
		elseif Type == "Product" then
			local PlayerProducts = PData.Profile.Data.Products
			for _, UniqueId in ipairs(Data) do
				if typeof(UniqueId) ~= "string" then
					continue
				end
				local Product = PlayerProducts[UniqueId]
				if not Product then
					continue
				end
				local ProductData = ProductInfo.GetProductFromIdOnly(Product.ProductId)

				if ProductData then
					local Rarity = ProductData.Rarity
					TotalCost += (RarityInfo[Rarity :: any].Value * Product.Count)
					PData:RemoveProduct(Product.ProductId)
				end
			end
		elseif Type == "Resource" then
			local PlayerResources = PData.Profile.Data.Resources
			for _, UniqueId in ipairs(Data) do
				if typeof(UniqueId) ~= "string" then
					continue
				end

				local Resource = PlayerResources[UniqueId]
				if not Resource then
					continue
				end
				local Rarity = UnitInfo.UnitInfo[Resource.Resource].Rarity
				TotalCost += (RarityInfo[Rarity :: any].Value * Resource.Count) / 10
				PData:RemoveResource(Resource.Resource)
			end
		end

		PData:AddGold(TotalCost)
	end
end)

EquipTitle.SetCallback(function(Player: Player, Title: string)
	local PData = PlayerData.GetPlayerDataAsync(Player)

	if PData then
		if PData.CurrentWave then
			return
		end

		local TitleData = require(Shared.Titles)[Title]
		if not TitleData then
			return
		end

		PData:ChangeTitle(Title)
		SendWarning.Fire(Player, string.format("You have equipped the title: %s", Title), Color3.fromRGB(0, 255, 0))
	end
end)
