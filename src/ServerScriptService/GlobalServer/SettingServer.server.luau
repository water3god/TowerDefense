--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Network = require(ReplicatedStorage.Network.Server)
local ChangeSettingServer = Network.ChangeSettingServer
local ChangeSettingClient = Network.ChangeSettingClient
local SendSettings = Network.SendSettings
local SettingSync = Network.SettingSync

ChangeSettingClient.SetCallback(function(Player: Player, Setting: string, Value: any)
	if typeof(Setting) ~= "string" then
		return
	end

	local Data = PlayerData.GetPlayerDataAsync(Player)

	if Data then
		Data:ChangeSetting(Setting, Value)
	end
end)

SettingSync.SetCallback(function(Player: Player, Data: any)
	if typeof(Data) ~= "table" then
		return
	end

	local PData = PlayerData.GetPlayerDataAsync(Player)

	if PData then
		for Setting, Value in pairs(Data) do
			PData:ChangeSetting(Setting, Value)
		end
	end
end)

local function OnDataAdded(Data: PlayerData.PlayerData)
	local Player = Data.Player
	local GivenData = Data.Profile.Data
	SendSettings.Fire(Player, GivenData.Settings)
	Data.SettingChanged:Connect(function(Setting: string, Value: any)
		ChangeSettingServer.Fire(Player, Setting, Value)
	end)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	OnDataAdded(Data)
end

PlayerData.DataAdded:Connect(OnDataAdded)
