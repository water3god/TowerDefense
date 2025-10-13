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

local Shared = ReplicatedStorage.Shared
local RarityInfo = require(Shared.RarityInfo)

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local Chances = {
	Common = 61.88,
	Rare = 30.94,
	Epic = 6.19,
	Legendary = 0.62,
	Mythic = 0.30,
	Godly = 0.06,
}

local Order = {
	"Common",
	"Rare",
	"Epic",
	"Legendary",
	"Mythic",
	"Godly",
}

local function CreateChances(props: Properties)
	local ChanceFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for Rarity: string, Chance: number in pairs(Chances) do
			local RarityData = RarityInfo[Rarity :: RarityInfo.Rarity]
			Frames[Rarity] = e(Main.Frame, {
				native = {
					Size = UDim2.fromScale(0.9, 0.15),
					LayoutOrder = table.find(Order, Rarity),
				},
			}, {
				RarityLabel = e(Main.TextLabel, {
					native = {
						Size = UDim2.fromScale(0.6, 0.5),
						Position = UDim2.fromScale(0.3, 0.5),
						Text = Rarity,
						TextXAlignment = Enum.TextXAlignment.Left,
					},
				}, {
					UIGradient = e("UIGradient", {
						Color = RarityData.Color,
					}),
				}, {
					UIStroke = e("UIStroke", {
						Thickness = 2,
					}),
				}),
				ChanceLabel = e(Main.TextLabel, {
					native = {
						Size = UDim2.fromScale(0.4, 0.5),
						Position = UDim2.fromScale(0.75, 0.5),
						Text = tostring(Chance) .. "%",
						TextXAlignment = Enum.TextXAlignment.Right,
					},
				}, {
					UIStroke = e("UIStroke", {
						Thickness = 2,
					}),
				}),
			})
		end

		return Frames
	end, {})

	return e(Main.ImageLabel, {
		native = Join({
			Image = "rbxassetid://78579166773802",
		}, props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 0.75,
		}),
		Main = e(Main.Frame, {
			Size = UDim2.fromScale(0.9, 0.9),
		}, {
			UIListLayout = e(Main.UIListLayout, {
				native = {
					FillDirection = Enum.FillDirection.Vertical,
				},
			}),
		}, ChanceFrames),
	}, props.children)
end

return CreateChances
