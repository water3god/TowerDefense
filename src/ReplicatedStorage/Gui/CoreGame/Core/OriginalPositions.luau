--!strict

-- By Wa1er_God --

local Constants = require(script.Parent.Constants)

local OriginalPositions: {
	[string]: UDim2,
} = {
	[Constants.INVENTORY_FRAME] = UDim2.fromScale(0.5, 0.5),
	[Constants.TRADE_FRAME] = UDim2.fromScale(0.5, 0.5),
	[Constants.TRADE_MENU] = UDim2.fromScale(0.5, 0.5),
	[Constants.STORY_FRAME] = UDim2.fromScale(0.4, 0.45),
	[Constants.ROLL_FRAME] = UDim2.fromScale(0.5, 0.5),
	[Constants.SETTINGS] = UDim2.fromScale(0.5, 0.5),
	[Constants.STORE] = UDim2.fromScale(0.5, 0.5),
	[Constants.DAILY_FRAME] = UDim2.fromScale(0.5, 0.5),
}

return OriginalPositions
