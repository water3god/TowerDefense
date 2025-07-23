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
local Hooks = require(CoreGame.Hooks)
local Title = require(CoreGame.Title)

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

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(1, 0.15),
		}, props.native),
	}, {
		Container = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.9, 0.9),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.298039, 0.094118, 0.470588),
			},
		}, {
			Label = e(Main.TextLabel, {
				native = {
					Text = props.Trait,
					Size = UDim2.fromScale(0.5, 0.5),
					Position = UDim2.fromScale(0.45, 0.5),
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.015,
					GradColor = RarityData.StrokeColor,
				}),
				UIGradient = e("UIGradient", {
					Color = RarityData.Color,
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
				UIGradient = e("UIGradient", {
					Color = RarityData.Color,
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
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
			}),
			InfoButton = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.9, 0.5),
					Size = UDim2.fromScale(0.3, 0.7),
					Image = "rbxassetid://77078349522524",
					ZIndex = 2,
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
	local TraitFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for TraitName, Data in pairs(Traits.Traits) do
			Frames[TraitName] = e(CreateTrait, {
				Trait = TraitName,
				native = {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					LayoutOrder = Data.Priority,
				},
			})
		end

		return Frames
	end)

	return e(Main.Frame, {
		native = Join({
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
			Size = UDim2.fromScale(0.8, 0.8),
		}, props.native),
	}, {
		Title = e(Title, {
			Position = UDim2.fromScale(0.3, 0),
			Size = UDim2.fromScale(1, 0.14),
			Title = "TRAITS",
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
		}, TraitFrames),
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

return CreateTraitsInfo
