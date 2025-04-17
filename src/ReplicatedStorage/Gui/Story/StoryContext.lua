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

local Context = React.createContext({
	Enabled = false,
} :: {
	Enabled: boolean,
	Data: StoryService.BoothData?,
})

local function Provider(props)
	local Value, SetValue = React.useState({
		Enabled = false,
		Data = nil,
	})

	React.useEffect(function()
		local Connection = StoryService.BoothChoosing:Connect(function()
			SetValue({
				Enabled = true,
			})
		end)

		local Connection1 = StoryService.BoothRestarted:Connect(function()
			SetValue({
				Enabled = false,
			})
		end)

		local Connection2 = StoryService.BoothWaiting:Connect(function(Data: StoryService.BoothData)
			SetValue({
				Enabled = true,
				Data = Data :: any,
			})
		end)

		local connection3 = StoryService

		return function()
			Connection:Disconnect()
			Connection1:Disconnect()
			Connection2:Disconnect()
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
