--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if game:GetService("RunService"):IsServer() then
	error("This module should only be required on the client side.")
end

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local ClientOnly = {
	Loaded = Signal.new(),

	Warning = Signal.new() :: Signal.Signal<string, Color3?>,
	TPGuiSet = Signal.new() :: Signal.Signal<{ MapName: string, ImageId: string }>,
	PlacementFinished = Signal.new() :: Signal.Signal<>,
	ChangeWalk = Signal.new() :: Signal.Signal<boolean>,
	FreecamToggled = Signal.new() :: Signal.Signal<boolean>,
	EvolutionTouched = Signal.new(),
	TraitsTouched = Signal.new(),
	DailysTouched = Signal.new(),

	NewNPCTalk = Signal.new(),
}

return ClientOnly
