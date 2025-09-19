--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

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

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local SFXService = require(GlobalClient.SFXService)

local Sounds = SoundService.SoundEffects.Sounds
local BaseLoseHp = Sounds.BaseLoseHp
local TimeTick = Sounds.TimeTick

local HealthLerp = Lerps.Color3(Color3.new(1, 0.011765, 0.011765), Color3.new(0.117647, 1, 0.054902))
local TimeLerp = Lerps.Color3(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 0, 0))

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

	local HealthStyles, API = ReactSpring.useSpring(function()
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
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.fromScale(0.5, 0.1),
			}, Props.native),
		}, {
			UISizeConstraint = e("UISizeConstraint", {
				MinSize = Vector2.new(200, 35),
				MaxSize = Vector2.new(600, 100),
			}),
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
						Text = Time:map(function(TimeInput: number)
							return HelperFunctions.FormatTime(TimeInput)
						end),
						TextColor3 = Time:map(function(TimeInput: number)
							if TimeInput < 6 then
								local alpha = TimeInput - math.floor(TimeInput)

								return TimeLerp(math.clamp(alpha * 3 - 2, 0, 1))
							else
								return Color3.fromRGB(255, 255, 255)
							end
						end),
						Size = Time:map(function(TimeInput: number)
							if TimeInput < 6 then
								local alpha = TimeInput - math.floor(TimeInput)
								local added = TweenService:GetValue(
									math.clamp(alpha * 3 - 2, 0, 1),
									Enum.EasingStyle.Quad,
									Enum.EasingDirection.In
								) / 10
								return UDim2.fromScale(1, 0.4 + added)
							else
								return UDim2.fromScale(1, 0.4)
							end
						end),
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeAdvanced, {
						Stroke = 0.03,
					}),
				}),
				Title = e(Main.TextLabel, {
					native = {
						Position = UDim2.fromScale(0.5, 0.25),
						Size = UDim2.fromScale(1, 0.4),
						Text = "Time Left:",
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeAdvanced, {
						Stroke = 0.03,
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
					UIStroke = e(UIStroke.UIStrokeAdvanced, {
						Stroke = 0.03,
					}),
				}),
				Title = e(Main.TextLabel, {
					native = {
						Position = UDim2.fromScale(0.5, 0.25),
						Size = UDim2.fromScale(1, 0.4),
						Text = "Wave:",
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeAdvanced, {
						Stroke = 0.03,
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
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.015,
					Color = Color3.fromRGB(33, 199, 47),
					native = {
						LineJoinMode = Enum.LineJoinMode.Round,
					},
				}),
				Bar = e(Main.Frame, {
					native = {
						BackgroundTransparency = 0,
						BackgroundColor3 = HealthStyles.alpha:map(function(alpha: number)
							return HealthLerp(alpha)
						end),
						Position = UDim2.fromScale(0, 0.5),
						Size = HealthStyles.alpha:map(function(alpha)
							return UDim2.fromScale(alpha, 1)
						end),
						AnchorPoint = Vector2.new(0, 0.5),
					},
				}, {
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),

				HealthLabel = e(Main.TextLabel, {
					native = {
						Size = UDim2.fromScale(0.8, 0.9),
						Text = React.joinBindings({ Health, MaxHealth }):map(function(Info: { number })
							return string.format("%u/%u", Info[1], Info[2])
						end),
						ZIndex = 2,
					},
				}, {
					UIGradient = e("UIGradient", {
						Color = ColorSequence.new(Color3.fromRGB(255, 155, 0)),
						Rotation = 90,
					}),
					UIStroke = e(UIStroke.UIStrokeAdvanced, {
						Stroke = 0.015,
					}),
				}),
			}),
		}, Props.children)
end

return CreateTopFrame
