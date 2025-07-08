--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local RarityInfo = require(Shared.RarityInfo)

type ProductData = { Name: string, Image: string, Rarity: RarityInfo.Rarity | string, Func: () -> () }

local ProductInfo: { [number]: ProductData } = {}

local GamepassInfo: { [number]: ProductData } = {}

local GiftIds: { [number]: number } = {}

local function GetProductFromName(Data: { Name: string, IsGamepass: boolean }): (ProductData?, number?)
	if Data.IsGamepass then
		for ProductId, OtherData in pairs(ProductInfo) do
			if Data.Name == OtherData.Name then
				return OtherData, ProductId
			end
		end
	else
		for ProductId, OtherData in pairs(GamepassInfo) do
			if Data.Name == OtherData.Name then
				return OtherData, ProductId
			end
		end
	end

	return
end

local function GetProductFromId(Data: { Id: number, IsGamepass: boolean }): (ProductData?, number?)
	if Data.IsGamepass then
		for ProductId, OtherData in pairs(ProductInfo) do
			if Data.Id == ProductId then
				return OtherData, ProductId
			end
		end
	else
		for ProductId, OtherData in pairs(GamepassInfo) do
			if Data.Id == ProductId then
				return OtherData, ProductId
			end
		end
	end

	return
end

return {
	GiftIds = GiftIds,
	ProductInfo = ProductInfo,
	GamepassInfo = GamepassInfo,
	GetProductFromId = GetProductFromId,
	GetProductFromName = GetProductFromName,
}
