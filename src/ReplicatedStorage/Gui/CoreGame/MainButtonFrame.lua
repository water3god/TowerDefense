--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local Join = require(Modules.JoinDicts)

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local BaseFrame = require(CoreGame.BaseFrame)

export type Properties = {
	Name: string,
	Icon: string,
	OnClick: (...any) -> ...any,

	native: { [any]: any }?,
	children: { [any]: any }?,

	Position: UDim2?,
	Size: UDim2?,
}

local function CreateButtonFrame(Properties: Properties)
	return e(BaseFrame, {
		Name = Properties.Name,
		LeftText = "",
		RightText = "",
		Image = Properties.Icon,

		BackgroundColor = ColorSequence.new(
			Color3.new(0.258824, 0.043137, 0.384314),
			Color3.new(0.564706, 0.113725, 0.827451)
		),
		OnClick = Properties.OnClick,

		Position = Properties.Position,
		Size = Properties.Size,

		native = Properties.native,
	}, Properties.children)
end

return CreateButtonFrame
