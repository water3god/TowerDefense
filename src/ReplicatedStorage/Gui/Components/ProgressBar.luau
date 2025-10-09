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
	Color: "Blue" | "Green" | "Orange" | "Pink" | "Purple" | "Red" | "Yellow"?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

type ColorSlice = { Left: string, Center: string, Right: string }
local Colors: { [string]: ColorSlice } = {
	Blue = {
		Left = "rbxassetid://111888660618379",
		Center = "rbxassetid://124297897955489",
		Right = "rbxassetid://122016269791645",
	},
	Green = {
		Left = "rbxassetid://105105423253647",
		Center = "rbxassetid://108995403344979",
		Right = "rbxassetid://109187005644761",
	},
	Orange = {
		Left = "rbxassetid://77393826324663",
		Center = "rbxassetid://131776711613316",
		Right = "rbxassetid://119978688984576",
	},
	Pink = {
		Left = "rbxassetid://75615613943072",
		Center = "rbxassetid://96924060430329",
		Right = "rbxassetid://117825579319776",
	},
	Purple = {
		Left = "rbxassetid://101299486137675",
		Center = "rbxassetid://133771187561345",
		Right = "rbxassetid://86257684744288",
	},
	Red = {
		Left = "rbxassetid://79950155112807",
		Center = "rbxassetid://92673767113979",
		Right = "rbxassetid://113271389514828",
	},
	Yellow = {
		Left = "rbxassetid://115601149714876",
		Center = "rbxassetid://76636561544547",
		Right = "rbxassetid://82940351110080",
	},
}

local function CreateProgressBar(props: Properties)
	local colorName: string = props.Color or "Blue"
	local colorSlice: ColorSlice = Colors[colorName] or Colors.Blue
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
				Image = colorSlice.Center,
				ZIndex = 2,
			},
		}),
		InnerBarLeft = e(Main.ImageLabel, {
			native = {
				Size = UDim2.fromScale(0.1, 1),
				Position = UDim2.fromScale(0, 0.5),
				AnchorPoint = Vector2.new(1, 0.5),
				Image = colorSlice.Left,
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
				Image = colorSlice.Right,
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
