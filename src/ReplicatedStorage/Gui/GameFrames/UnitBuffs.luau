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

local GlobalClient = ReplicatedStorage.Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)

export type Properties = {
	Buffs: { [string]: number },
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type ConnectedProps = {
	UniqueId: string,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type BuffProps = {
	Buff: string,
	Value: number,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateBuff(props: BuffProps)
	local BuffNumber = React.useMemo(function()
		local Value = if props.Buff == "FireRate" then 1 / props.Value else props.Value

		local Floored = math.floor(Value * 100) / 100
		return HelperFunctions.FormatNumberConditional(Floored - 1)
	end, { props.Buff, props.Value } :: { unknown })

	local BuffPercent = React.useMemo(function()
		if props.Value == 1 then
			return "0%"
		end

		return string.format("%d%%", (props.Value - 1) * 100)
	end, { props.Value })

	return tonumber(BuffNumber) > 0
		and e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(1, 0.15),
				LayoutOrder = UnitInfo.Stats.Layout[props.Buff :: any],
			},
		}, {
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			Icon = e(Main.ImageLabel, {
				native = {
					Size = UDim2.fromScale(0.3, 0.8),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Image = UnitInfo.Stats.Icons[props.Buff :: any],
					LayoutOrder = 1,
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
			}),
			Label = e(Main.TextLabel, {
				native = {
					Text = BuffPercent,
					Size = UDim2.fromScale(0.15, 0.8),
					TextColor3 = UnitInfo.Stats.Colors[props.Buff :: any],
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 2,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
				}),
			}),
		})
end

local function CreateUnitBuffs(props: Properties)
	local BuffFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for BuffName, BuffValue in pairs(props.Buffs) do
			Frames[BuffName] = e(CreateBuff, {
				Buff = BuffName,
				Value = BuffValue,
			})
		end

		return Frames
	end, { props.Buffs })

	return e(Main.Frame, {
		native = Join({}, props.native),
	}, {
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
	}, BuffFrames, props.children)
end

local function Connected(props: ConnectedProps)
	local Buffs, SetBuffs = React.useState({})

	React.useEffect(function()
		local Unit = UnitClient.GetUnit(props.UniqueId)

		if Unit then
			local function Set()
				local Ratios = {
					Damage = 1,
					FireRate = 1,
					Range = 1,
					Coins = 1,
				}

				for Name, Data in pairs(Unit.RatioData) do
					if string.sub(Name, 1, 2) == "__" then
						continue
					end

					local _, OtherData = next(Data)

					if not OtherData then
						continue
					end
					local HighestRatio: number? = nil

					for _, Ratio in pairs(Data) do
						if Ratio.Type == "FireRate" then
							if not HighestRatio or Ratio.Ratio < HighestRatio then
								HighestRatio = Ratio.Ratio
							end
						else
							if not HighestRatio or Ratio.Ratio > HighestRatio then
								HighestRatio = Ratio.Ratio
							end
						end
					end

					if HighestRatio then
						Ratios[OtherData.Type] *= HighestRatio
					end
				end

				SetBuffs(Ratios)
			end

			Set()
			Unit.PropertyChanged:Connect(Set)
		end
	end, { props.UniqueId })

	return e(CreateUnitBuffs, {
		Buffs = Buffs :: any,
		native = Join({}, props.native),
	}, {}, props.children)
end

return {
	CreateUnitBuffs = CreateUnitBuffs,
	Connected = Connected,
}
