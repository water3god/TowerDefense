--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)

export type Properties = {
	Place: (() -> ())?,
	Cancel: (() -> ())?,
	Rotate: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function MobilePlacementFrame(props: Properties)
	return e(React.Fragment, {}, {
		Rotate = e(Main.Animateables.TextButton, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.054902, 0.019608, 0.082353),
				Position = UDim2.fromScale(0.25, 0.5),
				Size = UDim2.fromScale(0.3, 0.2),
				Text = "",
				[React.Event.MouseButton1Click] = props.Rotate,
			},
		}, {
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.8),
					Text = "Rotate",
				},
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.01,
				Color = Color3.new(0.807843, 0.807843, 0.807843),
				native = {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),
		}),
		Main = e(Main.ImageLabel, {
			native = Join({
				Position = UDim2.fromScale(0.75, 0.5),
				Size = UDim2.fromScale(0.5, 0.3),
				Image = "rbxassetid://103903141717286",
			}, props.native),
		}, {
			Check = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.25, 0.5),
					Size = UDim2.fromScale(0.5, 0.6),
					ImageColor3 = Color3.new(0, 1, 0),
					Image = "rbxassetid://112969853042429",
					[React.Event.MouseButton1Click] = props.Place,
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
			}),
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 2,
			}),
			Close = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.75, 0.5),
					Size = UDim2.fromScale(0.5, 0.6),
					ImageColor3 = Color3.new(1, 0, 0),
					Image = "rbxassetid://112300863255979",
					[React.Event.MouseButton1Click] = props.Cancel,
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
			}),
		}, props.children),
	})
end

return MobilePlacementFrame
