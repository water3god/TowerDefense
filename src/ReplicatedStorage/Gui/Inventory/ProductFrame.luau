--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local BaseFrame = require(CoreGame.BaseFrame)

local Shared = ReplicatedStorage.Shared
local ProductInfo = require(Shared.ProductInfo)
local RarityInfo = require(Shared.RarityInfo)

export type ProductProps = {
	IsGamepass: boolean,
	ProductId: number,
	Count: number,
	OnClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateProductFrame(props: ProductProps)
	local ProductData = React.useMemo(function()
		if props.IsGamepass then
			return ProductInfo.GamepassInfo[props.ProductId]
		else
			return ProductInfo.ProductInfo[props.ProductId]
		end
	end, { props.ProductId, props.IsGamepass :: any })

	local RarityData = React.useMemo(function()
		local Rarity = ProductData.Rarity

		return RarityInfo[Rarity :: any]
	end, { ProductData })

	return e(BaseFrame, {
		Name = ProductData.Name,
		LeftText = "",
		RightText = string.format("%ux", props.Count),
		OnClick = props.OnClick,
		BackgroundColor = RarityData.BackgroundColor,
		NameColor = RarityData.Color,
		NameStrokeColor = RarityData.StrokeColor,
		RightColor = RarityData.Color,
		RightStrokeColor = RarityData.StrokeColor,
		native = props.native,
	}, props.children)
end

return CreateProductFrame
