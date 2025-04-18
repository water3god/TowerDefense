--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

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
		local Connection = StoryService.BoothChoosing:Connect(function(Data)
			local NewTable = table.clone(Value)
			NewTable.Enabled = true
			NewTable.BoothTimeData = Data
			SetValue(NewTable)
		end)

		local Connection1 = StoryService.BoothRestarted:Connect(function()
			local NewTable = table.clone(Value)
			NewTable.Enabled = false
			NewTable.Data = nil
			NewTable.BoothTimeData = nil
			SetValue(NewTable)
		end)

		local Connection2 = StoryService.BoothWaiting:Connect(function(Data: StoryService.BoothData)
			local NewTable = table.clone(Value)
			NewTable.Enabled = true
			NewTable.Data = Data
			NewTable.BoothTimeData = nil
			SetValue(NewTable)
		end)

		local Connection3 = StoryService.PlayerChanged:Connect(
			function(PlayerId: number, Added: boolean, Changed: boolean)
				if Changed and Value.Data and StoryService.Data then
					local NewTable = table.clone(Value)
					NewTable.Data = table.clone(StoryService.Data) :: any
					SetValue(NewTable)
				end
			end
		)

		local Connection4 = StoryService.MapDataChanged:Connect(function(Data)
			local NewTable = table.clone(Value)
			NewTable.CompletedMaps = Data
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
