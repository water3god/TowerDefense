--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GameSettings = UserSettings().GameSettings;

local Modules = ReplicatedStorage.Modules;
local Promise = require(Modules.Promise);

local UnitData = require(script.UnitClientData);

local UnitStorage: {[string]: Model} = {};
for _, Unit in ipairs(ReplicatedStorage.ModelStorage.Units:GetChildren()) do
	UnitStorage[Unit.Name] = Unit;
end

local UnitShowcase = {};

type ViewportData = {CurrentModel: Model?, WorldModel: WorldModel};
local ViewportData: {[ViewportFrame]: ViewportData} = {};

local function ClearViewport()
	
end

local function DisableAnimate(CurrentModel: Model)
	local Humanoid = CurrentModel:FindFirstChildWhichIsA("Humanoid") :: Humanoid;
	(CurrentModel:WaitForChild("Animate") :: LocalScript).Enabled = false;

	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false);
end

function UnitShowcase.ConnectViewport(Viewport: ViewportFrame)
	if not Viewport:IsA("ViewportFrame") then
		warn(tostring(Viewport.Name).."Is Not a viewportFrame");
	end
	
	local Camera = Instance.new("Camera");
	Camera.CFrame = CFrame.new(0, 3, -3) * CFrame.Angles(math.rad(0), math.rad(180), 0);
	Camera.Parent = Viewport;
	Viewport.CurrentCamera = Camera;

	local WorldModel = Instance.new("WorldModel");
	WorldModel.Parent = Viewport;
	
	ViewportData[Viewport] = {WorldModel = WorldModel};
	
	Viewport.Destroying:Once(function()
		local Data = ViewportData[Viewport];
		
		if Data then
			ViewportData[Viewport] = nil;
		end
	end)
end

function UnitShowcase.LoadIdle(Model: Model, UnitName: string)
	local UnitData = UnitData[UnitName];
	
	local Humanoid = Model:FindFirstChildWhichIsA("Humanoid") :: Humanoid;
	local Animator = Humanoid:FindFirstChildWhichIsA("Animator") :: Animator;
	
	local IdleId = UnitData.Animations["Idle"];

	if IdleId then
		local Animation = Instance.new("Animation");
		Animation.AnimationId = IdleId;

		local Anim = Animator:LoadAnimation(Animation);
		Anim.Looped = true;

		Anim:Play();
	end
end

function UnitShowcase.AnimateViewport(Viewport: ViewportFrame, UnitName: string)
	local ViewData = ViewportData[Viewport];
	local UnitData = UnitData[UnitName];
	
	if ViewData and UnitData then
		
		if ViewData.CurrentModel then
			if ViewData.CurrentModel.Name == UnitName then
				return;
			end
		end
		
		local Model = UnitData.Character:Clone();
		DisableAnimate(Model);
		(Model.PrimaryPart :: BasePart).Anchored = true;
		Model:PivotTo(CFrame.new());
		
		Model.Parent = ViewData.WorldModel;
		
		UnitShowcase.LoadIdle(Model, UnitName);
		
		ViewData.CurrentModel = Model;
	else
		if not ViewData then
			warn(tostring(Viewport.Name).."Viewport is not connected!");
		end
		if not UnitData then
			warn(tostring(UnitName).."Name does not exist!");
		end
		
	end
end

function UnitShowcase.DisconnectViewport(View: ViewportFrame)
	
end

function UnitShowcase.SetFrameImageId(Frame: ImageLabel, UnitName: string)
	local Data = UnitData[UnitName];
	
	if Data then
		Frame.Image = Data.DefaultImage;
	else
		warn(tostring(UnitName).."Name does not exist!");
	end
end

function UnitShowcase.GetUnits()
	return UnitData;
end

return UnitShowcase;