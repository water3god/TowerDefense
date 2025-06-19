--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local NewGui = require(CoreGame.NewGui)
local CloseButton = require(CoreGame.CloseButton)
local Main = require(CoreGame.Main)
local Title = require(CoreGame.Title)
local UIStroke = require(CoreGame.UIStroke)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)

export type Props = {
	UnitName: string?,
	Visible: boolean,
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateStatsFrame(props: Props)
	local UnitData = React.useMemo(function()
		if props.UnitName then
			return UnitInfo.UnitInfo[props.UnitName]
		else
			return UnitInfo.UnitInfo["Trajan"]
		end
	end, { props.UnitName })

	local RarityData = React.useMemo(function()
		return RarityInfo[UnitData.Rarity]
	end, { UnitData })

	return e(NewGui, {
		DisplayOrder = 4,
	}, {
		StatsFrame = e(Main.ImageLabel, {
			native = Join({
				Position = UDim2.fromScale(0.5, 0.55),
				Size = UDim2.fromScale(0.5, 0.5),
				Image = "rbxassetid://100546338175267",
				Visible = props.Visible,
				ZIndex = 5,
			}, props.native),
		}, {
			UnitLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.2, 0.175),
					Size = UDim2.fromScale(0.5, 0.1),
					Text = props.UnitName,
				},
			}, {
				ColorGradient = e("UIGradient", {
					Color = RarityData.Color,
				}),
				Stroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.02,
					GradColor = RarityData.StrokeColor,
				}),
			}),
			RarityLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.2, 0.3),
					Size = UDim2.fromScale(0.5, 0.1),
					Text = UnitData.Rarity,
				},
			}, {
				ColorGradient = e("UIGradient", {
					Color = RarityData.Color,
				}),
				Stroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.02,
					GradColor = RarityData.StrokeColor,
				}),
			}),
			Description = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.2),
					Position = UDim2.fromScale(0.5, 0.75),
					Text = UnitData.Description,
				},
			}),
			Title = e(Title, {
				Title = "STATS",
				Position = UDim2.fromScale(0.225, -0.04),
				Size = UDim2.fromScale(0.7, 0.35),
			}),
			UIAspectRatio = e("UIAspectRatioConstraint", {
				AspectRatio = 1.7,
			}),
			CloseButton = e(CloseButton, {
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromScale(0.2, 0.3),
				OnClick = props.CloseClick,
			}),
		}, props.children),
	})
end

return CreateStatsFrame
