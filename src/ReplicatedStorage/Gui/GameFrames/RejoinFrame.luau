--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require(ReplicatedStorage.Network.Client)
local RejoinPrompted = Network.RejoinPrompted
local Rejoin = Network.Rejoin

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local DelayHandler = require(Modules.DelayHandler)
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local CloseButton = require(CoreGame.CloseButton)
local Hooks = require(CoreGame.Hooks)

export type Properties = {
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateRejoinFrame(props: Properties)
	local OnRejoinClick = React.useCallback(function()
		if DelayHandler("RejoinClick", 3) then
			Rejoin.Fire()
		end
	end, {})

	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.3, 0.175),
			Image = "rbxassetid://124008352699396",
		}, props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.8,
		}),
		Title = e(Main.TextLabel, {
			native = {
				Text = "Rejoin previous game?",
				Position = UDim2.fromScale(0.5, 0.275),
				Size = UDim2.fromScale(0.8, 0.2),
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
			}),
		}),
		RejoinButton = e(Main.Animateables.TextButton, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0, 1, 0),
				Text = "",
				Position = UDim2.fromScale(0.5, 0.7),
				Size = UDim2.fromScale(0.6, 0.3),
				[React.Event.MouseButton1Click] = OnRejoinClick,
			},
		}, {
			Label = e(Main.TextLabel, {
				native = {
					Text = "Rejoin",
					Size = UDim2.fromScale(0.9, 0.6),
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.015,
				}),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Color = Color3.new(0.031373, 0.290196, 0.031373),
				Stroke = 0.015,
				native = {
					LineJoinMode = Enum.LineJoinMode.Round,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
			}),
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.5, 0.4),
			OnClick = props.CloseClick,
			native = {
				ZIndex = 2,
			},
		}),
	}, props.children)
end

local function RejoinConnected(props)
	local Styles, API = ReactSpring.useSpring(function()
		return {
			size = 0.8,
			config = { mass = 1, tension = 400, friction = 30, velocity = 0.02, precision = 0.01, clamp = true } :: any,
		}
	end)

	local Active, SetActive = React.useState(false)

	Hooks.useZapConnection(RejoinPrompted, function()
		SetActive(true)
	end, {})

	React.useEffect(function()
		if Active then
			API.start({
				size = 1,
			})
		else
			API.start({
				size = 0.8,
			})
		end
	end, { Active })

	local CloseClick = React.useCallback(function()
		SetActive(false)
	end, {})

	return e(CreateRejoinFrame, {
		CloseClick = CloseClick,
		native = Join({
			Visible = Styles.size:map(function(size)
				return size > 0.8
			end),
		}, props.native),
	}, {
		UIScale = e("UIScale", {
			Scale = Styles.size,
		}),
	}, props.children)
end

return {
	Create = CreateRejoinFrame,
	Connected = RejoinConnected,
}
