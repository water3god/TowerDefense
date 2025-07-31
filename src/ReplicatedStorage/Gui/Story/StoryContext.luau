--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Client = ReplicatedStorage.Client
local LobbyClient = Client.LobbyClient
local StoryService = require(LobbyClient.StoryService)

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Hooks = require(CoreGame.Hooks)

type Context = {
	Enabled: boolean,
	CompletedMaps: StoryService.MapData,
	Data: StoryService.BoothData?,
	BoothTimeData: StoryService.TimeData?,
}

local Context = React.createContext({
	Enabled = false,
	CompletedMaps = {},
} :: Context)

local function Provider(props)
	local Value, SetValue = React.useState({
		Enabled = false,
		Data = nil,
		BoothTimeData = nil,
		CompletedMaps = StoryService.MapData,
	} :: Context)

	Hooks.useEventConnection(StoryService.BoothChoosing, function(Data)
		local NewTable = table.clone(Value)
		NewTable.Enabled = true
		NewTable.BoothTimeData = Data
		SetValue(NewTable)
	end, { Value })

	Hooks.useEventConnection(StoryService.BoothRestarted, function()
		local NewTable = table.clone(Value)
		NewTable.Enabled = false
		NewTable.Data = nil
		NewTable.BoothTimeData = nil

		SetValue(NewTable)
	end, { Value })

	Hooks.useEventConnection(StoryService.BoothWaiting, function(Data: StoryService.BoothData)
		local NewTable = table.clone(Value)
		NewTable.Enabled = true
		NewTable.Data = Data
		NewTable.BoothTimeData = nil
		SetValue(NewTable)
	end, { Value })

	Hooks.useEventConnection(StoryService.PlayerChanged, function(_, _, Changed: boolean)
		if Changed and Value.Data and StoryService.Data then
			local NewTable = table.clone(Value)
			NewTable.Data = StoryService.Data
			SetValue(NewTable)
		end
	end, { Value })

	React.useEffect(function()
		local NewTable = table.clone(Value)
		NewTable.CompletedMaps = table.clone(StoryService.MapData or {})
		SetValue(NewTable)
	end, {})

	Hooks.useEventConnection(StoryService.MapDataChanged, function(Data)
		local NewTable = table.clone(Value)
		NewTable.CompletedMaps = table.clone(Data)
		SetValue(NewTable)
	end, { Value })

	return e(Context.Provider, {
		value = Value,
	}, props.children)
end

return {
	Context = Context,
	Provider = Provider,
}
