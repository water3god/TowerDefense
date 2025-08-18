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
	CompletedInfinites: StoryService.InfiniteMapData,
	Data: StoryService.BoothData?,
	BoothTimeData: StoryService.TimeData?,
}

local Context = React.createContext({
	Enabled = false,
	CompletedMaps = {},
	CompletedInfinites = {},
} :: Context)

local function Provider(props)
	local Value, SetValue = React.useState({
		Enabled = false,
		Data = nil,
		BoothTimeData = nil,
		CompletedMaps = {},
		CompletedInfinites = {},
	} :: Context)

	Hooks.useEventConnection(StoryService.BoothChoosing, function(Data)
		SetValue(function(Table)
			local NewTable = table.clone(Table)
			NewTable.Enabled = true
			NewTable.BoothTimeData = Data
			return NewTable
		end)
	end, { Value })

	Hooks.useEventConnection(StoryService.BoothRestarted, function()
		SetValue(function(Table)
			local NewTable = table.clone(Table)
			NewTable.Enabled = false
			NewTable.Data = nil
			NewTable.BoothTimeData = nil
			return NewTable
		end)
	end, { Value })

	Hooks.useEventConnection(StoryService.BoothWaiting, function(Data: StoryService.BoothData)
		SetValue(function(Table)
			local NewTable = table.clone(Table)
			NewTable.Enabled = true
			NewTable.Data = Data
			NewTable.BoothTimeData = nil
			return NewTable
		end)
	end, { Value })

	Hooks.useEventConnection(StoryService.PlayerChanged, function(_, _, Changed: boolean)
		if Changed and Value.Data and StoryService.Data then
			SetValue(function(Table)
				local NewTable = table.clone(Table)
				NewTable.Data = StoryService.Data
				return NewTable
			end)
		end
	end, { Value })

	React.useEffect(function()
		SetValue(function(Table)
			local NewTable = table.clone(Table)
			NewTable.CompletedMaps = table.clone(StoryService.MapData or {})
			NewTable.CompletedInfinites = table.clone(StoryService.InfiniteMapData or {})
			return NewTable
		end)
	end, {})

	Hooks.useEventConnection(StoryService.MapDataChanged, function(Data)
		SetValue(function(Table)
			local NewTable = table.clone(Table)
			NewTable.CompletedMaps = table.clone(Data)
			return NewTable
		end)
	end, { Value })

	Hooks.useEventConnection(StoryService.InfiniteMapDataChanged, function(Data)
		SetValue(function(Table)
			local NewTable = table.clone(Table)
			NewTable.CompletedInfinites = table.clone(Data)
			return NewTable
		end)
	end, { Value })

	return e(Context.Provider, {
		value = Value,
	}, props.children)
end

return {
	Context = Context,
	Provider = Provider,
}
