--!strict

--- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Main = require(ReplicatedStorage.Gui.CoreGame.Main)

export type Properties = {
	Position: UDim2?,
	Size: UDim2?,
	OnClick: (rbx: ImageButton) -> ()?,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

return function(Properties: Properties)
	return e(Main.Animateables.ImageButton, {
		native = {
			Position = Properties.Position,
			Size = Properties.Size,
			Image = "rbxassetid://101118925074854",
			[React.Event.MouseButton1Click] = Properties.OnClick,
		},
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}),
	}, Properties.children)
end
