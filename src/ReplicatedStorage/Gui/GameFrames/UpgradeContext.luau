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
	OwnerId: number?,
	UniqueId: string,
	UnitName: string,
	UpgradeData: UnitClient.TotalUnitData,
	Properties: {
		Damage: number,
		FireRate: number,
		Range: number,
		Coins: number?,
		Special: string?,
	},
	NextProperties: {
		Damage: number,
		FireRate: number,
		Range: number,
		Coins: number?,
		Special: string?,
	}?,
	Trait: string?,
	TotalCost: number,
	Level: number,
	Priority: UnitInfo.SortType | string,
	Enabled: boolean,
	Abilities: { UnitClient.AbilityData },
}

local DefaultValue: Data = {
	OwnerId = 1,
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
	Properties = {
		Damage = 1,
		FireRate = 1,
		Range = 10,
		Coins = 1,
	},
	NextProperties = {
		Damage = 1,
		FireRate = 1,
		Range = 10,
		Coins = 1,
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
		local UpgradeTrove = Trove.new()
		local Unit = props.UnitId and UnitClient.GetUnit(props.UnitId)
		if Unit then
			SetData({
				OwnerId = Unit.OwnerId,
				UniqueId = Unit.UniqueId,
				UnitName = Unit.UnitName,
				UpgradeData = Unit.UnitData.UnitData,
				Properties = Unit:GetProperties(),
				NextProperties = Unit:GetNextProperties(),
				Trait = Unit.Trait,
				TotalCost = Unit.TotalCost,
				Level = Unit.Level,
				Enabled = true,
				Priority = Unit.AttackPriority,
				Abilities = Unit.Abilities,
			} :: any)

			UpgradeTrove:Connect(Unit.Upgraded, function()
				SetData(function(Input)
					local Table = Join(Input, {
						Properties = Unit:GetProperties(),
						Trait = Unit.Trait,
						TotalCost = Unit.TotalCost,
						Level = Unit.Level,
					}) :: any
					Table.NextProperties = Unit:GetNextProperties() :: any

					return Table
				end)
			end)
			UpgradeTrove:Connect(Unit.PriorityChanged, function(Priority: UnitInfo.SortType)
				SetData(function(Input)
					return Join(Input, {
						Priority = Priority,
					}) :: any
				end)
			end)
			UpgradeTrove:Connect(Unit.AbilityUsed, function()
				SetData(function(Input)
					return Join(Input, {
						Abilities = table.clone(Unit.Abilities),
					}) :: any
				end)
			end)
			UpgradeTrove:Connect(Unit.PropertyChanged, function()
				SetData(function(Input)
					return Join(Input, {
						Properties = Unit:GetProperties(),
						NextProperties = Unit:GetNextProperties(),
					}) :: any
				end)
			end)

			UpgradeTrove:Connect(Unit.Destroying, function()
				SetData(function(Input)
					return Join(Input, {
						Enabled = false,
					}) :: any
				end)
			end)
		else
			SetData(Join(Data, {
				Enabled = false,
			}) :: any)
		end

		return UpgradeTrove:WrapClean()
	end, { props.UnitId })

	return e(UpgradeContext.Provider, {
		value = Data,
	}, props.children)
end

return {
	Context = UpgradeContext,
	Provider = UpgradeProvider,
}
