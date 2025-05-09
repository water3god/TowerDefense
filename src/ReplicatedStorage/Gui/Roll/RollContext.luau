--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)

export type RollData = {
	Units: { [number]: string },
	TimeStart: number,
	TotalTime: number,
}

local Default: RollData = {
	Units = {},
	TimeStart = 0,
	TotalTime = 30,
}

local RollContext = React.createContext(Default)

local function RollProvider(props)
	local State: RollData, SetState = React.useState(Default)

	return e(RollContext.Provider, {
		value = State,
	}, props.children)
end

return {
	Context = RollContext,
	Provider = RollProvider,
}
