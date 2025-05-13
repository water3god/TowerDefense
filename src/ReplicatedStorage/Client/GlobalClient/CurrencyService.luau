--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Remotes = ReplicatedStorage.Remotes
local Core = Remotes.Core
local CurrencyChanged = Core.CurrencyChanged

local Module = {
	Value = 0,
	CurrencyChanged = Signal.new(),
}

CurrencyChanged.OnClientEvent:Connect(function(Value: number)
	Module.Value = Value
	Module.CurrencyChanged:Fire(Value)
end)

return Module
