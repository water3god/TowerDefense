--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PurchaseService = require(ReplicatedStorage.Client.GlobalClient.PurchaseService)

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Hooks = require(CoreGame.Hooks)

export type ProductInfo = PurchaseService.ProductInfo

export type Data = {
	ProductInfo: PurchaseService.ProductInfo,
	Owned: boolean?,
	Rarity: string,
}

type Default = {
	ProductData: { [number]: {
		ProductInfo: PurchaseService.ProductInfo,
		Owned: boolean?,
		Rarity: string,
	} },
	GamepassData: { [number]: {
		ProductInfo: PurchaseService.ProductInfo,
		Owned: boolean,
		Rarity: string,
	} },
	Offers: { number },
	GiftIds: { [number]: number },
	Loaded: boolean,
}

local Default: Default = {
	ProductData = {},
	GamepassData = {},
	Offers = PurchaseService.Offers,
	GiftIds = PurchaseService.GiftIds,
	Loaded = false,
}

local PurchaseContext = React.createContext(Default)

local function SetPurchasesNative(SetPurchases: (any) -> ())
	SetPurchases({
		ProductData = PurchaseService.ProductData,
		GamepassData = PurchaseService.GamepassData,
		GiftIds = PurchaseService.GiftIds,
		Loaded = PurchaseService.IsLoaded,
	})
end

local function PurchaseProvider(Props)
	local Purchases, SetPurchases = React.useState(Default)

	React.useEffect(function()
		if PurchaseService.Loaded then
			SetPurchases({
				ProductData = PurchaseService.ProductData,
				GamepassData = PurchaseService.GamepassData,
				Offers = PurchaseService.Offers,
				GiftIds = PurchaseService.GiftIds,
				Loaded = PurchaseService.IsLoaded,
			} :: any)
		end
	end, {})

	Hooks.useEventConnection(PurchaseService.Loaded, function()
		SetPurchases({
			ProductData = PurchaseService.ProductData,
			GamepassData = PurchaseService.GamepassData,
			Offers = PurchaseService.Offers,
			GiftIds = PurchaseService.GiftIds,
			Loaded = PurchaseService.IsLoaded,
		} :: any)
	end, {})

	Hooks.useEventConnection(PurchaseService.GamepassSynced, function()
		SetPurchases(function(Old)
			Old.GamepassData = table.clone(PurchaseService.GamepassData)
			return Old
		end)
	end, {})

	return e(PurchaseContext.Provider, {
		value = Purchases,
	}, Props.children)
end

return {
	Context = PurchaseContext,
	Provider = PurchaseProvider,
}
