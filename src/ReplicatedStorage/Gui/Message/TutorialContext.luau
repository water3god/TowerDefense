--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local WaveService = require(GlobalClient.WaveService)

local Shared = ReplicatedStorage.Shared
local IsTutorial = require(Shared.IsTutorial)

local TutorialContext = React.createContext("")

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function TutorialProvider(props)
	local CurrentState, SetCurrentState = React.useState("")

	React.useEffect(function() end, {})

	return e(TutorialContext.Provider, {
		value = CurrentState,
	}, props.children)
end

return {
	Context = TutorialContext,
	Provider = TutorialProvider,
}
