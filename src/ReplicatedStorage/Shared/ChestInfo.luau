--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local RarityInfo = require(Shared.RarityInfo)

export type Reward = { Type: string, Name: string, Count: number }

export type Chest = { Reward: Reward, Tiers: { string } }

export type ChestItem = {
	Type: string,
	Name: string,
	Count: number,
}

export type ChestInfo = {
	[string | RarityInfo.Rarity]: {
		[string]: ChestItem & {
			Chance: number,
		},
	},
}

local ChestInfo: ChestInfo = {
	["Common"] = {
		Gold = { Type = "Resource", Name = "Gold", Count = 100, Chance = 200 },
		["XP"] = { Type = "Resource", Name = "XP", Count = 100, Chance = 200 },
		["Omen Coins"] = { Type = "Resource", Name = "Omen Coins", Count = 1, Chance = 100 },
		["Pyrrhus"] = { Type = "Unit", Name = "Pyrrhus", Count = 1, Chance = 10 },
		["Pompey"] = { Type = "Unit", Name = "Pompey", Count = 1, Chance = 10 },
		["Robert the Bruce"] = { Type = "Unit", Name = "Robert the Bruce", Count = 1, Chance = 10 },
		["Ptolemy"] = { Type = "Unit", Name = "Ptolemy", Count = 1, Chance = 10 },
		["Scrabs"] = { Type = "Resource", Name = "Scrabs", Count = 5, Chance = 20 },
		["Olympian Laurels"] = { Type = "Resource", Name = "Olympian Laurels", Count = 5, Chance = 20 },
		["Roman Eagles"] = { Type = "Resource", Name = "Roman Eagles", Count = 5, Chance = 20 },
		["Dragon Scales"] = { Type = "Resource", Name = "Dragon Scales", Count = 5, Chance = 20 },
		["Knight's Armor"] = { Type = "Resource", Name = "Knight's Armor", Count = 5, Chance = 20 },
	},
	["Rare"] = {
		Gold = { Type = "Resource", Name = "Gold", Count = 500, Chance = 200 },
		["XP"] = { Type = "Resource", Name = "XP", Count = 500, Chance = 100 },
		["Omen Coins"] = { Type = "Resource", Name = "Omen Coins", Count = 2, Chance = 100 },
		["Nile Pearls"] = { Type = "Resource", Name = "Nile Pearls", Count = 2, Chance = 20 },
		["Spartan Helmets"] = { Type = "Resource", Name = "Spartan Helmets", Count = 2, Chance = 20 },
		["Centurion Helmets"] = { Type = "Resource", Name = "Centurion Helmets", Count = 2, Chance = 20 },
		["Warrior's Fans"] = { Type = "Resource", Name = "Warrior's Fans", Count = 2, Chance = 20 },
		["Archer's Bows"] = { Type = "Resource", Name = "Archer's Bows", Count = 2, Chance = 20 },
		["Socrates"] = { Type = "Unit", Name = "Socrates", Count = 1, Chance = 20 },
		["Spartacus"] = { Type = "Unit", Name = "Spartacus", Count = 1, Chance = 20 },
		["Leif Erikson"] = { Type = "Unit", Name = "Leif Erikson", Count = 1, Chance = 20 },
		["Cleopatra"] = { Type = "Unit", Name = "Cleopatra", Count = 1, Chance = 20 },
	},
	["Epic"] = {
		Gold = { Type = "Resource", Name = "Gold", Count = 1000, Chance = 50 },
		["XP"] = { Type = "Resource", Name = "XP", Count = 1000, Chance = 50 },
		["Omen Coins"] = { Type = "Resource", Name = "Omen Coins", Count = 5, Chance = 50 },
		["Pericles"] = { Type = "Unit", Name = "Pericles", Count = 1, Chance = 20 },
		["Cicero"] = { Type = "Unit", Name = "Cicero", Count = 1, Chance = 20 },
		["Charlemagne"] = { Type = "Unit", Name = "Charlemagne", Count = 1, Chance = 20 },
		["Narmer"] = { Type = "Unit", Name = "Narmer", Count = 1, Chance = 20 },
		["Pyramid Relics"] = { Type = "Resource", Name = "Pyramid Relics", Count = 1, Chance = 10 },
		["Philosopher's Stones"] = { Type = "Resource", Name = "Philosopher's Stones", Count = 1, Chance = 10 },
		["Imperial Seals"] = { Type = "Resource", Name = "Imperial Seals", Count = 1, Chance = 10 },
		["Emperor's Gems"] = { Type = "Resource", Name = "Emperor's Gems", Count = 1, Chance = 10 },
		["Queen's Crowns"] = { Type = "Resource", Name = "Queen's Crowns", Count = 1, Chance = 10 },
	},
	["Legendary"] = {
		Gold = { Type = "Resource", Name = "Gold", Count = 2500, Chance = 50 },
		["XP"] = { Type = "Resource", Name = "XP", Count = 2500, Chance = 50 },
		["Omen Coins"] = { Type = "Resource", Name = "Omen Coins", Count = 10, Chance = 50 },
		["Themistocles"] = { Type = "Unit", Name = "Themistocles", Count = 1, Chance = 25 },
		["Julius Caesar"] = { Type = "Unit", Name = "Julius Caesar", Count = 1, Chance = 25 },
		["Joan of Arc"] = { Type = "Unit", Name = "Joan of Arc", Count = 1, Chance = 25 },
		["Akhenaten"] = { Type = "Unit", Name = "Akhenaten", Count = 1, Chance = 25 },
	},
	["Mythic"] = {
		Gold = { Type = "Resource", Name = "Gold", Count = 5000, Chance = 50 },
		["XP"] = { Type = "Resource", Name = "XP", Count = 5000, Chance = 50 },
		["Omen Coins"] = { Type = "Resource", Name = "Omen Coins", Count = 20, Chance = 50 },
		["Alexander The Great"] = { Type = "Unit", Name = "Alexander The Great", Count = 1, Chance = 25 },
		["Augustus"] = { Type = "Unit", Name = "Augustus", Count = 1, Chance = 25 },
		["William the Conqueror"] = { Type = "Unit", Name = "William the Conqueror", Count = 1, Chance = 25 },
		["Ramesses II"] = { Type = "Unit", Name = "Ramesses II", Count = 1, Chance = 25 },
	},
	["Godly"] = {
		Gold = { Type = "Resource", Name = "Gold", Count = 10000, Chance = 50 },
		["XP"] = { Type = "Resource", Name = "XP", Count = 10000, Chance = 50 },
		["Omen Coins"] = { Type = "Resource", Name = "Omen Coins", Count = 50, Chance = 50 },
		["Leonidas"] = { Type = "Unit", Name = "Leonidas", Count = 1, Chance = 25 },
		["Trajan"] = { Type = "Unit", Name = "Trajan", Count = 1, Chance = 25 },
		["Richard the Lionheart"] = { Type = "Unit", Name = "Richard the Lionheart", Count = 1, Chance = 25 },
		["Tutankhamun"] = { Type = "Unit", Name = "Tutankhamun", Count = 1, Chance = 25 },
		VIP = { Type = "Product", Name = "VIP", Count = 1, Chance = 20 },
		["Ultra VIP"] = { Type = "Product", Name = "Ultra VIP", Count = 1, Chance = 10 },
	},
}

return ChestInfo
