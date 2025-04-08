--!strict

-- By Wa1er_God --

local DefaultFont = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);
local JoinDicts = require(Modules.JoinDicts);

local ReactLua = Modules.ReactLua;
local React = require(ReactLua.React);
local e = React.createElement;

local DefaultGui = {};

function DefaultGui.Frame(Properties)
	return e("Frame", JoinDicts({
		BackgroundTransparency = 1;
		AnchorPoint = Vector2.new(0.5, 0.5);
	}, Properties.native));
end

return DefaultGui;