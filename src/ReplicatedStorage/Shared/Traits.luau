--!strict

-- By Wa1er_God --

type TraitType = "Damage" | "FireRate" | "Range" | "Coins"

export type TraitData = {
	Icon: string,
	Rarity: string,
	Data: { [TraitType | string]: number },
	Chance: number,
	Priority: number,
}

local Traits: { [string]: TraitData } = {
	["Damage I"] = {
		Icon = "rbxassetid://74203135188399", -- Replace with actual icon ID
		Rarity = "Common",
		Data = {
			Damage = 1.1,
		},
		Chance = 0.5, -- Example chance, adjust as needed
		Priority = 1,
	},
	["FireRate I"] = {
		Icon = "rbxassetid://1234567891", -- Replace with actual icon ID
		Rarity = "Common",
		Data = {
			FireRate = 1.1,
		},
		Chance = 0.5, -- Example chance, adjust as needed
		Priority = 2,
	},
	["Range I"] = {
		Icon = "rbxassetid://1234567892", -- Replace with actual icon ID
		Rarity = "Common",
		Data = {
			Range = 1.1,
		},
		Chance = 0.5, -- Example chance, adjust as needed
		Priority = 3,
	},
	["Coins I"] = {
		Icon = "rbxassetid://1234567893", -- Replace with actual icon ID
		Rarity = "Common",
		Data = {
			Coins = 1.1,
		},
		Chance = 0.5015, -- Example chance, adjust as needed
		Priority = 4,
	},
}

return {
	Traits = Traits,
}
