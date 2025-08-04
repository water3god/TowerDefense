--!strict

-- By Wa1er_God --

local DefaultImage = "rbxassetid://103876432340370"

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local BaseFrame = require(CoreGame.BaseFrame)
local AnimatedGradient = require(CoreGame.AnimatedGradient)

local Shared = ReplicatedStorage.Shared
local RarityInfo = require(Shared.RarityInfo)
local UnitInfo = require(Shared.UnitInfo)
local Traits = require(Shared.Traits)
export type Properties = {
	UnitName: string,
	Level: number | React.Binding<number>,
	Cost: number,
	Hovered: boolean?,
	Trait: string?,
	Hidden: boolean?,
	Shine: boolean?,

	UnitImage: string,
	Color: ColorSequence?,
	StrokeColor: ColorSequence?,
	BackgroundColor: ColorSequence?,

	Disabled: boolean?,
	OnClick: ((...any) -> ...any)?,

	native: { [any]: any }?,
	children: { [any]: any }?,
	containerChildren: { [any]: any }?,
}

local function CreateUnitFrameRaw(Properties: Properties)
	local TraitFrame = React.useMemo(function(): React.Node?
		if Properties.Trait then
			local TraitData = Traits.Traits[Properties.Trait]

			if TraitData then
				local RarityData = RarityInfo[TraitData.Rarity :: any]
				return e(Main.ImageLabel, {
					native = {
						Size = UDim2.fromScale(0.3, 0.3),
						Position = UDim2.fromScale(0.7, 0.5),
					},
				}, {
					UIGradient = e(AnimatedGradient, {
						GradColor = RarityData.Color,
						Animate = true,
						Speed = 1,
					}),
				})
			end
		end

		return nil
	end, { Properties.Trait })

	return e(BaseFrame, {
		Name = Properties.UnitName,
		LeftText = typeof(Properties.Level) == "number" and tostring(Properties.Level) or Properties.Level :: any,
		RightText = string.format("$%u", Properties.Cost),
		RightColor = ColorSequence.new(Color3.new(1, 0.706813, 0.310231)),
		Hidden = Properties.Hidden,

		BackgroundColor = Properties.BackgroundColor,

		LeftColor = Properties.Color,
		LeftStrokeColor = Properties.StrokeColor,

		MainImage = Properties.UnitImage,
		NameColor = Properties.Color,
		NameStrokeColor = Properties.StrokeColor,

		Shine = Properties.Shine,

		Disabled = Properties.Disabled,
		Hovered = Properties.Hovered,
		OnClick = Properties.OnClick,

		native = Properties.native,
		containerChildren = Properties.containerChildren,
	}, {
		TraitFrame = TraitFrame,
	}, Properties.children)
end

export type PropertiesMain = {
	UnitName: string,
	Level: number | React.Binding<number>,
	Hovered: boolean?,
	Trait: string?,
	Hidden: boolean?,

	Disabled: boolean?,
	OnClick: ((...any) -> ...any)?,

	native: { [any]: any }?,
	children: { [any]: any }?,
	containerChildren: { [any]: any }?,
}

local function CreateUnitFrame(Properties: PropertiesMain)
	local UnitData = React.useMemo(function()
		local Data = UnitInfo.UnitInfo[Properties.UnitName]

		if not Data then
			warn("No Data For Unit Name: " .. Properties.UnitName)
		end
		return Data
	end, { Properties.UnitName })
	local RarityData = React.useMemo(function()
		return RarityInfo[UnitData.Rarity]
	end, { UnitData.Rarity })

	return e(CreateUnitFrameRaw, {
		UnitName = Properties.UnitName,
		Level = Properties.Level,
		Cost = UnitData.UnitData[0].Cost,
		Trait = Properties.Trait,
		Color = RarityData.Color,
		StrokeColor = RarityData.StrokeColor,
		BackgroundColor = RarityData.BackgroundColor,
		UnitImage = UnitData.Image or DefaultImage,
		Hidden = Properties.Hidden,
		Shine = RarityData.Animate,

		Disabled = Properties.Disabled,
		Hovered = Properties.Hovered,
		OnClick = Properties.OnClick,

		native = Properties.native,
		containerChildren = Properties.containerChildren,
	}, Properties.children)
end

return {
	CreateUnitFrame = CreateUnitFrame,
	Raw = CreateUnitFrameRaw,
}
