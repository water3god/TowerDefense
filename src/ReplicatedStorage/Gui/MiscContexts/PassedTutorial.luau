--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)
local React = require(Packages.React)
local e = React.createElement

local NetworkFolder = ReplicatedStorage.Network
local Network = require(NetworkFolder.Client)
local ClientOnly = require(NetworkFolder.ClientOnly)
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

local TutorialSentSig = Signal.new() :: Signal.Signal<boolean>

TutorialSent.SetCallback(function(Passed: boolean)
	TutorialSentSig:Fire(Passed)
end)

local function PassedProvider(props)
	local IsPassed, SetIsPassed = React.useState(true)
	local PassedGameTutorial, SetPassedGameTutorial = React.useState(false)
	local Status, SetStatus = React.useState("")

	Hooks.useEventConnection(TutorialSentSig, function(Passed: boolean)
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
