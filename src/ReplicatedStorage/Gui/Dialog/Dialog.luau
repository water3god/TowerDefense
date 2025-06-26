--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local CloseButton = require(CoreGame.CloseButton)
local Title = require(CoreGame.Title)

local function CreateDialogFrame(props) end

local function CreateDialogFrameConnected(props) end

return {
	Create = CreateDialogFrame,
	Connected = CreateDialogFrameConnected,
}
