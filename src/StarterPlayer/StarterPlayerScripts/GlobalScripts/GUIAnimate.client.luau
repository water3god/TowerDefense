--!strict

-- By Wa1er_God --

-- Tags --

local ANIMATE_VISIBLITY_FRAME_TAG = "AnimateFrameVisibility"; -- Frames that will open in a tween;
local VISIBLE_ATTRIBUTE = "AnimateVisible";
local POSITION_GUI_ATTRIBUTE = "AnimatePosition";

local STATIC_BUTTON_VISIBILITY_TAG = "StaticButtonVisibility"; -- things turn invisible when frame is open

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");

local Player = Players.LocalPlayer;
local PlayerGui = Player.PlayerGui;

local Modules = ReplicatedStorage.Modules;
local ObserveTag = require(Modules.ObserveTag);

local GUIBlur = Lighting:WaitForChild("GUIBlur");
local BLUR_MAX_SIZE = GUIBlur.Size;
GUIBlur.Size = 0;
GUIBlur.Enabled = true;

local CurrentlyOpenFrame: GuiObject? = nil;

local TrueStaticTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
local FalseStaticTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In);

local DefaultY = -1;

local Properties: {[string]: {string}} = {
	CanvasGroup = {"GroupTransparency"};
};

local function HandleInstanceStatic(Instance: CanvasGroup)
	if Instance:IsA("CanvasGroup") then
		local PropertiesToSave = {"BackgroundTransparency"};

		local InstanceProperties = Properties[Instance.ClassName];
		if InstanceProperties then
			table.move(InstanceProperties, 1, #InstanceProperties, #PropertiesToSave + 1, PropertiesToSave);
		end

		for _, Property in ipairs(PropertiesToSave) do
			Instance:SetAttribute(Property, (Instance :: any)[Property]);
		end
	end
end

ObserveTag.ObserveTag(STATIC_BUTTON_VISIBILITY_TAG, function(Instance: Instance)
	if Instance:IsA("CanvasGroup") then
		HandleInstanceStatic(Instance);
		
		--[[for _, Descendant in ipairs(Instance:GetChildren()) do
			if Descendant:IsA("GuiObject") then
				Descendant:AddTag(STATIC_BUTTON_VISIBILITY_TAG);
			end
		end]]
	end

	return function() end
end)

local function GetOriginalProperties(Object: GuiObject, Visible: boolean)
	local GroupTransparency = nil;

	local Property = "GroupTransparency";
	local Value = Object:GetAttribute(Property);

	if Value then
		if Visible then
			GroupTransparency = 1;
		else
			GroupTransparency = Value;
		end
	end

	return GroupTransparency;
end

local function ChangeTransparencyDescendants(Instance: Instance, Visible: boolean)
	if Instance:IsA("CanvasGroup") then
		local TweenInfo = if Visible then TrueStaticTweenInfo else FalseStaticTweenInfo;
		local Transparency = GetOriginalProperties(Instance, Visible);

		local Tween = TweenService:Create(Instance, TweenInfo, {GroupTransparency = Transparency});
		if Visible then
			Tween.Completed:Once(function(PlaybackState: Enum.PlaybackState)
				if PlaybackState ~= Enum.PlaybackState.Cancelled then
					Instance.Visible = false;
				end
			end)
		else
			Instance.Visible = true;
		end
		Tween:Play();
	end
end

local function ToggleStatics(Visible: boolean)
	local Transparency = if Visible then 0 else 1;

	for _, Observed in ipairs(CollectionService:GetTagged(STATIC_BUTTON_VISIBILITY_TAG)) do
		ChangeTransparencyDescendants(Observed, Visible);
	end

	local TweenInfo = if Visible then TrueStaticTweenInfo else FalseStaticTweenInfo;
	local Blur = if Visible then BLUR_MAX_SIZE else 0;

	local Tween = TweenService:Create(GUIBlur, TweenInfo, {Size = Blur});
	Tween:Play();
end

local function ToggleFrame(Object: GuiObject, Visible: boolean)
	local TweenInfo = if Visible then TrueStaticTweenInfo else FalseStaticTweenInfo;
	
	local PositionAttribute: UDim2 = Object:GetAttribute(POSITION_GUI_ATTRIBUTE);
	
	local Position = if Visible then PositionAttribute else UDim2.fromScale(PositionAttribute.X.Scale, DefaultY);

	local Tween = TweenService:Create(Object, TweenInfo, {Position = Position});
	Object:SetAttribute(VISIBLE_ATTRIBUTE, Visible);
	if Visible then
		Object.Visible = true;
	else
		Tween.Completed:Once(function(PlaybackState: Enum.PlaybackState)
			if PlaybackState ~= Enum.PlaybackState.Cancelled then
				Object.Visible = false;
			end
		end)
	end

	Tween:Play();
end

ObserveTag.ObserveTag(ANIMATE_VISIBLITY_FRAME_TAG, function(Observed: Instance)
	if Observed:IsA("GuiObject") and Observed:IsDescendantOf(PlayerGui) then
		Observed:SetAttribute(VISIBLE_ATTRIBUTE, false);
		Observed:SetAttribute(POSITION_GUI_ATTRIBUTE, Observed.Position);
		Observed.Position = UDim2.fromScale(Observed.Position.X.Scale, DefaultY);

		Observed:GetAttributeChangedSignal(VISIBLE_ATTRIBUTE):Connect(function()
			local IsVisible = Observed:GetAttribute(VISIBLE_ATTRIBUTE);

			ToggleFrame(Observed, IsVisible);

			if IsVisible then
				if not CurrentlyOpenFrame then
					ToggleStatics(IsVisible);
				end
			else
				if CurrentlyOpenFrame then
					ToggleStatics(IsVisible);
				end
			end

			if IsVisible then
				if CurrentlyOpenFrame then
					ToggleFrame(CurrentlyOpenFrame, false);
				end
				CurrentlyOpenFrame = Observed;
			else
				CurrentlyOpenFrame = nil;
			end
		end)

		Observed:GetAttributeChangedSignal(POSITION_GUI_ATTRIBUTE):Connect(function()
			if Observed:GetAttribute(VISIBLE_ATTRIBUTE) then
				TweenService:Create(Observed, TrueStaticTweenInfo, {Position = Observed.Position}):Play();
			else
				local Position = UDim2.fromScale(Observed.Position.X.Scale, DefaultY);
				TweenService:Create(Observed, TrueStaticTweenInfo, {Position = Position}):Play();
			end
		end)
	end

	return function()
		if CurrentlyOpenFrame == Observed then
			CurrentlyOpenFrame = nil;
			ToggleStatics(false);
		end
	end
end)



