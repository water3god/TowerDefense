--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local HelperFunctions = require(ReplicatedStorage.Modules.HelperFunctions)

local Network = ReplicatedStorage.Network

local Remotes = ReplicatedStorage.Remotes
local WaveEvents = Remotes.Waves
local HealthChanged = WaveEvents.HealthChanged
local TimeChanged = WaveEvents.TimeChanged
local WaveEnded = WaveEvents.WaveEnded
local Passed = WaveEvents.Passed
local Added = WaveEvents.Added

local WarningEvents = require(Network.Warning)
local SendWarning = WarningEvents.FromServer.SendWarning:Server()

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
		if Wave.Wave ~= 1 then
			SendWarning:FireAll(
				string.format("Wave Bonus: %u Coins", Wave.Data.Data[Wave.Wave].CoinBonus),
				Color3.new(0.129412, 0.768627, 0.192157)
			)
		end
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

		local WavePercentage = Wave.Wave / #Wave.Data.Data

		for _, Player in ipairs(Players:GetPlayers()) do
			local PlayerDataModule = PlayerData.GetPlayerData(Player)
			local SendData = { Units = {}, Resources = {}, ExistingUnits = {} }
			local OtherSendData = {}

			if PlayerDataModule then
				if Win then
					for _, Unit in ipairs(Wave.RewardInfo.Units) do
						local Data = PlayerDataModule.Profile.Data

						if HelperFunctions.Len(Data.Units) < Data.MaxUnitCount then
							PlayerDataModule:AddUnit(Unit)
							table.insert(SendData, Unit)
						end
					end
				end

				for _, Resource in ipairs(Wave.RewardInfo.Resources) do
					if Resource.Resource == "Gold" then
						if Win then
							PlayerDataModule:AddGold(Resource.Count)
							table.insert(SendData.Resources, Resource)
						else
							if not Wave.IsInfinite then
								local Amount = math.floor(Resource.Count / WavePercentage / 2)
								if Amount > 0 then
									PlayerDataModule:AddGold(Amount)
									table.insert(SendData.Resources, Resource)
								end
							end
						end
					else
						if Win then
							PlayerDataModule:AddResource(Resource.Resource, Resource.Count)
							table.insert(SendData.Resources, Resource)
						end
					end
				end

				for _, EquippedUnit in ipairs(PlayerDataModule:GetEquippedUnits()) do
					local OldData = PlayerDataModule:GetUnitFromId(EquippedUnit) :: any

					local Data = { Name = OldData.Unit, OldLevel = OldData.Level, OldXP = OldData.XP }
					PlayerDataModule:AddUnitXP(EquippedUnit, TotalXP)
					Data.NewLevel = OldData.Level
					Data.NewXP = OldData.XP
					table.insert(SendData.ExistingUnits, Data)
				end

				OtherSendData.OldXP = PlayerDataModule.Profile.Data.XP
				OtherSendData.OldLevel = PlayerDataModule.Profile.Data.Level

				PlayerDataModule:AddXP(TotalXP / 9)

				OtherSendData.NewXP = PlayerDataModule.Profile.Data.XP
				OtherSendData.NewLevel = PlayerDataModule.Profile.Data.Level

				WaveEnded:FireClient(Player, Win, SendData, OtherSendData, WavePercentage)
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
	local NewWave = GlobalWave.GetWave()

	if NewWave then
		local SerializedWave = SerializeWave(NewWave)
		Added:FireClient(Player, SerializedWave)
	end
end

for _, Player in ipairs(Players:GetPlayers()) do
	OnPlayerAdded(Player)
end

Players.PlayerAdded:Connect(OnPlayerAdded)
