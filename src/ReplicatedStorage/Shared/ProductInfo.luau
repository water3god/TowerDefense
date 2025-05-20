--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local RarityInfo = require(Shared.RarityInfo)

local ProductInfo: { [number]: { Name: string, Image: string, Rarity: RarityInfo.Rarity | string, Func: () -> () } } =
	{}

local GamepassInfo: { [number]: { Name: string, Image: string, Rarity: RarityInfo.Rarity | string, Func: () -> () } } =
	{}

return {
	ProductInfo = ProductInfo,
	GamepassInfo = GamepassInfo,
}
