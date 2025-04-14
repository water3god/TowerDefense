--!strict

-- By Wa1er_God --

local DefaultBackgroundImage = "rbxassetid://122297615155487"
local HighlightedBackgroundImage = "rbxassetid://82394198587561"

local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

export type Properties = {
	Position: UDim2?,
	Size: UDim2?,

	Name: string,
	LeftText: string,
	RightText: string,
	UnitImage: string?,
	Hovered: boolean?,

	BackgroundColor: ColorSequence?,
	NameColor: ColorSequence?,
	NameStrokeColor: ColorSequence?,
	LeftColor: ColorSequence?,
	LeftStrokeColor: ColorSequence?,
	RightColor: ColorSequence?,
	RightStrokeColor: ColorSequence?,

	OnClick: ((...any) -> ...any)?,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateBaseFrame(Properties: Properties)
	return e(
		Main.Frame,
		Join({
			native = Join({
				Position = Properties.Position or UDim2.fromScale(0.5, 0.5),
				Size = Properties.Size or UDim2.fromScale(1, 1),
			}, Properties.native),
			children = Join({
				UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
				Container = e(Main.Animateables.TextButton, {
					native = {
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1, 1),
						Text = "",
						[React.Event.MouseButton1Click] = Properties.OnClick,
					},
					children = {
						BackgroundImage = e(Main.ImageLabel, {
							native = {
								Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromScale(1, 1),
								ZIndex = 0,
								Image = if Properties.Hovered
									then HighlightedBackgroundImage
									else DefaultBackgroundImage,
							},
							children = {
								UIGradient = e("UIGradient", {
									Color = Properties.BackgroundColor or ColorSequence.new(Color3.new(1, 1, 1)),
								}),
							},
						}),
						MainImage = e(Main.ImageLabel, {
							native = {
								Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromScale(1, 1),
								Image = Properties.UnitImage or "",
							},
						}),
						BaseName = e(Main.TextLabel, {
							native = {
								Position = UDim2.fromScale(0.5, 0.8),
								Size = UDim2.fromScale(0.7, 0.18),
								Text = Properties.Name,
							},
							children = {
								UIStroke = e(UIStroke.UIStroke, {
									Stroke = 0.002,
									GradColor = if Properties.NameStrokeColor
										then Properties.NameStrokeColor
										else ColorSequence.new(Color3.new(1, 1, 1)),
									native = {
										Enabled = if Properties.NameStrokeColor then true else false,
									},
								}),
								UIGradient = e("UIGradient", {
									Color = Properties.NameColor or ColorSequence.new(Color3.new(1, 1, 1)),
								}),
							},
						}),
						TopLeftLabel = e(Main.TextLabel, {
							native = {
								Position = UDim2.fromScale(0.55, 0.2),
								Size = UDim2.fromScale(0.8, 0.15),
								TextXAlignment = Enum.TextXAlignment.Left,
								Text = Properties.LeftText,
							},
							children = {
								UIStroke = e(UIStroke.UIStroke, {
									Stroke = 0.002,
									GradColor = Properties.LeftStrokeColor or ColorSequence.new(Color3.new(1, 1, 1)),
									native = {
										Enabled = if Properties.LeftStrokeColor then true else false,
									},
								}),
								UIGradient = e("UIGradient", {
									Color = Properties.LeftColor or ColorSequence.new(Color3.new(1, 1, 1)),
								}),
							},
						}),
						TopRightLabel = e(Main.TextLabel, {
							native = {
								Position = UDim2.fromScale(0.45, 0.2),
								Size = UDim2.fromScale(0.8, 0.15),
								TextXAlignment = Enum.TextXAlignment.Right,
								Text = Properties.RightText,
							},
							children = {
								UIStroke = e(UIStroke.UIStroke, {
									Stroke = 0.002,
									GradColor = Properties.RightStrokeColor or ColorSequence.new(Color3.new(1, 1, 1)),
									native = {
										Enabled = if Properties.RightStrokeColor then true else false,
									},
								}),
								UIGradient = e("UIGradient", {
									Color = Properties.RightColor or ColorSequence.new(Color3.new(1, 1, 1)),
								}),
							},
						}),
					},
				}),
			}, Properties.children),
		}) :: any
	)
end

return CreateBaseFrame
