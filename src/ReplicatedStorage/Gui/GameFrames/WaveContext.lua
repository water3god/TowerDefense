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
		local Connection = WaveService.Added:Connect(function()
			SetValue(WaveService.GetWaveData() :: any)
		end)

		local Connection1 = WaveService.HealthChanged:Connect(function(BaseHealth: number, MaxHealth: number)
			SetValue(Join(Value, {
				BaseHealth = BaseHealth,
				MaxHealth = MaxHealth,
			}) :: any)
		end)

		local Connection2 = WaveService.Passed:Connect(function(Wave)
			SetValue(Join(Value, {
				Wave = Wave,
			}) :: any)
		end)

		local Connection3 = WaveService.TimeChanged:Connect(function(Time: number, StartTime: number)
			SetValue(Join(Value, {
				StartTime = StartTime,
				Time = Time,
			}) :: any)
		end)

		local Connection4 = WaveService.Ended:Connect(function()
			local NewTable = table.clone(Value)
			Value.Time = 0
			Value.StartTime = 0
			SetValue(NewTable)
		end)

		return function()
			Connection:Disconnect()
			Connection1:Disconnect()
			Connection2:Disconnect()
			Connection3:Disconnect()
			Connection4:Disconnect()
		end
	end, {})

	return e(Context.Provider, {
		value = Value,
	}, props.children)
end

return {
	Context = Context,
	Provider = Provider,
}
