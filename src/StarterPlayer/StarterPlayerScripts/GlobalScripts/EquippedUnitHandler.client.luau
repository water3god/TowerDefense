--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");

local Client = ReplicatedStorage.Client;
local GlobalClient = Client.GlobalClient;
local UnitClient = require(GlobalClient.UnitClient);
local WaveService = require(GlobalClient.WaveService);
local InventoryService = require(GlobalClient.InventoryService);

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);

local Shared = ReplicatedStorage.Shared;
local UnitInfo = require(Shared.UnitInfo);

local Player = Players.LocalPlayer;
local PlayerGui: typeof(game:GetService("StarterGui")) & typeof(ReplicatedStorage.CloneGui) = Player.PlayerGui;
local GlobalGui: typeof(PlayerGui.GlobalGui) = PlayerGui:WaitForChild("GlobalGui");

local GameGui = GlobalGui.GameGui;
local Main = GameGui.BottomFrame;

local LevelBar = Main.LevelBar;
local LevelLabel = LevelBar.LevelLabel;
local ProgressBar = LevelBar.Container.ProgressBar;

local LevelData: {[number]: number} = {
	[1] = 3;
	[10] = 4;
	[20] = 5;
};

local Frames = {
	[1] = Main.Frame1;
	[2] = Main.Frame2;
	[3] = Main.Frame3;
	[4] = Main.Frame4;
	[5] = Main.Frame5;
};

if not InventoryService.IsSynced then
	InventoryService.Synced:Wait();
end

local function GetMaxUnits(Level: number)
	local CurrentIndex: number = 1;
	local MaxUnits: number = LevelData[CurrentIndex];

	for LowestLevel, UnitNum in pairs(LevelData) do
		if LowestLevel <= Level and LowestLevel > CurrentIndex then
			CurrentIndex = LowestLevel;
			MaxUnits = UnitNum;
		end
	end

	return MaxUnits;
end

local function OnEquipChanged(UnitData: any, Index: number, Equip: boolean)
	local Frame = Frames[Index];
	local Container = Frame.Container;

	if Equip then
		Container.LevelLabel.Text = UnitData.Level;
		Container.UnitName.Text = UnitData.Unit;

		local OtherData = UnitInfo.UnitInfo[UnitData.Unit];

		Container.CostLabel.Text = string.format("$%u", OtherData.PlacementCost);

		InventoryService.ApplyDataUnitFrame(UnitData, Frame);

		Container.LevelLabel.Visible = true;
		Container.UnitName.Visible = true;
		Container.CostLabel.Visible = true;
	else
		Container.BackgroundImage.UIGradient.Color = ColorSequence.new(Color3.fromRGB(186, 99, 255));

		Container.LevelLabel.Visible = false;
		Container.UnitName.Visible = false;
		Container.CostLabel.Visible = false;
	end
end

local function GetNeededLevel(Index: number)
	for Level, CurrentIndex in pairs(LevelData) do
		if CurrentIndex == Index then
			return Level;
		end
	end

	return 0;
end

local function OnLevelChanged(Level: number)
	local MaxUnits = GetMaxUnits(Level);

	for Index, Frame in ipairs(Frames) do
		local Container = Frame.Container;
		if Index <= MaxUnits then
			Container.Lock.Visible = false;
			Container.LevelLock.Visible = false;

			Container:AddTag("GuiAnimateBasic");
		else
			Container.UnitName.Visible = false;
			Container.LevelLabel.Visible = false;
			Container.Lock.Visible = true;
			Container.LevelLock.Visible = true;

			Container.LevelLock.Text = string.format("Level %u", GetNeededLevel(Index));

			Frame:RemoveTag("GuiAnimateBasic");
		end
	end
end

local Inventory = InventoryService:GetInventory();

OnLevelChanged(InventoryService.Level);

InventoryService.LevelChanged:Connect(function(Level: number)
	OnLevelChanged(Level);
end)

for Index = 1, GetMaxUnits(InventoryService.Level), 1 do
	local UniqueId = InventoryService.EquippedUnits[Index];

	if UniqueId then
		local UnitData = Inventory.Units[UniqueId];

		OnEquipChanged(UnitData, Index, true);
	else
		OnEquipChanged(nil, Index, false);
	end
end

InventoryService.UnitEquipChanged:Connect(function(Data: any)
	OnEquipChanged(Inventory.Units[Data.UniqueId], Data.Index, Data.Equip);
end)

local function OnXPChanged(XP: number)
	local NeededXP = InventoryService.NeededXP;

	LevelLabel.Text = string.format("Level %u (%u/%u)", InventoryService.Level, XP, NeededXP);

	local Ratio = XP / NeededXP;
	ProgressBar.Size = UDim2.fromScale(Ratio, 1);
end

OnXPChanged(InventoryService.XP);
InventoryService.XPChanged:Connect(OnXPChanged);

