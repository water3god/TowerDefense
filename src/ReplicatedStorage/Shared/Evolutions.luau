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
	["Robert the Bruce"] = {
		Evolution = "Robert the Bruce (Bannockburn)",
		Resources = {
			{ Name = "Knight's Armor", Amount = 5 },
			{ Name = "Archer's Bows", Amount = 2 },
			{ Name = "Queen's Crowns", Amount = 1 },
		},
	},
	--[[["Cleopatra"] = {
		Evolution = "Cleopatra (Triple)",
		Resources = {
			{ Name = "Scrabs", Amount = 10 },
			{ Name = "Nile Pearls", Amount = 10 },
			{ Name = "Pyramid Relics", Amount = 10 },
		},
	},]]
}

return table.freeze(Evolutions)
