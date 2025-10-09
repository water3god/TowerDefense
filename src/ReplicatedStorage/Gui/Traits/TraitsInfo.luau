--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local CloseButton = require(CoreGame.CloseButton)
local Title = require(CoreGame.Title)
local NewGui = require(CoreGame.NewGui)
local AnimatedGradient = require(CoreGame.AnimatedGradient)

local StatsFrame = require(Gui.Inventory.StatsFrame)

local Shared = ReplicatedStorage.Shared
local Traits = require(Shared.Traits)
local RarityInfo = require(Shared.RarityInfo)

export type Properties = {
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type TraitProperties = {
	Trait: string,
	SetTrait: (Trait: string) -> (),
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateTrait(props: TraitProperties)
	local TraitData = React.useMemo(function()
		return Traits.Traits[props.Trait]
	end, { props.Trait })

	local RarityData = React.useMemo(function()
		return RarityInfo[TraitData.Rarity :: any]
	end, { TraitData.Rarity })

	local InfoClick = React.useCallback(function()
		props.SetTrait(props.Trait)
	end, { props.SetTrait, props.Trait } :: { unknown })

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(1, 0.15),
		}, props.native),
	}, {
		Container = e(Main.ImageLabel, {
			native = {
				Size = UDim2.fromScale(0.9, 0.9),
				Image = "rbxassetid://103808626575670",
			},
		}, {
			Label = e(Main.TextLabel, {
				native = {
					Text = props.Trait,
					Size = UDim2.fromScale(0.45, 0.45),
					Position = UDim2.fromScale(0.425, 0.5),
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.015,
					GradColor = RarityData.StrokeColor,
				}),
				UIGradient = e(AnimatedGradient, {
					GradColor = RarityData.Color,
					Speed = 1,
				}),
			}),
			Chance = e(Main.TextLabel, {
				native = {
					Text = HelperFunctions.FormatNumberConditional(TraitData.Chance * 100) .. "%",
					Size = UDim2.fromScale(0.5, 0.5),
					Position = UDim2.fromScale(0.575, 0.5),
					TextXAlignment = Enum.TextXAlignment.Right,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.015,
					GradColor = RarityData.StrokeColor,
				}),
				UIGradient = e(AnimatedGradient, {
					GradColor = RarityData.Color,
					Speed = 1,
				}),
			}),
			Icon = e(Main.ImageLabel, {
				native = {
					Size = UDim2.fromScale(0.3, 0.7),
					Position = UDim2.fromScale(0.1, 0.5),
					Image = TraitData.Icon,
					BackgroundTransparency = 1,
				},
			}, {
				UIGradient = e(AnimatedGradient, {
					GradColor = RarityData.BackgroundColor,
					Animate = true,
					Speed = 1,
				}),
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
			}),
			InfoButton = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.9, 0.5),
					Size = UDim2.fromScale(0.3, 0.6),
					Image = "rbxassetid://77078349522524",
					ZIndex = 2,
					[React.Event.MouseButton1Click] = InfoClick,
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
			}),
		}),
	}, props.children)
end

local function CreateTraitsInfo(props: Properties)
	local SelectedTrait: string?, SetTrait = React.useState(nil :: string?)

	local TraitFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for TraitName, Data in pairs(Traits.Traits) do
			Frames[TraitName] = e(CreateTrait, {
				Trait = TraitName,
				SetTrait = SetTrait,
				native = {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					LayoutOrder = Data.Priority,
				},
			})
		end

		return Frames
	end, {})

	local StatsCloseClick = React.useCallback(function()
		SetTrait(nil)
	end, {})

	return e(NewGui, {
		DisplayOrder = 2,
	}, {
		StatsFrame = e(StatsFrame, {
			Type = "Trait",
			Level = 1,
			Visible = SelectedTrait ~= nil,
			Name = SelectedTrait,
			CloseClick = StatsCloseClick,
		}),
		Main = e(Main.ImageLabel, {
			native = Join({
				Size = UDim2.fromScale(0.5, 0.6),
				Image = "rbxassetid://85053227818414",
			}, props.native),
		}, {
			Title = e(Title, {
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.fromScale(1, 0.175),
				Title = "TRAITS",
			}),
			MainFrame = e(Main.ScrollingFrame, {
				BarSize = 0.01,
				native = {
					Position = UDim2.fromScale(0.5, 0.51),
					Size = UDim2.fromScale(0.95, 0.85),
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
			}, TraitFrames),
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 0.8,
			}),
			CloseButton = e(CloseButton, {
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromScale(0.175, 0.225),
				OnClick = props.CloseClick,
			}),
		}, props.children),
	})
end

return CreateTraitsInfo
