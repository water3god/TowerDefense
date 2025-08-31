--!strict

-- By Wa1er_God --

export type Rarity = "BLANK" | "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Godly"

export type RarityInfo = {
	Priority: number,
	Value: number,
	Color: ColorSequence, -- Color of the main text
	StrokeColor: ColorSequence, -- color of the stroke of the main text;
	BackgroundColor: ColorSequence, -- color of the background frame (small frame only);
	Animate: boolean,
}

local RarityInfo: { [Rarity]: RarityInfo } = {
	BLANK = {
		Priority = 0,
		Value = 0,
		Color = ColorSequence.new(Color3.new(1, 1, 1)),
		StrokeColor = ColorSequence.new(Color3.new(0, 0, 0)),
		BackgroundColor = ColorSequence.new(
			Color3.new(0.258824, 0.043137, 0.384314),
			Color3.new(0.564706, 0.113725, 0.827451)
		),
		Animate = false,
	},
	Common = {
		Priority = 1,
		Value = 10,
		Color = ColorSequence.new(Color3.new(0.9, 0.9, 0.9)),
		StrokeColor = ColorSequence.new(Color3.new(0.2, 0.2, 0.2)),
		BackgroundColor = ColorSequence.new(Color3.new(0.7, 0.7, 0.7)),
		Animate = false,
	},
	Rare = {
		Priority = 2,
		Value = 20,
		Color = ColorSequence.new(Color3.new(0.1, 0.8, 0.1)),
		StrokeColor = ColorSequence.new(Color3.new(0.05, 0.4, 0.05)),
		BackgroundColor = ColorSequence.new(Color3.new(0.2, 0.9, 0.2)),
		Animate = false,
	},
	Epic = {
		Priority = 3,
		Value = 50,
		Color = ColorSequence.new(Color3.new(0.1, 0.5, 1)),
		StrokeColor = ColorSequence.new(Color3.new(0.05, 0.25, 0.5)),
		BackgroundColor = ColorSequence.new(Color3.new(0.2, 0.6, 1)),
		Animate = false,
	},
	Legendary = {
		Priority = 4,
		Value = 100,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 0.2)),
			ColorSequenceKeypoint.new(0.5, Color3.new(0.9, 0.7, 0.1)),
			ColorSequenceKeypoint.new(1, Color3.new(1, 0.95, 0.3)),
		}),
		StrokeColor = ColorSequence.new(Color3.new(0.5, 0.4, 0.05), Color3.new(0.3, 0.25, 0.02)),
		BackgroundColor = ColorSequence.new(Color3.new(0.95, 0.85, 0.15), Color3.new(0.75, 0.65, 0.08)),
		Animate = true,
	},
	Mythic = {
		Priority = 5,
		Value = 200,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 0.2, 1)),
			ColorSequenceKeypoint.new(0.3, Color3.new(0.8, 0, 0.9)),
			ColorSequenceKeypoint.new(0.7, Color3.new(1, 0.4, 0.8)),
			ColorSequenceKeypoint.new(1, Color3.new(0.9, 0.6, 1)),
		}),
		StrokeColor = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.4, 0.1, 0.35)),
			ColorSequenceKeypoint.new(1, Color3.new(0.2, 0.05, 0.2)),
		}),
		BackgroundColor = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.8, 0.2, 0.9)),
			ColorSequenceKeypoint.new(0.5, Color3.new(0.6, 0.1, 0.7)),
			ColorSequenceKeypoint.new(1, Color3.new(0.85, 0.15, 0.95)),
		}),
		Animate = true,
	},
	Godly = {
		Priority = 6,
		Value = 400,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 0.9, 0.1)),
			ColorSequenceKeypoint.new(0.2, Color3.new(1, 0.5, 0.2)),
			ColorSequenceKeypoint.new(0.5, Color3.new(1, 0.8, 0.05)),
			ColorSequenceKeypoint.new(0.8, Color3.new(0.9, 0.4, 0.1)),
			ColorSequenceKeypoint.new(1, Color3.new(1, 0.7, 0.15)),
		}),
		StrokeColor = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.5, 0.4, 0.02)),
			ColorSequenceKeypoint.new(0.5, Color3.new(0.3, 0.2, 0.01)),
			ColorSequenceKeypoint.new(1, Color3.new(0.4, 0.35, 0.03)),
		}),
		BackgroundColor = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 0.85, 0.12)),
			ColorSequenceKeypoint.new(0.3, Color3.new(0.95, 0.6, 0.08)),
			ColorSequenceKeypoint.new(0.7, Color3.new(0.9, 0.75, 0.1)),
			ColorSequenceKeypoint.new(1, Color3.new(0.85, 0.7, 0.15)),
		}),
		Animate = true,
	},
}

return table.freeze(RarityInfo)
