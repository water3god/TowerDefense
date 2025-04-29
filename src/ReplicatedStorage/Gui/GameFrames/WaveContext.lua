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

local WaveService = require(ReplicatedStorage.Client.GlobalClient.WaveService)

local Default = {
	BaseHealth = 1,
	MaxHealth = 1,
	StartTime = 0,
	Time = 0,
	Wave = 1,
}

local Context = React.createContext(Default :: WaveService.WaveData)

local function Provider(props)
	local Value, SetValue = React.useState(Default :: WaveService.WaveData)

	React.useEffect(function()
		local Trove = Trove.new()

		Trove:Connect(WaveService.Added, function()
			SetValue(WaveService.GetWaveData() :: any)
		end)

		Trove:Connect(WaveService.HealthChanged, function(BaseHealth: number, MaxHealth: number)
			SetValue(Join(Value, {
				BaseHealth = BaseHealth,
				MaxHealth = MaxHealth,
			}) :: any)
		end)

		Trove:Connect(WaveService.Passed, function(Wave)
			SetValue(Join(Value, {
				Wave = Wave,
			}) :: any)
		end)

		Trove:Connect(WaveService.TimeChanged, function(Time: number, StartTime: number)
			SetValue(Join(Value, {
				StartTime = StartTime,
				Time = Time,
			}) :: any)
		end)

		Trove:Connect(WaveService.Ended, function()
			local NewTable = table.clone(Value)
			Value.Time = 0
			Value.StartTime = 0
			SetValue(NewTable)
		end)

		return Trove:WrapClean()
	end, {})

	return e(Context.Provider, {
		value = Value,
	}, props.children)
end

return {
	Context = Context,
	Provider = Provider,
}
