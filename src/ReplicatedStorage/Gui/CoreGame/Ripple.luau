--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local Hooks = require(CoreGame.Hooks)

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local Ripple = {}

function Ripple.useMotion<T>(initalValue: T)
	local Binding, SetValue = React.useBinding(initalValue)

	return Binding, SetValue
end

return Ripple
