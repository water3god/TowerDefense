--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if game:GetService("RunService"):IsClient() then
	error("This module should only be required on the server side.")
end

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local ServerOnly = {
	StartGame = Signal.new() :: Signal.Signal<>,
	BoothLoaded = Signal.new() :: Signal.Signal<string>,
}

return ServerOnly
