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

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Hooks = require(CoreGame.Hooks)

local WaveService = require(ReplicatedStorage.Client.GlobalClient.WaveService)

local Default = {
	BaseHealth = 100,
	MaxHealth = 100,
	StartTime = 1,
	Time = 0,
	Wave = 1,
}

local Context = React.createContext(Default :: WaveService.WaveData)

local function Provider(props)
	local Value, SetValue = React.useState(Default :: WaveService.WaveData)

	React.useEffect(function()
		local WaveTrove = Trove.new()

		local function SetWaveData()
			local Data = WaveService.GetWaveData()
			if Data then
				SetValue(table.clone(Data))
			end
		end

		SetWaveData()
		WaveTrove:Connect(WaveService.Added, SetWaveData)
		WaveTrove:Connect(WaveService.HealthChanged, SetWaveData)
		WaveTrove:Connect(WaveService.Passed, SetWaveData)
		WaveTrove:Connect(WaveService.TimeChanged, SetWaveData)

		return WaveTrove:WrapClean()
	end, {})

	Hooks.useEventConnection(WaveService.Ended, function()
		SetValue(Join(Value, {
			StartTime = 0,
			Time = 0,
		}) :: any)
	end, { Value })

	return e(Context.Provider, {
		value = Value,
	}, props.children)
end

return {
	Context = Context,
	Provider = Provider,
}
