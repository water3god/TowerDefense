--!strict

-- By Wa1er_God --

local AnimateTag = "GuiAnimate";
local BasicTag = "GuiAnimateBasic";
local OpenTag = "OpenAnimate";
local OpenAttribute = "IsVisible";

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");

local GlobalMusic = SoundService:WaitForChild("GlobalMusic");
local ClickSound = GlobalMusic:WaitForChild("ClickSound");
local DestroyStorage = GlobalMusic:WaitForChild("DestroyStorage");

local Modules = ReplicatedStorage.Modules;
local ObserveTag = require(Modules.ObserveTag);
local HelperFunctions = require(Modules.HelperFunctions);

local module = {};

function module.MakeVisible(GuiObject: any, Visible: boolean)
	if GuiObject:HasTag(OpenTag) and GuiObject:IsA("GuiObject") then
		if Visible then
			GuiObject.Visible = true;
			GuiObject.UIScale.Scale = 0.7;
			TweenService:Create(
				GuiObject.UIScale,
				TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
				{Scale = 1}
			):Play();
		else
			local Tween = TweenService:Create(
				GuiObject.UIScale,
				TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
				{Scale = 0.7}
			);
			Tween.Completed:Once(function(Playback: Enum.PlaybackState)
				if Playback == Enum.PlaybackState.Completed then
					GuiObject.Visible = false;
				end
			end)
			Tween:Play();
		end
	end
end

local function ConnectObserved(Observed: GuiObject)
	local OriginalSize = Observed.Size;

	Observed.MouseEnter:Connect(function()
		TweenService:Create(Observed, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(OriginalSize.X.Scale * 1.1, OriginalSize.Y.Scale * 1.1);
		}):Play();
	end)

	Observed.MouseLeave:Connect(function()
		TweenService:Create(Observed, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = OriginalSize;
		}):Play();
	end)
	
	Observed.InputBegan:Connect(function(Input: InputObject)
		if HelperFunctions.IsClick(Input) then
			ClickSound:Play();
			TweenService:Create(Observed, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Size = UDim2.fromScale(OriginalSize.X.Scale * 0.9, OriginalSize.Y.Scale * 0.9);
			}):Play();
		end
	end)

	Observed.InputEnded:Connect(function(Input: InputObject)
		if HelperFunctions.IsClick(Input) then
			TweenService:Create(Observed, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
				Size = OriginalSize;
			}):Play();
		end
	end);
	
	return function() end;
end

ObserveTag.ObserveTag(AnimateTag, function(Observed: Instance)
	if not Observed:IsA("GuiObject") then
		error(Observed.Name.." Is Not a GuiObject for Tag: "..AnimateTag);
		return function() end;
	end
	
	return ConnectObserved(Observed);
end)

ObserveTag.ObserveTag(BasicTag, function(Observed: Instance)
	if not Observed:IsA("GuiObject") then
		error(Observed.Name.." Is Not a GuiObject for Tag: "..AnimateTag);
		return function() end;
	end

	return ConnectObserved(Observed);
end)

ObserveTag.ObserveTag(OpenTag, function(Observed: Instance)
	if Observed:IsA("GuiObject") then
		local IsVisible = Observed:GetAttribute("IsVisible");
		Observed.Visible = IsVisible or false;
	end
	
	if not Observed:FindFirstChild("UIScale") then
		local Scale = Instance.new("UIScale");
		Scale.Parent = Observed;
	end
	
	Observed:GetAttributeChangedSignal("IsVisible"):Connect(function()
		module.MakeVisible(Observed, Observed:GetAttribute("IsVisible"));
	end)
	
	return function() end
end)

return module;

