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
local IsLobby = require(Shared.IsLobby)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

if not IsLobby then
	return
end

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

	local function OnProgressed(Data: { { Id: string, Data: QuestData.DefaultQuestData } })
		local IndividualData: { [number]: QuestRemoteInfo } = {}
		for Index, QuestInfo in ipairs(Data) do
			IndividualData[Index] = {
				Id = QuestInfo.Id,
				CurrentValue = QuestInfo.Data.CurrentValue,
				Redeemed = QuestInfo.Data.Redeemed,
				Data = QuestInfo.Data.Data, -- This field is optional, but included for completeness
			}
		end
		QuestChanged.Fire(PData.Player, IndividualData)
	end

	local function OnRedeemed(Quest: QuestData.DefaultQuestData)
		print("Redeemed")
		QuestChanged.Fire(PData.Player, {
			{
				Id = Quest.Id,
				CurrentValue = Quest.CurrentValue,
				Redeemed = Quest.Redeemed,
				Data = Quest.Data,
			},
		})
	end

	PData.QuestProgressed:Connect(OnProgressed)
	PData.QuestRedeemed:Connect(OnRedeemed)

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
