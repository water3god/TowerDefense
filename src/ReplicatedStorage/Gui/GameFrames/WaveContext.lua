--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local WaveService = require(ReplicatedStorage.Client.GlobalClient.WaveService)

local Context = React.createContext({} :: WaveService.WaveData)

local function Provider(props)
	local Value, SetValue = React.useState({})

	React.useEffect(function()
		local Connection = WaveService.Added:Connect(function()
			SetValue(WaveService.GetWaveData() :: any)
		end)

		local Connection1 = WaveService.HealthChanged:Connect(function()
			SetValue(table.clone(WaveService.GetWaveData() :: any))
		end)

		local Connection2 = WaveService.Passed:Connect(function()
			SetValue(table.clone(WaveService.GetWaveData() :: any))
		end)

		local Connection3 = WaveService.TimeChanged:Connect(function()
			SetValue(table.clone(WaveService.GetWaveData() :: any))
		end)

		local Connection4 = WaveService.Ended:Connect(function()
			SetValue({})
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
