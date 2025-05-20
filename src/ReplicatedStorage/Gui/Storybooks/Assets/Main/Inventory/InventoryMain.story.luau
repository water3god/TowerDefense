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
local Inventory = Gui.Inventory
local InventoryMain = require(Inventory.InventoryMain)

local InventoryContext = require(Inventory.InventoryContext)

-- Controls --

local controls = {}

-- Story --

local Sample = {
	Units = {
		Hello = {
			Level = 1,
			UniqueId = "Hello",
			NeededXP = 10,
			XP = 5,
			Unit = "Minigunner",
		},
	},
	Products = {},
	Resources = {},
}

local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	--controls = controls,
	story = function(Properties)
		local Frame = e(InventoryContext.Context.Provider, {
			value = Sample,
		}, {
			InventoryMain = e(InventoryMain),
		})
		return Frame
	end,
}

return Story
