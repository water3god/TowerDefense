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
local MessageFolder = Gui.Message
local Message = require(MessageFolder.Message)

-- Controls --
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function()
		local Frame = e(Message, {
			Messages = {
				"Welcome to Tower Defense! This is a demo storybook message. You can change the text and speaker name in the storybook file. Enjoy your stay! Feel free to explore the game and have fun defending your towers against waves of enemies. Good luck, and may your strategies lead you to victory!",
				"Remember to upgrade your towers and use your resources wisely. Each wave will get tougher, so prepare accordingly!",
				"Don't forget to communicate with your teammates. Teamwork is key to success in Tower Defense!",
			},
			SpeakerName = "Wa1er_God",
		})
		return Frame
	end,
}

return Story
