--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local TweenService = game:GetService("TweenService");

local UnitsFolder = workspace.Units;
local EnemiesFolder = workspace.Enemies;
local RangeParts = workspace.RangeParts;

local FindAncestor = require(ReplicatedStorage.Modules.FindAncestor);

local Camera = workspace.Camera;
local Player = Players.LocalPlayer;
local PlayerGui = Player.PlayerGui;

local ModelStorage = ReplicatedStorage.ModelStorage;
local Units: {[string]: Model} = {};
for _, Unit in ipairs(ModelStorage.Units:GetChildren()) do
	Units[Unit.Name] = Unit;
end

local RangeDisplay = script:WaitForChild("RangeDisplay");

-- Gui

local CharacterHover = PlayerGui:WaitForChild("CharacterHover") :: ScreenGui;
local EnemyFrame = (CharacterHover :: any).EnemyFrame :: Frame;
local UnitFrame = (CharacterHover :: any).UnitFrame :: Frame;

local UnitGui = PlayerGui:WaitForChild("UnitGui") :: ScreenGui;
local OpenFrame: Frame = (UnitGui :: any).OpenFrame :: Frame;
local UpgradeButton: TextButton = (OpenFrame :: any).UpgradeButton;
local DeleteButton: TextButton = (OpenFrame :: any).DeleteButton;
local UnitNameLabel: TextLabel = (OpenFrame :: any).UnitName;
local LevelLabel: TextLabel = (OpenFrame :: any).Level;

local PlacementGui = PlayerGui:WaitForChild("PlacementGui") :: ScreenGui;
local PlacementFrame: Frame = (PlacementGui :: any).PlaceFrame :: Frame;
local PlaceButton: TextButton = (PlacementFrame :: any).PlaceButton :: TextButton;

local ClientScripts = ReplicatedStorage.Client;

local EnemyClient = require(ClientScripts.EnemyClient);
local UnitClient = require(ClientScripts.UnitClient);
local Types = require(ClientScripts.Types);

local UnitClientEvents = ReplicatedStorage.Remotes.UnitClient;
local UpgradeEvent = UnitClientEvents.Upgrade;
local PlacementEvent = UnitClientEvents.Placement;
local Sell = UnitClientEvents.Sell;

local Connections = {};

local Params = RaycastParams.new();
Params.FilterType = Enum.RaycastFilterType.Exclude;
Params.IgnoreWater = true;

local CurrentName: "Enemy" | "Unit" | nil = nil;
local CurrentModel: Model? = nil;

local function Convert(MousePosition: Vector2)
	local VectorSize = Camera.ViewportSize;
	return UDim2.fromScale(MousePosition.X / VectorSize.X, MousePosition.Y / VectorSize.Y);
end

local function ClearConnections(Connections: {})
	for Index, Connection in pairs(Connections) do
		Connection:Disconnect();
		Connections[Index] = nil;
	end
end

local function CreateEnemyFrame(EnemyServer: Types.EnemyServerData, EnemyClient: Types.EnemyClientData)
	local EnemyName: TextLabel = (EnemyFrame :: any).EnemyName;
	local HealthLabel: TextLabel = (EnemyFrame :: any).Health;
	
	Connections.HealthChanged = EnemyClient.HealthChanged:Connect(function(Health: number)
		HealthLabel.Text = "Health: "..EnemyServer.Health;
	end)
	
	EnemyName.Text = EnemyServer.ModelName;
	HealthLabel.Text = "Health: "..EnemyServer.Health;
end

local PlayerStorage: {[number]: string} = {};

local function GetNameFromUserId(UserId: number)
	if PlayerStorage[UserId] then
		return PlayerStorage[UserId];
	else
		local Name = Players:GetNameFromUserIdAsync(UserId);
		PlayerStorage[UserId] = Name;
		return Name;
	end
end

