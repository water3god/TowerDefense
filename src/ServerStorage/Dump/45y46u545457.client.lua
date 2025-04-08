--!strict

--10-24-2024

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");

local Nodes = workspace:WaitForChild("Nodes");
--local Nodes = Nodes:GetChildren();

local Events = ReplicatedStorage.Remotes.Enemy;
local MoveEvent = Events.MoveEvent;
local SpawnEvent = Events.SpawnEvent;
local DestroyEvent = Events.DestroyEvent;

local EnemyStorage = ReplicatedStorage.ModelStorage.Enemies;
local EnemyModels: {[string]: Model} = {};

for _, Enemy in ipairs(EnemyStorage:GetChildren()) do
	EnemyModels[Enemy.Name] = Enemy;
end

local EnemyTranslate: AlignPosition = script:WaitForChild("EnemyTranslate");
local EnemyRotate: AlignOrientation = script:WaitForChild("EnemyRotate");

type ServerData = {
	UniqueId: string;
	ModelName: string;
	CFrame: CFrame;
	Delay: number;

	Health: number;
	Speed: number;
	Reverse: boolean;
	IsBoss: boolean;
	Ally: boolean;

	Node: number;

	Stuned: boolean;
};

type FrameData = {
	CFrame: CFrame;
}

type ClientData = {
	Character: Model;
	Humanoid: Humanoid;
	Animator: Animator;
	Root: BasePart;
	EnemyTranslate: AlignPosition;
	EnemyRotate: AlignOrientation;
	
	CurrentCFrame: "FirstCFrame" | "SecondCFrame";
	FirstCFrame: CFrame;
	SecondCFrame: CFrame;
	
	StateConnection: RBXScriptConnection;
	
	OldPosition: Vector3;
};

local function CleanClientData(Data: ClientData)
	Data.Character:Destroy();
	
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

local function OnSpeedChange(ServerData: ServerData, ClientData: ClientData)
	ClientData.EnemyRotate.MaxAngularVelocity = ServerData.Speed / 2;
end

local function CreateClientData(ServerData: ServerData, Data: ClientData)
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
	EnemyTranslate.MaxVelocity = ServerData.Speed
	EnemyTranslate.Parent = Root;
	
	local EnemyRotate = EnemyRotate:Clone();
	EnemyRotate.Attachment0 = RootAttachment;
	EnemyRotate.Parent = Root;
	
	Data.EnemyTranslate = EnemyTranslate;
	Data.EnemyRotate = EnemyRotate;
	
	Data.OldPosition = ServerData.CFrame.Position;
	
	Root.CFrame = ServerData.CFrame;
	EnemyTranslate.Position = ServerData.CFrame.Position;
	EnemyRotate.CFrame = ServerData.CFrame;
	
	Data.FirstCFrame = ServerData.CFrame;
	Data.CurrentCFrame = "FirstCFrame";
	
	Data.Character.Parent = workspace.Enemies;
	
	for _, Part in ipairs(Data.Character:GetChildren()) do
		if Part:IsA("BasePart") then
			Part.CanCollide = false;
		end
	end
	
	Data.StateConnection = Humanoid.StateChanged:Connect(function()
		for _, Part in ipairs(Data.Character:GetChildren()) do
			if Part:IsA("BasePart") then
				Part.CanCollide = false;
			end
		end
	end)
	
	OnSpeedChange(ServerData, Data);
end

local ServerData: {[string]: ServerData} = {};
local ClientData: {[string]: ClientData} = {};

--local Last = os.clock();

SpawnEvent.OnClientEvent:Connect(function(Data: {[string]: ServerData})
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
		
		ServerData.CFrame = EnemyData.CFrame;
		
		if ClientData.SecondCFrame then -- If in second frame --
			ClientData.FirstCFrame = ClientData.SecondCFrame;
			ClientData.SecondCFrame = EnemyData.CFrame;
			ClientData.CurrentCFrame = "FirstCFrame";
		else
			ClientData.FirstCFrame = EnemyData.CFrame;
			ClientData.SecondCFrame = EnemyData.CFrame;
			ClientData.CurrentCFrame = "FirstCFrame";
		end
	end
	
	--[[local UsedIds: {string} = {};
	
	for Id, v in pairs(Data) do
		local EnemyData = ServerData[Id];
		table.insert(UsedIds, Id);
		
		if EnemyData then
			for Item, Value in pairs(v) do
				EnemyData[Item] = Value;
			end
		else
			ServerData[Id] = v;
			ClientData[Id] = {} :: any;
			CreateClientData(ServerData[Id], ClientData[Id]);
		end
	end
	
	--[[print(os.clock() - Last);
	Last = os.clock();]]
	
	--[[for Id, Data in pairs(ClientData) do
		if not table.find(UsedIds, Id) then
			CleanClientData(Data);
			ClientData[Id] = nil;
		end
	end
	
	ServerData = Data;]]
	
	--[[local UsedIds: {string} = {};
	
	for Id, Data in pairs(ServerData) do
		table.insert(UsedIds, Id);
		local EnemyClientData = ClientData[Id];
		
		if not EnemyClientData then
			ClientData[Id] = {} :: any;
			CreateClientData(Data, ClientData[Id]);
		end
	end
	
	for Id, Data in pairs(ClientData) do
		if not table.find(UsedIds, Id) then
			CleanClientData(Data);
			Data[Id] = nil;
		end
	end]]
end)

DestroyEvent.OnClientEvent:Connect(function(Id: string)
	if ClientData[Id] then
		CleanClientData(ClientData[Id]);
		ClientData[Id] = nil;
	end
	ServerData[Id] = nil;
end)

RunService.PreAnimation:Connect(function(Delta: number)
	for Id, Data in pairs(ServerData) do
		local Client = ClientData[Id];
		
		if not Client then
			continue;
		end
		
		if (Client.OldPosition - Data.CFrame.Position).Magnitude >= 2 then
			Client.Root.CFrame = Data.CFrame;
		end
		
		if Client.CurrentCFrame == "FirstCFrame" and Client.SecondCFrame then
			if (Client.Root.Position - Client.FirstCFrame.Position).Magnitude < 0.2 then
				Client.FirstCFrame = Client.SecondCFrame;
				Client.CurrentCFrame = "SecondCFrame";
			end
		end
		
		local CurrentCFrame: CFrame = Client[Client.CurrentCFrame];
		
		Client.EnemyTranslate.Position = CurrentCFrame.Position;
		
		Client.OldPosition = CurrentCFrame.Position;
		Client.EnemyRotate.CFrame = CurrentCFrame;
		
		--print(math.round((Client.Root.Position - Client.FirstCFrame.Position).Magnitude * 10)/10, Client.CurrentCFrame)
		
		--[[local p = Instance.new("Part")
		p.Size = Vector3.one
		p.Anchored = true;
		p.CanCollide = false;
		p.CFrame = Data.CFrame;
		p.Parent = workspace;
		
		print(Data.CFrame.Position)]]
	end
end)