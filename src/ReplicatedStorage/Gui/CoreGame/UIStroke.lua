--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Modules = ReplicatedStorage.Modules;
local ReactLua = Modules.ReactLua;
local React = require(ReactLua.React);

local Join = require(Modules.JoinDicts);

local CurrentCamera = workspace.CurrentCamera;

export type PropertiesBasic = {
	Stroke: number;
	Color: Color3?;
	StrokeMode: Enum.ApplyStrokeMode?;
	Transparency: number?;
	
	native: {[any]: any}?;
	children: {[any]: any}?;
};

export type PropertiesNormal = PropertiesBasic & {GradColor: ColorSequence?};

local function CreateUIGrad(Properties: {Color: ColorSequence?})
	return React.createElement("UIGradient", {
		Color = Properties.Color;
	});
end

local Funcs = {};

function Funcs.UIStrokeBasic(Properties: PropertiesBasic)
	local StrokeRef = React.useRef(nil :: UIStroke?);
	local StrokeValue = Properties.Stroke;
	
	React.useEffect(function()
		if StrokeRef.current then
			StrokeRef.current:SetAttribute("StrokeValue", Properties.Stroke);
		end
	end, {Properties.Stroke})
	
	return React.createElement("UIStroke",
		Join({
			Color = Properties.Color;
			LineJoinMode = Enum.LineJoinMode.Miter;
			ApplyStrokeMode = Properties.StrokeMode or Enum.ApplyStrokeMode.Contextual;
			Transparency = Properties.Transparency or 0;
			[React.Tag] = "StrokeScale";
			ref = StrokeRef;
		},
		Properties.native
	), Properties.children)
end

function Funcs.UIStroke(Properties: PropertiesNormal)
	return React.createElement(Funcs.UIStrokeBasic, Properties, {
		children = {
			React.createElement(CreateUIGrad, {
			Color = Properties.GradColor;
			});
		}
	});
end

return Funcs;