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
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateClickHover(props: Properties)
	return e(Main.Frame, {
		native = Join({
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(77, 77, 77),
			Size = UDim2.fromScale(0.5, 0.5),
		}, props.children),
	}, {
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.2, 0),
		}),
		UIStroke = e(UIStroke.UIStrokeAdvanced, {
			Stroke = 0.015,
			native = {
				LineJoinMode = Enum.LineJoinMode.Round,
			},
		}),
		Label = e(Main.TextLabel, {
			native = {
				Text = "Click to View Stats...",
				Size = UDim2.fromScale(0.9, 0.5),
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
				native = {
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 5,
		}),
	}, props.children)
end

return CreateClickHover
