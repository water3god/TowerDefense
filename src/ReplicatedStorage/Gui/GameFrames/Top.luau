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
local Lerps = require(Modules.Lerps)
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)

local WaveContext = require(Gui.GameFrames.WaveContext)

local ColorLerp = Lerps.Color3(Color3.new(1, 0.011765, 0.011765), Color3.new(0.117647, 1, 0.054902))

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateTopFrame(Props: Properties)
	local WaveData = React.useContext(WaveContext.Context)

	local Time, _, SetTime = Hooks.UseTime()

	local Wave, SetWave = React.useBinding(1)
	local Health, SetHealth = React.useBinding(1)
	local MaxHealth, SetMaxHealth = React.useBinding(1)

	local Styles, API = ReactSpring.useSpring(function()
		return {
			alpha = 1,
		}
	end)

	React.useEffect(function()
		SetWave(WaveData.Wave)
		SetTime(WaveData.Time, WaveData.StartTime)
	end, { WaveData })

	React.useEffect(function()
		SetHealth(WaveData.BaseHealth)
		SetMaxHealth(WaveData.MaxHealth)
	end, { WaveData.BaseHealth, WaveData.MaxHealth })

	React.useEffect(function()
		API.start({
			alpha = math.clamp(WaveData.BaseHealth / WaveData.MaxHealth, 0, 1),
		})
	end, { WaveData.MaxHealth, WaveData.BaseHealth })

	return WaveData.BaseHealth
		and e(Main.Frame, {
			native = Join({
				Position = UDim2.fromScale(0.5, 0.075),
				Size = UDim2.fromScale(0.4, 0.1),
			}, Props.native),
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 7,
			}),
			TimeFrame = e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(1, 0.25),
					Size = UDim2.fromScale(0.25, 1),
				},
			}, {
				TimeLabel = e(Main.TextLabel, {
					native = {
						Position = UDim2.fromScale(0.5, 0.7),
						Size = UDim2.fromScale(1, 0.4),
						Text = Time:map(function(TimeInput: number)
							return HelperFunctions.FormatTime(TimeInput)
						end),
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.002,
					}),
				}),
				Title = e(Main.TextLabel, {
					native = {
						Position = UDim2.fromScale(0.5, 0.25),
						Size = UDim2.fromScale(1, 0.4),
						Text = "Time Left:",
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.002,
					}),
				}),
			}),
			WaveFrame = e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(0, 0.25),
					Size = UDim2.fromScale(0.25, 1),
				},
			}, {
				WaveLabel = e(Main.TextLabel, {
					native = {
						Position = UDim2.fromScale(0.5, 0.7),
						Size = UDim2.fromScale(1, 0.4),
						Text = Wave:map(function(InputWave: number)
							return tostring(InputWave)
						end),
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.002,
					}),
				}),
				Title = e(Main.TextLabel, {
					native = {
						Position = UDim2.fromScale(0.5, 0.25),
						Size = UDim2.fromScale(1, 0.4),
						Text = "Wave:",
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.002,
					}),
				}),
			}),
			HealthFrame = e(Main.CanvasGroup, {
				native = {
					BackgroundTransparency = 0,
					Size = UDim2.fromScale(0.75, 0.5),
					BackgroundColor3 = Color3.new(),
				},
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
				UIStroke = e(UIStroke.UIStrokeBasic, {
					Stroke = 0.002,
					Color = Color3.fromRGB(33, 199, 47),
					native = {
						LineJoinMode = Enum.LineJoinMode.Round,
					},
				}),
				Bar = e(Main.Frame, {
					native = {
						BackgroundTransparency = 0,
						BackgroundColor3 = Styles.alpha:map(function(alpha: number)
							return ColorLerp(alpha)
						end),
						Position = UDim2.fromScale(0, 0.5),
						Size = Styles.alpha:map(function(alpha)
							return UDim2.fromScale(alpha, 1)
						end),
						AnchorPoint = Vector2.new(0, 0.5),
					},
					children = {
						UICorner = e("UICorner", {
							CornerRadius = UDim.new(1, 0),
						}),
					},
				}),
				HealthLabel = e(Main.TextLabel, {
					native = {
						Size = UDim2.fromScale(0.8, 0.9),
						Text = React.joinBindings({ Health, MaxHealth }):map(function(Info: { number })
							return string.format("%u/%u", Info[1], Info[2])
						end),
						ZIndex = 2,
					},
					children = {
						UIGradient = e("UIGradient", {
							Color = ColorSequence.new(Color3.fromRGB(255, 155, 0)),
							Rotation = 90,
						}),
						UIStroke = e(UIStroke.UIStrokeBasic, {
							Stroke = 0.002,
						}),
					},
				}),
			}),
		}, Props.children)
end

return CreateTopFrame
