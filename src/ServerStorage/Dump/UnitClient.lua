--!strict

-- By Wa1er_God --

local SizeRatio = 0.5;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");

local ModelStorage = ReplicatedStorage.ModelStorage;

local UnitModels: {[string]: Model} = {};
for _, Model in ipairs(ModelStorage.Units:GetChildren()) do
	UnitModels[Model.Name] = Model;
end
local Adornments: {[string]: Model} = {};
for _, Model in ipairs(ModelStorage.Adornments:GetChildren()) do
	Adornments[Model.Name] = Model;
end

local Extra = ModelStorage.Extra;
local CollisionRadius = Extra.CollisionRadius;

local ClientFuncs = require(script.ClientFuncs);
local UnitFolder = workspace.Units;
local RangeParts = workspace.RangeParts;

local Shared = ReplicatedStorage.Shared;
local Modules = ReplicatedStorage.Modules;

local EnemyDamages = require(Shared.EnemyDamages);
local Trove = require(Modules.Trove);
local GoodSignal = require(Modules.GoodSignal);

local Events = ReplicatedStorage.Remotes.Unit;

local Attack = Events.Attack;
local Destroy = Events.DestroyEvent;
local Placement = Events.PlacementEvent;
local Upgrade = Events.Upgrade;

local UnitTranslate = script:WaitForChild("UnitTranslate");
local UnitRotate = script:WaitForChild("UnitRotate");

local CollisionReference = script:WaitForChild("CollisionRadius");
local RangeDisplayReference = script:WaitForChild("RangeDisplay");

--local EnemyClient = require(script.Parent.EnemyClient);
local Types = require(script.Parent.Types);

local Data = {};

local UnitData: {[string]: Types.UnitServerData} = {};
local ClientData: {[string]: Types.UnitClientData} = {};

Data.UnitData = UnitData;
Data.ClientData = ClientData;

Data.Deleted = GoodSignal.new();

function Data.GetDataFromChar(Character: Model): (Types.UnitServerData?, Types.UnitClientData?)
	for Id, Item in pairs(ClientData) do
		if Item.Character == Character and UnitData[Id] then
			return UnitData[Id], Item;
		end
	end

	return nil;
end

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

local function CreateAnimations(UnitClient: Types.UnitClientData, AnimationIds: {[string]: number})
	local Animator = UnitClient.Animator;
	local Tracks = UnitClient.Tracks;
	
	for Name, Track in pairs(Tracks) do
		if not AnimationIds[Name] then
			Track:Destroy();
			Tracks[Name] = nil;
		end
	end
	
	for Name, AnimationId in pairs(AnimationIds) do
		if Tracks[Name] then
			continue;
		end
		
		local Animation = Instance.new("Animation");
		Animation.AnimationId = "rbxassetid://"..AnimationId;
		local Track = Animator:LoadAnimation(Animation);
		Track.Name = UnitClient.Character.Name.." "..Name;
		
		Tracks[Name] = Track;
	end
	
	return Tracks; 
end

local function CreateData(Data: Types.UnitServerData)
	ClientData[Data.UniqueId] = {} :: any;
	local ClientData = ClientData[Data.UniqueId];
	
	ClientData.LevelChanged = GoodSignal.new();

	local Character = UnitModels[Data.ModelName]:Clone();

	local Root = Character.PrimaryPart :: Part;
	ClientData.Root = Root;
	
	Character:PivotTo(Data.CFrame - Vector3.new(0, 3, 0));
	
	local Animator = Character:FindFirstChildWhichIsA("Animator", true) :: Animator;
	
	ClientData.Animator = Animator;

	local RootAttachment: Attachment = (Root :: any).RootAttachment;

	local UnitTranslate = UnitTranslate:Clone();
	UnitTranslate.Attachment0 = RootAttachment;
	UnitTranslate.Position = Data.CFrame.Position;
	UnitTranslate.Parent = Root;

	local UnitRotate = UnitRotate:Clone();
	UnitRotate.Attachment0 = RootAttachment;
	UnitRotate.CFrame = Data.CFrame;
	UnitRotate.Parent = Root;
	
	local CollisionRadius = CollisionRadius:Clone();
	local Frame, Size = Character:GetBoundingBox();
	CollisionRadius.CFrame = Frame - Vector3.new(0, Size.Y/2, 0);
	CollisionRadius.CollisionGroup = "CollisionRadius";
	CollisionRadius.Transparency = 1;
	CollisionRadius.Size = Vector3.new(Data.CollisionRadius, CollisionRadius.Size.Y, Data.CollisionRadius);
	CollisionRadius.Parent = RangeParts;
	
	local CollisionReference = CollisionReference:Clone();
	CollisionReference.Value = CollisionRadius;
	CollisionReference.Parent = Character;
	
	local RangeReference = RangeDisplayReference:Clone();
	RangeReference.Parent = Character;
	
	CollisionReference.Destroying:Once(function()
		CollisionRadius:Destroy();
	end)
	
	
	local function EveryFrame()
		local Range = Data.UpgradeData[tostring(Data.Level)].Range;

		ClientData.CurrentEnemyId = EnemyClient.GetSortedEnemy(
			EnemyClient.GetRangedEnemies(Root.Position, Range),
			Data.AttackPriority :: any
		);

		local EnemyClientData = EnemyClient.ClientData[ClientData.CurrentEnemyId :: any];
		if EnemyClientData then
			local Root = EnemyClientData.Root;

			local EnemyPosition = Vector3.new(Root.Position.X, 0, Root.CFrame.Position.Z);
			local UnitPosition = Vector3.new(Data.CFrame.Position.X, 0, Data.CFrame.Position.Z);

			UnitRotate.CFrame = CFrame.lookAt(UnitPosition, EnemyPosition);
		else
			ClientData.CurrentEnemyId = nil;
		end
	end
	
	ClientData.LookAtConnection = RunService.PostSimulation:Connect(function(Delta: number)
		EveryFrame();
	end)
	
	EveryFrame();

	ClientData.Character = Character;
	
	HandleAdornment(ClientData, Data);
	
	Character.Parent = UnitFolder;
	
	ClientData.Tracks = {};
	CreateAnimations(ClientData, (Data.UpgradeData[tostring(Data.Level)] :: any).Animations);
	
	if ClientData.Tracks["Idle"] then
		ClientData.Tracks["Idle"]:Play();
	end
	
	for _, Descendant in ipairs(Character:GetDescendants()) do
		if Descendant:IsA("BasePart") then
			Descendant.CollisionGroup = "PlacedCharacters";
		end
	end

	local Humanoid = Character:FindFirstChildWhichIsA("Humanoid") :: Humanoid;
	
	local AttackId = EnemyDamages.AttackIds[Data.ModelName];
