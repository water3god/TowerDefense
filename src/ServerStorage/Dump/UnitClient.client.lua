--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local UnitModels: {[string]: Model} = {};
for _, Model in ipairs(ReplicatedStorage.ModelStorage.Units:GetChildren()) do
	UnitModels[Model.Name] = Model;
end

local UnitFolder = workspace.Units;

local Events = ReplicatedStorage.Remotes.Unit;

local Attack = Events.Attack;
local Destroy = Events.DestroyEvent;
local Placement = Events.PlacementEvent;
local Upgrade = Events.Upgrade;

local UnitTranslate = script:WaitForChild("UnitTranslate");
local UnitRotate = script:WaitForChild("UnitRotate");

export type PlacementData = {
	ModelName: string;
	CFrame: CFrame;
	OwnerId: number;
	AttackPriority: string;
	Level: number;
	UpgradeData: {
		[number]: {
			Range: number;
			Damage: {number};
			FireRate: number;
			Armor: Model?;
			Animations: {Animation};
		};
	};
	UniqueId: string;
};

local Data = {};

type ClientData = {
	Character: Model;
	Root: BasePart;
	
	UnitTranslate: AlignPosition;
	UnitRotate: AlignOrientation;
};

local UnitData: {[string]: PlacementData} = {};
local ClientData: {[string]: ClientData} = {};

Data.UnitData = UnitData;
Data.ClientData = ClientData;

function Data.GetDataFromChar(Character: Model): (PlacementData?, ClientData?)
	for Id, Item in pairs(ClientData) do
		if Item.Character == Character and UnitData[Id] then
			return UnitData[Id], Item;
		end
	end
	
	return nil;
end

Attack.OnClientEvent:Connect(function()
	
end)

Destroy.OnClientEvent:Connect(function(UniqueId: string)
	
end)

local function CreateData(Data: PlacementData)
	ClientData[Data.UniqueId] = {} :: any;
	local ClientData = ClientData[Data.UniqueId];
	
	local Character = UnitModels[Data.ModelName]:Clone();
	Character:PivotTo(Data.CFrame);
		
	local Root = Character.PrimaryPart :: Part;
	ClientData.Root = Root;
	
	local RootAttachment: Attachment = (Root :: any).RootAttachment;
	
	local UnitTranslate = UnitTranslate:Clone();
	UnitTranslate.Attachment0 = RootAttachment;
	UnitTranslate.Position = Data.CFrame.Position;
	UnitTranslate.Parent = Root;
	
	local UnitRotate = UnitRotate:Clone();
	UnitRotate.Attachment0 = RootAttachment;
	UnitRotate.CFrame = Data.CFrame;
	UnitRotate.Parent = Root;
		
	Character.Parent = UnitFolder;
	ClientData.Character = Character;
end

Placement.OnClientEvent:Connect(function(Data: {[string]: PlacementData})
	for Id: string, Unit: PlacementData in pairs(Data) do
		if not UnitData[Id] then
			UnitData[Id] = Unit;
			UnitData[Id].UniqueId = Id;
			CreateData(UnitData[Id]);
		end
	end
end)

Upgrade.OnClientEvent:Connect(function(Data: {UniqueId: string, Level: number})
	
end)

