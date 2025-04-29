--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Trove = require(Packages.Trove)

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Hooks = require(CoreGame.Hooks)

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)

local Client = ReplicatedStorage.Client
local LobbyClient = Client.LobbyClient
local StoryService = require(LobbyClient.StoryService)

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
		CompletedMaps = {},
	} :: Context)

	React.useEffect(function()
		local Trove = Trove.new()
		Trove:Connect(StoryService.BoothChoosing, function(Data)
			local NewTable = table.clone(Value)
			NewTable.Enabled = true
			NewTable.BoothTimeData = Data
			SetValue(NewTable)
		end)

		Trove:Connect(StoryService.BoothRestarted, function()
			local NewTable = table.clone(Value)
			NewTable.Enabled = false
			NewTable.Data = nil
			NewTable.BoothTimeData = nil
			SetValue(NewTable)
		end)

		Trove:Connect(StoryService.BoothWaiting, function(Data: StoryService.BoothData)
			local NewTable = table.clone(Value)
			NewTable.Enabled = true
			NewTable.Data = Data
			NewTable.BoothTimeData = nil
			SetValue(NewTable)
		end)

		Trove:Connect(StoryService.PlayerChanged, function(PlayerId: number, Added: boolean, Changed: boolean)
			if Changed and Value.Data and StoryService.Data then
				local NewTable = table.clone(Value)
				NewTable.Data = table.clone(StoryService.Data) :: any
				SetValue(NewTable)
			end
		end)

		Trove:Connect(StoryService.MapDataChanged, function(Data)
			local NewTable = table.clone(Value)
			NewTable.CompletedMaps = Data
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
