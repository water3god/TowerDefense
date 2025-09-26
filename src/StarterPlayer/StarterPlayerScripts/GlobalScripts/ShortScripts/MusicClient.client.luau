--!strict

local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

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

local Sounds: { Sound } = Music:GetChildren()
local OldVolumes: { [Sound]: number } = {}

local AllSounds: { Sound } = {}

for _, Sound in ipairs(GlobalMusic:GetDescendants()) do
	if Sound:IsA("Sound") then
		OldVolumes[Sound] = Sound.Volume
		table.insert(AllSounds, Sound)
	end
end

local function HandleMusic(Value: boolean)
	if Value then
		for _, Sound in ipairs(AllSounds) do
			Sound.Volume = OldVolumes[Sound] * SettingsService.GetSetting("MusicVolume")
		end
	else
		for _, Sound in ipairs(AllSounds) do
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
		for _, Sound in ipairs(AllSounds) do
			Sound.Volume = OldVolumes[Sound] * Volume
		end
	end
end)

local CurrentIndex = math.random(1, #Sounds)

local function RecalibrateMusic(Index: number)
	local Sound = Sounds[Index]

	CurrentIndex = Index
end

local function NextMusic()
	local NextIndex = CurrentIndex + 1
	if not Sounds[NextIndex] then
		NextIndex = 1
	end

	Sounds[NextIndex]:Play()
	RecalibrateMusic(NextIndex)
end

for _, Sound in ipairs(Sounds) do
	Sound.Looped = false

	if Sound.Name == "LobbyMedieval" then
		local Time = Sound.TimeLength - 7

		RunService.Heartbeat:Connect(function()
			print("Ran")
			if Sound.TimePosition >= Time then
				Sound.TimePosition = 0
			end
		end)
	else
		Sound.Ended:Connect(NextMusic)
	end
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
	Win:Stop()
	Lose:Stop()
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
