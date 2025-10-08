--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local ReactSpring = require(Packages.ReactSpring)
local React = require(Packages.React)
local e = React.createElement

local Input = require(Packages.Input)
local Trove = require(Packages.Trove)

local Modules = ReplicatedStorage.Modules
local Lerps = require(Modules.Lerps)
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Client = ReplicatedStorage.Client
local SettingService = require(Client.GlobalClient.SettingsService)

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Title = require(CoreGame.Title)
local CloseButton = require(CoreGame.CloseButton)

local SettingsFolder = Gui.Settings
local SettingsContext = require(SettingsFolder.SettingsContext)

local Shared = ReplicatedStorage.Shared
local SettingsModule = require(Shared.Settings)

export type Properties = {
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type SettingProps = {
	SettingName: string,
	Type: string,
	Value: any,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type ConnectedProps = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local ColorLerp = Lerps.Color3(Color3.new(0.882353, 0.101961, 0.101961), Color3.new(0.098039, 0.843137, 0.137255))
local PositionLerp = Lerps.UDim2(UDim2.fromScale(0.2, 0.5), UDim2.fromScale(0.8, 0.5))

local function CreateBoolean(props: { Setting: string, Value: boolean })
	local Value, SetValue = React.useState(props.Value)

	React.useEffect(function()
		SetValue(props.Value)
	end, { props.Value })

	local Styles, API = ReactSpring.useSpring(function()
		return {
			alpha = if Value then 1 else 0,
			config = { mass = 1, tension = 400, friction = 40, clamp = true, velocity = 0.02 :: any },
		}
	end)

	React.useEffect(function()
		API.start({
			alpha = if Value then 1 else 0,
		})
	end, { Value })

	local Click = React.useCallback(function()
		local NewValue = not Value
		SetValue(NewValue)
		SettingService.ChangeSetting(props.Setting, NewValue)
	end, { props.Setting, Value :: any })

	return e(Main.TextButton, {
		native = {
			Position = UDim2.fromScale(0.8, 0.5),
			Size = UDim2.fromScale(0.25, 0.45),
			BackgroundTransparency = 0,
			Text = "",
			BackgroundColor3 = Color3.new(0.254902, 0.254902, 0.254902),
			[React.Event.MouseButton1Click] = Click,
		},
	}, {
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.4, 0),
		}),
		Bar = e(Main.Frame, {
			native = {
				Position = Styles.alpha:map(function(alpha: number)
					return PositionLerp(alpha)
				end),
				Size = UDim2.fromScale(0.4, 1),
				BackgroundTransparency = 0,
				BackgroundColor3 = Styles.alpha:map(function(alpha: number)
					return ColorLerp(alpha)
				end),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.4, 0),
			}),
		}),
	})
end

