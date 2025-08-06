--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local BaseFrame = require(CoreGame.BaseFrame)
local UIStroke = require(CoreGame.UIStroke)

local Shared = ReplicatedStorage.Shared
local ProductInfo = require(Shared.ProductInfo)
local RarityInfo = require(Shared.RarityInfo)

local PurchaseContext = require(ReplicatedStorage.Gui.Store.PurchaseContext)

export type ProductProps = {
	IsGamepass: boolean,
	ProductId: number,
	Count: number,

	Purchaseable: boolean?,
	Hovered: boolean?,

	OnClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateProductFrame(props: ProductProps)
	local PurchaseData = React.useContext(PurchaseContext.Context)

	local ProductData = React.useMemo(function()
		if props.IsGamepass then
			return ProductInfo.GamepassInfo[props.ProductId]
		else
			return ProductInfo.ProductInfo[props.ProductId]
		end
	end, { props.ProductId, props.IsGamepass, PurchaseData } :: { unknown })

	local RarityData = React.useMemo(function()
		local Rarity = ProductData.Rarity

		return RarityInfo[Rarity :: any]
	end, { ProductData })

	local OnClick = React.useCallback(function()
		if props.Purchaseable then
			if props.IsGamepass then
				MarketplaceService:PromptGamePassPurchase(game.Players.LocalPlayer, props.ProductId)
			else
				MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, props.ProductId)
			end
		end
		if props.OnClick then
			props.OnClick()
		end
	end, { props.OnClick, props.Purchaseable, props.ProductId, props.IsGamepass } :: { unknown })

	local Info = React.useMemo(function(): PurchaseContext.Data?
		if not PurchaseData.Loaded then
			return nil
		end

		if props.IsGamepass then
			return PurchaseData.GamepassData[props.ProductId]
		else
			return PurchaseData.ProductData[props.ProductId]
		end
	end, { props.ProductId, props.IsGamepass, PurchaseData } :: { unknown })

	local PriceText = React.useMemo(function()
		if Info then
			return HelperFunctions.NumberScaler.ShortenNumber(Info.ProductInfo.PriceInRobux)
		else
			return ""
		end
	end, { Info })

	return e(BaseFrame, {
		Name = ProductData.Name,
		LeftText = "",
		RightText = not props.Purchaseable and string.format("%ux", props.Count) or "",
		OnClick = OnClick,

		Shine = RarityData.Animate,
		Hovered = props.Hovered,

		BackgroundColor = RarityData.BackgroundColor,
		NameColor = RarityData.Color,
		NameStrokeColor = RarityData.StrokeColor,
		RightColor = RarityData.Color,
		RightStrokeColor = RarityData.StrokeColor,
		native = props.native,
		containerChildren = {
			RobuxLabel = props.Purchaseable and Info and e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.2),
					Size = UDim2.fromScale(0.7, 0.16),
					Text = string.format("\u{E002}%s", PriceText),
					TextColor3 = Color3.new(0.078431, 1, 0.231373),
				},
			}),
			Owned = props.Purchaseable and Info and e(Main.TextLabel, {
				native = {
					Visible = Info.Owned == true,
					Text = "Owned!",
					Size = UDim2.fromScale(0.9, 0.3),
					Rotation = -45,
					ZIndex = 5,
					TextColor3 = Color3.new(0.568627, 0.568627, 0.568627),
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
				}),
			}),
		},
	}, props.children)
end

return CreateProductFrame
