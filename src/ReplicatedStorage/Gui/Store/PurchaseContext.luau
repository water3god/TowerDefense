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

local Default: {
	ProductData: { [number]: {
		ProductInfo: PurchaseService.ProductInfo,
		Rarity: string,
	} },
	GamepassData: { [number]: {
		ProductInfo: PurchaseService.ProductInfo,
		Owned: boolean,
		Rarity: string,
	} },
	GiftIds: { [number]: number },
	Loaded: boolean,
} =
	{
		ProductData = {},
		GamepassData = {},
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
			SetPurchasesNative(SetPurchases)
		end
	end, {})

	Hooks.useEventConnection(PurchaseService.Loaded, function()
		SetPurchasesNative(SetPurchases)
	end, {})

	Hooks.useEventConnection(PurchaseService.GamepassPurchased, function()
		SetPurchasesNative(SetPurchases)
	end, {})

	return e(PurchaseContext.Provider, {
		value = Purchases,
	}, Props.children)
end

return {
	Context = PurchaseContext,
	Provider = PurchaseProvider,
}
