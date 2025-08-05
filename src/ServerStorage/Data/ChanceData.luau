--!strict

-- By Wa1er_God --

local Units = {
	Common = { "Pyrrhus", "Pompey", "Robert the Bruce", "Ptolemy" },
	Rare = { "Socrates", "Spartacus", "Leif Erikson", "Cleopatra" },
	Epic = { "Pericles", "Cicero", "Charlemagne", "Narmer" },
	Legendary = { "Themistocles", "Julius Caesar", "Joan of Arc", "Akhenaten" },
	Mythic = { "Alexander The Great", "Augustus", "William the Conqueror", "Ramesses II", "Cao Cao" },
	Godly = { "Leonidas", "Trajan", "Richard the Lionheart", "Tutankhamun", "Qin Shi Huang" },
}

local Chances: { [string]: number } = {
	Common = 10,
	Rare = 5,
	Epic = 1,
	Legendary = 0.1,
	Mythic = 0.05,
	Godly = 0.01,
}

local CachedChances = {}

local function CalculateChanceOnLuck(Luck: number)
	if CachedChances[Luck] then
		return CachedChances[Luck]
	else
		local NewChances = {}
		-- Luck multiplier: higher luck makes rarer units more likely
		-- Base multiplier starts at 1, increases with luck
		local LuckMultiplier = 1 + (Luck * 0.1) -- 10% increase per luck point

		for Rarity, BaseChance in pairs(Chances) do
			local Length = #Units[Rarity]
			-- Apply different luck scaling based on rarity
			local RarityMultiplier = 1
			if Rarity == "Godly" then
				RarityMultiplier = LuckMultiplier ^ 3 -- Godly gets biggest boost
			elseif Rarity == "Mythic" then
				RarityMultiplier = LuckMultiplier ^ 2.5
			elseif Rarity == "Legendary" then
				RarityMultiplier = LuckMultiplier ^ 2
			elseif Rarity == "Epic" then
				RarityMultiplier = LuckMultiplier ^ 1.5
			elseif Rarity == "Rare" then
				RarityMultiplier = LuckMultiplier ^ 1.2
				-- Common stays at base multiplier (1)
			end

			local ModifiedChance = BaseChance * RarityMultiplier
			for _, Unit in pairs(Units[Rarity]) do
				NewChances[Unit] = ModifiedChance / Length
			end
		end

		CachedChances[Luck] = NewChances
		return NewChances
	end
end

return {
	Units = Units,
	Chances = Chances,
	CalculateChanceOnLuck = CalculateChanceOnLuck,
}
