--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Network = require(ReplicatedStorage.Network.Server)
local ChestSync = Network.ChestSync
local ChestAdded = Network.ChestAdded
local ChestRedeemed = Network.ChestRedeemed
local RedeemChest = Network.RedeemChest

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)

if not IsLobby then
	return
end

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local function HandlePlayerData(PData: PlayerData.PlayerData)
	local Data = PData.Profile.Data

	if #Data.Chests ~= 0 then
		ChestSync.Fire(PData.Player, Data.Chests)
	end

	PData.ChestAdded:Connect(function(Chest, Index)
		ChestAdded.Fire(PData.Player, Chest, Index)
	end)

	PData.ChestRedeemed:Connect(function(Index)
		ChestRedeemed.Fire(PData.Player, Index)
	end)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandlePlayerData(Data)
end

PlayerData.DataAdded:Connect(HandlePlayerData)

RedeemChest.SetCallback(function(Player: Player, Index: number)
	local Data = PlayerData.GetPlayerData(Player)

	if Data then
		Data:RedeemChest(Index)
	end
end)
