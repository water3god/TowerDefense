--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local GenerateId = require(Modules.GenerateId)
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local Hooks = require(CoreGame.Hooks)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)

local WarningContext = React.createContext({
	Warnings = {},
	Add = function(Text: string) end,
} :: {
	Warnings: { [string]: { Text: string, StartTime: number } },
	Add: (Text: string) -> (),
})

local function WarningProvider(props)
	local Value, SetValue = React.useState({} :: { [string]: { Text: string, StartTime: number } })

	local Add = React.useCallback(function(Text: string)
		SetValue(Join(Value, { [GenerateId.GenerateId()] = { Text = Text, StartTime = tick() } }))
	end, { Value })

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
