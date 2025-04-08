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
local BaseFrame =require(Gui.CoreGame.BaseFrame);

-- Controls --

local controls = {
	Name = "Goku";
	LeftText = "1";
	RightText = "$200";
	
	BackgroundColor = ColorSequence.new(Color3.new(0.736767, 0.275364, 1));
	NameColor = ColorSequence.new(Color3.new(1, 1, 1));
	LeftColor = ColorSequence.new(Color3.new(1, 1, 1));
	RightColor = ColorSequence.new(Color3.new(1, 1, 1));
};

-- Story --

local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(Properties)
		local Frame = React.createElement(BaseFrame, {
			Name = Properties.controls.Name;
			LeftText = Properties.controls.LeftText;
			RightText = Properties.controls.RightText;
			
			BackgroundColor = Properties.controls.BackgroundColor;
			NameColor = Properties.controls.NameColor;
			LeftColor = Properties.controls.LeftColor;
			RightColor = Properties.controls.RightColor;
		})
		return Frame;
	end
}

return Story;