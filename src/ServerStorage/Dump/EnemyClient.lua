--!strict

--10-24-2024

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");

local Nodes = workspace:WaitForChild("Nodes");
local Random = Random.new();

local Events = ReplicatedStorage.Remotes.Enemy;
local MoveEvent = Events.MoveEvent;
local SpawnEvent = Events.SpawnEvent;
local DestroyEvent = Events.DestroyEvent;
local SpeedEvent = Events.SpeedEvent;
local NodeEvent = Events.NodeEvent;
local DamageEvent = Events.DamageEvent;

local GoodSignal = require(ReplicatedStorage.Modules.GoodSignal);

local Types = require(script.Parent.Types);

local ModelStorage = ReplicatedStorage.ModelStorage;

local EnemyModels: {[string]: Model} = {};

for _, Enemy in ipairs(ModelStorage.Enemies:GetChildren()) do
	EnemyModels[Enemy.Name] = Enemy;
end
local Adornments: {[string]: Model} = {};
for _, Model in ipairs(ModelStorage.Adornments:GetChildren()) do
	Adornments[Model.Name] = Model;
end


local EnemyTranslate: AlignPosition = script:WaitForChild("EnemyTranslate");
local EnemyRotate: AlignOrientation = script:WaitForChild("EnemyRotate");

type FrameData = {
	X: number;
	Z: number;
	rY: number;
}

local function IsNan(CFrame: CFrame)
	for _, Comp in pairs(table.pack(CFrame:GetComponents())) do
		if Comp ~= Comp then
			return true;
		end
	end

	return false;
end

local function CleanClientData(Data: Types.EnemyClientData)
	Data.HealthChanged:DisconnectAll();
	
	Data.Character:Destroy();
	Data.Character = nil :: any;

	if Data.StateConnection then
		Data.StateConnection:Disconnect();
	end
end

local function DisableHumanoid(Humanoid: Humanoid)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false);
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false);
end

local function OnSpeedChange(ServerData: Types.EnemyServerData, ClientData: Types.EnemyClientData)
	ClientData.EnemyRotate.MaxAngularVelocity = ServerData.Speed;
end

local SizeRatio = 0.5;

local function WeldParts(Character: Model, Adornment: Model)
	for _, Limb in ipairs(Adornment:GetChildren()) do
		if not Limb:IsA("Model") then
			continue;
		end
		local CharLimb: BasePart? = Character:FindFirstChild(Limb.Name) :: BasePart;
		local Middle: BasePart = Limb:FindFirstChild("Middle") :: BasePart;

		if not Middle then
			warn("No BasePart Called Middle For: "..Limb.Name);
		end

		if not CharLimb then
			continue;
		end

		for _, BasePart in ipairs(Limb:GetDescendants()) do
			if BasePart:IsA("BasePart") and BasePart.Name ~= "Middle" then
				BasePart.CanCollide = false;
				BasePart.Anchored = false;

				local Offset = Middle.CFrame:ToObjectSpace(BasePart.CFrame);
				local ScaledOffset = CFrame.new(
					Offset.X * SizeRatio, Offset.Y * SizeRatio, Offset.Z * SizeRatio
					
				) * Offset.Rotation;

				local WorldCFrame = ScaledOffset:ToWorldSpace(CharLimb.CFrame);

				local Weld = Instance.new("WeldConstraint");
				BasePart.CFrame = WorldCFrame;
				Weld.Name = BasePart.Name;
				Weld.Part0 = BasePart;
				Weld.Part1 = Middle;
				Weld.Parent = Middle;
			end
		end

		Middle.CFrame = CharLimb.CFrame;
		local Weld = Instance.new("WeldConstraint");
		Weld.Name = "MainMiddleWeld";
		Weld.Part0 = Middle;
		Weld.Part1 = CharLimb;
		Weld.Parent = Middle;
	end
end

