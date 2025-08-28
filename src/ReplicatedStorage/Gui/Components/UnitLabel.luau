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
local UnitView = require(CoreGame.UnitView)
local AnimatedGradient = require(CoreGame.AnimatedGradient)
local UIStroke = require(CoreGame.UIStroke)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)

export type Properties = {
	Unit: string,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateUnitLabel(props: Properties)
	local RotationCFrame = React.useBinding(CFrame.Angles(math.rad(20), 0, 0))

	local Rarity = React.useMemo(function()
		return UnitInfo.UnitInfo[props.Unit].Rarity
	end, { props.Unit })

	local RarityData = React.useMemo(function()
		return RarityInfo[Rarity :: RarityInfo.Rarity]
	end, { Rarity })

	return e(Main.Frame, {
		native = Join({}, props.native),
	}, {
		UnitView = e(UnitView, {
			UnitName = props.Unit,
			Level = 1,
			Distance = 4,
			RotationCFrame = RotationCFrame,
			Offset = Vector3.new(0, -1, 0),
			native = {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.9, 0.9),
			},
		}),
		UnitLabel = e(Main.TextLabel, {
			native = {
				Text = props.Unit,
				Position = UDim2.fromScale(0.5, 0.6),
				Size = UDim2.fromScale(0.9, 0.2),
			},
		}, {
			UIGradient = e(AnimatedGradient, {
				GradColor = RarityData.Color,
			}),
			UIStroke = e(UIStroke.UIStrokeGradient, {
				GradColor = RarityData.StrokeColor,
				Stroke = 0.02,
			}),
		}),
		RarityLabel = e(Main.TextLabel, {
			native = {
				Text = Rarity,
				Position = UDim2.fromScale(0.5, 0.9),
				Size = UDim2.fromScale(0.9, 0.2),
			},
		}, {
			UIGradient = e(AnimatedGradient, {
				GradColor = RarityData.Color,
			}),
			UIStroke = e(UIStroke.UIStrokeGradient, {
				GradColor = RarityData.StrokeColor,
				Stroke = 0.02,
			}),
		}),
	}, props.children)
end

return CreateUnitLabel
