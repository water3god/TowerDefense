--!strict

--- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Modules = ReplicatedStorage.Modules;
local ReactLua = Modules.ReactLua;
local React = require(ReactLua.React);
local e = React.createElement;

local Join = require(Modules.JoinDicts);

export type Properties = {
	Position: UDim2?;
	Size: UDim2?;
	OnClick: (rbx: ImageButton) -> ()?;
	
	native: {[any]: any}?;
	children: {[any]: any}?;
};

return function(Properties: Properties)
	return e("ImageButton", Join({
		BackgroundTransparency = 1;
		AnchorPoint = Vector2.new(0.5, 0.5);
		Position = Properties.Position;
		Size = Properties.Size;
		Image = "rbxassetid://101118925074854";
		[React.Tag] = "GuiAnimateBasic" :: any;
		[React.Event.MouseButton1Click] = Properties.OnClick,
	}, Properties.native), {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1;
		})
	}, Properties.children);
end