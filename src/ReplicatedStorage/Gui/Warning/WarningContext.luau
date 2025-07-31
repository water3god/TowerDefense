--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local GenerateId = require(Modules.GenerateId)
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Network = require(ReplicatedStorage.Network.Client)
local ClientOnly = require(ReplicatedStorage.Network.ClientOnly)
local SendWarning = Network.SendWarning
local Warning = ClientOnly.Warning

local OnWarning: Signal.Signal<string, Color3?> = Signal.new()

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Hooks = require(CoreGame.Hooks)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)

local WarningContext = React.createContext({
	Warnings = {},
	Add = function() end,
} :: {
	Warnings: { [string]: { Text: string, Color: Color3, StartTime: number } },
	Add: (Text: string) -> (),
})

SendWarning.SetCallback(function(Message, Color)
	OnWarning:Fire(Message, Color)
end)

local function WarningProvider(props)
	local Value, SetValue = React.useState({} :: { [string]: { Text: string, Color: Color3, StartTime: number } })

	local Add = React.useCallback(function(Text: string, ColorInput: Color3?)
		local Color = ColorInput or Color3.new(1, 0.043137, 0.043137)
		SetValue(function(CurrentValue)
			return Join(
				CurrentValue,
				{ [GenerateId.GenerateId()] = { Text = Text, Color = Color, StartTime = tick() } }
			)
		end)
	end, {})

	Hooks.useEventConnection(RunService.PostSimulation, function()
		local NewTable = table.clone(Value)
		local Changed = false
		for Id, Data in pairs(Value) do
			if tick() - Data.StartTime >= Constants.WarningTime then
				NewTable[Id] = nil
				GenerateId.RemoveId(Id)
				Changed = true
			end
		end
		if Changed then
			SetValue(NewTable)
		end
	end, { Value })

	Hooks.useEventConnection(OnWarning, function(Text: string, Color: Color3?)
		Add(Text, Color)
	end, {})

	Hooks.useEventConnection(Warning, function(Text: string, Color: Color3?)
		Add(Text, Color)
	end, {})

	return e(WarningContext.Provider, {
		value = {
			Warnings = Value,
			Add = Add,
		},
	}, props.children)
end

return {
	Context = WarningContext,
	Provider = WarningProvider,
}
