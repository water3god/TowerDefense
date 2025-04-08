--[[
	First, Fire Event, wait(0.05) seconds, fire the new start time (+ wait time), then with this data,
	deal at every delay time, then visually kill the enemy if the damage is higher than its health. This
	would mean that the killed event would not fire anymore. Also, if the time is higher than the total
	animation time, then do immedietly. also, skip to the proper time frame when fired.
	
]]

local Data = {};

local AnimationsIds: {
	[string --[[AttackId]]]: number --[[AnimationId]];
} = {
	["Scoutv1.0"] = 3;
};
-- 
local AttackIds: {
	[string --[[ModelName]]]: {[number --[[Level]]]: string --[[AttackId]]};
} = {
	["Scout"] = {[0] = "Scoutv1.0"};  
};

Data.AnimationIds = AnimationsIds;
Data.AttackIds = AttackIds;

return Data
