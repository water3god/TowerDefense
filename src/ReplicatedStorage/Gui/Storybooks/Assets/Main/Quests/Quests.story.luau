--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local Quests = Gui.Quests
local QuestsContext = require(Quests.QuestsContext)
local QuestsFrame = require(Quests.QuestsFrame)

-- Controls --
local controls = {}

-- Story --
local Story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function()
		local Frame = e(QuestsContext.Context.Provider, {
			value = {
				Loading = false,
				Data = {
					DailyQuests = {
						{
							Type = "Playtime",
							Id = "Global_Playtime_1",
							Name = "Play for 10 Hours",
							Description = "Play for 10 hours to earn rewards.",
							Data = { Type = "Hours" },
							CurrentValue = 0,
							NeededValue = 10,
							Redeemed = false,
							QuestReward = { Type = "Title", Value = "Player", Count = 1 },
						},
						{
							Type = "Playtime",
							Id = "Global_Playtime_2",
							Name = "Play for 10 Hours",
							Description = "Play for 10 hours to earn rewards.",
							Data = { Type = "Hours" },
							CurrentValue = 0,
							NeededValue = 10,
							Redeemed = false,
							QuestReward = { Type = "Resource", Value = "Gold", Count = 1 },
						},
					},
					WeeklyQuests = {},
					EventQuests = {},
					GlobalQuests = {
						{
							Type = "Playtime",
							Id = "Global_Playtime_1",
							Name = "Play for 10 Hours",
							Description = "Play for 10 hours to earn rewards.",
							Data = { Type = "Hours" },
							CurrentValue = 0,
							NeededValue = 10,
							Redeemed = false,
							QuestReward = { Type = "Title", Value = "Player", Count = 1 },
						},
					},
					MetaData = {
						DailyRegenerated = 0,
						WeeklyRegenerated = 0,
						CurrentEvent = "",
					},
				},
			},
		}, {
			QuestsFrame = e(QuestsFrame, {}),
		})
		return Frame
	end,
}

return Story
