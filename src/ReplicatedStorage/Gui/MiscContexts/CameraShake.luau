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

local Camera = workspace.CurrentCamera

local CameraShake = CameraShakeModule.new(Enum.RenderPriority.Camera.Value + 1, function(ShakeCF: CFrame)
	Camera.CFrame *= ShakeCF
end)

type CameraShakeContext = {
	CameraShake: typeof(CameraShake),

	Shake: () -> (),
}

CameraShake:Start()

local Context = React.createContext({
	CameraShake = CameraShake,
	Shake = function()
		CameraShake:ShakeOnce(2, 20, 0, 0.4, Vector3.new(0.3, 0.3, 0.3), Vector3.new(2, 1, 1))
	end,
})

return {
	Context = Context,
}