local function HandleAdornment(ClientData: Types.UnitClientData, ServerData: Types.UnitServerData)
	local CurrentLevel = ServerData.Level;

	local AdornmentName = ServerData.UpgradeData[tostring(CurrentLevel)].Armor;

	if AdornmentName then
		if not ClientData.CurrentAdornment or AdornmentName ~= ClientData.CurrentAdornment.Name then
			if ClientData.CurrentAdornment then
				ClientData.CurrentAdornment:Destroy();
				ClientData.CurrentAdornment = nil;
			end

			local Adornment = Adornments[AdornmentName]:Clone();
			WeldParts(ClientData.Character, Adornment);
			Adornment.Parent = ClientData.Character;
			ClientData.CurrentAdornment = Adornment;
		end
	end
end

local function CreateClientData(ServerData: Types.EnemyServerData, Data: Types.EnemyClientData)
	Data.HealthChanged = GoodSignal.new();
	
	Data.Character = EnemyModels[ServerData.ModelName]:Clone();

	local Humanoid = Data.Character:FindFirstChildWhichIsA("Humanoid") :: Humanoid;
	DisableHumanoid(Humanoid);
	Data.Humanoid = Humanoid;

	local Animator = Humanoid:FindFirstChildWhichIsA("Animator") :: Animator;
	Data.Animator = Animator;

	local Root = Data.Character.PrimaryPart :: BasePart;
	Data.Root = Root;

	local RootAttachment = Root:FindFirstChild("RootAttachment") :: Attachment;

	local EnemyTranslate = EnemyTranslate:Clone();
	EnemyTranslate.Attachment0 = RootAttachment;
	EnemyTranslate.MaxVelocity = ServerData.Speed;
	EnemyTranslate.Parent = Root;

	local EnemyRotate = EnemyRotate:Clone();
	EnemyRotate.Attachment0 = RootAttachment;
	EnemyRotate.Parent = Root;
	
	Data.PositionOffset = Vector3.new(Random:NextNumber(-1, 1), 0, Random:NextNumber(-1, 1));

	Data.EnemyTranslate = EnemyTranslate;
	Data.EnemyRotate = EnemyRotate;
	
	Data.OldPosition = ServerData.CFrame.Position;

	Root.CFrame = ServerData.CFrame + Data.PositionOffset;
	EnemyTranslate.Position = ServerData.CFrame.Position + Data.PositionOffset;
	EnemyRotate.CFrame = ServerData.CFrame + Data.PositionOffset;

	Data.FirstCFrame = ServerData.CFrame;
	Data.CurrentCFrame = "FirstCFrame";

	if not Data.SecondCFrame then
		repeat task.wait();
		until Data.SecondCFrame;
	end
	
	if Data.Character then
		Data.Character.Parent = workspace.Enemies;

		for _, Part in ipairs(Data.Character:GetChildren()) do
			if Part:IsA("BasePart") then
				Part.CollisionGroup = "PlacedCharacters";
			end
		end

		OnSpeedChange(ServerData, Data);
	end
end

local Data = {};
local ServerData: {[string]: Types.EnemyServerData} = {};
local ClientData: {[string]: Types.EnemyClientData} = {};

Data.ServerData = ServerData;
Data.ClientData = ClientData;

function Data.GetDataFromChar(Character: Model): (Types.EnemyServerData?, Types.EnemyClientData?)
	for Id, Item in pairs(ClientData) do
		if Item.Character == Character and ServerData[Id] then
			return ServerData[Id], Item;
		end
	end

	return nil;
end

function Data.CleanEnemy(UniqueId: string)
	ServerData[UniqueId] = nil;
	if ClientData[UniqueId] then
		CleanClientData(ClientData[UniqueId]);
	end
end

function Data.GetRangedEnemies(Position: Vector3, Range: number)
	local Position = Vector3.new(Position.X, 0, Position.Z);
	local Enemies: {string} = {};
	
	for Id, Data in pairs(ClientData) do
		local EnemyPosition = Vector3.new(Data.Root.Position.X, 0, Data.Root.Position.Z);
		
		if (EnemyPosition - Position).Magnitude <= Range then
			table.insert(Enemies, Id);
		end
	end
	
	return Enemies;
end

export type SortType = "First" | "Last" | "Strongest" | "Weakest";
local SortType: {SortType} = {"First", "Last", "Strongest", "Weakest"};

