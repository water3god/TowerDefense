--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Network = require(ReplicatedStorage.Network.Server)
local RedeemDailyReward = Network.RedeemDailyReward
local DailySync = Network.DailySync
local DailyRedeemed = Network.DailyRedeemed

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)

if not IsLobby then
	return
end

RedeemDailyReward.SetCallback(function(Player: Player)
	local Data = PlayerData.GetPlayerData(Player)

	if Data then
		Data:RedeemDaily()
	end
end)

local function HandleData(Data: PlayerData.PlayerData)
	DailySync.Fire(Data.Player, Data.Profile.Data.DailyData)

	Data.DailyRedeemed:Connect(function(Day: number, LastRedeemed: number)
		DailyRedeemed.Fire(Data.Player, {
			Day = Day,
			LastRedeemed = LastRedeemed,
		})
	end)
end
for _, Data in pairs(PlayerData.GetDatas()) do
	HandleData(Data)
end

PlayerData.DataAdded:Connect(HandleData)
