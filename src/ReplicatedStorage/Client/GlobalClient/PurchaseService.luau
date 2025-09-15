--!strict

-- By Wa1er_God --

-- Services --
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local Signal = require(Packages.Signal)

local Network = require(ReplicatedStorage.Network.Client)

local UseProduct = Network.UseProduct
local OwnedGamepasses = Network.OwnedGamepasses

local Shared = ReplicatedStorage.Shared
local ProductInfo = require(Shared.ProductInfo)

export type Offer = ProductInfo.Offer
export type Offers = ProductInfo.Offers

export type ProductInfo = {
	Name: string,
	Description: string,
	PriceInRobux: number,
	ProductId: number,
	ProductType: string,
	Created: string, -- Time (Unix Timestamp) --
	Updated: string, -- Time (Unix Timestamp) --
	ContentRatingTypeId: boolean,
	MinimumMembershipLevel: number,
	IsPublicDomain: boolean, -- (Is Free) --
	TargetId: number,
	Creator: {
		CreatorType: Enum.CreatorType,
		CreatorTargetId: number,
		HasVerifiedBadge: boolean,
		Name: string,
		Id: number, -- Proxy for CreatorTargetId --
	},
	AssetId: number,
	AssetTypeId: number,
	IconImageAssetId: number,
	IsForSale: boolean,
	IsLimited: boolean,
	IsLimitedUnique: boolean,
	IsNew: boolean,
	Remaining: boolean,
	Sales: number,
	CollectibleItemId: string,
	CollectibleProductId: string,
	CollectiblesItemDetails: {
		CollectibleLowestAvailableResaleItemInstanceId: number,
		CollectibleLowestAvailableResaleProductId: number,
		CollectibleLowestResalePrice: number,
		IsForSale: boolean,
		IsLimited: boolean,
		TotalQuantity: number,
	},
	CanBeSoldInThisGame: boolean,
	SaleLocation: {
		SaleLocationType: Enum.ProductLocationRestriction,
		UniverseIds: { number },
	},
}

local Module: {
	GiftPurchased: Signal.Signal<number>,
	ProductPurchased: Signal.Signal<number>,
	GamepassPurchased: Signal.Signal<number>,
	Purchased: Signal.Signal<>,
	ProductData: { [number]: {
		ProductInfo: ProductInfo,
		Rarity: string,
	} },
	GamepassData: { [number]: {
		ProductInfo: ProductInfo,
		Owned: boolean,
		Rarity: string,
	} },
	Offers: Offers,
	GiftIds: { [number]: number },
	GamepassSynced: Signal.Signal<{ number }>,
	Loaded: Signal.Signal<>,
	IsLoaded: boolean,
	UsePurchase: (ProductId: number, IsGamepass: boolean) -> (),
	OwnsGamepass: (GamepassId: number) -> boolean,
} =
	{
		GiftPurchased = Signal.new(),
		ProductPurchased = Signal.new(),
		GamepassPurchased = Signal.new(),
		Purchased = Signal.new(),
		ProductData = {},
		GamepassData = {},
		Offers = ProductInfo.Offers,
		GiftIds = ProductInfo.GiftIds,
		GamepassSynced = Signal.new(),
		Loaded = Signal.new(),
		IsLoaded = false,
		UsePurchase = function(ProductId, IsGamepass)
			UseProduct.Fire(ProductId, IsGamepass)
		end,
		OwnsGamepass = function()
			return false
		end,
	}

function Module.OwnsGamepass(GamepassId: number): boolean
	return Module.GamepassData[GamepassId] and Module.GamepassData[GamepassId].Owned or false
end

local function GamepassDone(Player: Player, GamepassId: number, Purchased: boolean)
	if LocalPlayer == Player and Purchased then
		task.spawn(function()
			if not Module.IsLoaded then
				Module.Loaded:Wait()
			end
			Module.GamepassData[GamepassId].Owned = true
			Module.GamepassPurchased:Fire(GamepassId)
		end)
	end
end

local function ProductDone(UserId: number, ProductId: number, Purchased: boolean)
	if Purchased then
		task.spawn(function()
			if not Module.IsLoaded then
				Module.Loaded:Wait()
			end
			if UserId == LocalPlayer.UserId then
				local ProductFromGiftId = ProductInfo.GiftIds[ProductId]
				if ProductFromGiftId then
					Module.GiftPurchased:Fire(ProductFromGiftId)
				else
					Module.ProductPurchased:Fire(ProductId)
				end
			end
		end)
	end
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(GamepassDone)
MarketplaceService.PromptProductPurchaseFinished:Connect(ProductDone)

local GamepassIds = nil

OwnedGamepasses.SetCallback(function(Ids: { number })
	GamepassIds = Ids

	for GamepassId, _ in pairs(ProductInfo.GamepassInfo) do
		if Module.GamepassData[GamepassId] then
			Module.GamepassData[GamepassId].Owned = table.find(Ids, GamepassId) ~= nil
		end
	end

	Module.GamepassSynced:Fire(Ids)
end)

local Promises = {}

for ProductId, Data in pairs(ProductInfo.ProductInfo) do
	local ProductPromise = Promise.retryWithDelay(function()
		return Promise.try(function()
			return MarketplaceService:GetProductInfo(ProductId, Enum.InfoType.Product)
		end)
	end, 10, 5)
		:andThen(function(Info: ProductInfo)
			Module.ProductData[ProductId] = {
				ProductInfo = Info,
				Rarity = Data.Rarity,
			}
		end)
		:catch(function(error)
			print(error)
		end)

	table.insert(Promises, ProductPromise)
end

local Ids = if RunService:IsRunning() then GamepassIds or Module.GamepassSynced:Wait() else {}
for GamepassId, Data in pairs(ProductInfo.GamepassInfo) do
	local GamepassPromise = Promise.retryWithDelay(function()
		return Promise.try(function()
			return MarketplaceService:GetProductInfo(GamepassId, Enum.InfoType.GamePass)
		end)
	end, 10, 5)
		:andThen(function(Info: ProductInfo)
			print("[DEBUG]", "Ran")
			Module.GamepassData[GamepassId] = {
				ProductInfo = Info,
				Owned = table.find(Ids, GamepassId) ~= nil,
				Rarity = Data.Rarity,
			}
		end)
		:catch(function(error)
			print(error)
		end)

	table.insert(Promises, GamepassPromise)
end

Promise.all(Promises)
	:andThen(function()
		print("Loaded")
		Module.IsLoaded = true
		Module.Loaded:Fire()
	end)
	:catch(function()
		LocalPlayer:Kick("Failed to load Product Data")
	end)

return Module
