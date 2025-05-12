--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local BaseFrame = require(CoreGame.BaseFrame)

export type Properties = {
	Name: string,
	Icon: string,
	OnClick: (...any) -> ...any,

	native: { [any]: any }?,
	children: { [any]: any }?,

	Position: UDim2?,
	Size: UDim2?,
}

local function CreateButtonFrame(Properties: Properties)
	return e(BaseFrame, {
		Name = Properties.Name,
		LeftText = "",
		RightText = "",
		Image = Properties.Icon,

		Animated = true,
		BackgroundColor = ColorSequence.new(
			Color3.new(0.309804, 0.054902, 0.458824),
			Color3.new(0.666667, 0.141176, 0.976471)
		),
		OnClick = Properties.OnClick,

		Position = Properties.Position,
		Size = Properties.Size,

		native = Properties.native,
	}, Properties.children)
end

return CreateButtonFrame