local function CreateNumber(props: { Setting: string, Value: number })
	local NumberValue, SetNumberValue = React.useBinding(0)
	local Holding, SetHolding = React.useState(false)
	local TouchBox = React.useRef(nil :: TextBox?)

	React.useEffect(function()
		if not Holding then
			SetNumberValue(props.Value)
		end
	end, { props.Value })

	React.useEffect(function()
		if Holding then
			local Frame = TouchBox.current :: TextBox
			local InputTrove = Trove.new()

			local function Moved(Position: Vector2)
				local Difference = Position.X - Frame.AbsolutePosition.X

				local Value = math.clamp(Difference / Frame.AbsoluteSize.X, 0, 1)

				SetNumberValue(Value)
				SettingService.ChangeSettingClient(props.Setting, Value)
			end

			local Function = Input.PreferredInput.Observe(function(PreferredInput)
				if PreferredInput == "Gamepad" then
					local Gamepad = InputTrove:Construct(Input.Gamepad)
				elseif PreferredInput == "MouseKeyboard" then
					Moved(UserInputService:GetMouseLocation())

					InputTrove:Connect(UserInputService.InputChanged, function(InputObject)
						if InputObject.UserInputType == Enum.UserInputType.MouseMovement then
							Moved(UserInputService:GetMouseLocation())
						end
					end)

					InputTrove:Connect(UserInputService.InputEnded, function(InputObject: InputObject)
						if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
							SetHolding(false)
						end
					end)
				elseif PreferredInput == "Touch" then
					local Touch = InputTrove:Construct(Input.Touch)
					Moved(UserInputService:GetMouseLocation())
					Touch.TouchMoved:Connect(function()
						Moved(UserInputService:GetMouseLocation())
					end)
				end
			end)

			return function()
				InputTrove:Destroy()
				Function()
			end
		else
			SettingService.SyncSetting(props.Setting)
			return function() end
		end
	end, { Holding })

	local Down = React.useCallback(function()
		SetHolding(true)
	end, {})

	return e(Main.TextButton, {
		native = {
			ref = TouchBox,
			Position = UDim2.fromScale(0.8, 0.5),
			Size = UDim2.fromScale(0.25, 0.175),
			Text = "",
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.254902, 0.254902, 0.254902),
			[React.Event.MouseButton1Down] = Down,
		},
	}, {
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.4, 0),
		}),
		Bar = e(Main.Frame, {
			native = {
				Position = NumberValue:map(function(Number)
					return UDim2.fromScale(Number, 0.5)
				end),
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.fromScale(0.05, 3),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.584314, 0.584314, 0.584314),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.4, 0),
			}),
		}),
	})
end

local function CreateSetting(props: SettingProps)
	local ValueDeterminer: React.Node = React.useMemo(function()
		if props.Type == "boolean" then
			return e(CreateBoolean, {
				Setting = props.SettingName,
				Value = props.Value,
			}) :: any
		elseif props.Type == "number" then
			return e(CreateNumber, {
				Setting = props.SettingName,
				Value = props.Value,
			}) :: any
		else
			return e(Main.Frame, {}) :: any
		end
	end, { props.Type, props.SettingName, props.Value })

	local Name = React.useMemo(function()
		return SettingsModule.Displays[props.SettingName] or props.SettingName
	end, { props.SettingName })

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(1, 0.175),
		}, props.native),
	}, {
		Main = e(Main.ImageLabel, {
			native = {
				Size = UDim2.fromScale(0.9, 0.9),
				Image = "rbxassetid://103808626575670",
			},
		}, {
			NameLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.325, 0.5),
					Size = UDim2.fromScale(0.575, 0.4),
					Text = Name,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.015,
				}),
			}),
			Value = ValueDeterminer,
		}),
	}, props.children)
end

local function CreateSettingsFrame(props: Properties)
	local SettingsData = React.useContext(SettingsContext.Context)

	local SettingsFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for Setting, Value in pairs(SettingsData) do
			if table.find(SettingsModule.NotVisible, Setting) then
				continue
			end
			Frames[Setting] = e(CreateSetting, {
				SettingName = Setting,
				Type = typeof(Value),
				Value = Value,
				native = {
					LayoutOrder = table.find(SettingsModule.SettingIndexes, Setting),
				},
			})
		end

		return Frames
	end, { SettingsData })

	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.5, 0.7),
			Image = "rbxassetid://138837230897413",
		}, props.native),
	}, {
		UISizeConstraint = e("UISizeConstraint", {
			MinSize = Vector2.new(210, 230),
			MaxSize = Vector2.new(840, 920),
		}),
		MainFrame = e(Main.ScrollingFrame, {
			BarSize = 0.01,
			native = {
				Position = UDim2.fromScale(0.5, 0.51),
				Size = UDim2.fromScale(0.95, 0.8),
				ZIndex = 2,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
			},
		}, {
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 0),
				FillDirection = Enum.FillDirection.Vertical,
			}),
		}, SettingsFrames),
		Title = e(Title, {
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromScale(1, 0.15),
			Title = "SETTINGS",
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 0.8,
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.175, 0.225),
			OnClick = props.CloseClick,
		}),
	}, props.children)
end

return {
	Create = CreateSettingsFrame,
}
