--!strict

-- By Wa1er_God --

export type EvolutionResource = {
	Name: string,
	Amount: number,
}

local Evolutions: { [string]: {
	Evolution: string,
	Resources: { EvolutionResource },
} } = {
	["Cleopatra"] = {
		Evolution = "Cleopatra (Triple)",
		Resources = {
			{ Name = "Scrab Gems", Amount = 10 },
			{ Name = "Nile Pearls", Amount = 10 },
			{ Name = "Pyramid Relics", Amount = 10 },
		},
	},
}

return table.freeze(Evolutions)