local function CreateUnitFrame(UnitServer: Types.UnitServerData, UnitClient: Types.UnitClientData)
	local LevelLabel: TextLabel = (UnitFrame :: any).Level;
	local Owner: TextLabel = (UnitFrame :: any).Owner;
	local UnitName: TextLabel = (UnitFrame :: any).UnitName;
	
	Connections.LevelChanged = UnitClient.LevelChanged:Connect(function(Level: number)
		LevelLabel.Text = "Level: "..Level;
	end)
	
	LevelLabel.Text = "Level: "..UnitServer.Level;
	Owner.Text = "Owner: "..GetNameFromUserId(UnitServer.OwnerId);
	UnitName.Text = UnitServer.ModelName;
end

local function HandleFrameData(Position: Vector2, Touched: boolean)
	local MousePosition: Vector2 = Position;
	local Ray = Camera:ViewportPointToRay(MousePosition.X, MousePosition.Y);
	Params.FilterDescendantsInstances = {Player.Character};

	local RaycastResult = workspace:Raycast(Ray.Origin, Ray.Direction * 1000, Params);
	if RaycastResult and RaycastResult.Instance then
		local Humanoid = FindAncestor.FindFirstHumanoid(RaycastResult.Instance);

		if Humanoid then
			local Character: Model = Humanoid.Parent :: Model;
			local Found: boolean = false;

			if Character and Character ~= CurrentModel then
				if Character:IsDescendantOf(EnemiesFolder) then
					local EnemyServer, EnemyClient = EnemyClient.GetDataFromChar(Character);

					if EnemyServer and EnemyClient then
						ClearConnections(Connections);
						CreateEnemyFrame(EnemyServer, EnemyClient);
						CurrentName = "Enemy";
						Found = true;
					end
				elseif Character:IsDescendantOf(UnitsFolder) then
					local UnitServer, UnitClient = UnitClient.GetDataFromChar(Character);

					if UnitServer and UnitClient then
						ClearConnections(Connections);
						CreateUnitFrame(UnitServer, UnitClient);
						CurrentName = "Unit";
						Found = true;
					end
				end

				if not Found then
					CurrentName = nil;
				end
			end

			CurrentModel = Character;

			if CurrentName == "Enemy" then
				EnemyFrame.Visible = true;
				UnitFrame.Visible = false;

				EnemyFrame.Position = Convert(MousePosition);
			elseif CurrentName == "Unit" then
				EnemyFrame.Visible = false;
				UnitFrame.Visible = true;

				UnitFrame.Position = Convert(MousePosition);
			else
				ClearConnections(Connections);
				EnemyFrame.Visible = false;
				UnitFrame.Visible = false;
			end
			return;
		end
	end
	CurrentModel = nil;
	CurrentName = nil;
	EnemyFrame.Visible = false;
	UnitFrame.Visible = false;
end

local OpenModel: Model? = nil;
local OpenClient: Types.UnitClientData?, OpenServer: Types.UnitServerData? = nil, nil;
local CurrentDisplay: BasePart? = nil;
local MoveConnections: {[string]: any} = {};
local CurrentRange = 0;

local function CreateUnitMenu()
	if not OpenClient or not OpenServer then
		return;
	end

	OpenModel = OpenClient.Character;
	
	UnitNameLabel.Text = OpenServer.ModelName;
	LevelLabel.Text = "Level: "..OpenServer.Level;
	
	OpenFrame.Visible = true;
	
	local RangeDisplay = RangeDisplay:Clone();
	local Pos, Size = OpenClient.Character:GetBoundingBox();
	RangeDisplay.CFrame = CFrame.new(Vector3.new(Pos.X, Pos.Y - Size.Y/2, Pos.Z));
	
	local Range = OpenServer.UpgradeData[tostring(OpenServer.Level)].Range * 2;
	CurrentRange = Range;
	
	RangeDisplay.Size = Vector3.new(Range * 0.3, 0.01, Range * 0.3);
	
	local Tween = TweenService:Create(
		RangeDisplay,
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = Vector3.new(Range, 0.01, Range)}
	):Play();
	
	if MoveConnections.RotateRangeDisplay then
		MoveConnections.RotateRangeDisplay:Disconnect();
		MoveConnections.RotateRangeDisplay = nil;
	end
	
	MoveConnections.RotateRangeDisplay = RunService.PostSimulation:Connect(function(Delta: number)
		RangeDisplay.CFrame *= CFrame.Angles(0, math.rad(0.5), 0);
	end)
	
	CurrentDisplay = RangeDisplay;
	RangeDisplay.Parent = RangeParts;
