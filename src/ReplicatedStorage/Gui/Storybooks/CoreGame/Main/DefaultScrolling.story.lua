--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage");

-- Libraries --

local Packages = ReplicatedStorage.Packages;
local React = require(Packages.React);
local ReactRoblox = require(Packages.ReactRoblox);
local e = React.createElement;

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
		local Frame = e(DefaultScrolling, {
			BarSize = Properties.controls.BarSize;
			native = {
				BackgroundTransparency = 1;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Size = UDim2.fromScale(1, 1);
				Position = UDim2.fromScale(0.5, 0.5);
			}
		})
		return Frame;
	end
};

return Story;