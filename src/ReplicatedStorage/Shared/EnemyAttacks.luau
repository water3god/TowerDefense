--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)

local Shared = ReplicatedStorage.Shared
local Types = require(Shared.Types)

export type EnemyAttack = {
	Funcs: {
		[string]: (Enemy: Types.EnemyClient, Ratio: number, Delay: number) -> (),
	},
}

local EnemyAttacks: {
	[string]: EnemyAttack,
} = {}

return EnemyAttacks
