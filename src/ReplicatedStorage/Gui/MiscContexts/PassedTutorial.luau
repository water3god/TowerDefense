--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Network = require(ReplicatedStorage.Network.Client)
local TutorialSent = Network.TutorialSent

local CoreGame = ReplicatedStorage.Gui.CoreGame
local Hooks = require(CoreGame.Hooks)
local PassedContext = React.createContext(true)

local function PassedProvider(props)
	local IsPassed, SetIsPassed = React.useState(true)

	Hooks.useZapConnection(TutorialSent, function()
		SetIsPassed(false)
	end, {})

	return e(PassedContext.Provider, {
		value = IsPassed,
	}, props.children)
end

return {
	Context = PassedContext,
	Provider = PassedProvider,
}
