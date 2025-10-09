--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local CloseButton = require(CoreGame.CloseButton)
local UIStroke = require(CoreGame.UIStroke)
local Main = require(CoreGame.Main)

local Components = Gui.Components
local Button = require(Components.Button)

local function CreateBasicButton(Props: {
	OnClick: () -> ()?,
	native: { [any]: any }?,
	children: {}?,
	LabelText: string,
	Color: Color3,
})
	return e(Main.Animateables.ImageButton, {
		native = Join({
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromScale(0.4, 0.3),
			Image = "rbxassetid://110715473491790",
			ImageColor3 = Props.Color,
			[React.Event.MouseButton1Click] = Props.OnClick,
		}, Props.native),
	}, {
		TextLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.5, 0.5),
				Text = Props.LabelText,
				ZIndex = 2,
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeBasic, {
				Stroke = 0.002,
			}),
		}),
		BackFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.95, 0.85),
				BackgroundTransparency = 0,
				BackgroundColor3 = Props.Color,
			},
		}),
	}, Props.children)
end

type props = {
	Title: string,
	Description: string,
	YesText: string?,
	NoText: string?,
	Enabled: boolean,
	Handler: (End: boolean?) -> (),

	native: { [any]: any }?,
}

local IsRunning = RunService:IsRunning()

local ConfirmGui = Instance.new("ScreenGui")
ConfirmGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ConfirmGui.DisplayOrder = 5
ConfirmGui.Name = "ConfirmGui"

if IsRunning then
	ConfirmGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
end

local function CreateConfirm(props: props)
	local Enabled, SetEnabled = React.useState(props.Enabled)
	local IntEnabled, SetIntEnabled = React.useState(Enabled)
	local InAnim, SetInAnim = React.useState(false)

	local Styles, api = ReactSpring.useSpring(function()
		return {
			Scale = 0.9,
			config = { mass = 1, tension = 400, friction = 30, precision = 0.01 },
		}
	end)

	React.useEffect(function()
		if Enabled == true then
			SetIntEnabled(true)
		end
	end, { Enabled })

	React.useEffect(function()
		if IntEnabled and not InAnim then
			if not IntEnabled then
				SetInAnim(true)
			end
			api.stop()
			api.start({
				Scale = if Enabled then 1 else 0.9,
			}):andThen(function()
				if not Enabled then
					SetIntEnabled(false)
				end
			end)
		end
	end, { Enabled, InAnim, IntEnabled })

	React.useEffect(function()
		SetEnabled(props.Enabled)
	end, { props.Enabled })

	local OnYes = React.useCallback(function()
		props.Handler(true)
		SetEnabled(false)
	end, { Enabled })

	local OnNo = React.useCallback(function()
		props.Handler(false)
		SetEnabled(false)
	end, { Enabled })

	local OnClose = React.useCallback(function()
		props.Handler(nil)
		SetEnabled(false)
	end, { Enabled })

	local function Render()
		return e(Main.ImageLabel, {
			native = Join({
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.25, 0.25),
				Image = "rbxassetid://124008352699396",
			}, props.native),
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1.813,
			}),
			TitleLabel = e(Main.TextLabel, {
				native = {
					Text = props.Title,
					Position = UDim2.fromScale(0.5, 0.2),
					Size = UDim2.fromScale(0.5, 0.175),
					ZIndex = 2,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.01,
				}),
			}),
			DescriptionLabel = e(Main.TextLabel, {
				native = {
					Text = props.Description,
					Position = UDim2.fromScale(0.5, 0.425),
					Size = UDim2.fromScale(0.9, 0.25),
					ZIndex = 2,
					AutoLocalize = false,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.005,
				}),
			}),
			NoButton = e(Button, {
				Text = props.NoText or "No",
				Color = "Red",
				Position = UDim2.fromScale(0.75, 0.75),
				Size = UDim2.fromScale(0.5, 0.4),
				OnClick = OnNo,
			}),
			YesButton = e(Button, {
				Text = props.YesText or "Yes",
				Color = "Green",
				Position = UDim2.fromScale(0.25, 0.75),
				Size = UDim2.fromScale(0.5, 0.4),
				OnClick = OnYes,
			}),
			CloseButton = e(CloseButton, {
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromScale(0.2, 0.3),
				OnClick = OnClose,
			}),
			UIScale = e("UIScale", {
				Scale = Styles.Scale,
			}),
		})
	end

	if IsRunning then
		return IntEnabled and ReactRoblox.createPortal(Render(), ConfirmGui)
	else
		return IntEnabled and Render()
	end
end

return CreateConfirm
