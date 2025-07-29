--!strict

local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local SettingsService = require(GlobalClient.SettingsService)
local WaveService = require(GlobalClient.WaveService)

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)

if not SettingsService.IsSynced then
	SettingsService.Synced:Wait()
end

local GlobalMusic = SoundService:WaitForChild("GlobalMusic")
local Music = GlobalMusic:WaitForChild("Music")
local Win = GlobalMusic:WaitForChild("Win") :: Sound
local Lose = GlobalMusic:WaitForChild("Lose") :: Sound

Win.Looped = true
Lose.Looped = true

local Sounds: { Sound } = Music:GetChildren()
local OldVolumes: { [Sound]: number } = {}

for _, Sound in ipairs(Sounds) do
	OldVolumes[Sound] = Sound.Volume
end

local function HandleMusic(Value: boolean)
	if Value then
		for _, Sound in ipairs(Sounds) do
			Sound.Volume = OldVolumes[Sound] * SettingsService.GetSetting("MusicVolume")
		end
	else
		for _, Sound in ipairs(Sounds) do
			Sound.Volume = 0
		end
	end
end

HandleMusic(SettingsService.GetSetting("Music"))

SettingsService.GetSettingChangedSignal("Music"):Connect(function(Value: boolean)
	HandleMusic(Value)
end)

SettingsService.GetSettingChangedSignal("MusicVolume"):Connect(function(Volume: number)
	if SettingsService.GetSetting("Music") then
		for _, Sound in ipairs(Sounds) do
			Sound.Volume = OldVolumes[Sound] * Volume
		end
	end
end)

local CurrentIndex = math.random(1, #Sounds)

local function RecalibrateMusic(Index: number)
	local Sound = Sounds[Index]

	CurrentIndex = Index
end

for _, Sound in ipairs(Sounds) do
	Sound.Looped = false

	Sound.Ended:Connect(function()
		local NextIndex = CurrentIndex + 1
		if not Sounds[NextIndex] then
			NextIndex = 1
		end

		Sounds[NextIndex]:Play()
		RecalibrateMusic(NextIndex)
	end)
end

local function HandleEnded(Won: boolean)
	Sounds[CurrentIndex]:Stop()
	if Won then
		Win:Play()
	else
		Lose:Play()
	end
end

local function HandleStarted()
	Sounds[CurrentIndex].TimePosition = 0
	Sounds[CurrentIndex]:Play()
	RecalibrateMusic(CurrentIndex)
end

if WaveService.GetWaveData() or IsLobby then
	HandleStarted()
elseif WaveService.Win ~= nil then
	HandleEnded(WaveService.Win)
end

WaveService.Ended:Connect(HandleEnded)
WaveService.Added:Connect(HandleStarted)
