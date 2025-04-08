--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");
local RunService = game:GetService("RunService");

local Modules = ReplicatedStorage.Modules;
local DelayHandler = require(Modules.DelayHandler);
local HelperFunctions = require(Modules.HelperFunctions);

local Remotes = ReplicatedStorage.Remotes;
local UnitClient = Remotes.UnitClient;

local ChangePriority = UnitClient.ChangePriority;
local Placement = UnitClient.Placement;
local Upgrade = UnitClient.Upgrade;
local Sell = UnitClient.Sell;

local GlobalModules = ServerScriptService.GlobalModules;
local Unit = require(GlobalModules.Unit);
local Enemy = require(GlobalModules.Enemy);
local GlobalWave = require(GlobalModules.GlobalWave);

local PlayerData = require(GlobalModules.PlayerData);

local UnitData = require(ServerStorage.Data.UnitData);
local UnitInfo = require(ReplicatedStorage.Shared.UnitInfo);

local CylinderCast = ReplicatedStorage.ModelStorage.Extra.CylinderCast;

local PriorityTypes = Enemy.GetSortTypes();

type ChangePriorityData = {
	UniqueId: string;
	Priority: Enemy.SortType;
};

type PlacementData = {
	Unit: string;
	UnitPosition: Vector3;
	RotationIndex: number;
};

local CylinderCache: {[number]: BasePart} = {};

local function CloneCylinder(Radius: number)
	if not CylinderCache[Radius] then
		local Cylinder = CylinderCast:Clone();
		Cylinder.Size = Vector3.new(Radius, Cylinder.Size.Y, Radius);
		CylinderCache[Radius] = Cylinder;
	end

	return CylinderCache[Radius];
end

ChangePriority.OnServerInvoke = function(Player: Player, Data: ChangePriorityData): Enemy.SortType?
	local CurrentUnit = Unit.GetUnit(Data.UniqueId);
	
	if CurrentUnit then
		if CurrentUnit.Owner == Player then
			if DelayHandler("ChangeUnitPriority"..Player.UserId, 0.2) then
				if typeof(Data.Priority) == "string" and table.find(PriorityTypes, Data.Priority) then
					return CurrentUnit:ChangePriority(Data.Priority);
				else
					return CurrentUnit:ChangePriority();
				end
			end
		end
	end
	
	return nil;
end

local function CheckPlacement(InputCFrame: CFrame, UnitData: Unit.UnitInput): RaycastResult?
	local UnitPos = HelperFunctions.ConvertToVec2(InputCFrame.Position);
	
	for UniqueId, OtherUnit in pairs(Unit.GetUnits()) do
		local Radius = UnitData.CollisionRadius + OtherUnit.CollisionRadius;
		local OtherPos = HelperFunctions.ConvertToVec2(OtherUnit.CFrame.Position);
		
		if (UnitPos - OtherPos).Magnitude < Radius / 2 then
			return;
		end
	end
	
	local RayParams = RaycastParams.new();
	RayParams.FilterType = Enum.RaycastFilterType.Exclude;
	RayParams.CollisionGroup = "PlacementClient";
	
	local Raycast = workspace:Raycast(InputCFrame.Position + Vector3.new(0, 1, 0), -Vector3.yAxis * 4, RayParams);
	
	if Raycast and Raycast.Instance then
		if Raycast.Instance:HasTag("CanPlace") then
			local OvParams = OverlapParams.new();
			OvParams.FilterType = Enum.RaycastFilterType.Exclude;
			OvParams.CollisionGroup = "PlacementClient";
			
			local Cylinder = CloneCylinder(UnitData.CollisionRadius);
			local Parts = workspace:GetPartsInPart(Cylinder, OvParams);
			
			for _, BasePart in ipairs(Parts) do
				if not BasePart:HasTag("CanPlace") then
					return;
				end
			end
		else
			return;
		end
	else
		return;
	end
	
	return Raycast;
end

local function PlaceUnit(Player: Player, Wave: GlobalWave.GlobalWave, Data: PlacementData)
	local InputCFrame = CFrame.new(Data.UnitPosition) * CFrame.Angles(0, math.rad(-90 * Data.RotationIndex), 0);
	
	local UnitData = UnitData.UnitData[Data.Unit];
	
	if UnitData then
		local Cost = UnitData.UpgradeData[0].Cost;

		--if Wave:HasEnoughYen(Player.UserId, Cost) then
			local Result = CheckPlacement(InputCFrame, UnitData);
			if Result then
				local Unit = Unit.new({
					CFrame = InputCFrame;
					Level = 0;
				}, UnitData);

				--Wave:AddUnit(Unit);
				--Wave:SubtractYen(Player.UserId, Cost);
			--end
		end
	end
end

local function OnPlacement(Player: Player, Data: PlacementData)
	local PlayerData = PlayerData.GetPlayerData(Player);
	
	if PlayerData then
		local Wave = GlobalWave.GetWave();
		if Wave then
			PlaceUnit(Player, Wave, Data);
		end
	end
end


Placement.OnServerEvent:Connect(function(Player: Player, Data: PlacementData)
	if typeof(Data.Unit) ~= "string" or typeof(Data.UnitPosition) ~= "Vector3" or typeof(Data.RotationIndex) ~= "number" then
		return;
	end
	if HelperFunctions.IsNan(Data.UnitPosition) or HelperFunctions.IsNan(Data.RotationIndex) or not HelperFunctions.IsInteger(Data.RotationIndex) then
		return;
	end
	OnPlacement(Player, Data);
end)

type UpgradeData = {
	UniqueId: string;
}

Upgrade.OnServerEvent:Connect(function(Player: Player, Data: UpgradeData)
	local CurrentUnit = Unit.GetUnit(Data.UniqueId);
	
	if CurrentUnit and CurrentUnit.Owner == Player then
		CurrentUnit:Upgrade();
	end
end)

Sell.OnServerEvent:Connect(function(Player: Player, UniqueId: string)
	local CurrentUnit = Unit.GetUnit(UniqueId);
	
	if CurrentUnit then
		CurrentUnit:Delete();
	end
end)