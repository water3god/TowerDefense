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
local DefaultScrolling = require(Gui.CoreGame.DefaultScrolling);

-- Controls --

local Controls = {
	BarSize = 0.2;
};

local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = Controls,
	story = function(Properties)
		local Frame = React.createElement(DefaultScrolling, {
			BarSize = Properties.controls.BarSize;
			Size = UDim2.fromScale(1, 1);
			Position = UDim2.fromScale(0.5, 0.5);
		})
		return Frame;
	end
};

return Story;