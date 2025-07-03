--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Network = require(ReplicatedStorage.Network.Client)
local ChangeSettingClient = Network.ChangeSettingClient
local ChangeSettingServer = Network.ChangeSettingServer
local SettingSync = Network.SettingSync
local SendSettings = Network.SendSettings

local Shared = ReplicatedStorage.Shared
local SettingsData = require(Shared.Settings)

local SettingChangedSignals: { [string]: Signal.Signal<any> } = {}
local PlayerSettings: { [string]: any } = SettingsData.PreSync

local SettingService = {}

function SettingService.GetPlayerSettings()
	return PlayerSettings
end

local SettingCache: { string } = {}

local SettingChanged = Signal.new()
local Synced = Signal.new()
SettingService.SettingChanged = SettingChanged
SettingService.Synced = Synced
SettingService.IsSynced = false

function SettingService.GetSetting(Setting: string, Yield: boolean?)
	if Yield then
		if not SettingService.IsSynced then
			SettingService.Synced:Wait()
		end
	end
	return PlayerSettings[Setting]
end

function SettingService.GetSettingChangedSignal(Setting: string)
	if SettingChangedSignals[Setting] then
		return SettingChangedSignals[Setting]
	else
		local SettingSignal = Signal.new()
		SettingChangedSignals[Setting] = SettingSignal
		return SettingSignal
	end
end

function SettingService.ChangeSetting(Setting: string, Value: any)
	if PlayerSettings[Setting] == Value and SettingService.IsSynced then
		return
	end
	PlayerSettings[Setting] = Value
	SettingChanged:Fire(Setting, Value)
	if SettingChangedSignals[Setting] then
		SettingChangedSignals[Setting]:Fire(Value)
	end
	ChangeSettingClient.Fire(Setting, Value)
end

function SettingService.ChangeSettingClient(Setting: string, Value: any)
	PlayerSettings[Setting] = Value
	if not table.find(SettingCache, Setting) then
		table.insert(SettingCache, Setting)
	end
	SettingChanged:Fire(Setting, Value)
	if SettingChangedSignals[Setting] then
		SettingChangedSignals[Setting]:Fire(Value)
	end
end

function SettingService.SyncSetting(Setting: string)
	task.spawn(function()
		if not SettingService.IsSynced then
			SettingService.Synced:Wait()
		end
		ChangeSettingClient.Fire(Setting, PlayerSettings[Setting])
	end)
end

function SettingService.SyncSettings()
	local SentData = {}
	for _, Setting in ipairs(SettingCache) do
		SentData[Setting] = PlayerSettings[Setting]
	end

	SettingSync.Fire(SentData)
end

ChangeSettingServer.SetCallback(function(Setting: string, Value: any)
	local Index = table.find(SettingCache, Setting)
	if Index then
		table.remove(SettingCache, Index)
	end
	SettingChanged:Fire(Setting, Value)
	if SettingChangedSignals[Setting] then
		SettingChangedSignals[Setting]:Fire(Value)
	end
	PlayerSettings[Setting] = Value
end)

SendSettings.SetCallback(function(Settings: any)
	PlayerSettings = Settings
	SettingService.IsSynced = true

	Synced:Fire()
end)

return SettingService
