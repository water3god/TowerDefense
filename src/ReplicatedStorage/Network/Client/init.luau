--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

if RunService:IsServer() then
	error("This module should not be required on the server.")
end

local HelperFunctions = require(ReplicatedStorage.Modules.HelperFunctions)

local Client1 = require(ReplicatedStorage.Network.Client.Client1)
local Client2 = require(ReplicatedStorage.Network.Client.Client2)
local Client3 = require(ReplicatedStorage.Network.Client.Client3)

return HelperFunctions.joinDicts(Client1, Client2, Client3) :: typeof(Client1) & typeof(Client2) & typeof(Client3)
