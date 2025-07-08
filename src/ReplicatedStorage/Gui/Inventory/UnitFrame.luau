--!strict

-- By Wa1er_God --

local DefaultImage = "rbxassetid://103876432340370"

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local BaseFrame = require(CoreGame.BaseFrame)

local Shared = ReplicatedStorage.Shared
local RarityInfo = require(Shared.RarityInfo)
local UnitInfo = require(Shared.UnitInfo)

export type Properties = {
	UnitName: string,
	Level: number | React.Binding<number>,
	Cost: number,
	Hovered: boolean?,

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
	return e(BaseFrame, {
		Name = Properties.UnitName,
		LeftText = typeof(Properties.Level) == "number" and tostring(Properties.Level) or Properties.Level :: any,
		RightText = string.format("$%u", Properties.Cost),
		RightColor = ColorSequence.new(Color3.new(1, 0.706813, 0.310231)),

		BackgroundColor = Properties.BackgroundColor,

		LeftColor = Properties.Color,
		LeftStrokeColor = Properties.StrokeColor,

		MainImage = Properties.UnitImage,
		NameColor = Properties.Color,
		NameStrokeColor = Properties.StrokeColor,

		Disabled = Properties.Disabled,
		Hovered = Properties.Hovered,
		OnClick = Properties.OnClick,

		native = Properties.native,
		children = Properties.children,
		containerChildren = Properties.containerChildren,
	})
end

export type PropertiesMain = {
	UnitName: string,
	Level: number | React.Binding<number>,
	Hovered: boolean?,

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
		Color = RarityData.Color,
		StrokeColor = RarityData.StrokeColor,
		BackgroundColor = RarityData.BackgroundColor,
		UnitImage = UnitData.Image or DefaultImage,

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
