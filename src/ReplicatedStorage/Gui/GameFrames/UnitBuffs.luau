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
	local BuffPercent = React.useMemo(function()
		return HelperFunctions.FormatNumberConditional(1 - props.Value)
	end, { props.Value })

	return tonumber(BuffPercent) > 1
		and e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(1, 0.3),
				LayoutOrder = UnitInfo.Stats.Layout[props.Buff :: any],
			},
		}, {
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
			}),
			Icon = e(Main.ImageLabel, {
				native = {
					Size = UDim2.fromScale(0.2, 1),
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
					AutomaticSize = Enum.AutomaticSize.X,
					Text = BuffPercent,
					Size = UDim2.fromScale(0.1, 0.5),
					TextColor3 = UnitInfo.Stats.Colors[props.Buff :: any],
					LayoutOrder = 2,
				},
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
	end)

	return e(Main.Frame, {
		native = Join({}, props.native),
	}, {
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
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

				for _, Data in pairs(Unit.RatioData) do
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
