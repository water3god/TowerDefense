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
	CurrentData[Data.Player] = Data.Profile.Data.EquippedUnits
	if Player then
		AllEquippedSync.FireExcept(Player, { [Data.Player] = Data.Profile.Data.EquippedUnits })
	else
		AllEquippedSync.FireAll({ [Data.Player] = Data.Profile.Data.EquippedUnits })
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
