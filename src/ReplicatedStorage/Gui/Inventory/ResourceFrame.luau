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
local GameInfo = require(Shared.GameInfo)
local RarityInfo = require(Shared.RarityInfo)

export type ResourceProps = {
	Name: string,
	Value: number?,
	LeftValue: string?,
	Hovered: boolean?,
	OnClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateResourceFrame(props: ResourceProps)
	local ResourceData = React.useMemo(function()
		return GameInfo.RewardInfo[props.Name]
	end, { props.Name })

	local RarityData = React.useMemo(function()
		local Rarity = ResourceData.Rarity
		return RarityInfo[Rarity :: any]
	end, { ResourceData })

	return e(BaseFrame, {
		LeftText = props.LeftValue or "",
		RightText = props.Value and string.format("%ux", props.Value) or "",
		Name = props.Name,
		OnClick = props.OnClick,
		MainImage = ResourceData.Image,

		Shine = RarityData.Animate,
		Hovered = props.Hovered,

		BackgroundColor = RarityData.BackgroundColor,
		NameColor = RarityData.Color,
		NameStrokeColor = RarityData.StrokeColor,
		LeftStrokeColor = ColorSequence.new(Color3.new()),
		RightColor = RarityData.Color,
		RightStrokeColor = RarityData.StrokeColor,
		native = props.native,
	}, props.children)
end

return CreateResourceFrame
