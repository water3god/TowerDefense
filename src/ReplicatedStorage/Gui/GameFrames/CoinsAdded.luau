--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local ReactSpring = require(Packages.ReactSpring)
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
	Coins: number,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateCoinsAdded(props: Properties)
	local Styles = ReactSpring.useSpring({
		from = { transparency = 0 },
		to = { transparency = 1 },
	}, {})

	return e(Main.TextLabel, {
		native = Join({
			Position = Styles.transparency:map(function(t)
				return UDim2.fromScale(0.5, 1 - t)
			end),
			Size = UDim2.fromScale(0.8, 0.2),
			Text = string.format("+%d", props.Coins or 0),
			TextColor3 = Color3.fromRGB(255, 215, 0),
			TextTransparency = Styles.transparency,
		}, props.native),
	}, {
		UIStroke = e(UIStroke.UIStrokeAdvanced, {
			Stroke = 0.01,
			native = {
				Transparency = Styles.transparency,
			},
		}),
	}, props.children)
end

return CreateCoinsAdded
