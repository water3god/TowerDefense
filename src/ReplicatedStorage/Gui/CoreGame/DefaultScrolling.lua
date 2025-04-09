--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local ReactLua = ReplicatedStorage.Modules.ReactLua;
local React = require(ReactLua.React);
local e = React.createElement;

local Modules = ReplicatedStorage.Modules;
local Join = require(Modules.JoinDicts);

export type Properties = {
	BarSize: number?;
	
	native: {[any]: any}?;
	children: {[any]: any}?;
};

local function GetScrollingSize(Size: number, selfRef: any)
	return Size * selfRef.current.AbsoluteSize.X;
end

local function CreateDefaultScrolling(Properties: Properties)
	local BarSize = Properties.BarSize or 0.1;
	local selfRef = React.useRef(nil);
	local Bar, SetBar = React.useState(0.1);
	
	React.useEffect(function()
		SetBar(GetScrollingSize(BarSize, selfRef));
	end, {Properties.BarSize})
	
	return e("ScrollingFrame", Join({
		ref = selfRef;
		
		ScrollBarThickness = Bar;
		[React.Change.Size] = function()
			SetBar(GetScrollingSize(BarSize, selfRef)); 
		end,
	}, Properties.native
	), Properties.children
	);
end

return CreateDefaultScrolling;