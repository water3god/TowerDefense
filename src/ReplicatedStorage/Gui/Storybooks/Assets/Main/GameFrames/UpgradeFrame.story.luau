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
local GameFrames = Gui.GameFrames
local UpgradeFrame = require(GameFrames.UpgradeFrame)
local UpgradeContext = require(GameFrames.UpgradeContext)

-- Controls --
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	--controls = controls,
	story = function(Properties)
		local Component = e(UpgradeContext.Context.Provider, {
			value = {
				UnitName = "Trajan",
				UpgradeData = {
					[0] = {
						Cost = 10,
						Damage = { 1 },
						FireRate = 1,
						Range = 10,
					},
					[1] = {
						Cost = 100,
						Damage = { 2 },
						FireRate = 0.5,
						Range = 20,
					},
				},
				Properties = {
					Damage = 1,
					FireRate = 1,
					Range = 10,
				},
				NextProperties = {
					Damage = 1,
					FireRate = 1,
					Range = 10,
				},
				Trait = "Damage I",
				Priority = "First",
				Level = 0,
				TotalCost = 10,
				Enabled = true,
				Abilities = {
					{
						MinimumLevel = 0,
						LastUsed = 0,
						Name = "Rage",
						Icon = "",
						Length = 10,
						Cooldown = 30,
						BackgroundColor = ColorSequence.new(Color3.new()),
						Func = function() end,
					},
				},
			},
		}, {
			UpgradeFrame = e(UpgradeFrame, {
				IsVisible = true,
			}),
		})
		return Component
	end,
}

return Story
