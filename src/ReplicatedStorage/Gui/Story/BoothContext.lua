--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Hooks = require(CoreGame.Hooks)

local Booth = require(ServerScriptService.LobbyModules.Booth)

export type Properties = {
	children: { [any]: any }?,
}

export type BoothData = {
	MapId: string,
	LevelId: string,
	Difficulty: string,
	PlayerCount: number,
	MaxPlayerCount: number,
	StartTime: number,
	EndTime: number,
	Enabled: boolean,
}

local Context = React.createContext({
	MapId = "BattleOfHastings",
	LevelId = "Hastingsv1",
	Difficulty = "Normal",
	PlayerCount = 1,
	MaxPlayerCount = 2,
	StartTime = 1,
	EndTime = 1,
	Enabled = false,
} :: BoothData)

local function Provider(props: Properties)
	local Value, SetValue = React.useState({})

	return e(Context.Provider, {
		value = Value,
	}, props.children)
end

return {
	Context = Context,
	Provider = Provider,
}
