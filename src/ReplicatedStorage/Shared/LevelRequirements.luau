local LevelData: { [number]: number } = {
	[1] = 1,
	[2] = 1,
	[3] = 1,
	[4] = 5,
	[5] = 20,
}

local Colors: { [number]: ColorSequence } = {
	[5] = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200)), -- Default
	[10] = ColorSequence.new(Color3.fromRGB(0, 255, 0), Color3.fromRGB(100, 255, 100)), -- Green
	[20] = ColorSequence.new(Color3.fromRGB(0, 128, 255), Color3.fromRGB(100, 200, 255)), -- Blue
	[50] = ColorSequence.new(Color3.fromRGB(255, 128, 0), Color3.fromRGB(255, 200, 100)), -- Orange
	[100] = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 100, 100)), -- Red
}

return {
	EquippedFrames = LevelData,
	Colors = Colors,
}
