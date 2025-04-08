--!strict

-- By Wa1er_God --

local NoColor = Color3.new(1, 0.0117647, 0.027451);

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");

local Helper = require(ReplicatedStorage.Modules.HelperFunctions);

local Extra = ReplicatedStorage.ModelStorage.Extra;
local CollisionReference = Extra.CollisionRadius;
local CylinderCast = Extra.CylinderCast;

local RangeParts = workspace.RangeParts;

local Client = ReplicatedStorage.Client;
local PlacementValues = Client.Values.Placement;
local InPlacement = PlacementValues.InPlacement;
local PlacementModel = PlacementValues.PlacementModel;
local Map = PlacementValues.Map;
local CanPlaceValue = PlacementValues.CanPlace;

local PartColors: {[BasePart]: Color3} = {};

local function Check(Part: BasePart)
	if not PartColors[Part] then
		PartColors[Part] = Part.Color;

		Part.Destroying:Once(function()
			PartColors[Part] = nil;
		end)
	end
end

local function TweenPartColor(Part: BasePart, Start: boolean)
	Check(Part);
	
	if Start then
		TweenService:Create(
			Part,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{Color = NoColor}
		):Play();
	else
		TweenService:Create(
			Part,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Color = PartColors[Part]}
		):Play();
	end
end

local OriginalTransparency = CollisionReference.Transparency;

local function TweenCollisionTransparency(Part: BasePart, Start: boolean)
	if Start then
		TweenService:Create(
			Part,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{Transparency = OriginalTransparency}
		):Play();
	else
		TweenService:Create(
			Part,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Transparency = 1}
		):Play();
	end
end

InPlacement.Changed:Connect(function(Value: boolean)
	if not Map.Value then
		return;
	end
	
	if Value then
		for _, Descendant in ipairs(Map.Value:GetDescendants()) do
			if Descendant:IsA("BasePart") then
				if not Descendant:HasTag("CanPlace") then
					TweenPartColor(Descendant, true);
				end
			end
		end
	else
		for _, Descendant in ipairs(Map.Value:GetDescendants()) do
			if Descendant:IsA("BasePart") then
				if not Descendant:HasTag("CanPlace") then
					TweenPartColor(Descendant, false);
				end
			end
		end
	end
end)

local CanPlaceGlobal = false;

local CylinderCache: {[number]: BasePart} = {};

local function CloneCylinder(Radius: number)
	if not CylinderCache[Radius] then
		local Cylinder = CylinderCast:Clone();
		Cylinder.Size = Vector3.new(Radius, Cylinder.Size.Y, Radius);
		CylinderCache[Radius] = Cylinder;
	end
	
	return CylinderCache[Radius];
end

local function OnFrame(Model: Model, Override: boolean)
	local OvParams = OverlapParams.new();
	OvParams.FilterType = Enum.RaycastFilterType.Exclude;
	OvParams.CollisionGroup = "CollisionRadius";
	
	local RParams = RaycastParams.new();
	RParams.RespectCanCollide = true;
	RParams.FilterDescendantsInstances = {Model};

	local CollisionPart: ObjectValue = Model:FindFirstChild("CollisionRadius") :: ObjectValue;
	local Part = CollisionPart.Value :: BasePart;
	local Cylinder = CloneCylinder(Part.Size.X);
	Cylinder.CFrame = Part.CFrame;
	
	OvParams.FilterDescendantsInstances = {Model, Part};
	
	local Parts = workspace:GetPartsInPart(Cylinder, OvParams);

	local TouchingForbidPart = false;
	local TouchingNearbyUnit = false;
	local OnAir = true;

	for _, Part in ipairs(Parts) do
		if not Part:HasTag("CanPlace") then
			TouchingForbidPart = true;
		end
		if Part:IsDescendantOf(RangeParts) then
			TouchingNearbyUnit = true;
		end
	end
	
	local Result = workspace:Raycast(Part.Position + Vector3.new(0, 2, 0), - Vector3.yAxis * 4, RParams);
	
	if Result and Result.Instance then
		OnAir = false;
	end
	
	local CanPlace: boolean;
	
	if TouchingForbidPart or TouchingNearbyUnit or OnAir then
		CanPlace = false;
	else
		CanPlace = true;
	end
	
	if CanPlaceGlobal ~= CanPlace or Override then
		if CanPlace then
			for _, Descendant in ipairs(Model:GetDescendants()) do
				if Descendant:IsA("BasePart") then
					Check(Descendant);
					Descendant.Color = PartColors[Descendant];
				end
			end
		else
			for _, Descendant in ipairs(Model:GetDescendants()) do
				if Descendant:IsA("BasePart") then
					Check(Descendant);
					Descendant.Color = NoColor;
				end
			end
		end
		CanPlaceGlobal = CanPlace;
	end
	
	return CanPlace;
end

PlacementModel.Changed:Connect(function(Model: Model?)
	RunService:UnbindFromRenderStep("PlacementFrame");
	if Model then
		OnFrame(Model, true);
		
		RunService:BindToRenderStep("PlacementFrame", Enum.RenderPriority.Character.Value - 1, function()
			local CanPlace = OnFrame(Model, false);
			CanPlaceValue.Value = CanPlace;
		end)
	end
	
	local Start = if Model then true else false;
	
	for _, Part in ipairs(RangeParts:GetChildren()) do
		if Part.Name == "CollisionRadius" then
			TweenCollisionTransparency(Part, Start);
		end
	end
end)