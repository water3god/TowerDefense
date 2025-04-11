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
local Inventory = Gui.Inventory;
local UnitFrame = require(Inventory.UnitFrame);

-- Controls --

local controls = {
	UnitName = "Goku";
	Level = 5;
	Cost = 500;
};

-- Story --

local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Frame = e(UnitFrame, {
			UnitName = Properties.controls.UnitName;
			Level = Properties.controls.Level;
			Cost = Properties.controls.Cost;

			BackgroundColor = ColorSequence.new(Color3.new(1, 0.588647, 0.288457))
		});
		return Frame;
	end
}

return Story;