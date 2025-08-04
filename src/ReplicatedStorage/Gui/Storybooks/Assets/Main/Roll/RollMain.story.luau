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
local Roll = Gui.Roll
local RollMain = require(Roll.RollMain)
local RollContext = require(Roll.RollContext)

local PurchaseContext = require(ReplicatedStorage.Gui.Store.PurchaseContext)

-- Controls --
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	--controls = controls,
	story = function(Properties)
		local RollFrame = e(PurchaseContext.Provider, {}, {
			RollProvider = e(RollContext.Context.Provider, {
				value = {
					Units = { "Augustus", "Trajan", "Julius Caesar" },
					TimeStart = workspace:GetServerTimeNow(),
					TotalTime = workspace:GetServerTimeNow() + 30,
				},
			}, {
				RollMain = e(RollMain, {
					CloseClick = function() end,
					SetVisible = function() end,
				}),
			}),
		})

		return RollFrame
	end,
}

return Story
