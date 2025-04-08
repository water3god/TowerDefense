--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Modules = ReplicatedStorage.Modules;
local Signal = require(Modules.Signal);

local Remotes = ReplicatedStorage.Remotes;
local SettingsEvents = Remotes.Settings;
local ChangeSetting = SettingsEvents.ChangeSetting;
local SettingSync = SettingsEvents.SettingSync;
local SendSettings = SettingsEvents.SendSettings;

local SettingChangedSignals: {[string]: Signal.Signal<any>} = {};
local PlayerSettings: {[string]: any} = {};

local SettingService = {};
local SettingCache: {string} = {};

local SettingChanged = Signal.new();
local Synced = Signal.new();
SettingService.SettingChanged = SettingChanged;
SettingService.Synced = Synced;
SettingService.IsSynced = false;

function SettingService.GetSetting(Setting: string, Yield: boolean?)
	if Yield then
		if not SettingService.IsSynced then
			SettingService.Synced:Wait();
		end
	end
	return PlayerSettings[Setting];
end

function SettingService.GetSettingChangedSignal(Setting: string)
	if SettingChangedSignals[Setting] then
		return SettingChangedSignals[Setting];
	else
		local SettingSignal = Signal.new();
		SettingChangedSignals[Setting] = SettingSignal;
		return SettingSignal;
	end
end

function SettingService.ChangeSetting(Setting: string, Value: any)
	PlayerSettings[Setting] = Value;
	SettingChanged:Fire(Setting, Value);
	if SettingChangedSignals[Setting] then
		SettingChangedSignals[Setting]:Fire(Value);
	end
	ChangeSetting:FireServer(Setting, Value);
end

function SettingService.ChangeSettingClient(Setting: string, Value: any)
	PlayerSettings[Setting] = Value;
	if not table.find(SettingCache, Setting) then
		table.insert(SettingCache, Setting);
	end
	SettingChanged:Fire(Setting, Value);
	if SettingChangedSignals[Setting] then
		SettingChangedSignals[Setting]:Fire(Value);
	end
end

function SettingService.SyncSetting(Setting: string)
	ChangeSetting:FireServer(Setting, PlayerSettings[Setting]);
end

function SettingService.SyncSettings()
	local SentData = {};
	for _, Setting in ipairs(SettingCache) do
		SentData[Setting] = PlayerSettings[Setting];
	end

	SettingSync:FireServer(SentData);
end

ChangeSetting.OnClientEvent:Connect(function(Setting: string, Value: any)
	local Index = table.find(SettingCache, Setting);
	if Index then
		table.remove(SettingCache, Index);
	end
	SettingChanged:Fire(Setting, Value);
	if SettingChangedSignals[Setting] then
		SettingChangedSignals[Setting]:Fire(Value);
	end
	PlayerSettings[Setting] = Value;
end)

SendSettings.OnClientEvent:Connect(function(Settings: any)
	PlayerSettings = Settings;
	SettingService.IsSynced = true;
	
	Synced:Fire();
end)

return SettingService;

