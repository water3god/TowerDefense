--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local CameraShakeModule = require(Modules.CameraShaker)
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateCameraShake(props: Properties)
	return e(Main.Frame, {
		native = Join({}, props.native),
	}, {}, props.children)
end

return CreateCameraShake
