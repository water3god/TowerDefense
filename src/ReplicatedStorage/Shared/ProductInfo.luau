--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local RarityInfo = require(Shared.RarityInfo)

export type ProductData = { Name: string, Rarity: RarityInfo.Rarity | string, Priority: number, Func: () -> ()? }

local Offers = { 3385224877 }

local ProductInfo: { [number]: ProductData } = {
	-- Offers --
	[3385224877] = {
		Name = "Trajan's Offer",
		Rarity = "Legendary",
		Priority = 1001,
	},

	-- Products --

	[3348441372] = {
		Name = "1000 Gold",
		Rarity = "Common",
		Priority = 1,
	},
	[3348441586] = {
		Name = "2000 Gold",
		Rarity = "Common",
		Priority = 2,
	},
	[3348442115] = {
		Name = "5000 Gold",
		Rarity = "Common",
		Priority = 3,
	},
	[3348442394] = {
		Name = "20000 Gold",
		Rarity = "Common",
		Priority = 4,
	},
	[3348443298] = {
		Name = "100000 Gold",
		Rarity = "Common",
		Priority = 5,
	},
	[3359654911] = {
		Name = "10 Omen Coins",
		Rarity = "Common",
		Priority = 6,
	},
	[3359655092] = {
		Name = "50 Omen Coins",
		Rarity = "Common",
		Priority = 7,
	},
	[3359656288] = {
		Name = "100 Omen Coins",
		Rarity = "Common",
		Priority = 8,
	},
	[3359656647] = {
		Name = "1000 Omen Coins",
		Rarity = "Common",
		Priority = 9,
	},
	[3359651817] = {
		Name = "2x Luck Boost (1 Hour)",
		Rarity = "Rare",
		Priority = 10,
	},
	[3359652520] = {
		Name = "3x Luck Boost (1 Hour)",
		Rarity = "Rare",
		Priority = 11,
	},
}

local GamepassInfo: { [number]: ProductData } = {
	[1382164818] = {
		Name = "VIP",
		Rarity = "Legendary",
		Priority = 1,
	},
	[1403443463] = {
		Name = "Ultra VIP",
		Rarity = "Legendary",
		Priority = 2,
	},
	[1403365727] = {
		Name = "20% XP Boost",
		Rarity = "Legendary",
		Priority = 3,
	},
}

-- GiftId = ProductId --
local GiftIds: { [number]: number } = {
	-- Gamepasses --
	[3360124700] = 1382164818, -- VIP --
	[3371898460] = 1403443463, -- Ultra VIP --
	[3371892823] = 1403365727, -- 20% XP Boost --
	-- Products --
	[3370830163] = 3359654911, -- 10 Omen Coins --
	[3370847071] = 3359655092, -- 50 Omen Coins --
	[3370831087] = 3359656288, -- 100 Omen Coins --
	[3370831549] = 3359656647, -- 1000 Omen Coins --

	[3370833945] = 3348441372, -- 1000 Gold --
	[3370834600] = 3348441586, -- 2000 Gold --
	[3370835080] = 3348442115, -- 5000 Gold --
	[3370836058] = 3348442394, -- 20000 Gold --
	[3370835535] = 3348443298, -- 100000 Gold --

	[3370831956] = 3359651817, -- 2x Luck Boost (1 Hour) --
	[3370832916] = 3359652520, -- 3x Luck Boost (1 Hour) --

	-- Offers --

	[3385226960] = 3385224877, -- Trajan's Offer --
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

local function GetProductIdFromGiftId(GiftId: number)
	for GiftKey, ProductId in pairs(GiftIds) do
		if ProductId == GiftId then
			return GiftKey :: number?
		end
	end

	return nil
end

return {
	Offers = Offers,
	GiftIds = GiftIds,
	ProductInfo = ProductInfo,
	GamepassInfo = GamepassInfo,
	ProductIsGamepass = ProductIsGamepass,
	GetProductFromId = GetProductFromId,
	GetProductFromName = GetProductFromName,
	GetProductFromIdOnly = GetProductFromIdOnly,
	GetProductFromNameOnly = GetProductFromNameOnly,
	GetProductFromGiftId = GetProductFromGiftId,
	GetProductIdFromGiftId = GetProductIdFromGiftId,
}
