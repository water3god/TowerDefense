--!strict

-- By Wa1er_God --

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
	VIP = {
		Color = ColorSequence.new(Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 230, 150)),
		Description = "A player who has achieved VIP status.",
		Priority = 7,
	},
	["God"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 100, 200)),
		Description = "A player who has achieved God status.",
		Priority = 8,
	},
	["Destroyer Of Worlds"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 100, 200)),
		Description = "A player who has achieved Destroyer of Worlds status.",
		Priority = 7,
	},
	["Slayer I"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 100, 200)),
		Description = "A player who has achieved Slayer I status.",
		Priority = 10,
	},
	["Slayer II"] = {
		Color = ColorSequence.new(Color3.fromRGB(200, 0, 255), Color3.fromRGB(200, 100, 200)),
		Description = "A player who has achieved Slayer II status.",
		Priority = 11,
	},
	["Slayer III"] = {
		Color = ColorSequence.new(Color3.fromRGB(150, 0, 255), Color3.fromRGB(150, 100, 200)),
		Description = "A player who has achieved Slayer III status.",
		Priority = 12,
	},
	["Weekly Slayer"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 150), Color3.fromRGB(255, 100, 200)),
		Description = "A player who has achieved the Weekly Slayer title.",
		Priority = 20,
	},
	["Damage Dealer I"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 150, 100)),
		Description = "A player who excels in dealing damage.",
		Priority = 30,
	},
	["Damage Dealer II"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 150, 0), Color3.fromRGB(255, 200, 100)),
		Description = "A player who excels in dealing damage at a higher level.",
		Priority = 31,
	},
	["Damage Dealer III"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 250, 100)),
		Description = "A player who excels in dealing damage at the highest level.",
		Priority = 32,
	},
	["Advanced Summoner"] = {
		Color = ColorSequence.new(Color3.fromRGB(0, 255, 150), Color3.fromRGB(100, 255, 200)),
		Description = "A player who has mastered advanced summoning techniques.",
		Priority = 40,
	},
	["Tower Defense Enjoyer"] = {
		Color = ColorSequence.new(Color3.fromRGB(0, 200, 255), Color3.fromRGB(100, 200, 255)),
		Description = "A player who enjoys the Tower Defense game mode.",
		Priority = 41,
	},
	["Wave Slayer"] = {
		Color = ColorSequence.new(Color3.fromRGB(0, 150, 255), Color3.fromRGB(100, 150, 255)),
		Description = "A player who excels in defeating waves of enemies.",
		Priority = 42,
	},
	["Winner I"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 100, 100)),
		Description = "A player who has won a specific competition or event.",
		Priority = 43,
	},
	["First Place"] = {
		Color = ColorSequence.new(Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 230, 150)),
		Description = "A player who achieved first place in a competition.",
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

return Titles
