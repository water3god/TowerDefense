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

local function Update(Data: PlayerData.PlayerData, Player: Player?)
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

	CurrentData[Data.Player] = SendData
	if Player then
		AllEquippedSync.FireExcept(Player, { [Data.Player] = SendData })
	else
		AllEquippedSync.FireAll({ [Data.Player] = SendData })
	end
end

local function HandleData(Data: PlayerData.PlayerData)
	Update(Data, Data.Player)
	Data.UnitEquipped:Connect(function()
		Update(Data)
	end)

	Data.UnitUnequipped:Connect(function()
		Update(Data)
	end)

	AllEquippedSync.Fire(Data.Player, CurrentData)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandleData(Data)
end

PlayerData.DataAdded:Connect(HandleData)
