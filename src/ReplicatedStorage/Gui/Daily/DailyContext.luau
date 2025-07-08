--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Hooks = require(CoreGame.Hooks)

local Client = ReplicatedStorage.Client
local LobbyClient = Client.LobbyClient
local DailyService = require(LobbyClient.DailyService)

local Default = {
	Day = 1,
	LastRedeemed = workspace:GetServerTimeNow(),
	Redeem = function() end,
}

local DailyContext = React.createContext(Default)

local function DailyProvider(props)
	local DailyValue, SetValue = React.useState(Default)

	local function Update()
		SetValue({
			Day = DailyService.Day,
			LastRedeemed = DailyService.LastRedeemed,
			Redeem = DailyService.RedeemDaily,
		})
	end

	React.useEffect(function()
		if DailyService.IsSynced then
			Update()
		end
	end, {})

	Hooks.useEventConnection(DailyService.Synced, Update, {})
	Hooks.useEventConnection(DailyService.Redeemed, Update, {})

	return e(DailyContext.Provider, {
		value = DailyValue,
	}, props.children)
end

return {
	Context = DailyContext,
	Provider = DailyProvider,
}
