--!strict

-- By Wa1er_God --

export type Dialog = {
	Title: string,
	Message: { string },
	Image: string?,
	Status: string?,
}

-- MapId, StageId, Wave
local Dialogs: { [string]: { [string]: { Dialog } } } = {
	Tutorial = {
		Tutorial = {
			{
				Title = "Trajan",
				Message = {
					"Hello, Welcome to Civilization Tower Defense.",
					"Ill be guiding you through this tutorial",
					"Place down your first unit next to the path to start",
				},
				Image = "rbxassetid://103084517800878",
			},
			{
				Title = "Trajan",
				Message = {
					"Every time a new wave starts you earn some gold.",
					"You also earn gold by defeating enemies.",
					"Use the Gold to upgrade your units.",
					"Upgrade your first unit by clicking on the unit and then the upgrade button",
				},
				Image = "rbxassetid://103084517800878",
			},
			{
				Title = "Trajan",
				Message = {
					"When you're back at the lobby, you can summon new units with Gold in the Summon room.",
					"You can also make your units get stronger by applying traits to them in the Ascension room.",
					"Last Wave of Tutorial. Good Luck!",
				},
				Image = "rbxassetid://103084517800878",
			},
		},
	},
}

return Dialogs
