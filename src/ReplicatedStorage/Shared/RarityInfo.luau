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
		Color = ColorSequence.new(Color3.new(1, 1, 1)),
		StrokeColor = ColorSequence.new(Color3.new(0, 0, 0)),
		BackgroundColor = ColorSequence.new(
			Color3.new(0.258824, 0.043137, 0.384314),
			Color3.new(0.564706, 0.113725, 0.827451)
		),
	},
	Common = {
		Priority = 1,
		Value = 10,
		Color = ColorSequence.new(Color3.new(0.878431, 0.878431, 0.878431)),
		StrokeColor = ColorSequence.new(Color3.new(0.113725, 0.113725, 0.113725)),
		BackgroundColor = ColorSequence.new(Color3.new(0.596078, 0.596078, 0.596078)),
	},
	Rare = {
		Priority = 2,
		Value = 20,
		Color = ColorSequence.new(Color3.new(0.862745, 0.619608, 0.137255)),
		StrokeColor = ColorSequence.new(Color3.new(0.341176, 0.258824, 0.117647)),
		BackgroundColor = ColorSequence.new(Color3.new(0.894118, 0.611765, 0.152941)),
	},
	Epic = {
		Priority = 3,
		Value = 50,
		Color = ColorSequence.new(Color3.new(0.7149, 0, 1)),
		StrokeColor = ColorSequence.new(Color3.new(0.243137, 0.078431, 0.403922)),
		BackgroundColor = ColorSequence.new(Color3.new(0.403922, 0.145098, 0.698039)),
	},
	Legendary = {
		Priority = 4,
		Value = 100,
		Color = ColorSequence.new(Color3.new(0.992157, 0.952941, 0.235294)),
		StrokeColor = ColorSequence.new(Color3.new(0.376471, 0.345098, 0.07451)),
		BackgroundColor = ColorSequence.new(Color3.new(0.819608, 0.819608, 0.129412)),
	},
	Mythic = {
		Priority = 5,
		Value = 200,
		Color = ColorSequence.new(Color3.new(1, 0, 0.941604)),
		StrokeColor = ColorSequence.new(Color3.new(0.294118, 0.098039, 0.25098)),
		BackgroundColor = ColorSequence.new(
			Color3.new(0.721569, 0.152941, 0.835294),
			Color3.new(0.768627, 0.117647, 0.917647)
		),
	},
	Godly = {
		Priority = 6,
		Value = 400,
		Color = ColorSequence.new(Color3.new(1, 0.815686, 0.14902)),
		StrokeColor = ColorSequence.new(Color3.new(0.372549, 0.305882, 0.05098)),
		BackgroundColor = ColorSequence.new(
			Color3.new(0.929412, 0.768627, 0.117647),
			Color3.new(0.819608, 0.690196, 0.121569)
		),
	},
}

return RarityInfo
