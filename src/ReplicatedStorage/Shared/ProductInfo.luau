--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local RarityInfo = require(Shared.RarityInfo)

export type ProductData = { Name: string, Rarity: RarityInfo.Rarity | string, Func: () -> ()? }

local ProductInfo: { [number]: ProductData } = {
	[3348441372] = {
		Name = "1000 Gold",
		Rarity = "Common",
	},
	[3348441586] = {
		Name = "2000 Gold",
		Rarity = "Common",
	},
	[3348442115] = {
		Name = "5000 Gold",
		Rarity = "Common",
	},
	[3348442394] = {
		Name = "20000 Gold",
		Rarity = "Common",
	},
	[3348443298] = {
		Name = "100000 Gold",
		Rarity = "Common",
	},
	[3359651817] = {
		Name = "2x Luck Boost (1 Hour)",
		Rarity = "Rare",
	},
	[3359652520] = {
		Name = "3x Luck Boost (1 Hour)",
		Rarity = "Rare",
	},
	[3359654911] = {
		Name = "10 Omen Coins",
		Rarity = "Common",
	},
	[3359655092] = {
		Name = "50 Omen Coins",
		Rarity = "Common",
	},
	[3359656288] = {
		Name = "100 Omen Coins",
		Rarity = "Common",
	},
	[3359656647] = {
		Name = "1000 Omen Coins",
		Rarity = "Common",
	},
}

local GamepassInfo: { [number]: ProductData } = {
	[1382164818] = {
		Name = "VIP",
		Rarity = "Legendary",
	},
}

-- GiftId = ProductId --
local GiftIds: { [number]: number } = {
	[3360124700] = 1382164818, -- VIP --
}

local function GetProductFromName(Data: { Name: string, IsGamepass: boolean }): (ProductData?, number?)
	if Data.IsGamepass then
		for ProductId, OtherData in pairs(GamepassInfo) do
			if Data.Name == OtherData.Name then
				return OtherData, ProductId
			end
		end
	else
		for ProductId, OtherData in pairs(ProductInfo) do
			if Data.Name == OtherData.Name then
				return OtherData, ProductId
			end
		end
	end

	return
end

local function GetProductFromNameOnly(Name: string): (ProductData?, number?, boolean?)
	for ProductId, OtherData in pairs(ProductInfo) do
		if Name == OtherData.Name then
			return OtherData, ProductId, false
		end
	end
	for ProductId, OtherData in pairs(GamepassInfo) do
		if Name == OtherData.Name then
			return OtherData, ProductId, true
		end
	end

	return
end

local function GetProductFromId(Data: { Id: number, IsGamepass: boolean }): (ProductData?, number?)
	if Data.IsGamepass then
		for ProductId, OtherData in pairs(GamepassInfo) do
			if Data.Id == ProductId then
				return OtherData, ProductId
			end
		end
	else
		for ProductId, OtherData in pairs(ProductInfo) do
			if Data.Id == ProductId then
				return OtherData, ProductId
			end
		end
	end

	return
end

local function GetProductFromIdOnly(Id: number): (ProductData?, boolean?)
	for ProductId, OtherData in pairs(ProductInfo) do
		if Id == ProductId then
			return OtherData, false
		end
	end
	for ProductId, OtherData in pairs(GamepassInfo) do
		if Id == ProductId then
			return OtherData, true
		end
	end

	return
end

local function ProductIsGamepass(ProductId: number): boolean
	if ProductInfo[ProductId] then
		return true
	elseif GamepassInfo[ProductId] then
		return false
	else
		error("Product with ID " .. tostring(ProductId) .. " does not exist.")
	end
end

local function GetProductFromGiftId(GiftId: number): (ProductData?, boolean?)
	if GiftIds[GiftId] then
		return GetProductFromIdOnly(GiftIds[GiftId])
	else
		return nil, nil
	end
end

return {
	GiftIds = GiftIds,
	ProductInfo = ProductInfo,
	GamepassInfo = GamepassInfo,
	ProductIsGamepass = ProductIsGamepass,
	GetProductFromId = GetProductFromId,
	GetProductFromName = GetProductFromName,
	GetProductFromIdOnly = GetProductFromIdOnly,
	GetProductFromNameOnly = GetProductFromNameOnly,
	GetProductFromGiftId = GetProductFromGiftId,
}
