--!strict

-- By Wa1er_God --

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local NewGui = require(CoreGame.NewGui)
local Hooks = require(CoreGame.Hooks)
local Indicator = require(Gui.Message.Indicator)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)

local IsTutorial = require(ReplicatedStorage.Shared.IsTutorial)

if not IsTutorial then
	return
end

local Root = ReactRoblox.createRoot(Instance.new("Folder"))

if not next(UnitClient.GetUnits()) then
	UnitClient.NewUnit:Wait()
end

local _, Unit = next(UnitClient.GetUnits())

local function Render()
	local Position, SetPosition = React.useBinding(Vector3.zero)
	local OnScreen, SetOnScreen = React.useBinding(false)

	Hooks.useEventConnection(RunService.PostSimulation, function()
		local Pos, OnScr = workspace.CurrentCamera:WorldToScreenPoint(Unit.Root.Position)

		if Pos then
			SetPosition(Pos)
			SetOnScreen(OnScr)
		else
			SetOnScreen(false)
		end
	end, {})

	return e(Main.Frame, {
		native = {
			Position = Position:map(function(pos: Vector3)
				return UDim2.fromOffset(pos.X, pos.Y)
			end),
			Size = UDim2.fromScale(0.1, 0.1),
			Visible = OnScreen,
		},
	}, {
		Indicator = e(Indicator, {
			Wave = 2,
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
	})
end

Root:render(ReactRoblox.createPortal(
	e(NewGui, {}, {
		Indicator = e(Render),
	}),
	PlayerGui
))
