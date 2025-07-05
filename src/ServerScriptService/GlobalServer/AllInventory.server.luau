--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Network = require(ReplicatedStorage.Network.Server)
local AllEquippedSync = Network.AllEquippedSync

local CurrentData = {}

local function Update(Data: PlayerData.PlayerData)
	local SendData = {}

	for Index, Id in pairs(Data.Profile.Data.EquippedUnits) do
		local UnitData = Data:GetUnitFromId(Id)

		if UnitData then
			SendData[Index] = {
				Id = Id,
				Level = UnitData.Level,
				UnitName = UnitData.Unit,
			}
		end
	end

	local NewTable = {
		Level = Data.Profile.Data.Level,
		Title = Data.Profile.Data.EquippedTitle,
		EquippedUnits = SendData,
	}

	CurrentData[Data.Player] = NewTable

	AllEquippedSync.FireExcept(Data.Player, { [Data.Player] = NewTable })
end

local function HandleData(Data: PlayerData.PlayerData)
	AllEquippedSync.Fire(Data.Player, CurrentData)
	Update(Data)
	Data.UnitEquipped:Connect(function()
		Update(Data)
	end)

	Data.UnitUnequipped:Connect(function()
		Update(Data)
	end)

	Data.LeveledUp:Connect(function()
		Update(Data)
	end)

	Data.TitleChanged:Connect(function()
		Update(Data)
	end)

	Data.Destroying:Once(function()
		CurrentData[Data.Player] = nil
	end)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandleData(Data)
end

PlayerData.DataAdded:Connect(HandleData)
