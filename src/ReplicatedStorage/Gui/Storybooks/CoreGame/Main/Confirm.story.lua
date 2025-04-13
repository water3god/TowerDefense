--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage");

-- Libraries --

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React);
local ReactRoblox = require(Packages.ReactRoblox);
local e = React.createElement;

-- Reference UI --

local Gui = ReplicatedStorage.Gui;
local Confirm = require(Gui.CoreGame.Confirm);

-- Controls --

local controls = {
	Title = "Title";
    Description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer tempus gravida tellus, sit amet iaculis tellus blandit ut. Nullam auctor risus quis libero mattis convallis.";
	Enabled = true;
};

-- Story --

local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		return e(Confirm, {
			Title = Properties.controls.Title;
			Description = Properties.controls.Description;
			Handler = function()
				
			end,
			Enabled = Properties.controls.Enabled;
			native = {
				Position = UDim2.fromScale(0.5, 0.5);
				Size = UDim2.fromScale(0.8, 0.8);
			};
		});
	end
}

return Story;