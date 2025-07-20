--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local GlobalClient = ReplicatedStorage.Client.GlobalClient
local SettingsService = if RunService:IsClient()
	then require(GlobalClient.SettingsService)
	else {} :: typeof(require(GlobalClient.SettingsService))

local SoundEffects = SoundService.SoundEffects
local SoundGroup = SoundEffects.SoundGroup
local PlayingSounds = SoundService.PlayingSounds

local GlobalSounds = workspace.GlobalWorkspace.Sounds

local function NewPart()
	local Part = Instance.new("Part")
	Part.Transparency = 1
	Part.Anchored = true
	Part.CanCollide = false
	Part.Size = Vector3.one
	Part.CanQuery = false
	Part.CanTouch = false

	return Part
end

local SoundsList: { Sound } = {}

local function RemoveSound(Sound: Sound)
	local Index = table.find(SoundsList, Sound)
	if Index then
		table.remove(SoundsList, Index)
	end
end

local function RandomizeSound(Sound: Sound)
	Sound.PlaybackSpeed = math.random(95, 105) / 100
end

local function PlaySoundAt(SoundInput: Sound, CFrame: CFrame, Func: ((Sound: Sound) -> ())?)
	local Sound = SoundInput:Clone()
	Sound.SoundGroup = SoundGroup
	local Part = NewPart()

	if Func then
		RandomizeSound(Sound)
		Func(Sound)
	end

	Sound.Parent = Part

	Part.CFrame = CFrame
	Part.Parent = GlobalSounds

	table.insert(SoundsList, Sound)
	Sound:Play()

	Sound.Ended:Once(function()
		RemoveSound(Sound)
		Part:Destroy()
	end)
end

local function PlaySoundAtRandom(Sounds: { Sound }, CFrame: CFrame, Func: ((Sound: Sound) -> ())?)
	if #Sounds == 0 then
		return
	end

	local RandomSound = Sounds[math.random(1, #Sounds)]
	PlaySoundAt(RandomSound, CFrame, Func)
end

local function PlaySoundGlobal(SoundInput: Sound, Func: ((Sound: Sound) -> ())?)
	local Sound = SoundInput:Clone()
	Sound.SoundGroup = SoundGroup

	if Func then
		RandomizeSound(Sound)
		Func(Sound)
	end

	Sound.Parent = PlayingSounds

	table.insert(SoundsList, Sound)
	Sound:Play()

	Sound.Ended:Once(function()
		RemoveSound(Sound)
		Sound:Destroy()
	end)
end

local function PlaySoundGlobalWithId(SoundId: string, Func: ((Sound: Sound) -> ())?)
	local Sound = Instance.new("Sound")
	Sound.SoundId = SoundId
	Sound.SoundGroup = SoundGroup

	if Func then
		RandomizeSound(Sound)
		Func(Sound)
	end

	Sound.Parent = PlayingSounds

	table.insert(SoundsList, Sound)
	Sound:Play()

	Sound.Ended:Once(function()
		RemoveSound(Sound)
		Sound:Destroy()
	end)
end

local Module: {
	PlayingSounds: { Sound },
	SoundPlayed: Signal.Signal<Sound>,
	Synced: boolean,
	PlaySoundAt: (SoundInput: Sound, CFrame: CFrame, Func: ((Sound: Sound) -> ())?) -> (),
	PlaySoundAtRandom: (Sounds: { Sound }, CFrame: CFrame, Func: ((Sound: Sound) -> ())?) -> (),
	PlaySoundGlobal: (SoundInput: Sound, Func: ((Sound: Sound) -> ())?) -> (),
	PlaySoundGlobalWithId: (SoundId: string, Func: ((Sound: Sound) -> ())?) -> (),
} =
	{
		PlayingSounds = SoundsList,
		SoundPlayed = Signal.new(),
		Synced = false,
		PlaySoundAt = PlaySoundAt,
		PlaySoundAtRandom = PlaySoundAtRandom,
		PlaySoundGlobal = PlaySoundGlobal,
		PlaySoundGlobalWithId = PlaySoundGlobalWithId,
	}

if RunService:IsClient() then
	task.spawn(function()
		SoundGroup.Volume = SettingsService.GetSetting("SFXVolume", true)
		Module.Synced = true
	end)

	SettingsService.GetSettingChangedSignal("SFXVolume"):Connect(function(Volume: number)
		SoundGroup.Volume = Volume
	end)
end

return Module
