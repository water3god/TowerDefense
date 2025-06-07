--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Trove = require(Packages.Trove)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local GlobalClient = ReplicatedStorage.Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)

export type Data = {
	UniqueId: string,
	UnitName: string,
	UpgradeData: UnitClient.TotalUnitData,
	TotalCost: number,
	Level: number,
	Priority: UnitInfo.SortType | string,
	Enabled: boolean,
	Abilities: { UnitClient.AbilityData },
}

local DefaultValue: Data = {
	UniqueId = "IOD97208U43RI47U6RJE9i",
	UnitName = "Pompey",
	UpgradeData = {
		[0] = {
			Cost = 10,
			Damage = { 1 },
			FireRate = 1,
			Range = 10,
		},
	},
	Priority = UnitInfo.SortTypes[1],
	Level = 0,
	TotalCost = 10,
	Enabled = false,
	Abilities = {
		{
			MinimumLevel = 0,
			LastUsed = 0,
			Name = "Rage",
			Icon = "",
			Length = 10,
			Cooldown = 30,
			BackgroundColor = ColorSequence.new(Color3.new()),
			Func = function() end,
		},
	},
}

local UpgradeContext = React.createContext(DefaultValue)

export type Props = {
	UnitId: string?,
	children: { [any]: any }?,
}

local function UpgradeProvider(props: Props)
	local Data, SetData = React.useState(DefaultValue)

	React.useEffect(function()
		local Trove = Trove.new()
		local Unit = props.UnitId and UnitClient.GetUnit(props.UnitId)
		if Unit then
			local function Set(EnabledInput: boolean?)
				local Enabled = true
				if EnabledInput ~= nil then
					Enabled = EnabledInput
				end

				SetData({
					UniqueId = Unit.UniqueId,
					UnitName = Unit.UnitName,
					UpgradeData = Unit.UnitData.UnitData,
					TotalCost = Unit.TotalCost,
					Level = Unit.Level,
					Enabled = Enabled,
					Priority = Unit.AttackPriority,
					Abilities = Unit.Abilities,
				})
			end

			Set()

			Trove:Connect(Unit.Upgraded, Set)
			Trove:Connect(Unit.PriorityChanged, Set)
			Trove:Connect(Unit.AbilityUsed, Set)

			Trove:Connect(Unit.Destroying, function()
				Set(false)
			end)
		else
			SetData(Join(Data, {
				Enabled = false,
			}) :: any)
		end

		return Trove:WrapClean()
	end, { props.UnitId })

	return e(UpgradeContext.Provider, {
		value = Data,
	}, props.children)
end

return {
	Context = UpgradeContext,
	Provider = UpgradeProvider,
}
