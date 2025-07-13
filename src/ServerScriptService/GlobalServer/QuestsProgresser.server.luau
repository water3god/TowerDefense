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

	local function AddToAll(Property: string, Amount: number)
		DailyQuests[Property] += Amount
		WeeklyQuests[Property] += Amount
		EventQuests[Property] += Amount
		GlobalQuests[Property] += Amount
		Progress(Property :: any, {
			DailyQuests = DailyQuests[Property],
			WeeklyQuests = WeeklyQuests[Property],
			EventQuests = EventQuests[Property],
			GlobalQuests = GlobalQuests[Property],
		})
	end

	local function AddToAllWithParameter(Property: string, Additional: string, Amount: number, ExtraData: any)
		DailyQuests[Property][Additional] += Amount
		WeeklyQuests[Property][Additional] += Amount
		EventQuests[Property][Additional] += Amount
		GlobalQuests[Property][Additional] += Amount
		Progress(Property :: any, {
			DailyQuests = DailyQuests[Property][Additional],
			WeeklyQuests = WeeklyQuests[Property][Additional],
			EventQuests = EventQuests[Property][Additional],
			GlobalQuests = GlobalQuests[Property][Additional],
		}, ExtraData)
	end

	local function HandleUnit(OtherUnit: Unit.Unit)
		if OtherUnit.Owner == PData.Player then
			OtherUnit.Damaged:Connect(function(Damage: number)
				AddToAll("Damage", Damage)

				AddToAllWithParameter("DamageByUnit", OtherUnit.UnitName, Damage, {
					UnitName = OtherUnit.UnitName,
				})

				PData:AddDamageDone(Damage)
			end)

			OtherUnit.KilledEnemy:Connect(function(Enemy)
				AddToAll("Kills", 1)

				AddToAllWithParameter("EnemyKills", Enemy.ModelName, 1, {
					EnemyName = Enemy.ModelName,
				})
			end)
		end
	end

	local PlaytimeTimer = QuestTrove:Construct(Timer, 60)

	PlaytimeTimer.Tick:Connect(function()
		AddToAll("Playtime", 60)
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
			AddToAllWithParameter("Resources", Resource.Resource, Count, { Resource = Resource.Resource })
		end
	end)

	PData.RobuxSpent:Connect(function(_, NewRobuxSpent: number)
		AddToAll("RobuxSpent", NewRobuxSpent)
	end)

	PData.Summoned:Connect(function()
		AddToAll("Summon", 1)
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
				AddToAll("Wins", 1)
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
