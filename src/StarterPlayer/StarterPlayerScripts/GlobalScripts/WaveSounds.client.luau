--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local SFXService = require(GlobalClient.SFXService)
local WaveService = require(GlobalClient.WaveService)

local Sounds = SoundService.SoundEffects.Sounds
local BaseLoseHp = Sounds.BaseLoseHp
local TimeTick = Sounds.TimeTick

local old = math.huge

WaveService.HealthChanged:Connect(function(new)
	if new < old then
		SFXService.PlaySoundGlobal(BaseLoseHp)
	end

	old = new
end)

local TimeTrove = Trove.new()

local function TimeChanged(TotalTime: number, StartTime: number)
	TimeTrove:Clean()
	local oldtime = 0
	do
		local Time = TotalTime - math.floor(workspace:GetServerTimeNow() - StartTime)
		if Time <= 6 and Time > 0 then
			SFXService.PlaySoundGlobal(TimeTick)
			oldtime = Time
		end
	end
	TimeTrove:Connect(RunService.PostSimulation, function()
		local Time = TotalTime - math.floor(workspace:GetServerTimeNow() - StartTime)
		if Time <= 6 and Time > 0 and Time ~= oldtime then
			SFXService.PlaySoundGlobal(TimeTick)
			oldtime = Time
		end
	end)
end

local Data = WaveService.GetWaveData()

if Data then
	TimeChanged(Data.Time, Data.StartTime)
end

WaveService.TimeChanged:Connect(TimeChanged)
