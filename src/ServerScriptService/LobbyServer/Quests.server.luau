--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Network = require(ReplicatedStorage.Network.Server)
local QuestSync = Network.QuestSync
local QuestChanged = Network.QuestChanged
local RedeemQuest = Network.RedeemQuest

local Shared = ReplicatedStorage.Shared
local QuestData = require(Shared.Quests)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

type QuestRemoteInfo = {
	Id: string,
	CurrentValue: number,
	Redeemed: boolean,
}

local function HandlePlayerData(PData: PlayerData.PlayerData)
	local Quests = PData.Profile.Data.Quests

	local SendData = {}

	local function Convert(Name: string)
		local Data = Quests[Name]
		local IndividualData: { [number]: QuestRemoteInfo } = {}

		for Index, QuestInfo in ipairs(Data) do
			IndividualData[Index] = {
				Id = QuestInfo.Id,
				CurrentValue = QuestInfo.CurrentValue,
				Redeemed = QuestInfo.Redeemed,
			}
		end

		SendData[Name] = IndividualData
	end

	Convert("DailyQuests")
	Convert("WeeklyQuests")
	Convert("EventQuests")
	Convert("GlobalQuests")

	local function OnQuestChanged(Quest: QuestData.DefaultQuestData)
		QuestChanged.Fire(PData.Player, {
			Id = Quest.Id,
			CurrentValue = Quest.CurrentValue,
			Redeemed = Quest.Redeemed,
		})
	end

	PData.QuestProgressed:Connect(OnQuestChanged)
	PData.QuestRedeemed:Connect(OnQuestChanged)

	QuestSync.Fire(PData.Player, SendData)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandlePlayerData(Data)
end

PlayerData.DataAdded:Connect(HandlePlayerData)

RedeemQuest.SetCallback(function(Player: Player, QuestId: string)
	local PData = PlayerData.GetPlayerData(Player)

	if not PData then
		return
	end

	PData:RedeemQuest(QuestId)
end)
