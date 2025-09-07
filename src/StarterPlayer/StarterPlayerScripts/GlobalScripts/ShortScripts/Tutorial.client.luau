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
local Indicator = require(Gui.Message.Indicator)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)

local Root = ReactRoblox.createRoot(Instance.new("Folder"))

if not next(UnitClient.GetUnits()) then
	UnitClient.NewUnit:Wait()
end

local _, Unit = next(UnitClient.GetUnits())

Root:render(ReactRoblox.createPortal(
	e("BillboardGui", {
		Adornee = Unit,
		Size = UDim2.fromScale(1, 1),
	}, {
		Indicator = e(Indicator, {
			Wave = 2,
		}),
	}),
	Unit.Root
))
