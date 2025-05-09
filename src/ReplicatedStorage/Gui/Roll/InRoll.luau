--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UnitView = require(CoreGame.UnitView)
local UIStroke = require(CoreGame.UIStroke)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)

export type Properties = {
	UnitNames: { string },
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type UnitProperties = {
	UnitName: string,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateUnitFrame(props: UnitProperties)
	local Position, API = ReactSpring.useSpring(function()
		return {
			Scale = 0,
		}
	end)

	local Data = React.useMemo(function()
		if props.UnitName then
			local UnitData = UnitInfo.UnitInfo[props.UnitName]
			local RarityData = RarityInfo[UnitData.Rarity]

			return {
				UnitName = props.UnitName,
				Rarity = UnitData.Rarity,
				RarityData = RarityData,
			}
		else
			return {} :: any
		end
	end, { props.UnitName })

	local RotationCFrame = React.useBinding(CFrame.Angles(math.rad(20), 0, 0))

	return e(Main.Frame, {
		native = Join({}, props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}),
		Container = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.9, 0.9),
			},
		}, {
			View = e(UnitView, {
				UnitName = props.UnitName,
				RotationCFrame = RotationCFrame,
				Distance = 4,
				Size = UDim2.fromScale(1.2, 1.2),
				Offset = Vector3.new(0, -1, 0),
				native = {
					Position = UDim2.fromScale(0.5, 0.6),
				},
			}),
			NameLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.15),
					Position = UDim2.fromScale(0.5, 0.75),
					Text = Data.UnitName or "",
					ZIndex = 2,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.03,
					GradColor = Data.RarityData and Data.RarityData.StrokeColor,
				}),
				UIGradient = e("UIGradient", {
					Color = Data.RarityData and Data.RarityData.Color,
				}),
			}),
			RarityLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.15),
					Position = UDim2.fromScale(0.5, 0.9),
					Text = Data.Rarity or "",
					ZIndex = 2,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.03,
					GradColor = Data.RarityData and Data.RarityData.StrokeColor,
				}),
				UIGradient = e("UIGradient", {
					Color = Data.RarityData and Data.RarityData.Color,
				}),
			}),
		}),
	}, props.children)
end

local MaxPerRow = 4

local function CreateInRoll(props: Properties)
	local MainFrames: any = React.useMemo(function()
		local Frames = {}
		local RowCount = math.ceil(#props.UnitNames / MaxPerRow)

		local MaxSize = math.max(math.pow(1 - math.clamp(#props.UnitNames, 0, 4) * 0.12, 1.2), 0.5)

		for i = 1, RowCount, 1 do
			local UnitFrames: any = {}

			for j = 1, MaxPerRow, 1 do
				local Index = MaxPerRow * (i - 1) + j
				local UnitName = props.UnitNames[Index]

				if UnitName then
					UnitFrames["UnitFrame" .. Index] = e(CreateUnitFrame, {
						UnitName = UnitName,
						native = {
							LayoutOrder = j,
						},
					})
				end
			end

			Frames["CoverFrame" .. i] = e(Main.Frame, {
				native = {
					Size = UDim2.fromScale(1, math.min(1 / RowCount, MaxSize)),
					Position = UDim2.fromScale(0.5, (i - 0.5) * (1 / RowCount)),
					LayoutOrder = i,
				},
			}, {
				UIListLayout = e("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
			}, UnitFrames)
		end

		return Frames
	end, { props.UnitNames })

	return e(Main.Frame, {
		native = Join({
			Position = UDim2.fromScale(0.5, 0.4),
			Size = UDim2.fromScale(0.8, 0.6),
		}, props.native),
	}, {
		ContinueButton = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.5, 1.2),
				Size = UDim2.fromScale(0.5, 0.2),
				Image = "rbxassetid://80739823452825",
				ImageColor3 = Color3.new(1.000000, 0.125490, 0.125490),
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 3.2,
			}),
			Label = e(Main.TextLabel, {
				native = {
					Text = "Continue",
					Size = UDim2.fromScale(0.7, 0.7),
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
				}),
			}),
		}),
	}, MainFrames, props.children)
end

local function CreateRollConnected(props)
	return e(CreateInRoll)
end

return {
	Create = CreateInRoll,
	Connected = CreateRollConnected,
}
