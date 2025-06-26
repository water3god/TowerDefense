--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

type SetDialog = (dialog: DialogType?) -> ()

export type DialogType = {
	Title: string,
	Content: string,
	Buttons: { [string]: () -> () },
	Colors: {
		Background: Color3,
		Title: Color3,
		Content: Color3,
		Buttons: { Color3 },
	},
	SetDialog: SetDialog,
}

local DialogContext = React.createContext({})

local function DialogContextProvider(props)
	local Dialog, SetDialog = React.useState(nil)

	local AdvancedSetDialog = React.useCallback(function() end)

	return e(DialogContext.Provider, {
		value = {
			Dialog = Dialog,
			SetDialog = SetDialog,
		},
	}, props.children)
end

return {
	Context = DialogContext,
	Provider = DialogContextProvider,
}
