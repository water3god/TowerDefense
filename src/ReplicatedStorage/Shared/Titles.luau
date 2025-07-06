--!strict

-- By Wa1er_God --

-- Services --

local Titles: {
	[string]: {
		Color: ColorSequence,
		Priority: number,
	},
} = {
	Owner = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 100, 100)),
		Priority = 1,
	},
	CoOwner = {
		Color = ColorSequence.new(Color3.fromRGB(255, 128, 0), Color3.fromRGB(255, 200, 100)),
		Priority = 2,
	},
	Admin = {
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 100)),
		Priority = 3,
	},
	Moderator = {
		Color = ColorSequence.new(Color3.fromRGB(0, 255, 0), Color3.fromRGB(100, 255, 100)),
		Priority = 4,
	},
	Developer = {
		Color = ColorSequence.new(Color3.fromRGB(0, 128, 255), Color3.fromRGB(100, 200, 255)),
		Priority = 5,
	},
	Tester = {
		Color = ColorSequence.new(Color3.fromRGB(128, 0, 255), Color3.fromRGB(200, 100, 255)),
		Priority = 6,
	},
	Supporter = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 100, 200)),
		Priority = 7,
	},
	Player = {
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200)),
		Priority = 8,
	},
}

return Titles
