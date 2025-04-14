--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local JoinDicts = HelperFunctions.joinDicts

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local BaseFrame = require(CoreGame.BaseFrame)

export type Properties = {
	UnitName: string,
	Level: number,
	Cost: number,
	Hovered: boolean,

	Color: ColorSequence,
	StrokeColor: ColorSequence,
	BackgroundColor: ColorSequence,

	OnClick: (...any) -> ...any?,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateUnitFrame(Properties: Properties)
	return e(BaseFrame, {
		Name = Properties.UnitName,
		LeftText = tostring(Properties.Level),
		RightText = string.format("$%u", Properties.Cost),
		RightColor = ColorSequence.new(Color3.new(1, 0.706813, 0.310231)),

		BackgroundColor = Properties.BackgroundColor,

		LeftColor = Properties.Color,
		LeftStrokeColor = Properties.StrokeColor,

		NameColor = Properties.Color,
		NameStrokeColor = Properties.StrokeColor,

		Hovered = Properties.Hovered,
		OnClick = Properties.OnClick,

		native = Properties.native,
		children = Properties.children,
	})
end

return CreateUnitFrame
