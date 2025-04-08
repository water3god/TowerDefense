--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage");

-- Libraries --

local ReactLua = ReplicatedStorage.Modules.ReactLua;
local React = require(ReactLua.React);
local ReactRoblox = require(ReactLua.ReactRoblox);

-- Reference UI --

local Gui = ReplicatedStorage.Gui;
local Inventory = Gui.Inventory;
local StatsFrame = require(Inventory.StatsFrame);

-- Controls --

local controls = {

};

-- Story --

local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Frame = React.createElement(StatsFrame, {

		});
		return Frame;
	end
}

return Story;