--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

if not require(ReplicatedStorage.Shared.IsLobby) then
	return
end

local Remotes = ReplicatedStorage.Remotes
local BoothEvents = Remotes.Booth
local DataEvents = BoothEvents.DataEvents
local DataSync: RemoteEvent = DataEvents.DataSync

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local function HandleData(Data: PlayerData.PlayerData)
	local function SendData()
		DataSync:FireClient(Data.Player, Data.Profile.Data.CompletedMaps)
	end

	SendData()

	Data.StageChanged:Connect(SendData)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandleData(Data)
end

PlayerData.DataAdded:Connect(HandleData)
