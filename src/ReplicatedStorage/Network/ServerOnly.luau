--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if game:GetService("RunService"):IsClient() then
	error("This module should only be required on the server side.")
end

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

export type EnemyData = {
	Enemy: string,
	Position: number,
	Summoned: boolean?,
}

local ServerOnly = {
	PlayerLoaded = Signal.new(),
	PlayerRolled = Signal.new() :: Signal.Signal<Player, string>,

	StartGame = Signal.new() :: Signal.Signal<>,

	AddEnemy = Signal.new() :: Signal.Signal<{
		Enemy: string,
		Position: number,
		Summoned: boolean?,
	}>,
}

return ServerOnly
