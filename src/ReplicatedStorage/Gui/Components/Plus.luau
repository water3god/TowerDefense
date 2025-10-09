--!strict

-- By Wa1er_God --

local PlusFont =
	Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

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

return function(props: any)
	return e(Main.Animateables.ImageButton, {
		native = Join({
			Image = "",
		}, props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}),
		BackgroundImage = e(Main.ImageLabel, {
			native = {
				Image = "rbxassetid://75527211593942",
			},
		}, {
			UIGradient = e("UIGradient", {
				Color = ColorSequence.new(
					Color3.new(0.27451, 0.196078, 0.035294),
					Color3.new(0.505882, 0.329412, 0.043137)
				),
			}),
		}),
		Plus = e(Main.TextLabel, {
			native = {
				Text = props.Text or "+",
				FontFace = PlusFont,
				Size = UDim2.fromScale(0.8, 0.8),
				ZIndex = 2,
			},
		}),
	}, props.children)
end
