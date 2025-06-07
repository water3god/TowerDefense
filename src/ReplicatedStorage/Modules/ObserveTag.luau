--!strict

-- By Wa1er_God --

local CollectionService = game:GetService("CollectionService")

local Data = {}
local Connections: { [Instance]: RBXScriptConnection } = {}

function Data.ObserveTag(Tag: string, func: (Observed: Instance) -> (() -> ())?)
	for _, Instance in ipairs(CollectionService:GetTagged(Tag)) do
		local Func = func(Instance)

		if Func then
			Connections[Instance] = Instance.Destroying:Once(function()
				Func()
			end)
		end
	end

	CollectionService:GetInstanceAddedSignal(Tag):Connect(function(Observed: Instance)
		local Func = func(Observed)

		if Func then
			Connections[Observed] = Observed.Destroying:Once(function()
				Func()
			end)
		end
	end)
end

function Data.StopObserving(Instance: Instance)
	if Connections[Instance] then
		Connections[Instance]:Disconnect()
		Connections[Instance] = nil
	end
end

return Data
