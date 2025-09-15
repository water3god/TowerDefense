--!strict

-- By Wa1er_God --
-- PC WAS HEREEEEE --
-- Services --

local Titles: {
	[string]: {
		Color: ColorSequence,
		Description: string,
		Priority: number,
	},
} = {
	Owner = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 100, 100)),
		Description = "The creator of the game.",
		Priority = 1,
	},
	CoOwner = {
		Color = ColorSequence.new(Color3.fromRGB(255, 128, 0), Color3.fromRGB(255, 200, 100)),
		Description = "A trusted individual with significant influence.",
		Priority = 2,
	},
	Admin = {
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 100)),
		Description = "An individual with elevated permissions.",
		Priority = 3,
	},
	Moderator = {
		Color = ColorSequence.new(Color3.fromRGB(0, 255, 0), Color3.fromRGB(100, 255, 100)),
		Description = "A member of the moderation team.",
		Priority = 4,
	},
	Developer = {
		Color = ColorSequence.new(Color3.fromRGB(0, 128, 255), Color3.fromRGB(100, 200, 255)),
		Description = "A developer contributing to the game.",
		Priority = 5,
	},
	Tester = {
		Color = ColorSequence.new(Color3.fromRGB(128, 0, 255), Color3.fromRGB(200, 100, 255)),
		Description = "A tester ensuring game quality.",
		Priority = 6,
	},
	["Content Creator"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 100, 100)),
		Description = "A player who creates content for the game.",
		Priority = 7,
	},
	["Ultra VIP"] = {
		Color = ColorSequence.new(Color3.fromRGB(185, 244, 38), Color3.fromRGB(185, 244, 38)),
		Description = "A player who has achieved Ultra VIP status.",
		Priority = 8,
	},
	VIP = {
		Color = ColorSequence.new(Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 230, 150)),
		Description = "A player who has achieved VIP status.",
		Priority = 9,
	},
	["TOP 100"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 100, 200)),
		Description = "A player who is one of the top 100 in the leaderboard.",
		Priority = 10,
	},
	["Destroyer Of Worlds"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 100, 200)),
		Description = "A player who has achieved Destroyer of Worlds status.",
		Priority = 12,
	},
	["Eradicator"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 100, 200)),
		Description = "Damage Dealer.",
		Priority = 13,
	},
	["Slayer"] = {
		Color = ColorSequence.new(Color3.fromRGB(200, 0, 255), Color3.fromRGB(200, 100, 200)),
		Description = "A player who has achieved Slayer II status.",
		Priority = 14,
	},
	["Slayer III"] = {
		Color = ColorSequence.new(Color3.fromRGB(150, 0, 255), Color3.fromRGB(150, 100, 200)),
		Description = "A player who has achieved Slayer III status.",
		Priority = 15,
	},
	["Annahilator"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 100, 0), Color3.fromRGB(135, 0, 172)),
		Description = "Dealt 100k damage to enemies.",
		Priority = 30,
	},
	["Furious"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 150, 0), Color3.fromRGB(186, 203, 31)),
		Description = "A player who excels in dealing damage at a higher level.",
		Priority = 31,
	},
	["Veteran"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 150, 0), Color3.fromRGB(203, 0, 3)),
		Description = "A player who excels in dealing damage at a higher level.",
		Priority = 31,
	},
	["Fighter"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 250, 100)),
		Description = "A player who excels in dealing damage at the highest level.",
		Priority = 32,
	},
	["Advanced Summoner"] = {
		Color = ColorSequence.new(Color3.fromRGB(0, 255, 150), Color3.fromRGB(100, 255, 200)),
		Description = "A player who has mastered advanced summoning techniques.",
		Priority = 40,
	},
	["Wave Defender"] = {
		Color = ColorSequence.new(Color3.fromRGB(0, 200, 255), Color3.fromRGB(100, 200, 255)),
		Description = "A player who enjoys the Infinite Gamemode.",
		Priority = 41,
	},
	["Wave Slayer"] = {
		Color = ColorSequence.new(Color3.fromRGB(0, 150, 255), Color3.fromRGB(100, 150, 255)),
		Description = "A player who excels in defeating waves of enemies.",
		Priority = 42,
	},
	["Rookie"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 195, 112)),
		Description = "AFirst Win.",
		Priority = 43,
	},
	["Competitor"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 230, 150)),
		Description = "A player who has won 5 games within a week.",
		Priority = 44,
	},
	["Cleared"] = {
		Color = ColorSequence.new(Color3.fromRGB(0, 255, 0), Color3.fromRGB(100, 255, 100)),
		Description = "A player who has cleared a specific challenge or level.",
		Priority = 45,
	},
	["Demolisher"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 100, 100)),
		Description = "A player who excels in demolishing structures or enemies.",
		Priority = 46,
	},
	["Group Member"] = {
		Color = ColorSequence.new(Color3.fromRGB(0, 213, 255), Color3.fromRGB(100, 219, 255)),
		Description = "A group member",
		Priority = 50,
	},
	Player = {
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200)),
		Description = "A regular player.",
		Priority = 51,
	},
}

return table.freeze(Titles)
