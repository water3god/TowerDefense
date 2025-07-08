--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Network = require(ReplicatedStorage.Network.Client)
local QuestSync = Network.QuestSync
local QuestChanged = Network.QuestChanged
local RedeemQuest = Network.RedeemQuest

local Shared = ReplicatedStorage.Shared
local QuestData = require(Shared.Quests)

local Module = {
	Data = nil :: QuestData.Quests?,
	QuestChanged = Signal.new(),
	Synced = Signal.new(),
	IsSynced = false,
}

QuestSync.SetCallback(function(Data)
	local Table = {}
	local function Update(Name: string)
		local QuestSub: { QuestData.QuestRemoteInfo } = Data[Name]
		local ReferenceData = QuestData.QuestsOnly[Name]
		local MergedTable = {}

		for _, Quest in ipairs(QuestSub) do
			for _, ReferenceQuest in ipairs(ReferenceData) do
				if Quest.Id == ReferenceQuest.Id then
					table.insert(MergedTable, {
						Type = ReferenceQuest.Type,
						Id = Quest.Id,
						Name = ReferenceQuest.Name,
						Description = ReferenceQuest.Description,
						Data = Quest.CurrentValue,
						CurrentValue = Quest.CurrentValue,
						NeededValue = ReferenceQuest.NeededValue,
						Redeemed = Quest.Redeemed,
						QuestReward = ReferenceQuest.QuestReward,
					})
				end
			end
		end

		Table[Name] = MergedTable
	end

	Update("DailyQuests")
	Update("WeeklyQuests")
	Update("EventQuests")
	Update("GlobalQuests")
	Table.MetaData = QuestData.Quests.MetaData
	Module.Data = Table
end)

function Module.GetQuestFromId(Id: string): QuestData.QuestRemoteInfo?
	if not Module.Data then
		return nil
	end

	for _, QuestType in pairs(Module.Data) do
		for _, Quest in ipairs(QuestType) do
			if Quest.Id == Id then
				return Quest
			end
		end
	end
	return nil
end

function Module.RedeemQuest(Id: string)
	RedeemQuest.Fire(Id)
end

QuestChanged.SetCallback(function(Data)
	local Quest = Module.GetQuestFromId(Data.Id)
	if not Quest then
		return
	end
	Quest.CurrentValue = Data.CurrentValue
	Quest.Redeemed = Data.Redeemed
	Module.QuestChanged:Fire(Quest)
end)

return Module
