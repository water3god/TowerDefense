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
	Supporter = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 100, 200)),
		Description = "A supporter of the game.",
		Priority = 7,
	},
	Player = {
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200)),
		Description = "A regular player.",
		Priority = 8,
	},
}

return Titles
