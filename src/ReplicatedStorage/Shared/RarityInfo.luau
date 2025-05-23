--!strict

-- By Wa1er_God --

export type Rarity = "BLANK" | "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Godly"

export type RarityInfo = {
	Priority: number,
	Value: number,
	Color: ColorSequence, -- Color of the main text
	StrokeColor: ColorSequence, -- color of the stroke of the main text;
	BackgroundColor: ColorSequence, -- color of the background frame (small frame only);
}

local RarityInfo: { [Rarity]: RarityInfo } = {
	BLANK = {
		Priority = 0,
		Color = ColorSequence.new(Color3.new(255, 255, 255)),
		StrokeColor = ColorSequence.new(Color3.new(0, 0, 0)),
		BackgroundColor = ColorSequence.new(
			Color3.new(0.258824, 0.043137, 0.384314),
			Color3.new(0.564706, 0.113725, 0.827451)
		),
	},
	Common = {
		Priority = 1,
		Value = 10,
		Color = ColorSequence.new(Color3.new(255, 255, 255)),
		StrokeColor = ColorSequence.new(Color3.new(0, 0, 0)),
		BackgroundColor = ColorSequence.new(Color3.new(255, 0, 0), Color3.new(1, 1, 1)),
	},
	Rare = {
		Priority = 2,
		Value = 20,
		Color = ColorSequence.new(Color3.new(0.965682, 0.825895, 0.623743)),
		StrokeColor = ColorSequence.new(Color3.new(0.950683, 0.516121, 0)),
		BackgroundColor = ColorSequence.new(Color3.new(255, 0, 0), Color3.new(1, 1, 1)),
	},
	Epic = {
		Priority = 3,
		Value = 50,
		Color = ColorSequence.new(Color3.new(0.7149, 0, 1)),
		StrokeColor = ColorSequence.new(Color3.new(0.670542, 0.309133, 1)),
		BackgroundColor = ColorSequence.new(Color3.new(255, 0, 0), Color3.new(1, 1, 1)),
	},
	Legendary = {
		Priority = 4,
		Value = 100,
		Color = ColorSequence.new(Color3.new(1, 1, 1)),
		StrokeColor = ColorSequence.new(Color3.new(0.857389, 0.807324, 0)),
		BackgroundColor = ColorSequence.new(Color3.new(255, 0, 0), Color3.new(1, 1, 1)),
	},
	Mythic = {
		Priority = 5,
		Value = 200,
		Color = ColorSequence.new(Color3.new(1, 0, 0.941604)),
		StrokeColor = ColorSequence.new(Color3.new(1, 0.335546, 0.85005)),
		BackgroundColor = ColorSequence.new(Color3.new(255, 0, 0), Color3.new(1, 1, 1)),
	},
	Godly = {
		Priority = 6,
		Value = 400,
		Color = ColorSequence.new(Color3.new(1, 0.952941, 0.082353)),
		StrokeColor = ColorSequence.new(Color3.new(0.513725, 0.462745, 0.07451)),
		BackgroundColor = ColorSequence.new(Color3.new(0.901961, 0.835294, 0.117647), Color3.new(1, 1, 1)),
	},
}

return RarityInfo
