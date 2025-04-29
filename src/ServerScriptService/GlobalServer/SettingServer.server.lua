--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)
local GlobalWave = require(GlobalModules.GlobalWave)

local UnitData = require(ServerStorage.Data.UnitData)

local Remotes = ReplicatedStorage.Remotes

-- Settings --

local SettingsEvents = Remotes.Settings
local ChangeSetting = SettingsEvents.ChangeSetting
local SendSettings = SettingsEvents.SendSettings
local SettingSync = SettingsEvents.SettingSync

ChangeSetting.OnServerEvent:Connect(function(Player: Player, Setting: string, Value: any)
	local PlayerData = PlayerData.GetPlayerDataAsync(Player)

	if PlayerData then
		PlayerData:ChangeSetting(Setting, Value)
	end
end)

SettingSync.OnServerEvent:Connect(function(Player: Player, Data: any)
	local PlayerData = PlayerData.GetPlayerDataAsync(Player)

	if PlayerData then
		for Setting, Value in pairs(Data) do
			PlayerData:ChangeSetting(Setting, Value)
		end
	end
end)

local function OnDataAdded(Data: PlayerData.PlayerData)
	local Player = Data.Player
	local GivenData = Data.Profile.Data
	SendSettings:FireClient(Player, GivenData.Settings)
	Data.SettingChanged:Connect(function(Setting: string, Value: any)
		ChangeSetting:FireClient(Player, Setting, Value)
	end)
end

for Id, Data in pairs(PlayerData.GetDatas()) do
	OnDataAdded(Data)
end

PlayerData.DataAdded:Connect(OnDataAdded)
