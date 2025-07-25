--!strict

-- By Wa1er_God --

export type EvolutionResource = {
	Name: string,
	Amount: number,
}

local Evolutions: { [string]: {
	Evolution: string,
	Resources: { EvolutionResource },
} } = {}

return Evolutions
