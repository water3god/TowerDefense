--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Player = Players.LocalPlayer

local IsRunning = RunService:IsRunning()

local function NewGui(props: { DisplayOrder: number?, children: { any: any }? })
	if IsRunning then
		return ReactRoblox.createPortal(
			e("ScreenGui", {
				ResetOnSpawn = false,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = props.DisplayOrder,
			}, props.children),
			Player.PlayerGui
		)
	else
		return e(React.Fragment, nil, props.children)
	end
end

return NewGui
