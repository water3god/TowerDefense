--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

local HelperFunctions = require(ReplicatedStorage.Modules.HelperFunctions)

local Network = require(ReplicatedStorage.Network.Server)

local HealthChanged = Network.WaveHealthChanged
local TimeChanged = Network.TimeChanged
local WaveEnded = Network.WaveEnded
local Passed = Network.WavePassed
local Added = Network.WaveAdded

local SendWarning = Network.SendWarning

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Random = Random.new()

local GlobalWave = require(script.Parent)

local function SerializeWave(Wave: GlobalWave.GlobalWave)
	return {
		Wave = Wave.Wave,
		BaseHealth = Wave.BaseHealth,
		MaxHealth = Wave.MaxHealth,
		Time = Wave.Time,
		StartTime = Wave.StartTime,
		MapId = Wave.MapId,
		StageId = Wave.StageId,
	}
end

local function SendHealthInfo(Wave: GlobalWave.GlobalWave)
	HealthChanged.FireAll({
		BaseHealth = Wave.BaseHealth,
		MaxHealth = Wave.MaxHealth,
	})
end

local function CalculateXPNormal(Win: boolean, Wave: number, XPMultiplier: number)
	local XP = math.floor(math.pow(Wave, 2))
	XP *= XPMultiplier
	if not Win then
		XP /= 2
	end
	return XP
end

local function CalculateXPInfinite(Wave: number, XPMultiplier: number)
	local XP = math.floor(math.pow(Wave, 1.2) * 2)
	XP *= XPMultiplier
	return XP
end

local function CalculateGoldPercentage(Win: boolean, Wave: number)
	-- Returns a percentage in [0,1]
	-- Requirements:
	-- - Max at wave 15 with win should be 1
	-- - Early loss (e.g., wave 5) should be drastically smaller (~0.1)
	local base = math.clamp(Wave / 15, 0, 1)
	if Win then
		-- Linear to 1 at wave 15 when winning
		return base
	else
		-- Quadratic scaling penalizes early losses heavily
		-- Pick factor so wave 5 (~0.333) gives ~0.1: 0.85 * (1/3)^2 ≈ 0.094
		local lossFactor = 0.85
		return math.clamp(lossFactor * base * base, 0, 1)
	end
end

local Won = false

local function OnAdded(Wave: GlobalWave.GlobalWave)
	local SerializedWave = SerializeWave(Wave)

	Added.FireAll(SerializedWave)

	Wave.TimeChanged:Connect(function(Time: number, StartTime: number)
		TimeChanged.FireAll({
			Time = Time,
			StartTime = StartTime,
		})
	end)

	Wave.Passed:Connect(function()
		Passed.FireAll(Wave.Wave)
		if Wave.Wave ~= 1 then
			SendWarning.FireAll(
				string.format("Wave Bonus: %u Coins", Wave.Data.Data[Wave.Wave].CoinBonus),
				Color3.new(0.129412, 0.768627, 0.192157)
			)
		end
	end)

	Wave.HealthChanged:Connect(function()
		SendHealthInfo(Wave)
	end)

	Wave.Ended:Connect(function(Win: boolean)
		Won = Win
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
				local GoldMultiplier = PlayerDataModule:CalculateGoldMultiplier()
				local XPMultiplier = PlayerDataModule:CalculateXPMultiplier()

				local WaveMultiplier = HelperFunctions.Round(Wave.Wave / 15, 3)

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
							local Amount = math.floor(Resource.Count * GoldMultiplier)
							PlayerDataModule:AddGold(Amount)

							local NewResource = table.clone(Resource)
							NewResource.Count = Amount

							table.insert(SendData.Resources, NewResource)
						else
							if Wave.IsInfinite then
								local Gold = math.floor((Resource.Count * GoldMultiplier * WaveMultiplier) / 2)
								if Gold > 0 then
									PlayerDataModule:AddGold(Gold)
									local NewResource = table.clone(Resource)
									NewResource.Count = Gold
									table.insert(SendData.Resources, NewResource)
								end
							else
								local Gold = math.floor((Resource.Count * GoldMultiplier) * (WavePercentage / 2))
								if Gold > 0 then
									PlayerDataModule:AddGold(Gold)
									local NewResource = table.clone(Resource)
									NewResource.Count = Gold
									table.insert(SendData.Resources, NewResource)
								end
							end
						end
					elseif Resource.Resource == "XP" then
						continue
					else
						if Wave.IsInfinite then
							local Num = if Resource.Resource == "Omen Coins" then 10 else 15
							local ResourceValue = math.floor(Wave.Wave / Num)
							if ResourceValue > 0 then
								PlayerDataModule:AddResource(Resource.Resource, ResourceValue)
								local NewResource = table.clone(Resource)
								NewResource.Count = ResourceValue
								table.insert(SendData.Resources, NewResource)
							end
						else
							if Win then
								if Resource.Count < 1 then
									if Random:NextNumber(0, 1) <= Resource.Count then
										PlayerDataModule:AddResource(Resource.Resource, 1)
										local NewResource = table.clone(Resource)
										NewResource.Count = 1
										table.insert(SendData.Resources, NewResource)
									end
								else
									PlayerDataModule:AddResource(Resource.Resource, Resource.Count)
									table.insert(SendData.Resources, Resource)
								end
							end
						end
					end
				end

				for _, EquippedUnit in ipairs(PlayerDataModule:GetEquippedUnits()) do
					local OldData = PlayerDataModule:GetUnitFromId(EquippedUnit)

					if OldData then
						local Data = {
							Name = OldData.Unit,
							Trait = OldData.Trait,
							OldLevel = OldData.Level,
							OldXP = OldData.XP,
						}
						PlayerDataModule:AddUnitXP(EquippedUnit, math.floor(TotalXP * 30 * XPMultiplier))
						Data.NewLevel = OldData.Level
						Data.NewXP = OldData.XP
						table.insert(SendData.ExistingUnits, Data)
					end
				end

				OtherSendData.OldXP = PlayerDataModule.Profile.Data.XP
				OtherSendData.OldLevel = PlayerDataModule.Profile.Data.Level

				PlayerDataModule:AddXP(math.floor(TotalXP * 10 * XPMultiplier))

				OtherSendData.NewXP = PlayerDataModule.Profile.Data.XP
				OtherSendData.NewLevel = PlayerDataModule.Profile.Data.Level

				WaveEnded.Fire(Player, Win, SendData, OtherSendData, WavePercentage)
				task.defer(PlayerDataModule.Profile.Save, PlayerDataModule.Profile)
			end
		end
	end)
end

local Wave = GlobalWave.GetWave()
if Wave then
	OnAdded(Wave)
end

GlobalWave.Added:Connect(OnAdded)

local function OnDataAdded(Data: PlayerData.PlayerData)
	local NewWave = GlobalWave.GetWave()

	if NewWave then
		local SerializedWave = SerializeWave(NewWave)
		if not RunService:IsStudio() then
			Added.Fire(Data.Player, SerializedWave)
		end
	else
		WaveEnded.Fire(Data.Player, Won, {
			Units = {},
			Resources = {},
			ExistingUnits = {},
		}, {
			OldXP = Data.Profile.Data.XP,
			NewXP = Data.Profile.Data.XP,
			OldLevel = Data.Profile.Data.Level,
			NewLevel = Data.Profile.Data.Level,
		}, 0)
	end
end

for _, Data in pairs(PlayerData.GetDatas()) do
	OnDataAdded(Data)
end

PlayerData.DataAdded:Connect(OnDataAdded)
