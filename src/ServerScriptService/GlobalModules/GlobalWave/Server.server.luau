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

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

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

local function CalculateXPNormal(Win: boolean, Wave: number, XPMultiplier: number)
	local XP = math.floor(math.pow(Wave, 1.5) * 2)
	XP *= XPMultiplier
	if not Win then
		XP /= 1.5
	end
	return XP
end

local function CalculateXPInfinite(Wave: number, XPMultiplier: number)
	local XP = math.floor(math.pow(Wave, 1.2) * 2)
	XP *= XPMultiplier
	return XP
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
		local TotalXP = 0
		if Wave.IsInfinite then
			TotalXP = CalculateXPInfinite(Wave.Wave, Wave.XPMultiplier)
		else
			TotalXP = CalculateXPNormal(Win, Wave.Wave, Wave.XPMultiplier)
		end

		for _, Player in ipairs(Players:GetPlayers()) do
			local PlayerData = PlayerData.GetPlayerData(Player)
			local SendData = { Units = {}, Resources = {}, ExistingUnits = {} }
			local OtherSendData = {}

			if PlayerData then
				for _, Unit in ipairs(Wave.RewardInfo.Units) do
					PlayerData:AddUnit(Unit)
					table.insert(SendData, Unit)
				end

				for _, Resource in ipairs(Wave.RewardInfo.Resources) do
					if Resource.Resource == "Gold" then
						PlayerData:AddGold(Resource.Count)
					else
						-- Add Artifact --
					end
					table.insert(SendData.Resources, Resource)
				end

				for _, EquippedUnit in ipairs(PlayerData:GetEquippedUnits()) do
					local OldData = PlayerData:GetUnitFromId(EquippedUnit) :: any

					local Data = { Name = OldData.Unit, OldLevel = OldData.Level, OldXP = OldData.XP }
					PlayerData:AddUnitXP(EquippedUnit, TotalXP)
					Data.NewLevel = OldData.Level
					Data.NewXP = OldData.XP
					table.insert(SendData.ExistingUnits, Data)
				end

				OtherSendData.OldXP = PlayerData.Profile.Data.XP
				OtherSendData.OldLevel = PlayerData.Profile.Data.Level

				PlayerData:AddXP(TotalXP / 9)

				OtherSendData.NewXP = PlayerData.Profile.Data.XP
				OtherSendData.NewLevel = PlayerData.Profile.Data.Level

				WaveEnded:FireClient(Player, Win, SendData, OtherSendData)
			end
		end
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
