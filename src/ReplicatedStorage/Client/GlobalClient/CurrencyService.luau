--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Network = require(ReplicatedStorage.Network.Client)
local CurrencyChanged = Network.CurrencyChanged

local Module = {
	Value = 0,
	CurrencyChanged = Signal.new(),
}

CurrencyChanged.SetCallback(function(Value: number)
	Module.Value = Value
	Module.CurrencyChanged:Fire(Value)
end)

return Module
