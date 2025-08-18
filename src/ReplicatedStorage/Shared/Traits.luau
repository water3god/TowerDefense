--!strict

-- By Wa1er_God --

type TraitType = "Damage" | "FireRate" | "Range" | "Coins"

export type TraitData = {
	Icon: string,
	Rarity: string,
	Data: { [TraitType | string]: number },
	Description: string,
	Chance: number,
	Priority: number,
}

local Traits: { [string]: TraitData } = {
	SharpEyed = {
		Icon = "rbxassetid://122185382899091",
		Rarity = "Common",
		Data = { Range = 0.08 },
		Description = "Increases unit range by 8%.",
		Chance = 0.15,
		Priority = 1,
	},

	["Fast Loader"] = {
		Icon = "rbxassetid://131130794346076",
		Rarity = "Common",
		Data = { FireRate = 0.08 },
		Description = "Increases fire rate by 8%.",
		Chance = 0.15,
		Priority = 2,
	},

	["Hard Hitter"] = {
		Icon = "rbxassetid://136940392261450",
		Rarity = "Common",
		Data = { Damage = 0.08 },
		Description = "Increases damage by 8%.",
		Chance = 0.15,
		Priority = 3,
	},

	Greedy = {
		Icon = "rbxassetid://127736146775622",
		Rarity = "Common",
		Data = { Coins = 0.08 },
		Description = "Increases money gained from this unit by 8%.",
		Chance = 0.15,
		Priority = 4,
	},

	-- RARE
	["Quick Hands"] = {
		Icon = "rbxassetid://73467033417948",
		Rarity = "Rare",
		Data = { FireRate = 0.07, Coins = 0.07 },
		Description = "Moderately increases fire rate and coins.",
		Chance = 0.1,
		Priority = 5,
	},

	["Ranged Veteran"] = {
		Icon = "rbxassetid://91396981570027",
		Rarity = "Rare",
		Data = { Range = 0.10, Damage = 0.05 },
		Description = "Boosts range and damage slightly.",
		Chance = 0.1,
		Priority = 6,
	},

	-- EPIC
	Deadshot = {
		Icon = "rbxassetid://105101578867166",
		Rarity = "Epic",
		Data = { Damage = 0.18, Range = 0.12 },
		Description = "Significantly boosts damage and range.",
		Chance = 0.06,
		Priority = 7,
	},

	["Greedy Hunter"] = {
		Icon = "rbxassetid://138889605430553",
		Rarity = "Epic",
		Data = { Damage = 0.10, Coins = 0.15 },
		Description = "Boosts coins and damage for high-profit kills.",
		Chance = 0.06,
		Priority = 9,
	},

	-- LEGENDARY
	Sharpshooter = {
		Icon = "rbxassetid://102716307344081",
		Rarity = "Legendary",
		Data = { Range = 0.20, Damage = 0.20, FireRate = 0.10 },
		Description = "Major boost to range, damage, and fire rate.",
		Chance = 0.025,
		Priority = 10,
	},

	["Treasure Seeker"] = {
		Icon = "rbxassetid://128643620969084",
		Rarity = "Legendary",
		Data = { Coins = 0.25, Range = 0.10, FireRate = 0.10 },
		Description = "Greatly increases coins with bonus range and fire rate.",
		Chance = 0.025,
		Priority = 11,
	},

	-- MYTHIC
	Annihilator = {
		Icon = "rbxassetid://114935210571228",
		Rarity = "Mythic",
		Data = { Damage = 0.30, FireRate = 0.20, Range = 0.10 },
		Description = "Huge boost to combat effectiveness.",
		Chance = 0.01,
		Priority = 12,
	},

	Stormcaller = {
		Icon = "rbxassetid://81412171819994",
		Rarity = "Mythic",
		Data = { FireRate = 0.25, Range = 0.15, Coins = 0.15 },
		Description = "Lightning fast fire rate with solid profits.",
		Chance = 0.01,
		Priority = 13,
	},

	-- GODLY
	Omnistrike = {
		Icon = "rbxassetid://87359585001441",
		Rarity = "Godly",
		Data = { Damage = 0.35, FireRate = 0.25, Range = 0.15, Coins = 0.10 },
		Description = "Unmatched power in all combat stats.",
		Chance = 0.003,
		Priority = 14,
	},

	["Eternal Greed"] = {
		Icon = "rbxassetid://104394794140208",
		Rarity = "Godly",
		Data = { Coins = 0.40, FireRate = 0.25, Damage = 0.15, Range = 0.10 },
		Description = "Maximize wealth with powerful support stats.",
		Chance = 0.003,
		Priority = 15,
	},

	["All Seeing"] = {
		Icon = "rbxassetid://119612261371730",
		Rarity = "Godly",
		Data = { Range = 0.30, Damage = 0.25, FireRate = 0.20, Coins = 0.20 },
		Description = "Elite trait boosting everything considerably.",
		Chance = 0.003,
		Priority = 16,
	},

	Ascended = {
		Icon = "rbxassetid://72619437947138",
		Rarity = "Godly",
		Data = { Damage = 0.5, FireRate = 0.5, Range = 0.5, Coins = 0.5 },
		Description = "Perfect balance across all attributes.",
		Chance = 0.001,
		Priority = 17,
	},
}

return {
	Traits = Traits,
}
