--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local CloseButton = require(CoreGame.CloseButton)

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)
local InventoryService = require(GlobalClient.InventoryService)
local WaveService = require(GlobalClient.WaveService)

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateUpgradeFrame(Properties: Properties)
	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.8, 0.8),
			Image = "rbxassetid://103903141717286",
		}, Properties.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.8,
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.2, 0.25),
		}),
		UnitName = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.2),
				Size = UDim2.fromScale(0.5, 0.15),
				Text = "Minigunner",
			},
		}),
		CurrentData = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.164706, 0.031373, 0.274510),
				Position = UDim2.fromScale(0.25, 0.6),
				Size = UDim2.fromScale(0.4, 0.6),
			},
		}, {
			UnitInfo = e(Main.ScrollingFrame, {
				BarSize = 0.002,
			}),
		}),
		NextData = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.164706, 0.031373, 0.274510),
				Position = UDim2.fromScale(0.75, 0.6),
				Size = UDim2.fromScale(0.4, 0.6),
			},
		}, {
			UnitInfo = e(Main.ScrollingFrame, {
				BarSize = 0.002,
			}),
		}),
	}, Properties.children)
end

return CreateUpgradeFrame
