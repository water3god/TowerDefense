--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local React = require(Packages.React)
local e = React.createElement

local Network = require(ReplicatedStorage.Network.Client)
local BoostsSync = Network.BoostsSync

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local Hooks = require(CoreGame.Hooks)

local Shared = ReplicatedStorage.Shared
local BoostsModule = require(Shared.Boosts)

export type BoostProperties = {
	Boost: string,
	EndTime: number,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type Properties = {
	Boosts: { [string]: number },
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateBoost(props: BoostProperties)
	local Time, _, SetTime = Hooks.UseTime()

	React.useEffect(function()
		local TimeTotal = props.EndTime - workspace:GetServerTimeNow()
		SetTime(TimeTotal, props.EndTime)
	end, { props.EndTime })

	local BoostData = React.useMemo(function(): BoostsModule.BoostData
		return BoostsModule[props.Boost]
	end, { props.Boost })

	return e(Main.Frame, {
		native = Join({}, props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}),
		Container = e(Main.ImageLabel, {
			native = {
				Image = BoostData.Icon,
				Size = UDim2.fromScale(0.9, 0.9),
			},
		}),
		NameLabel = e(Main.TextLabel, {
			native = {
				Text = props.Boost,
				Size = UDim2.fromScale(1, 0.2),
				Position = UDim2.fromScale(0.5, 0.6),
			},
		}),
		TimeLabel = e(Main.TextLabel, {
			native = {
				Text = Time:map(function(Input: number)
					return HelperFunctions.FormatTime(math.floor(Input))
				end),
				Size = UDim2.fromScale(1, 0.2),
				Position = UDim2.fromScale(0.5, 0.9),
			},
		}),
	}, props.children)
end

local function CreateBoosts(props: Properties)
	local BoostsFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		local LayoutOrder = Hooks.LayoutOrder()

		for BoostName, TimeEnd in pairs(props.Boosts) do
			Frames[BoostName] = e(CreateBoost, {
				Boost = BoostName,
				EndTime = TimeEnd,
				native = {
					LayoutOrder = LayoutOrder(),
				},
			})
		end
	end, { props.Boosts })

	return e(Main.Frame, {
		native = Join({
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.fromScale(0.4, 0.1),
			AnchorPoint = Vector2.new(0, 1),
		}, props.native),
	}, {
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}, BoostsFrames),
	}, props.children)
end

local function BoostsConnected(props)
	local Boosts, SetBoosts = React.useState({} :: { [string]: number })

	local Promised = React.useRef({} :: { [string]: Promise.Promise })

	Hooks.useZapConnection(BoostsSync, function(BoostsTable)
		SetBoosts(function(BoostsInput)
			local CurrentTable = table.clone(BoostsInput)
			for Boost, EndTime in pairs(BoostsTable) do
				if EndTime > workspace:GetServerTimeNow() then
					CurrentTable[Boost] = EndTime

					if Promised.current[Boost] then
						Promised.current[Boost]:cancel()
						Promised.current[Boost] = nil
					end
				end
			end

			return CurrentTable
		end)
	end, {})

	React.useEffect(function()
		for Boost, EndTime in pairs(Boosts) do
			if not Promised.current[Boost] then
				Promised.current[Boost] = Promise.delay((EndTime + 1) - workspace:GetServerTimeNow()):andThen(function()
					SetBoosts(function(BoostsInput)
						local NewBoosts = table.clone(BoostsInput)
						NewBoosts[Boost] = nil
						return NewBoosts
					end)
				end)
			end
		end
	end, { Boosts })

	return e(CreateBoosts, {
		Boosts = Boosts,
	})
end

return {
	Create = CreateBoosts,
	Connected = BoostsConnected,
}