end

local function CloseUnitMenu(Clear: boolean)
	OpenFrame.Visible = false;
	task.spawn(function()
		local Display = CurrentDisplay;
		CurrentDisplay = nil;
		if Display then
			local Tween = TweenService:Create(
				Display,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Size = Vector3.new(CurrentRange * 0.3, 0.01, CurrentRange * 0.3)}
			);
			Tween:Play();

			Tween.Completed:Connect(function()
				if Display then
					Display:Destroy();
				end
				ClearConnections(MoveConnections);
			end)
		end
	end)
	if Clear then
		OpenClient = nil;
		OpenServer = nil;
	end
	OpenModel = nil;
end

UpgradeButton.MouseButton1Click:Connect(function()
	if not OpenClient or not OpenServer then
		return;
	end
	
	UpgradeEvent:FireServer({UniqueId = OpenServer.UniqueId});
end)

DeleteButton.MouseButton1Click:Connect(function()
	if not OpenClient or not OpenServer then
		return;
	end
	
	Sell:FireServer(OpenServer.UniqueId);
end)

UnitClient.Deleted:Connect(function(UnitClientData: Types.UnitClientData, UnitServerData: Types.UnitServerData)
	if UnitClientData.Character == OpenModel then
		CloseUnitMenu(true);
	end
end)

UserInputService.InputBegan:Connect(function(Input: InputObject, Processed: boolean)
	if Processed then
		return;
	end
	
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		if not CurrentModel then
			CloseUnitMenu(true);
			return;
		end
		
		OpenServer, OpenClient = UnitClient.GetDataFromChar(CurrentModel);
		
		if OpenServer and OpenClient and OpenModel ~= OpenClient.Character then
			if Player.UserId == OpenServer.OwnerId then
				if OpenModel then
					CloseUnitMenu(false);
				end
				
				CreateUnitMenu();
				return;
			end
		end
		
		CloseUnitMenu(true);
	end
end)

RunService.PostSimulation:Connect(function(Delta: number)
	if GuiService.MenuIsOpen then
		EnemyFrame.Visible = false;
		UnitFrame.Visible = false;
		return;
	end
	local MouseLocation = UserInputService:GetMouseLocation();
	local ScreenLocation = MouseLocation - GuiService:GetGuiInset();
	
	HandleFrameData(MouseLocation, true);
end)

local PlacementFolder = workspace.PlacementClient;

local Params = RaycastParams.new();
Params.FilterType = Enum.RaycastFilterType.Exclude;

local function GetCharacters(Data: {})
	for _, Player in ipairs(Players:GetPlayers()) do
		table.insert(Data, Player.Character);
	end
end

local Characters: {Instance} = {};

do
	local function HandlePlayer(Player: Player)
		if Player.Character then
			table.insert(Characters, Player.Character);
		end

		Player.CharacterAdded:Connect(function(Character)
			table.insert(Characters, Character);
		end)

		Player.CharacterRemoving:Connect(function(Character)
			local Index = table.find(Characters, Character);

			if Index then
				table.remove(Characters, Index);
			end
		end)
	end


	for _, Player in ipairs(Players:GetPlayers()) do
		HandlePlayer(Player);
	end

	Players.PlayerAdded:Connect(HandlePlayer);

	table.insert(Characters, PlacementFolder);
	table.insert(Characters, workspace.Enemies);
	table.insert(Characters, workspace.Units);
end

local InPlacement = Instance.new("BoolValue");

local Data: {
	CurrentUnit: string?;
	CurrentModel: Model?;
	Rotation: CFrame;
	CFrame: CFrame;
	RotationIndex: number;
	PlacementConnection: RBXScriptConnection?;
	CollideConnection: RBXScriptConnection?;
	Root: BasePart?;
} = {
	CurrentUnit = "Scout";
	CurrentModel = nil;
	CFrame = CFrame.new();
	Rotation = CFrame.new();
	RotationIndex = 0;
	PlacementConnection = nil;
	CollideConnection = nil;
	Root = nil;
}

