--!strict

-- By Wa1er_God --

local Constants = require(script.Parent.Constants)

local OriginalPositions: {
	[string]: UDim2,
} = {
	[Constants.INVENTORY_FRAME] = UDim2.fromScale(0.5, 0.5),
	[Constants.TRADE_FRAME] = UDim2.fromScale(0.5, 0.5),
	[Constants.TRADE_MENU] = UDim2.fromScale(0.5, 0.5),
}

return OriginalPositions