function Data.GetSortedEnemy(GivenEnemies: {string}, SortType: SortType)
	local NearestEnemy: string = nil;

	if SortType == "First" then
		local ClosestNode: number = 1;
		local ClosestPosition: Vector3 = nil;

		for _, Id in pairs(GivenEnemies) do
			local Enemy = ServerData[Id];

			if not Enemy then
				continue;
			end
			
			if not NearestEnemy then
				ClosestNode = Enemy.Node;
				NearestEnemy = Id;
				ClosestPosition = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z);
			end

			if Enemy.Node > ClosestNode then
				local CurrentPosition = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z);
				ClosestNode = Enemy.Node;
				NearestEnemy = Id;
				ClosestPosition = CurrentPosition;
			elseif Enemy.Node == ClosestNode then
				local NodePart = Enemy.Nodes[Enemy.Node + 1];

				if not NodePart then
					continue;
				end

				local CurrentPosition = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z);
				local NodePosition = Vector3.new(NodePart.Position.X, 0, NodePart.Position.Z);

				if (NodePosition - CurrentPosition).Magnitude < (NodePosition - ClosestPosition).Magnitude then
					ClosestNode = Enemy.Node;
					NearestEnemy = Id;
					ClosestPosition = CurrentPosition;
				end
			end
		end
	elseif SortType == "Last" then
		local ClosestNode: number = 1;
		local ClosestPosition: Vector3 = nil;

		for _, Id in ipairs(GivenEnemies) do
			local Enemy = ServerData[Id];
			
			if not Enemy then
				continue;
			end
			
			if not NearestEnemy then
				ClosestNode = Enemy.Node;
				NearestEnemy = Id;
				ClosestPosition = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z);
			end

			if Enemy.Node < ClosestNode then
				local CurrentPosition = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z);
				ClosestNode = Enemy.Node;
				NearestEnemy = Id;
				ClosestPosition = CurrentPosition;
			elseif Enemy.Node == ClosestNode then
				local NodePart = Enemy.Nodes[Enemy.Node + 1];

				if not NodePart then
					continue;
				end

				local CurrentPosition = Vector3.new(Enemy.CFrame.Position.X, 0, Enemy.CFrame.Position.Z);
				local NodePosition = Vector3.new(NodePart.Position.X, 0, NodePart.Position.Z);

				if (NodePosition - CurrentPosition).Magnitude > (NodePosition - ClosestPosition).Magnitude then
					ClosestNode = Enemy.Node;
					NearestEnemy = Id;
					ClosestPosition = CurrentPosition;
				end
			end
		end
	elseif SortType == "Strongest" then
		local MostHealth = 0;

		for _, Id in ipairs(GivenEnemies) do
			local Enemy = ServerData[Id];

			if not Enemy then
				continue;
			end
			
			if Enemy.Health >= MostHealth then
				MostHealth = Enemy.Health;
				NearestEnemy = Id;
			end
		end
	elseif SortType == "Weakest" then
		
		local LeastHealth = math.huge;

		for _, Id in ipairs(GivenEnemies) do
			local Enemy = ServerData[Id];

			if not Enemy then
				continue;
			end
			if Enemy.Health <= LeastHealth then
				LeastHealth = Enemy.Health;
				NearestEnemy = Id;
			end
		end
	end
	
	return NearestEnemy;
end

NodeEvent.OnClientEvent:Connect(function(Data: {[string]: number})
	for Id, Node in pairs(Data) do
		local ServerData = ServerData[Id];
		
		if ServerData then
			ServerData.Node = Node;
		end
	end
end)

SpawnEvent.OnClientEvent:Connect(function(Data: {[string]: Types.EnemyServerData})
	for Id, EnemyData in pairs(Data) do
		if ServerData[Id] then
			continue;
		end

		ServerData[Id] = EnemyData;

		ClientData[Id] = {} :: any;
		CreateClientData(EnemyData, ClientData[Id]);
	end
end)

