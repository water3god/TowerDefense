--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Trove = require(Packages.Trove)
local Promise = require(Packages.Promise)

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

		local function SetWaveData()
			local Data = WaveService.GetWaveData()
			if Data then
				SetValue(table.clone(Data))
			end
		end

		SetWaveData()
		Trove:Connect(WaveService.Added, SetWaveData)
		Trove:Connect(WaveService.HealthChanged, SetWaveData)
		Trove:Connect(WaveService.Passed, SetWaveData)
		Trove:Connect(WaveService.TimeChanged, SetWaveData)
		Trove:Connect(WaveService.Ended, SetWaveData)

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
