--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)

local Modules = ReplicatedStorage.Modules
local Join = require(Modules.JoinDicts)

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

export type Properties = {
	Title: string,
	Size: UDim2?,
	Position: UDim2?,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

return function(Properties: Properties)
	return e(Main.ImageLabel, {
		native = {
			Position = Properties.Position,
			Size = Properties.Size,
			Image = "rbxassetid://82588529589997",
			ZIndex = 2,
		},
		children = {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 5.23,
			}),
			TitleLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.55),
					Size = UDim2.fromScale(0.7, 0.5),
					Text = Properties.Title,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
				children = {
					UIGradient = e("UIGradient", {
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.new(0.768627, 0.380392, 1)),
							ColorSequenceKeypoint.new(0.623, Color3.new(1, 1, 1)),
							ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
						}),
						Rotation = -90,
					}),
				},
			}),
		},
	})
end
