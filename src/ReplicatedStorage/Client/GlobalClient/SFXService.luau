--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SmoothVoxelsUpgraderService = game:GetService("SmoothVoxelsUpgraderService")
local SoundService = game:GetService("SoundService")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local GlobalClient = ReplicatedStorage.Client.GlobalClient
local SettingsService = require(GlobalClient.SettingsService)

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

local function PlaySoundAt(SoundInput: Sound, CFrame: CFrame, Func: ((Sound: Sound) -> ())?)
	local Sound = SoundInput:Clone()
	Sound.SoundGroup = SoundGroup
	local Part = NewPart()

	if Func then
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

local function PlaySoundGlobal(SoundInput: Sound, Func: ((Sound: Sound) -> ())?)
	local Sound = SoundInput:Clone()
	Sound.SoundGroup = SoundGroup

	if Func then
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
	PlaySoundAt: (SoundInput: Sound, CFrame: CFrame, Func: (() -> ())?) -> (),
	PlaySoundGlobal: (SoundInput: Sound, Func: (() -> ())?) -> (),
} =
	{
		PlayingSounds = SoundsList,
		SoundPlayed = Signal.new(),
		Synced = false,
		PlaySoundAt = PlaySoundAt,
		PlaySoundGlobal = PlaySoundGlobal,
	}

task.spawn(function()
	SoundGroup.Volume = SettingsService.GetSetting("SFXVolume", true)
	Module.Synced = true
end)

SettingsService.GetSettingChangedSignal("SFXVolume"):Connect(function(Volume: number)
	SoundGroup.Volume = Volume
end)

return Module
