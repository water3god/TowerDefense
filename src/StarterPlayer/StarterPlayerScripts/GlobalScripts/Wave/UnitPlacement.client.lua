--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");

local Client = ReplicatedStorage.Client;
local GlobalClient = Client.GlobalClient;
local UnitClient = require(GlobalClient.UnitClient);
local WaveService = require(GlobalClient.WaveService);
local InventoryService = require(GlobalClient.InventoryService);

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);
local Trove = require(Modules.Trove);

local Player = Players.LocalPlayer;
local PlayerGui: typeof(game:GetService("StarterGui")) & typeof(ReplicatedStorage.CloneGui) = Player.PlayerGui;
local GlobalGui: typeof(PlayerGui.GlobalGui) = PlayerGui:WaitForChild("GlobalGui");
local GameGui = GlobalGui.GameGui;

if PlayerGui:FindFirstChild("LobbyGui") then
	return;
end

local Main = GameGui.BottomFrame;

local Frames = {
	[1] = Main.Frame1;
	[2] = Main.Frame2;
	[3] = Main.Frame3;
	[4] = Main.Frame4;
	[5] = Main.Frame5;
};

local Keys = {
	Enum.KeyCode.One;
	Enum.KeyCode.Two;
	Enum.KeyCode.Three;
	Enum.KeyCode.Four;
	Enum.KeyCode.Five;
};

local CurrentPlacementTrove: Trove.Trove? = nil;
local PlacementIndex: number? = nil;

Player.CharacterRemoving:Connect(function()
	if CurrentPlacementTrove then
		CurrentPlacementTrove:Destroy();
	end
end)

if not InventoryService.IsSynced then
	InventoryService.Synced:Wait();
end

local Inventory = InventoryService:GetInventory();

local function InitIndex(Index: number)
	local UniqueId = InventoryService.EquippedUnits[Index];
	if UniqueId then
		local Name = Inventory.Units[UniqueId].Unit;
		if Name then
			if PlacementIndex == Index then
				if CurrentPlacementTrove then
					CurrentPlacementTrove:Destroy();
				end
			else
				if CurrentPlacementTrove then
					CurrentPlacementTrove:Destroy();
				end
				local TempTrove = UnitClient.InitPlacement(Name);
				TempTrove:Add(function()
					CurrentPlacementTrove = nil;
					PlacementIndex = nil;
				end)
				CurrentPlacementTrove = TempTrove;
				PlacementIndex = Index;
			end
		end
	end
end

WaveService.Ended:Connect(function()
	if CurrentPlacementTrove then
		CurrentPlacementTrove:Destroy();
	end
end)

UserInputService.InputBegan:Connect(function(Input: InputObject, Processed: boolean)
	if Processed then
		return;
	end
		
	if Input.UserInputType == Enum.UserInputType.Keyboard then
		local Index = table.find(Keys, Input.KeyCode);
		
		if Index then
			InitIndex(Index);
		end
	end
end)

for Index, Frame in ipairs(Frames) do
	Frame.InputBegan:Connect(function(Input: InputObject)
		if HelperFunctions.IsClick(Input) then
			InitIndex(Index);
		end
	end)
end
