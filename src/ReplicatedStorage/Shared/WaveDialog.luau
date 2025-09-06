--!strict

-- By Wa1er_God --

export type Dialog = {
	Title: string,
	Message: { string },
	Image: string?,
}

-- MapId, StageId, Wave
local Dialogs: { [string]: { [string]: { Dialog } } } = {
	Tutorial = {
		Tutorial = {
			{
				Title = "PCER",
				Message = { "This is a tutorial message." },
				Image = "rbxassetid://123456789",
			},
			{
				Title = "Another Tutorial Step",
				Message = { "This is another tutorial message." },
				Image = "rbxassetid://987654321",
			},
		},
	},
}

return Dialogs
