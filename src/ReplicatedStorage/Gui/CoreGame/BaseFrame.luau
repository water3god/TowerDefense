--!strict

-- By Wa1er_God --

local DefaultBackgroundImage = "rbxassetid://122297615155487"
local HighlightedBackgroundImage = "rbxassetid://107455378505876"

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local AnimatedGradient = require(CoreGame.AnimatedGradient)

export type Properties = {
	Position: UDim2?,
	Size: UDim2?,

	Name: string,
	LeftText: string,
	RightText: any,
	MainImage: string?,
	Hovered: boolean?,
	Disabled: boolean?,
	Hidden: boolean?,

	Animated: boolean?,
	Shine: boolean?,

	BackgroundColor: ColorSequence?,
	NameColor: ColorSequence?,
	NameStrokeColor: ColorSequence?,
	LeftColor: ColorSequence?,
	LeftStrokeColor: ColorSequence?,
	RightColor: ColorSequence?,
	RightStrokeColor: ColorSequence?,

	ImageColor: ColorSequence?,

	OnClick: ((...any) -> ...any)?,

	native: { [any]: any }?,
	children: { [any]: any }?,
	containerChildren: { [any]: any }?,
}

local function CreateBaseFrame(Properties: Properties)
	local Rotation, SetRotation = React.useBinding(0)

	React.useEffect(function()
		if Properties.Animated then
			local Connection = RunService.PostSimulation:Connect(function()
				local NewRotation = Rotation:getValue() + 0.4

				if NewRotation > 360 then
					SetRotation(NewRotation - 360)
				else
					SetRotation(NewRotation)
				end
			end)

			return function()
				Connection:Disconnect()
			end
		end

		return function() end
	end, { Properties.Animated, Properties.BackgroundColor } :: { unknown })

	local Shine, SetShine = React.useBinding(-4)

	React.useEffect(function()
		if Properties.Shine then
			local Connection = RunService.PostSimulation:Connect(function(Delta: number)
				local NewShine = Shine:getValue() + Delta * 2

				if NewShine > 4 then
					SetShine(NewShine - 8)
				else
					SetShine(NewShine)
				end
			end)

			return function()
				Connection:Disconnect()
			end
		end

		return function() end
	end, { Properties.Shine })

	return e(Main.Frame, {
		native = Join({
			Position = Properties.Position or UDim2.fromScale(0.5, 0.5),
			Size = Properties.Size or UDim2.fromScale(1, 1),
		}, Properties.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}),
		Container = e(Main.Animateables.TextButton, {
			native = {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				Text = "",
				[React.Event.MouseButton1Click] = Properties.OnClick,
			},
		}, {
			ShineWrap = Properties.Shine and e(Main.Frame, {
				native = {
					BackgroundTransparency = 0,
					Size = UDim2.fromScale(0.86, 0.86),
					ZIndex = 0,
				},
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.05, 0),
				}),
				Shine = e("UIGradient", {
					Color = Properties.BackgroundColor or ColorSequence.new(Color3.new(1, 1, 1)),
					Transparency = Shine:map(function(Value: number)
						local first = math.clamp(Value - 0.15, 0, 1)
						local second = math.clamp(Value + 0.15, 0, 1)

						local FirstKeypoint = NumberSequenceKeypoint.new(first, 1)

						local SecondKeypoint = NumberSequenceKeypoint.new(second, 1)

						local Keypoints = {
							FirstKeypoint,
							SecondKeypoint,
						}

						if Value >= 0 and Value <= 1 then
							table.insert(Keypoints, 2, NumberSequenceKeypoint.new(Value, 0.3))
						end

						if FirstKeypoint.Time ~= 0 then
							table.insert(Keypoints, 1, NumberSequenceKeypoint.new(0, 1))
						end

						if SecondKeypoint.Time ~= 1 then
							table.insert(Keypoints, NumberSequenceKeypoint.new(1, 1))
						end

						return NumberSequence.new(Keypoints)
					end),
					Rotation = 45,
				}),
			}),

			BackgroundImage = e(Main.ImageLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),
					ZIndex = -1,
					Image = if Properties.Hovered then HighlightedBackgroundImage else DefaultBackgroundImage,
					ImageTransparency = if Properties.Hidden then 0.5 else 0,
				},
			}, {
				UIGradient = e("UIGradient", {
					Color = Properties.BackgroundColor or ColorSequence.new(Color3.new(1, 1, 1)),
					Rotation = Rotation,
				}),
			}),
			MainImage = e(Main.ImageLabel, {
				native = {
					Visible = not Properties.Disabled,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.8, 0.8),
					Image = Properties.MainImage or "",
					ZIndex = 1,
					ScaleType = Enum.ScaleType.Fit,
				},
			}, {
				UIGradient = e("UIGradient", {
					Color = Properties.ImageColor or ColorSequence.new(Color3.new(1, 1, 1)),
					Rotation = Rotation,
				}),
			}),
			BaseName = e(Main.TextLabel, {
				native = {
					Visible = not Properties.Disabled,
					Position = UDim2.fromScale(0.5, 0.8),
					Size = UDim2.fromScale(0.7, 0.18),
					Text = Properties.Name,
					ZIndex = 2,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.02,
					GradColor = if Properties.NameStrokeColor
						then Properties.NameStrokeColor
						else ColorSequence.new(Color3.new(0, 0, 0)),
					native = {
						Enabled = if Properties.NameStrokeColor then true else false,
					},
				}),
				UIGradient = e(AnimatedGradient, {
					GradColor = Properties.NameColor or ColorSequence.new(Color3.new(1, 1, 1)),
					Animate = true,
					Speed = 1,
				}),
			}),
			TopLeftLabel = e(Main.TextLabel, {
				native = {
					Visible = not Properties.Disabled,
					Position = UDim2.fromScale(0.55, 0.2),
					Size = UDim2.fromScale(0.8, 0.15),
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = Properties.LeftText,
					AutoLocalize = false,
					ZIndex = 2,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.02,
					GradColor = Properties.LeftStrokeColor or ColorSequence.new(Color3.new(0, 0, 0)),
					native = {
						Enabled = if Properties.LeftStrokeColor then true else false,
					},
				}),
				UIGradient = e(AnimatedGradient, {
					GradColor = Properties.LeftColor or ColorSequence.new(Color3.new(1, 1, 1)),
					Animate = true,
					Speed = 1,
				}),
			}),
			TopRightLabel = e(Main.TextLabel, {
				native = {
					Visible = not Properties.Disabled,
					Position = UDim2.fromScale(0.45, 0.2),
					Size = UDim2.fromScale(0.8, 0.15),
					TextXAlignment = Enum.TextXAlignment.Right,
					Text = Properties.RightText,
					AutoLocalize = false,
					ZIndex = 2,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.02,
					GradColor = Properties.RightStrokeColor or ColorSequence.new(Color3.new(0, 0, 0)),
					native = {
						Enabled = if Properties.RightStrokeColor then true else false,
					},
				}),
				UIGradient = e(AnimatedGradient, {
					GradColor = Properties.RightColor or ColorSequence.new(Color3.new(1, 1, 1)),
					Animate = true,
					Speed = 1,
				}),
			}),
		}, Properties.containerChildren),
	}, Properties.children)
end

return CreateBaseFrame
