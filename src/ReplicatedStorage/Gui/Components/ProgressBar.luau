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

export type Properties = {
	Bar: React.Binding<number>,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateProgressBar(props: Properties)
	return e(Main.Frame, {
		native = Join({}, props.native),
	}, {
		BarLeft = e(Main.ImageLabel, {
			native = {
				Image = "rbxassetid://77778012608707",
				Size = UDim2.fromScale(0.2, 1),
				Position = UDim2.fromScale(0, 0.5),
				AnchorPoint = Vector2.new(1, 0.5),
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		BarRight = e(Main.ImageLabel, {
			native = {
				Image = "rbxassetid://94018539447338",
				Size = UDim2.fromScale(0.2, 1),
				Position = UDim2.fromScale(1, 0.5),
				AnchorPoint = Vector2.new(0, 0.5),
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		InnerBar = e(Main.ImageLabel, {
			native = {
				Size = props.Bar:map(function(Bar)
					return UDim2.fromScale(math.clamp(Bar, 0, 1), 1)
				end),
				Position = UDim2.fromScale(0, 0.5),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Image = "rbxassetid://124297897955489",
				ZIndex = 2,
			},
		}),
		InnerBarLeft = e(Main.ImageLabel, {
			native = {
				Size = UDim2.fromScale(0.1, 1),
				Position = UDim2.fromScale(0, 0.5),
				AnchorPoint = Vector2.new(1, 0.5),
				Image = "rbxassetid://111888660618379",
				ZIndex = 2,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 0.22,
			}),
		}),
		InnerBarRight = e(Main.ImageLabel, {
			native = {
				Size = UDim2.fromScale(0.1, 1),
				Position = UDim2.fromScale(1, 0.5),
				AnchorPoint = Vector2.new(0, 0.5),
				Image = "rbxassetid://122016269791645",
				Visible = props.Bar:map(function(Bar)
					return math.clamp(Bar, 0, 1) == 1
				end),
				ZIndex = 2,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 0.22,
			}),
		}),

		MainBar = e(Main.ImageLabel, {
			native = {
				Image = "rbxassetid://137236531720016",
			},
		}),
	}, props.children)
end

return CreateProgressBar
