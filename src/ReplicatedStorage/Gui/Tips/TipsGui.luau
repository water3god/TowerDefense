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

	return e(Main.ImageLabel, {
		native = Join({
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromScale(0.5, 0.1),
			Image = "rbxassetid://81483731389339",
			ZIndex = 0,
		}, props.native),
	}, {
		UISizeConstraint = e("UISizeConstraint", {
			MinSize = Vector2.new(180, 35),
			MaxSize = Vector2.new(720, 140),
		}),
		UIAspectRatio = e("UIAspectRatioConstraint", {
			AspectRatio = 6,
		}),
		Label = e(Main.TextLabel, {
			native = {
				Text = TipText,
				TextScaled = true,
				Size = UDim2.fromScale(0.8, 0.7),
				TextTransparency = Styles.Transparency,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.005,
				native = {
					Transparency = Styles.Transparency,
				},
			}),
		}),
	}, props.children)
end

return CreateTipsGui
