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
local PassedContext = React.createContext({
	IsPassed = true,
	PassedGameTutorial = false,
	Status = "",
} :: {
	IsPassed: boolean,
	PassedGameTutorial: boolean,
	Status: string,
})

local function PassedProvider(props)
	local IsPassed, SetIsPassed = React.useState(true)
	local PassedGameTutorial, SetPassedGameTutorial = React.useState(false)
	local Status, SetStatus = React.useState("")

	Hooks.useZapConnection(TutorialSent, function(Passed: boolean)
		SetIsPassed(false)
		SetPassedGameTutorial(Passed)

		print(Passed)

		if Passed then
			SetStatus("Active")
		end
	end, {})

	return e(PassedContext.Provider, {
		value = {
			IsPassed = IsPassed,
			PassedGameTutorial = PassedGameTutorial,
			Status = Status,
			SetStatus = SetStatus,
		},
	}, props.children)
end

return {
	Context = PassedContext,
	Provider = PassedProvider,
}
