--!nonstrict

-- By Wa1er_God --

local CollectionService = game:GetService("CollectionService");

for _, Module in ipairs(CollectionService:GetTagged("Init")) do
	require(Module);
end

CollectionService:GetInstanceAddedSignal("Init"):Connect(function(Module)
	require(Module);
end)