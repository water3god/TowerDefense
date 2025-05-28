--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local SettingsService = require(GlobalClient.SettingsService)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Hooks = require(CoreGame.Hooks)

local Shared = ReplicatedStorage.Shared
local SettingsData = require(Shared.Settings)

local SettingsContext = React.createContext(SettingsData.PreSync)

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function SettingsProvider(props: Properties)
	local Settings, SetSettings = React.useState(SettingsData.PreSync)

	React.useEffect(function()
		if SettingsService.IsSynced then
			SetSettings(table.clone(SettingsService.GetPlayerSettings()))
		end
	end, {})

	Hooks.useEventConnection(SettingsService.Synced, function()
		SetSettings(table.clone(SettingsService.GetPlayerSettings()))
	end, {})

	Hooks.useEventConnection(SettingsService.SettingChanged, function(Setting: string, Value: any)
		SetSettings(table.clone(SettingsService.GetPlayerSettings()))
	end, { Settings })

	return e(SettingsContext.Provider, {
		value = Settings,
	}, props.children)
end

return {
	Context = SettingsContext,
	Provider = SettingsProvider,
}
