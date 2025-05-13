--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local WaveEvents = ReplicatedStorage.Remotes.Waves
local HealthChanged = WaveEvents.HealthChanged
local TimeChanged = WaveEvents.TimeChanged
local WaveEnded = WaveEvents.WaveEnded
local Passed = WaveEvents.Passed
local Added = WaveEvents.Added

local GlobalWave = require(script.Parent)

local function SerializeWave(Wave: GlobalWave.GlobalWave)
	return {
		Wave = Wave.Wave,
		BaseHealth = Wave.BaseHealth,
		MaxHealth = Wave.MaxHealth,
		Time = Wave.Time,
		StartTime = Wave.StartTime,
	}
end

local function SendHealthInfo(Wave: GlobalWave.GlobalWave)
	HealthChanged:FireAllClients({
		BaseHealth = Wave.BaseHealth,
		MaxHealth = Wave.MaxHealth,
	})
end

local function OnAdded(Wave: GlobalWave.GlobalWave)
	local SerializedWave = SerializeWave(Wave)
	Added:FireAllClients(SerializedWave)

	Wave.TimeChanged:Connect(function(Time: number, StartTime: number)
		TimeChanged:FireAllClients({
			Time = Time,
			StartTime = StartTime,
		})
	end)

	Wave.Passed:Connect(function()
		Passed:FireAllClients(Wave.Wave)
	end)

	Wave.HealthChanged:Connect(function()
		SendHealthInfo(Wave)
	end)

	Wave.Ended:Connect(function(Win: boolean)
		WaveEnded:FireAllClients(Win)
	end)
end

local Wave = GlobalWave.GetWave()
if Wave then
	OnAdded(Wave)
end

GlobalWave.Added:Connect(OnAdded)

local function OnPlayerAdded(Player: Player)
	local Wave = GlobalWave.GetWave()

	if Wave then
		local SerializedWave = SerializeWave(Wave)
		Added:FireAllClients(SerializedWave)
	end
end

for _, Player in ipairs(Players:GetPlayers()) do
	OnPlayerAdded(Player)
end

Players.PlayerAdded:Connect(OnPlayerAdded)
