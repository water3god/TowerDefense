--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

if not require(ReplicatedStorage.Shared.IsLobby) then
	return
end

local Network = require(ReplicatedStorage.Network.Server)

local DataSync = Network.StoryDataSync

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local function HandleData(Data: PlayerData.PlayerData)
	local function SendData()
		DataSync.Fire(Data.Player, Data.Profile.Data.CompletedMaps :: any)
	end

	SendData()

	Data.StageChanged:Connect(SendData)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandleData(Data)
end

PlayerData.DataAdded:Connect(HandleData)
