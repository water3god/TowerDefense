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

local TutorialContext = React.createContext("")

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function TutorialProvider(props)
	return e(TutorialContext.Provider, {
		value = {},
	}, props.children)
end

return {
	Context = TutorialContext,
	Provider = TutorialProvider,
}
