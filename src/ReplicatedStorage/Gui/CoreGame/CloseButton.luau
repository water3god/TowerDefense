--!strict

--- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local CoreGame = ReplicatedStorage.Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)

export type Properties = {
	Position: UDim2?,
	Size: UDim2?,
	OnClick: (rbx: ImageButton) -> ()?,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

return function(Properties: Properties)
	return e(Main.Frame, {
		native = {
			Position = Properties.Position,
			Size = Properties.Size,
		},
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}),
		Button = e(Main.Animateables.ImageButton, {
			native = Join({
				Position = UDim2.fromScale(0.5, 0.5),
				Image = "rbxassetid://115509365553249",
				[React.Event.MouseButton1Click] = Properties.OnClick,
			}, Properties.native),
		}, {
			TextLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.5, 0.5),
					Text = "X",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.06,
				}),
			}),
		}),
	}, Properties.children)
end
