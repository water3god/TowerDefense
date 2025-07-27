--!strict

-- By Wa1er_God --

-- Services --

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Network = require(ReplicatedStorage.Network.Client)

local UseProduct = Network.UseProduct

local Shared = ReplicatedStorage.Shared
local ProductInfo = require(Shared.ProductInfo)

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
	GiftIds: { [number]: number },
	Loaded: Signal.Signal<>,
	IsLoaded: boolean,
	UsePurchase: (ProductId: number, IsGamepass: boolean) -> (),
} =
	{
		GiftPurchased = Signal.new(),
		ProductPurchased = Signal.new(),
		GamepassPurchased = Signal.new(),
		Purchased = Signal.new(),
		ProductData = {},
		GamepassData = {},
		GiftIds = ProductInfo.GiftIds,
		Loaded = Signal.new(),
		IsLoaded = false,
		UsePurchase = function(ProductId, IsGamepass)
			UseProduct.Fire(ProductId, IsGamepass)
		end,
	}

local function GamepassDone(GamepassId: number, Purchased: boolean)
	if Purchased then
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
			if UserId == Player.UserId then
				if ProductInfo.GetProductFromGiftId(ProductId) then
					Module.GiftPurchased:Fire(ProductId)
				else
					Module.ProductPurchased:Fire(ProductId)
				end
			end
		end)
	end
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(GamepassDone)
MarketplaceService.PromptProductPurchaseFinished:Connect(ProductDone)

task.spawn(function()
	for GamepassId, Data in pairs(ProductInfo.GamepassInfo) do
		Module.GamepassData[GamepassId] = {
			ProductInfo = MarketplaceService:GetProductInfo(GamepassId, Enum.InfoType.GamePass),
			Owned = MarketplaceService:UserOwnsGamePassAsync(Player.UserId, GamepassId),
			Rarity = Data.Rarity,
		}
	end
	for ProductId, Data in pairs(ProductInfo.ProductInfo) do
		Module.ProductData[ProductId] = {
			ProductInfo = MarketplaceService:GetProductInfo(ProductId, Enum.InfoType.Product),
			Rarity = Data.Rarity,
		}
	end

	Module.IsLoaded = true
	Module.Loaded:Fire()
end)

return Module
