--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HelperFunctions = require(ReplicatedStorage.Modules.HelperFunctions)

local Server1 = require(ReplicatedStorage.Network.Server.Server1)
local Server2 = require(ReplicatedStorage.Network.Server.Server2)
local Server3 = require(ReplicatedStorage.Network.Server.Server3)

return HelperFunctions.joinDicts(Server1, Server2, Server3) :: typeof(Server1) & typeof(Server2) & typeof(Server3)
