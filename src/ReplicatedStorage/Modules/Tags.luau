--!strict

-- By Wa1er_God -- 

local CollectionService = game:GetService("CollectionService");

local Tags = {};
Tags.__index = Tags

function Tags:ObserveTag(Tag: string, Func: (Instance) -> ...any)
	local self = setmetatable({}, Tags);
	
	self.TotalInstances = {};
	
	for _, Tagged in ipairs(CollectionService:GetTagged(Tag)) do
		local Callback = Func(Tagged);
		
		local CallbackConnection: RBXScriptConnection? = nil;
		
		if typeof(Callback) == "function" then
			Tagged.Destroying:Once(function()
				if Tagged then
					Callback();
				end
			end)
		end
		
		if CallbackConnection then
			table.insert(self.TotalInstances, {[Tagged] = CallbackConnection});
		end
	end
	
	self.Func = CollectionService:GetInstanceAddedSignal(Tag):Connect(function(Tagged: Instance)
		local Callback = Func(Tagged);
		
		if typeof(Callback) == "function" then
			Tagged.Destroying:Once(function()
				Callback();
			end)
		end
	end)
end

function Tags:StopObserving(DiscInstance: Instance?)
	
	if DiscInstance then
		if self.TotalInstances then
			local Callback = self.TotalInstances[DiscInstance];
			
			if Callback then
				Callback:Disconnect();
				self.TotalInstances[DiscInstance] = nil;
			end
		end
		
		return;
	end
	
	if self.Func then
		self.Func:Disconnect();
	end
	
	for Index, Connections in pairs(self.TotalInstances) do
		if Connections then
			Connections:Disconnect();
		end
		self.TotalInstances[Index] = nil;
	end
	
	setmetatable(self, nil);
	
	return;
end


return Tags
