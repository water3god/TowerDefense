--!strict

-- By Wa1er_God --

export type Rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic";

export type RarityInfo = {
	Color: ColorSequence; -- Color of the main text
	StrokeColor: ColorSequence; -- color of the stroke of the main text;
	BackgroundColor: ColorSequence; -- color of the background frame (small frame only);
}

local RarityInfo: {[Rarity]: RarityInfo} = {
	Common = {
		Color = ColorSequence.new(Color3.new(255, 255, 255));
		StrokeColor = ColorSequence.new(Color3.new(0, 0, 0));
		BackgroundColor = ColorSequence.new(Color3.new(255, 0, 0), Color3.new(1, 1, 1));
	};
	Rare = {
		Color = ColorSequence.new(Color3.new(0.965682, 0.825895, 0.623743));
		StrokeColor = ColorSequence.new(Color3.new(0.950683, 0.516121, 0));
		BackgroundColor = ColorSequence.new(Color3.new(255, 0, 0), Color3.new(1, 1, 1));
	};
	Epic = {
		Color = ColorSequence.new(Color3.new(0.7149, 0, 1));
		StrokeColor = ColorSequence.new(Color3.new(0.670542, 0.309133, 1));
		BackgroundColor = ColorSequence.new(Color3.new(255, 0, 0), Color3.new(1, 1, 1));
	};
	Legendary = {
		Color = ColorSequence.new(Color3.new(1, 1, 1));
		StrokeColor = ColorSequence.new(Color3.new(0.857389, 0.807324, 0));
		BackgroundColor = ColorSequence.new(Color3.new(255, 0, 0), Color3.new(1, 1, 1));
	};
	Mythic = {
		Color = ColorSequence.new(Color3.new(1, 0, 0.941604));
		StrokeColor = ColorSequence.new(Color3.new(1, 0.335546, 0.85005));
		BackgroundColor = ColorSequence.new(Color3.new(255, 0, 0), Color3.new(1, 1, 1));
	};
};

return RarityInfo;