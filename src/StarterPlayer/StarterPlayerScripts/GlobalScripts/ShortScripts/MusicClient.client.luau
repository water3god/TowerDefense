--!strict

local SoundService = game:GetService("SoundService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");

local Client = ReplicatedStorage.Client;
local GlobalClient = Client.GlobalClient;
local SettingsService = require(GlobalClient.SettingsService);

if not SettingsService.IsSynced then
	SettingsService.Synced:Wait();
end

local GlobalMusic = SoundService:WaitForChild("GlobalMusic");
local Music = GlobalMusic:WaitForChild("Music");

local Sounds: {Sound} = Music:GetChildren();
local OldVolumes: {[Sound]: number} = {};

for _, Sound in ipairs(Sounds) do
	OldVolumes[Sound] = Sound.Volume;
end

local function HandleMusic(Value: boolean)
	if Value then
		for _, Sound in ipairs(Sounds) do
			Sound.Volume = OldVolumes[Sound] * SettingsService.GetSetting("MusicVolume");
		end
	else
		for _, Sound in ipairs(Sounds) do
			Sound.Volume = 0;
		end
	end
end

HandleMusic(SettingsService.GetSetting("Music"));

SettingsService.GetSettingChangedSignal("Music"):Connect(function(Value: boolean)
	HandleMusic(Value);
end)

SettingsService.GetSettingChangedSignal("MusicVolume"):Connect(function(Volume: number)
	if SettingsService.GetSetting("Music") then
		for _, Sound in ipairs(Sounds) do
			Sound.Volume = OldVolumes[Sound] * Volume;
		end
	end
end)

local CurrentIndex = math.random(1, #Sounds);

local function RecalibrateMusic(Index: number)
	local Sound = Sounds[Index];

	CurrentIndex = Index;
end

for _, Sound in ipairs(Sounds) do
	Sound.Looped = false;

	Sound.Ended:Connect(function(SoundId: string)
		local NextIndex = CurrentIndex + 1;
		if not Sounds[NextIndex] then
			NextIndex = 1;
		end

		Sounds[NextIndex]:Play();
		RecalibrateMusic(NextIndex);
	end)
end

Sounds[CurrentIndex]:Play();
RecalibrateMusic(CurrentIndex);