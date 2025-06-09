--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local JoinDicts = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)

local function CreateBaseButton(Properties: {
	Text: string,
	OnClick: () -> (),
	Highlighted: boolean,
	native: { [any]: any }?,
})
	local Image = React.useMemo(function()
		if Properties.Highlighted then
			return "rbxassetid://140162476120723"
		else
			return "rbxassetid://90225038866735"
		end
	end, { Properties.Highlighted })

	return React.createElement(Main.Animateables.ImageButton, {
		native = JoinDicts({
			Size = UDim2.fromScale(0.125, 0.09),
			Image = Image,
			[React.Event.MouseButton1Click] = Properties.OnClick,
		}, Properties.native),
	}, {
		TextLabel = React.createElement(Main.TextLabel, {
			native = {
				Text = Properties.Text,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.9, 0.6),
			},
		}),
	})
end

return CreateBaseButton
