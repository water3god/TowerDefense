--!strict

-- By Wa1er_God --

-- Services --

local Titles: {
	[string]: {
		Color: ColorSequence,
	},
} = {
	Owner = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 100, 100)),
	},
	CoOwner = {
		Color = ColorSequence.new(Color3.fromRGB(255, 128, 0), Color3.fromRGB(255, 200, 100)),
	},
	Admin = {
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 100)),
	},
	Moderator = {
		Color = ColorSequence.new(Color3.fromRGB(0, 255, 0), Color3.fromRGB(100, 255, 100)),
	},
	Developer = {
		Color = ColorSequence.new(Color3.fromRGB(0, 128, 255), Color3.fromRGB(100, 200, 255)),
	},
	Tester = {
		Color = ColorSequence.new(Color3.fromRGB(128, 0, 255), Color3.fromRGB(200, 100, 255)),
	},
	Supporter = {
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 100, 200)),
	},
	Player = {
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200)),
	},
}

return Titles
