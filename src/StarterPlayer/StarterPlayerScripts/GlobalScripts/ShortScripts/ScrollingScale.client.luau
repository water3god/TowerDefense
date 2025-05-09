--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Camera = workspace.CurrentCamera;

local Modules = ReplicatedStorage.Modules;
local ObserveTag = require(Modules.ObserveTag);

local function DisconnectAll(Data: {RBXScriptConnection})
	for _, Connection in ipairs(Data) do
		Connection:Disconnect();
	end
	table.clear(Data);
end

local function OnAdded(Frame: ScrollingFrame)
	local function OnChanged()
		local Value: number = Frame:GetAttribute("ScrollSize");
		Frame.ScrollBarThickness = Camera.ViewportSize.X * Value;
	end
	
	local Connections = {};
	
	OnChanged();
	table.insert(Connections, Frame:GetAttributeChangedSignal("ScrollSize"):Connect(OnChanged));
	table.insert(Connections, Camera:GetPropertyChangedSignal("ViewportSize"):Connect(OnChanged));
	
	return function()
		DisconnectAll(Connections);
	end
end

ObserveTag.ObserveTag("ScrollingScrollScale", function(Observed: Instance)
	if Observed:IsA("ScrollingFrame") then
		return OnAdded(Observed);
	end
	
	return function() end
end)