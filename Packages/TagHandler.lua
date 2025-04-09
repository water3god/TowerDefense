--!strict

-- By Wa1er_God --

local CollectionService = game:GetService("CollectionService");

local Tags = {};

local CurrentTags: {[string]: {Instance}} = {};
local CurrentConnections: {[string]: {RBXScriptConnection}} = {};

function Tags:GetTagged(Tag: string)
	local Tagged = CurrentTags[Tag];
	
	if not Tagged then
		CurrentTags[Tag] = CollectionService:GetTagged(Tag);
		
		CurrentConnections[Tag] = {};
		
		table.insert(CurrentConnections[Tag], 
			CollectionService:GetInstanceAddedSignal(Tag):Connect(
			function(TagInstance: Instance)
				table.insert(CurrentTags[Tag], TagInstance);
			end)
		);
		
		table.insert(CurrentConnections[Tag], 
			CollectionService:GetInstanceRemovedSignal(Tag):Connect(
			function(TagInstance: Instance)
				local Index = table.find(CurrentTags[Tag], TagInstance)
				
				if Index then
					table.remove(CurrentTags[Tag], Index);
				end
			end)
		);
		
		return CurrentTags[Tag];
	end
	
	return Tagged;
end

function Tags:ConnectTag(Tag: string, AddedFunc: (...any) -> (...any), RemovedFunc: (...any) -> (...any)?)
	for _, InstanceInTag in ipairs(CollectionService:GetTagged(Tag)) do
		AddedFunc(InstanceInTag);
	end
	
	
	return {
		Added = CollectionService:GetInstanceAddedSignal(Tag):Connect(function(Instance)
			AddedFunc(Instance);
		end);
		
		Removed = if typeof(RemovedFunc) == "function" then
			CollectionService:GetInstanceRemovedSignal(Tag):Connect(function(Instance)
					
				RemovedFunc(Instance);
			end)
		else
			nil;
	}
end

-- DO NOT USE --

function Tags:____AttributeChanged(Instance: Instance, AttributeName: string, Func: (Attribute: any) -> ())
	
	Instance:GetAttributeChangedSignal(AttributeName):Connect(function()
		local Attribute = Instance:GetAttribute(AttributeName);
		
		Func(Attribute);
	end)
end

-- END --

function Tags:DisconnectTag(Tag: string)
	if CurrentTags[Tag] and CurrentConnections[Tag] then
		for Index, Connection in ipairs(CurrentConnections[Tag]) do
			if Connection then
				Connection:Disconnect();
			end
		end
		
		CurrentConnections[Tag] = nil;
		CurrentTags[Tag] = nil;
	end
end

return Tags;
