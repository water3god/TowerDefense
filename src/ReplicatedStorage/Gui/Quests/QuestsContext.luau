--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local React = require(Packages.React)
local e = React.createElement

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Hooks = require(CoreGame.Hooks)

local Client = ReplicatedStorage.Client
local LobbyClient = Client.LobbyClient
local QuestsService = require(LobbyClient.QuestsService)

local Shared = ReplicatedStorage.Shared
local QuestsInfo = require(Shared.Quests)

local Default: {
	Loading: boolean,
	Data: QuestsInfo.Quests,
} = {
	Loading = true,
	Data = {
		DailyQuests = {},
		WeeklyQuests = {},
		EventQuests = {},
		GlobalQuests = {},
		MetaData = {
			DailyRegenerated = 0,
			WeeklyRegenerated = 0,
			CurrentEvent = "",
		},
	},
}

local QuestsContext = React.createContext(Default)

local function QuestsProvider(props)
	local QuestsData, SetQuestsData = React.useState(Default)

	React.useEffect(function()
		Promise.new(function(resolve)
			if not QuestsService.IsSynced then
				QuestsService.Synced:Wait()
			end
			resolve(QuestsService.Data)
		end):andThen(function(Data)
			if Data then
				SetQuestsData({
					Loading = false,
					Data = Data,
				})
			end
		end)
	end, {})

	Hooks.useEventConnection(QuestsService.QuestChanged, function()
		if QuestsService.Data then
			SetQuestsData({
				Loading = false,
				Data = table.clone(QuestsService.Data),
			})
		end
	end, {})

	return e(QuestsContext.Provider, {
		value = QuestsData,
	}, props.children)
end

return {
	Context = QuestsContext,
	Provider = QuestsProvider,
}
