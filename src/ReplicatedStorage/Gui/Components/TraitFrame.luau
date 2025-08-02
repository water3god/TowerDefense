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
local AnimatedGradient = require(CoreGame.AnimatedGradient)

local Shared = ReplicatedStorage.Shared
local Traits = require(Shared.Traits)
local RarityInfo = require(Shared.RarityInfo)

export type Properties = {
	Trait: string?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateTraitFrame(props: Properties)
	local TraitData = React.useMemo(function(): Traits.TraitData?
		if props.Trait then
			return Traits.Traits[props.Trait]
		end
		return nil
	end, { props.Trait })

	local RarityData = React.useMemo(function(): RarityInfo.RarityInfo?
		if TraitData then
			return RarityInfo[TraitData.Rarity :: RarityInfo.Rarity]
		end
		return nil
	end, { TraitData })

	return e(Main.ImageLabel, {
		native = Join({
			Image = TraitData and TraitData.Icon or "",
		}, props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}),
		UIGradient = e(AnimatedGradient, {
			GradColor = RarityData and RarityData.Color or ColorSequence.new(Color3.fromRGB(255, 255, 255)),
			Animate = true,
		}),
	}, props.children)
end

return CreateTraitFrame
