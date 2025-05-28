--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Input = require(Packages.Input)
local Trove = require(Packages.Trove)

local Modules = ReplicatedStorage.Modules
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

local function CreateBoolean(props: { Setting: string, Value: boolean })
	local Value, SetValue = React.useState(props.Value)

	React.useEffect(function()
		SetValue(props.Value)
	end, { props.Value })

	local Color = React.useMemo(function()
		if Value then
			return Color3.new(0.098039, 0.843137, 0.137255)
		else
			return Color3.new(0.882353, 0.101961, 0.101961)
		end
	end, { Value })

	local BarPosition = React.useMemo(function()
		if Value then
			return UDim2.fromScale(0.8, 0.5)
		else
			return UDim2.fromScale(0.2, 0.5)
		end
	end, { Value })

	local Click = React.useCallback(function()
		local NewValue = not Value
		SetValue(NewValue)
		SettingService.ChangeSetting(props.Setting, NewValue)
	end, { props.Setting, Value :: any })

	return e(Main.TextButton, {
		native = {
			Position = UDim2.fromScale(0.8, 0.5),
			Size = UDim2.fromScale(0.3, 0.5),
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
				Position = BarPosition,
				Size = UDim2.fromScale(0.4, 1),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color,
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
			local Trove = Trove.new()

			local function Moved(Position: Vector2)
				local Difference = Position.X - Frame.AbsolutePosition.X

				local Value = math.clamp(Difference / Frame.AbsoluteSize.X, 0, 1)

				SetNumberValue(Value)
				SettingService.ChangeSettingClient(props.Setting, Value)
			end

			local Function = Input.PreferredInput.Observe(function(PreferredInput)
				if PreferredInput == "Gamepad" then
					local Gamepad = Trove:Construct(Input.Gamepad)
				elseif PreferredInput == "MouseKeyboard" then
					Moved(UserInputService:GetMouseLocation())

					Trove:Connect(UserInputService.InputChanged, function(Input, Processed)
						if Input.UserInputType == Enum.UserInputType.MouseMovement then
							Moved(UserInputService:GetMouseLocation())
						end
					end)

					Trove:Connect(UserInputService.InputEnded, function(Input: InputObject)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 then
							SetHolding(false)
						end
					end)
				elseif PreferredInput == "Touch" then
					local Touch = Trove:Construct(Input.Touch)
					Moved(UserInputService:GetMouseLocation())
					Touch.TouchMoved:Connect(function(Input: InputObject)
						Moved(UserInputService:GetMouseLocation())
					end)
				end
			end)

			return function()
				Trove:Destroy()
				Function()
			end
		else
			SettingService.SyncSetting(props.Setting)
			return function() end
		end
	end, { Holding })

	local Down = React.useCallback(function(rbx: TextButton)
		SetHolding(true)
	end, {})

	return e(Main.TextButton, {
		native = {
			ref = TouchBox,
			Position = UDim2.fromScale(0.8, 0.5),
			Size = UDim2.fromScale(0.3, 0.2),
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
	local ValueDeterminer = React.useMemo(function()
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
			Size = UDim2.fromScale(0.9, 0.15),
		}, props.native),
	}, {
		Main = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.9, 0.9),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.298039, 0.094118, 0.470588),
			},
		}, {
			NameLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.325, 0.5),
					Size = UDim2.fromScale(0.575, 0.4),
					Text = Name,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
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

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(0.6, 0.8),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
		}, props.native),
	}, {
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
			Position = UDim2.fromScale(0.3, 0),
			Size = UDim2.fromScale(1, 0.14),
			Title = "SETTINGS",
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 0.8,
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.2, 0.3),
			OnClick = props.CloseClick,
		}),
		InnerFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.52),
				Size = UDim2.fromScale(0.94, 0.9),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.015, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Color = Color3.new(0.388235, 0.101961, 0.486275),
				Stroke = 0.002,
				native = {
					Transparency = 0.1,
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
		}),
		UIStroke = e(UIStroke.UIStrokeAdvanced, {
			Color = Color3.new(0.866667, 0.866667, 0.866667),
			Stroke = 0.002,
			native = {
				LineJoinMode = Enum.LineJoinMode.Round,
			},
		}),
	}, props.children)
end

return {
	Create = CreateSettingsFrame,
}