--[[
	Code that runs every step for placement.
]]
local function OnStepped()
	local MousePosition = UserInputService:GetMouseLocation();
	local ViewportRay = Camera:ViewportPointToRay(MousePosition.X, MousePosition.Y);

	Params.FilterDescendantsInstances = Characters;
	local RaycastResult = workspace:Raycast(ViewportRay.Origin, ViewportRay.Direction * 200, Params);
	if RaycastResult and Data.CurrentModel then
		local RayInstance = RaycastResult.Instance;

		local Root = Data.CurrentModel.PrimaryPart :: BasePart;
		local CenterCFrame, Height = Data.CurrentModel:GetBoundingBox();

		local HeightDifference = (Root.Position - CenterCFrame.Position).Y;

		local AlteredCFrame = CFrame.new(RaycastResult.Position) + Vector3.new(
			0,
			Height.Y/2 + HeightDifference,
			0
		);

		local NextCFrame = AlteredCFrame * Data.Rotation;

		Data.CFrame = NextCFrame;
		Root.CFrame = NextCFrame;
	end
end


local function HandleStart()
	Data.CurrentModel = Units[Data.CurrentUnit :: any]:Clone();
	if Data.CurrentModel then
		CloseUnitMenu(true);
		local Root = Data.CurrentModel.PrimaryPart :: BasePart;
		Root.Anchored = true;
		OnStepped();
		Data.CurrentModel.Parent = PlacementFolder;
		Data.PlacementConnection = RunService.PostSimulation:Connect(OnStepped);

		local Humanoid = Data.CurrentModel:FindFirstChildWhichIsA("Humanoid") :: Humanoid;

		for _, Descendant in ipairs(Data.CurrentModel:GetChildren()) do
			if Descendant:IsA("BasePart") then
				Descendant.CanCollide = false;
			end
		end

		Data.CollideConnection = Humanoid.StateChanged:Connect(function()
			for _, Descendant in ipairs(Data.CurrentModel:GetChildren()) do
				if Descendant:IsA("BasePart") then
					Descendant.CanCollide = false;
				end
			end
		end)
	end
end

InPlacement.Changed:Connect(function(Value)
	if Value then
		HandleStart();
	else
		if Data.PlacementConnection then
			Data.PlacementConnection:Disconnect();
			Data.PlacementConnection = nil;
		end
		if Data.CollideConnection then
			Data.CollideConnection:Disconnect();
			Data.CollideConnection = nil;
		end
		if Data.CurrentModel then
			Data.CurrentModel:Destroy();
			Data.CurrentModel = nil;
		end
	end
end)

PlaceButton.MouseButton1Click:Connect(function()
	InPlacement.Value = not InPlacement.Value;
end)

local function InWorldClick(MousePosition: Vector2)
	local GuiInset: Vector2 = GuiService:GetGuiInset();

	if MousePosition.X < GuiInset.X or MousePosition.Y < GuiInset.Y then
		return false;
	end

	if #PlayerGui:GetGuiObjectsAtPosition(MousePosition.X - GuiInset.X, MousePosition.Y - GuiInset.Y) ~= 0 then
		return false;
	end

	return true;
end

UserInputService.InputBegan:Connect(function(Input: InputObject, Proccessed: boolean)
	if Input.UserInputType == Enum.UserInputType.Keyboard then
		if Input.KeyCode == Enum.KeyCode.R then
			Data.RotationIndex = (Data.RotationIndex + 1) % 4;
			Data.Rotation = CFrame.Angles(0, math.rad(Data.RotationIndex * 90), 0);
		end
	elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
		local Pos = UserInputService:GetMouseLocation();

		if InPlacement.Value and InWorldClick(Pos) then
			if Data.CurrentUnit and Data.CurrentModel then
				local _, rY _ = Data.CFrame:ToEulerAnglesXYZ();
				local Data = {
					ModelName = Data.CurrentUnit;
					Position = Data.CFrame.Position;
					YIndex = Data.RotationIndex;
				};

				PlacementEvent:FireServer(Data);
			end
		end
	end
end)