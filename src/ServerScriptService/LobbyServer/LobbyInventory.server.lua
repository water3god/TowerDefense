--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");

local GlobalModules = ServerScriptService.GlobalModules;
local PlayerData = require(GlobalModules.PlayerData);

local Remotes = ReplicatedStorage.Remotes;

-- Inventory --

local InventoryEvents = Remotes.Inventory;
local ItemChanged = InventoryEvents.ItemChanged;
local InventorySync = InventoryEvents.InventorySync;
local UnitEquipped = InventoryEvents.UnitEquipped;
local EquipUnit = InventoryEvents.EquipUnit;
local SellUnit = InventoryEvents.SellUnit;

EquipUnit.OnServerEvent:Connect(function(Player: Player, Data: {UniqueId: string, Equip: boolean})
	if typeof(Data) ~= "table" then
		return;
	end
	if typeof(Data.UniqueId) ~= "string" then
		return;
	end

	if typeof(Data.Equip) ~= "boolean" then
		return;
	end

	local PlayerData = PlayerData.GetPlayerDataAsync(Player);

	if PlayerData then
		if PlayerData.CurrentWave then
			return;
		end
		if Data.Equip then
			PlayerData:EquipUnit(Data.UniqueId);
		else
			PlayerData:UnequipUnit(Data.UniqueId);
		end
	end
end)

SellUnit.OnServerEvent:Connect(function(Player: Player, Data: {string})
	if typeof(Data) ~= "table" then
		return;
	end

	if #Data == 0 then
		return;
	end

	local PlayerData = PlayerData.GetPlayerDataAsync(Player);

	if PlayerData then
		if PlayerData.CurrentWave then
			return;
		end
		for _, UniqueId in ipairs(Data) do
			if typeof(UniqueId) ~=  "string" then
				continue;
			end
			PlayerData:DeleteUnit(UniqueId);
		end
	end
end)

