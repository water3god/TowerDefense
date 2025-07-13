--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Timer = require(Packages.Timer)
local Trove = require(Packages.Trove)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)
local GlobalWave = require(GlobalModules.GlobalWave)
local Unit = require(GlobalModules.Unit)

local Shared = ReplicatedStorage.Shared
local QuestInfo = require(Shared.Quests)
local GameInfo = require(Shared.GameInfo)

local function HandlePlayerData(PData: PlayerData.PlayerData)
	local Data = PData.Profile.Data
	local QuestData = Data.QuestData

	local DailyQuests = QuestData.DailyQuests
	local WeeklyQuests = QuestData.WeeklyQuests
	local EventQuests = QuestData.EventQuests
	local GlobalQuests = QuestData.GlobalQuests

	local QuestTrove = PData._Trove:Extend()

	local function Progress(
		Type: QuestInfo.QuestType,
		Amount: number | { [string | QuestInfo.QuestSubs]: number },
		ExtraData: any
	)
		if typeof(Amount) == "number" then
			PData:ProgressQuests({ Type = Type, Amount = Amount, ExtraData = ExtraData })
		else
			for QuestType, QuestAmount in pairs(Amount) do
				PData:ProgressQuests({ Type = Type, SubType = QuestType, Amount = QuestAmount, ExtraData = ExtraData })
			end
		end
	end

	local function HandleUnit(OtherUnit: Unit.Unit)
		if OtherUnit.Owner == PData.Player then
			OtherUnit.Damaged:Connect(function(Damage: number)
				DailyQuests.Damage += Damage
				WeeklyQuests.Damage += Damage
				EventQuests.Damage += Damage
				GlobalQuests.Damage += Damage
				Progress("Damage", {
					DailyQuests = DailyQuests.Damage,
					WeeklyQuests = WeeklyQuests.Damage,
					EventQuests = EventQuests.Damage,
					GlobalQuests = GlobalQuests.Damage,
				})

				DailyQuests.DamageByUnit[OtherUnit.UnitName] += Damage
				WeeklyQuests.DamageByUnit[OtherUnit.UnitName] += Damage
				EventQuests.DamageByUnit[OtherUnit.UnitName] += Damage
				GlobalQuests.DamageByUnit[OtherUnit.UnitName] += Damage
				Progress("DamageByUnit", {
					DailyQuests = DailyQuests.DamageByUnit[OtherUnit.UnitName],
					WeeklyQuests = WeeklyQuests.DamageByUnit[OtherUnit.UnitName],
					EventQuests = EventQuests.DamageByUnit[OtherUnit.UnitName],
					GlobalQuests = GlobalQuests.DamageByUnit[OtherUnit.UnitName],
				}, {
					UnitName = OtherUnit.UnitName,
				})
				PData:AddDamageDone(Damage)
			end)

			OtherUnit.KilledEnemy:Connect(function(Enemy)
				DailyQuests.Kills += 1
				WeeklyQuests.Kills += 1
				EventQuests.Kills += 1
				GlobalQuests.Kills += 1
				Progress("Kills", {
					DailyQuests = DailyQuests.Kills,
					WeeklyQuests = WeeklyQuests.Kills,
					EventQuests = EventQuests.Kills,
					GlobalQuests = GlobalQuests.Kills,
				})

				DailyQuests.EnemyKills[Enemy.ModelName] += 1
				WeeklyQuests.EnemyKills[Enemy.ModelName] += 1
				EventQuests.EnemyKills[Enemy.ModelName] += 1
				GlobalQuests.EnemyKills[Enemy.ModelName] += 1
				Progress("EnemyKills", {
					DailyQuests = DailyQuests.EnemyKills[Enemy.ModelName],
					WeeklyQuests = WeeklyQuests.EnemyKills[Enemy.ModelName],
					EventQuests = EventQuests.EnemyKills[Enemy.ModelName],
					GlobalQuests = GlobalQuests.EnemyKills[Enemy.ModelName],
				}, {
					EnemyName = Enemy.ModelName,
				})
			end)
		end
	end

	local PlaytimeTimer = QuestTrove:Construct(Timer, 60)

	PlaytimeTimer.Tick:Connect(function()
		DailyQuests.Playtime += 60
		WeeklyQuests.Playtime += 60
		EventQuests.Playtime += 60
		GlobalQuests.Playtime += 60
		Progress("Playtime", {
			DailyQuests = DailyQuests.Playtime,
			WeeklyQuests = WeeklyQuests.Playtime,
			EventQuests = EventQuests.Playtime,
			GlobalQuests = GlobalQuests.Playtime,
		})
	end)

	for _, OtherUnit in pairs(Unit.GetUnits()) do
		HandleUnit(OtherUnit)
	end

	QuestTrove:Connect(Unit.Added, HandleUnit)

	local function SetLeaderboard(LeaderboardName: string, QuestType: string, Position: number)
		local CurrentValue = QuestData[QuestType].Leaderboard[LeaderboardName]
		if CurrentValue and CurrentValue <= Position then
			return
		end

		QuestData[QuestType].Leaderboard[LeaderboardName] = Position
	end

	PData.LeaderboardChanged:Connect(function(LeaderboardName: string, Position: number)
		SetLeaderboard(LeaderboardName, "DailyQuests", Position)
		SetLeaderboard(LeaderboardName, "WeeklyQuests", Position)
		SetLeaderboard(LeaderboardName, "EventQuests", Position)
		SetLeaderboard(LeaderboardName, "GlobalQuests", Position)
		Progress("Leaderboard", {
			DailyQuests = DailyQuests.Leaderboard[LeaderboardName],
			WeeklyQuests = WeeklyQuests.Leaderboard[LeaderboardName],
			EventQuests = EventQuests.Leaderboard[LeaderboardName],
			GlobalQuests = GlobalQuests.Leaderboard[LeaderboardName],
		}, { LeaderboardName = LeaderboardName, Position = Position })
	end)

	PData.ResourceChanged:Connect(function(Type: string, Resource, Count: number?)
		if not Count then
			return
		end
		if Type == "Added" then
			DailyQuests.Resources[Resource.Resource] += Count
			WeeklyQuests.Resources[Resource.Resource] += Count
			EventQuests.Resources[Resource.Resource] += Count
			GlobalQuests.Resources[Resource.Resource] += Count
			Progress("Resources", {
				DailyQuests = DailyQuests.Resources[Resource.Resource],
				WeeklyQuests = WeeklyQuests.Resources[Resource.Resource],
				EventQuests = EventQuests.Resources[Resource.Resource],
				GlobalQuests = GlobalQuests.Resources[Resource.Resource],
			}, { Resource = Resource.Resource })
		end
	end)

	PData.RobuxSpent:Connect(function(_, NewRobuxSpent: number)
		DailyQuests.RobuxSpent += NewRobuxSpent
		WeeklyQuests.RobuxSpent += NewRobuxSpent
		EventQuests.RobuxSpent += NewRobuxSpent
		GlobalQuests.RobuxSpent += NewRobuxSpent
		Progress("RobuxSpent", {
			DailyQuests = DailyQuests.RobuxSpent,
			WeeklyQuests = WeeklyQuests.RobuxSpent,
			EventQuests = EventQuests.RobuxSpent,
			GlobalQuests = GlobalQuests.RobuxSpent,
		})
	end)

	PData.Summoned:Connect(function()
		DailyQuests.Summon += 1
		WeeklyQuests.Summon += 1
		EventQuests.Summon += 1
		GlobalQuests.Summon += 1
		Progress("Summon", {
			DailyQuests = DailyQuests.Summon,
			WeeklyQuests = WeeklyQuests.Summon,
			EventQuests = EventQuests.Summon,
			GlobalQuests = GlobalQuests.Summon,
		})
	end)

	for MapName, Stages in pairs(Data.CompletedMaps) do
		local Default = GameInfo.GetMapFromId(MapName)
		if not Default then
			continue
		end
		Progress("Map", 1, { MapName = MapName })
		for Stage, _ in pairs(Stages) do
			Progress("MapStage", Stage, { MapName = MapName, Stage = Stage })
		end
	end

	Progress("Level", Data.Level)

	local function OnWave(Wave: GlobalWave.GlobalWave)
		QuestTrove:Connect(Wave.Ended, function(Win: boolean)
			if Win then
				DailyQuests.Wins += 1
				WeeklyQuests.Wins += 1
				EventQuests.Wins += 1
				GlobalQuests.Wins += 1
				Progress("Wins", {
					DailyQuests = DailyQuests.Wins,
					WeeklyQuests = WeeklyQuests.Wins,
					EventQuests = EventQuests.Wins,
					GlobalQuests = GlobalQuests.Wins,
				})
			end
		end)
	end

	do
		local Wave = GlobalWave.GetWave()
		if Wave then
			OnWave(Wave)
		end
		QuestTrove:Connect(GlobalWave.Added, OnWave)
	end

	PlaytimeTimer:Start()
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandlePlayerData(Data)
end

PlayerData.DataAdded:Connect(HandlePlayerData)
