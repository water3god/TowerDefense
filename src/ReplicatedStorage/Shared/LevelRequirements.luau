local LevelData: { [number]: number } = {
	[1] = 1,
	[2] = 1,
	[3] = 1,
	[4] = 5,
	[5] = 20,
}

local Colors: { [number]: ColorSequence } = {
	[5] = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(150, 150, 150)), -- Default (White to Medium Gray)
	[10] = ColorSequence.new(Color3.fromRGB(50, 255, 50), Color3.fromRGB(0, 180, 0)), -- Green (Vibrant Light Green to Vibrant Dark Green)
	[20] = ColorSequence.new(Color3.fromRGB(50, 180, 255), Color3.fromRGB(0, 100, 200)), -- Blue (Vibrant Light Blue to Vibrant Dark Blue)
	[50] = ColorSequence.new(Color3.fromRGB(255, 180, 50), Color3.fromRGB(200, 100, 0)), -- Orange (Vibrant Light Orange to Vibrant Dark Orange)
	[100] = ColorSequence.new(Color3.fromRGB(255, 50, 50), Color3.fromRGB(180, 0, 0)), -- Red (Vibrant Light Red to Vibrant Dark Red)
}

return {
	EquippedFrames = LevelData,
	Colors = Colors,
}
