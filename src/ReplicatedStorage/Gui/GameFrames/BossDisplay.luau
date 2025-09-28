--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)

export type DisplayProps = {
	Name: string,
	Health: number,
	MaxHealth: number,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateDisplay(props: DisplayProps)
	return e(Main.ImageLabel, {
		native = Join({
			Image = "rbxassetid://130859913415626",
		}, props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 7.8,
		}),
		Border = e(Main.ImageLabel, {
			Image = "rbxassetid://117640397950526",
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 7,
			}),
		}),
	}, props.children)
end

local function CreateBossDisplay(props: Properties)
	return e(Main.Frame, {
		native = Join({}, props.native),
	}, {}, props.children)
end

local function Connected(props) end

return CreateBossDisplay
