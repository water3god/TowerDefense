--!strict

--[[
	MIT License
	
	Copyright (c) Wa1er_God

	Permission is hereby granted, free of charge, to any person obtaining a copy of
	this software and associated documentation files (the "Software"), to deal in
	the Software without restriction, including without limitation the rights to
	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
	of the Software, and to permit persons to whom the Software is furnished to do
	so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

-- By Wa1er_God --
-- December 2024 --

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");

local Player = Players.LocalPlayer;
local PlayerGui = Player.PlayerGui;
local Camera = workspace.CurrentCamera;

local Tag: string = "StrokeScale";
local AttributeName: string = "StrokeValue";

local function GetAncestors(Instance: Instance)
	local CurrentParent: Instance = Instance;
	local Ancestors = {};

	repeat
		table.insert(Ancestors, CurrentParent :: Instance);
		CurrentParent = (CurrentParent :: any).Parent;
	until CurrentParent == nil;

	return Ancestors;
end

local function DisconnectAll(Connections: {RBXScriptConnection})
	for _, Connection in ipairs(Connections) do
		Connection:Disconnect();
	end
	table.clear(Connections);
end

local function IsValid(UIStroke: UIStroke)
	if not UIStroke:IsDescendantOf(PlayerGui) then
		return false;
	end

	for _, Parent in ipairs(GetAncestors(UIStroke)) do
		if Parent:IsA("GuiBase2d") then
			if Parent:IsA("GuiObject") then
				if not Parent.Visible then
					return false;
				end
			elseif Parent:IsA("LayerCollector") then
				if not Parent.Enabled then
					return false;
				end
			end
		elseif Parent:IsA("LuaSourceContainer") then
			return false;
		end
	end

	return true;
end

local function HasText(Parent)
	local success, returned = pcall(function()
		if (Parent :: any).Text and (Parent :: any).TextBounds and (Parent :: any).TextScaled then
			return true;
		else
			return false;
		end
	end)
	
	if success then
		return returned;
	else
		return false;
	end
end

local function HandleStroke(Stroke: UIStroke)
	local ParentConnection: RBXScriptConnection? = nil;
	local SizeConnection: RBXScriptConnection? = nil;
	local ChangeConnection: RBXScriptConnection? = nil;
	local FormatConnection: RBXScriptConnection? = nil;
	
	local Connections = {};

	local function OnParentChange()
		local Parent = Stroke.Parent;
		if Parent == nil or not Parent:IsA("GuiObject") or not IsValid(Stroke) then
			return;
		end

		if SizeConnection then
			SizeConnection:Disconnect();
			SizeConnection = nil;
		end

		if ChangeConnection then
			ChangeConnection:Disconnect();
			ChangeConnection = nil;
		end

		if FormatConnection then
			FormatConnection:Disconnect();
			FormatConnection = nil;
		end

		local function OnSizeChange()
			local StrokeValue = Stroke:GetAttribute(AttributeName) or 0.002;
			--if Stroke.ApplyStrokeMode == Enum.ApplyStrokeMode.Border then
			local ViewSize = Camera.ViewportSize;
				local Size = math.min(ViewSize.X, ViewSize.Y);
				Stroke.Thickness = StrokeValue * Size;
			--[[elseif Stroke.ApplyStrokeMode == Enum.ApplyStrokeMode.Contextual then
				if (Parent :: any).Text and (Parent :: any).TextBounds then
					local TextBounds: Vector2 = (Parent :: any).TextBounds;
					local XScale = TextBounds.X / Parent.AbsoluteSize.X;
					local YScale = TextBounds.Y / Parent.AbsoluteSize.Y;

					local Size = math.min(XScale, YScale);
					Stroke.Thickness = StrokeValue * Size * 50;
				end]]
			--end
		end

		OnSizeChange();
		SizeConnection = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			OnSizeChange();			
		end)

		ChangeConnection = Stroke:GetAttributeChangedSignal(AttributeName):Connect(function()
			OnSizeChange();
		end)

		FormatConnection = Stroke:GetPropertyChangedSignal("ApplyStrokeMode"):Connect(function()
			OnSizeChange();
		end)
	end

	OnParentChange();
	
	local function HandleAncestor(Ancestor: Instance)
		if Ancestor:IsA("GuiBase2d") then
			if Ancestor:IsA("GuiObject") then
				table.insert(Connections, Ancestor:GetPropertyChangedSignal("Visible"):Connect(function()
					OnParentChange();
				end))
			elseif Ancestor:IsA("LayerCollector") then
				table.insert(Connections, Ancestor:GetPropertyChangedSignal("Enabled"):Connect(function()
					OnParentChange();
				end))
			end
		end
	end
	
	ParentConnection = Stroke.AncestryChanged:Connect(function(Child, Parent)
		DisconnectAll(Connections);
		OnParentChange();
		for _, Ancestor in ipairs(GetAncestors(Stroke)) do
			HandleAncestor(Ancestor);
		end
	end)
	
	for _, Ancestor in ipairs(GetAncestors(Stroke)) do
		HandleAncestor(Ancestor);
	end

	Stroke.Destroying:Once(function()
		if SizeConnection then
			SizeConnection:Disconnect();
			SizeConnection = nil;
		end
		DisconnectAll(Connections);
	end)
end

for _, UIStroke in ipairs(CollectionService:GetTagged(Tag)) do
	HandleStroke(UIStroke);
end

CollectionService:GetInstanceAddedSignal(Tag):Connect(function(UIStroke: Instance)
	if UIStroke:IsA("UIStroke") then
		HandleStroke(UIStroke);
	end
end)