MoveEvent.OnClientEvent:Connect(function(Data: {[string]: FrameData})

	for Id, EnemyData in pairs(Data) do
		if not ServerData[Id] or not ClientData[Id] then
			continue;
		end

		local ServerData = ServerData[Id];
		local ClientData = ClientData[Id];
		
		local EnemyCFrame = CFrame.new(EnemyData.X, ServerData.TranslatedY, EnemyData.Z)
			* CFrame.Angles(0, EnemyData.rY, 0);

		ServerData.CFrame = EnemyCFrame;
		
		if ClientData.SecondCFrame then
			ClientData.FirstCFrame = ClientData.SecondCFrame;
			ClientData.SecondCFrame = EnemyCFrame;
			ClientData.CurrentCFrame = "FirstCFrame";
		else
			ClientData.FirstCFrame = EnemyCFrame;
			ClientData.SecondCFrame = EnemyCFrame;
			ClientData.CurrentCFrame = "FirstCFrame";
		end
	end
	
end)

SpeedEvent.OnClientEvent:Connect(function(Data: {[string]: number})
	for Id, Speed in pairs(Data) do
		local ServerData = ServerData[Id];
		local ClientData = ClientData[Id];
		
		if ServerData and ClientData then
			ServerData.Speed = Speed;
			
			ClientData.EnemyTranslate.MaxVelocity = ServerData.Speed;
		end
	end
end)

DestroyEvent.OnClientEvent:Connect(function(Ids: {string})
	for _, Id in ipairs(Ids) do
		if ClientData[Id] then
			CleanClientData(ClientData[Id]);
			ClientData[Id] = nil;
		end
		ServerData[Id] = nil;
	end
end)

DamageEvent.OnClientEvent:Connect(function(Id: string, Health: number)
	local ServerData = ServerData[Id];
	local ClientData = ClientData[Id];
	
	if ServerData and ClientData then
		ServerData.Health = Health;
		ClientData.HealthChanged:Fire(Health);
	end
end)

local function GetLerpAlphaCFrame(CFrame1: CFrame, CFrame2: CFrame, LerpCFrame: CFrame)
	local Distance = (CFrame2.Position - CFrame1.Position).Magnitude;
	local AlphaDistance = (LerpCFrame.Position - CFrame1.Position).Magnitude;
	
	return AlphaDistance / Distance;
end

local function GetLerpAlphVec(Vec1: Vector3, Vec2: Vector3, LerpVec: Vector3)
	local DefaultDistance = (Vec2 - Vec1).Magnitude;
	local AlphaDistance = (LerpVec - Vec1).Magnitude;
	
	return AlphaDistance / DefaultDistance;
end

RunService.PreAnimation:Connect(function(Delta: number)
	for Id, Data in pairs(ServerData) do
		local Client = ClientData[Id];

		if not Client then
			continue;
		end
		
		--print(((Client.Root.CFrame.Position - Client.PositionOffset) - Data.CFrame.Position).Magnitude)
		
		local CurrentCFrame: CFrame = Client[Client.CurrentCFrame];

		if Client.CurrentCFrame == "FirstCFrame" and Client.SecondCFrame then
			if ((Client.Root.Position - Client.PositionOffset) - Client.FirstCFrame.Position).Magnitude < 0.2 then
				Client.OldCFrame = Client.FirstCFrame;
				Client.FirstCFrame = Client.SecondCFrame;
				Client.CurrentCFrame = "SecondCFrame";
			end
		end
		
		--print(((Client.Root.CFrame.Position - Client.PositionOffset) - Client[Client.CurrentCFrame].Position).Magnitude)
		
		--[[if Client.EnemyTranslate.Active then
			if ((Client.Root.CFrame.Position - Client.PositionOffset) - Client[Client.CurrentCFrame].Position).Magnitude >= 0.4 * Data.Speed then
				Client.Root.CFrame = CFrame.new(Client.EnemyTranslate.Position) * Client.Root.CFrame.Rotation;
			end
		end]]

		Client.EnemyTranslate.Position = CurrentCFrame.Position + Client.PositionOffset;

		Client.OldPosition = CurrentCFrame.Position;
		Client.EnemyRotate.CFrame = CurrentCFrame + Client.PositionOffset;
	end
end)

local Count = 0;

RunService.PostSimulation:Connect(function()
	Count += 1
	if Count < 100 then
		return;
	end
	--Count = 0;
	--[[for Id, Data in pairs(ServerData) do
		if IsNan(Data.CFrame) then
			print(Data.CFrame);
		end
	end]]
end)

return Data;