--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local Units = {
	Common = { "Pyrrhus", "Pompey", "Robert the Bruce", "Ptolemy" },
	Rare = { "Socrates", "Spartacus", "Leif Erikson", "Cleopatra" },
	Epic = { "Pericles", "Cicero", "Charlemagne", "Narmer" },
	Legendary = { "Themistocles", "Julius Caesar", "Joan of Arc", "Akhenaten" },
	Mythic = {
		"Alexander The Great",
		"Augustus",
		"William the Conqueror",
		"Ramesses II", --[["Cao Cao"]]
	},
	Godly = {
		"Leonidas",
		"Trajan",
		"Richard the Lionheart",
		"Tutankhamun", --[["Qin Shi Huang"]]
	},
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

local function CalculateChanceOnLuck(Luck: number, BannerUnits: { string }?)
	-- Create a cache key that includes both luck and banner units
	local BannerKey = ""
	if BannerUnits then
		local sortedBanner = table.clone(BannerUnits)
		table.sort(sortedBanner)
		BannerKey = table.concat(sortedBanner, ",")
	end
	local CacheKey = tostring(Luck) .. "|" .. BannerKey

	if CachedChances[CacheKey] then
		return CachedChances[CacheKey]
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

			-- Handle banner units with 3x chance
			if BannerUnits and #BannerUnits > 0 then
				-- Count how many banner units are in this rarity
				local BannerUnitsInRarity = 0
				for _, Unit in pairs(Units[Rarity]) do
					if table.find(BannerUnits, Unit) then
						BannerUnitsInRarity += 1
					end
				end

				-- If there are banner units in this rarity, adjust chances
				if BannerUnitsInRarity > 0 then
					local NonBannerUnits = Length - BannerUnitsInRarity
					-- Total weight: banner units get 3x weight, non-banner get 1x weight
					local TotalWeight = (BannerUnitsInRarity * 3) + NonBannerUnits

					-- Distribute chances proportionally
					for _, Unit in pairs(Units[Rarity]) do
						if table.find(BannerUnits, Unit) then
							-- Banner units get 3x the base chance
							NewChances[Unit] = HelperFunctions.Round((ModifiedChance * 3) / TotalWeight, 6)
						else
							-- Non-banner units get 1x the base chance
							NewChances[Unit] = HelperFunctions.Round(ModifiedChance / TotalWeight, 6)
						end
					end
				else
					-- No banner units in this rarity, distribute evenly
					for _, Unit in pairs(Units[Rarity]) do
						NewChances[Unit] = HelperFunctions.Round(ModifiedChance / Length, 6)
					end
				end
			else
				-- No banner units specified, distribute evenly
				for _, Unit in pairs(Units[Rarity]) do
					NewChances[Unit] = HelperFunctions.Round(ModifiedChance / Length, 6)
				end
			end
		end

		CachedChances[CacheKey] = NewChances
		return NewChances
	end
end

return {
	Units = Units,
	Chances = Chances,
	CalculateChanceOnLuck = CalculateChanceOnLuck,
}
