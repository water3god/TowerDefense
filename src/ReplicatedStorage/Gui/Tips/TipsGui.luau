--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactSpring = require(Packages.ReactSpring)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local TipsFolder = Gui.Tips
local TipsContext = require(TipsFolder.TipsContext)

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateTipsGui(props: Properties)
	local Tip = React.useContext(TipsContext.Context)
	local TipText, SetTipText = React.useBinding(Tip)
	local Styles, API = ReactSpring.useSpring(function()
		return {
			Transparency = 1,
		}
	end)

	React.useEffect(function()
		API.start({
			Transparency = 1,
		}):andThen(function()
			SetTipText(Tip)
			API.start({
				Transparency = 0,
			})
		end)
	end, { Tip })

	return e(Main.Frame, {
		native = Join({
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(60, 21, 78),
			Position = UDim2.fromScale(0.5, 0.05),
			Size = UDim2.fromScale(0.6, 0.07),
			ZIndex = 0,
		}, props.native),
	}, {
		UIAspectRatio = e("UIAspectRatioConstraint", {
			AspectRatio = 6,
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.3, 0),
		}),
		UIStroke = e(UIStroke.UIStrokeAdvanced, {
			Stroke = 0.01,
			native = {
				LineJoinMode = Enum.LineJoinMode.Round,
			},
		}),
		Label = e(Main.TextLabel, {
			native = {
				Text = TipText,
				TextScaled = true,
				Size = UDim2.fromScale(0.9, 0.9),
				TextTransparency = Styles.Transparency,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.01,
				native = {
					Transparency = Styles.Transparency,
				},
			}),
		}),
	}, props.children)
end

return CreateTipsGui
