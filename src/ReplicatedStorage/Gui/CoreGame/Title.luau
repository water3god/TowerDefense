--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)

export type Properties = {
	Title: string,
	Size: UDim2?,
	Position: UDim2?,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

return function(Properties: Properties)
	return e(Main.Frame, {
		native = {
			Position = Properties.Position,
			Size = Properties.Size,
			ZIndex = 2,
		},
	}, {
		InsideImage = e(Main.ImageLabel, {
			native = {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1.05, 0.8),
				Image = "rbxassetid://111182319089503",
				ZIndex = 2,
			},
		}, {}),
		LeftImage = e(Main.ImageLabel, {
			native = {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.fromScale(0.4, 1),
				Image = "rbxassetid://113285065304136",
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		RightImage = e(Main.ImageLabel, {
			native = {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(1, 0.5),
				Size = UDim2.fromScale(0.4, 1),
				Image = "rbxassetid://93132495961595",
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 2,
		}),
		TitleLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.55),
				Size = UDim2.fromScale(0.9, 0.45),
				Text = Properties.Title,

				ZIndex = 3,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
			}),
		}),
	})
end
