--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Network = require(ReplicatedStorage.Network.Client)
local NewBanner = Network.NewBanner

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Hooks = require(CoreGame.Hooks)

export type RollData = {
	Units: { [number]: string },
	TimeStart: number,
	TotalTime: number,
}

local Default: RollData = {
	Units = { "Richard the Lionheart", "Leonidas", "Trajan" },
	TimeStart = 0,
	TotalTime = 30,
}

local RollContext = React.createContext(Default)

local function RollProvider(props)
	local State: RollData, SetState = React.useState(Default)

	Hooks.useZapConnection(NewBanner, function(data)
		SetState({
			Units = data.Units,
			TimeStart = workspace:GetServerTimeNow(),
			TotalTime = data.TimeEnd - workspace:GetServerTimeNow(),
		})
	end, {})

	return e(RollContext.Provider, {
		value = State,
	}, props.children)
end

return {
	Context = RollContext,
	Provider = RollProvider,
}
