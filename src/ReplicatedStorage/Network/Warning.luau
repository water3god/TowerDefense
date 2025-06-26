--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Red = require(Packages.Red)
local Signal = require(Packages.Signal)
local Guard = require(Packages.Guard)

return {
	FromServer = {
		SendWarning = Red.Event("SendWarning", function(Message, Color)
			return Guard.String(Message), Guard.Optional(Guard.Color3)(Color)
		end),
	},
	ClientOnly = {
		WarningBindable = Signal.new() :: Signal.Signal<string, Color3?>,
	},
}