end

local function DestroyData(Data: Types.UnitClientData)
	Data.LevelChanged:DisconnectAll();
	
	if Data.LookAtConnection then
		Data.LookAtConnection:Disconnect();
	end
	
	if Data.CollideConnection then
		Data.CollideConnection:Disconnect();
	end
	
	Data.Character:Destroy();
end

Destroy.OnClientEvent:Connect(function(UniqueIds: {string})
	for _, UniqueId in ipairs(UniqueIds) do
		local UnitClientData = ClientData[UniqueId];
		local UnitServerData = UnitData[UniqueId];

		if UnitClientData then
			Data.Deleted:Fire(UnitClientData, UnitServerData);
			DestroyData(UnitClientData);
			ClientData[UniqueId] = nil;
		end
	end
end)

Placement.OnClientEvent:Connect(function(Data: {[string]: Types.UnitServerData})
	for Id: string, Unit: Types.UnitServerData in pairs(Data) do
		if not UnitData[Id] then
			UnitData[Id] = Unit;
			UnitData[Id].UniqueId = Id;
			CreateData(UnitData[Id]);
		end
	end
end)

local function OnUpgrade(Data: {UniqueId: string, Level: number})
	local ClientData = ClientData[Data.UniqueId];
	local ServerData = UnitData[Data.UniqueId];
	
	if not ClientData or not ServerData then
		return;
	end
	
	ServerData.Level = Data.Level;
	ClientData.LevelChanged:Fire(Data.Level);
	
	CreateAnimations(ClientData, (ServerData.UpgradeData[tostring(Data.Level)] :: any).Animations);
	HandleAdornment(ClientData, ServerData);
end

Upgrade.OnClientEvent:Connect(OnUpgrade);

export type AttackData = {
	UniqueId: string;
	AttackId: string;
	AnimationName: string;
	EnemyId: string;
	Firetime: number;
};

local function AnimateDamage(Damage: number)
	
end

local AttackParams = {"ClientData", "ServerData", "TimeFired", "EnemyData"};

local function CheckValidAttack(Data: Types.Param)
	for _, Param in ipairs(AttackParams) do
		if Data[Param] == nil then
			return false;
		end
	end
	
	if not Data.EnemyData.ClientData or not Data.EnemyData.ServerData then
		return false;
	end
	
	return true;
end

local function HandleAttackData(Data: AttackData)
	local ServerDelayTime = Data.Firetime - workspace:GetServerTimeNow();
	
	local UnitClientData = ClientData[Data.UniqueId];
	local UnitServerData = UnitData[Data.UniqueId];
	
	if not UnitClientData or not UnitServerData then
		return;
	end
	
	local AttackAnim = UnitClientData.Tracks[Data.AnimationName];
	
	task.delay(-ServerDelayTime, function()
		if AttackAnim then
			if AttackAnim.IsPlaying then
				AttackAnim:Stop();
			end
			
			AttackAnim:Play();
			AttackAnim.TimePosition = ServerDelayTime;
		end
	end)
	
	local CurrentEnemyClient = EnemyClient.ClientData[Data.EnemyId];
	local CurrentEnemyServer = EnemyClient.ServerData[Data.EnemyId];
	local ParamData: Types.Param = {
		ClientData = UnitClientData :: any;
		ServerData = UnitServerData :: any;
		TimeFired = Data.Firetime;
		EnemyData = {
			ClientData = CurrentEnemyClient;
			ServerData = CurrentEnemyServer;
		} :: any;
	};
	
	local AttackFuncs = ClientFuncs.Funcs[Data.AttackId];
	
	if AttackFuncs and CheckValidAttack(ParamData) then
		for DelayTime, Func in pairs(AttackFuncs) do
			task.delay(-ServerDelayTime + DelayTime, function()
				Func(ParamData);
			end)
		end
	end
end

Attack.OnClientEvent:Connect(HandleAttackData);

return Data;