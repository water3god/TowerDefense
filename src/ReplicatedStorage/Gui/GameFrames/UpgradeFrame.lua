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
		}, Properties.native),
	}, {}, Properties.children)
end

return CreateUpgradeFrame
