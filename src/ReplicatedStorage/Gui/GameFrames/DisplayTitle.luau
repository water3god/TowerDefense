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

local Shared = ReplicatedStorage.Shared
local Titles = require(Shared.Titles)
local LevelRequirements = require(Shared.LevelRequirements)

export type Properties = {
	Name: string,
	Level: number,
	Title: string,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateDisplayTitle(props: Properties)
	local TitleData = React.useMemo(function()
		return Titles[props.Title]
	end, { props.Title })

	local LevelColor = React.useMemo(function()
		local HighestLevel = 1
		for Level, _ in pairs(LevelRequirements.Colors) do
			if Level <= props.Level and Level > HighestLevel then
				HighestLevel = Level
			end
		end
		return LevelRequirements.Colors[HighestLevel]
			or ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0.8, 0.8, 0.8))
	end, { props.Level })

	return e(Main.Frame, {
		native = Join({}, props.children),
	}, {
		NameLabel = e(Main.TextLabel, {
			native = {
				Text = props.Name,
				Size = UDim2.fromScale(0.8, 0.2),
				Position = UDim2.fromScale(0.5, 0.25),
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
				Color = Color3.new(0, 0, 0),
			}),
		}),
		TitleLabel = e(Main.TextLabel, {
			native = {
				Text = props.Title,
				Size = UDim2.fromScale(0.8, 0.2),
				Position = UDim2.fromScale(0.5, 0.5),
			},
		}, {
			UIGradient = e("UIGradient", {
				Color = TitleData.Color,
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
				Color = Color3.new(0, 0, 0),
			}),
		}),
		LevelLabel = e(Main.TextLabel, {
			native = {
				Text = string.format("Level %d", props.Level),
				Size = UDim2.fromScale(0.8, 0.2),
				Position = UDim2.fromScale(0.5, 0.75),
			},
		}, {
			UIGradient = e("UIGradient", {
				Color = LevelColor,
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
				Color = Color3.new(0, 0, 0),
			}),
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.5,
		}),
	}, props.children)
end

return CreateDisplayTitle
