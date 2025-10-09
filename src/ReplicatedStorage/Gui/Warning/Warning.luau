--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)

local Warning = Gui.Warning
local WarningContext = require(Warning.WarningContext)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)

export type Props = {
	LayoutOrder: number,
	Text: string,
	Delay: number,
	Color: Color3?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateWarning(props: Props)
	local SizeStyles = ReactSpring.useSpring({
		from = { Size = 1.2 },
		to = { Size = 1 },
		config = { mass = 1, tension = 1000, friction = 30, clamp = true },
	})

	local FadeStyles = ReactSpring.useSpring({
		from = { Transparency = 0 },
		to = { Transparency = 1 },
		delay = props.Delay,
	})

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(1, 0.2),
			ZIndex = 100,
		}, props.native),
	}, {
		Label = e(Main.TextLabel, {
			native = {
				LayoutOrder = props.LayoutOrder,
				Text = props.Text,
				TextColor3 = props.Color or Color3.new(1, 0.043137, 0.043137),
				TextTransparency = FadeStyles.Transparency,
				ZIndex = 100,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.005,
				native = {
					Transparency = FadeStyles.Transparency,
				},
			}),
			UISize = e("UIScale", {
				Scale = SizeStyles.Size,
			}),
		}),
	}, props.children)
end

local function CreateMainFrame(props: any)
	local WarningData = React.useContext(WarningContext.Context)

	local WarningFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for Id, Data in pairs(WarningData.Warnings) do
			Frames[Id] = e(CreateWarning, {
				Text = Data.Text,
				LayoutOrder = Data.StartTime,
				Delay = Data.StartTime - tick() + (Constants.WarningTime * 0.8),
				Color = Data.Color,
			})
		end

		return Frames
	end, { WarningData })

	return e(Main.Frame, {
		native = Join({
			Position = UDim2.fromScale(0.5, 0.6),
			Size = UDim2.fromScale(0.6, 0.2),
			ZIndex = 100,
		}, props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 5,
		}),
		UISizeConstraint = e("UISizeConstraint", {
			MinSize = Vector2.new(200, 80),
			MaxSize = Vector2.new(800, 320),
		}),
		UIListLayout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}, WarningFrames, props.children)
end

return CreateMainFrame
