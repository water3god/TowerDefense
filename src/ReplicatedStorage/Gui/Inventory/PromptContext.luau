--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)
local React = require(Packages.React)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local NewGui = require(CoreGame.NewGui)

local Inventory = Gui.Inventory
local InventoryPrompt = require(Inventory.InventoryPrompt)

local UnitAdded = Signal.new()

local PromptContext = React.createContext({
	SetVisible = function(Visible: boolean) end,
	Visible = false,
	ClearIds = function() end,
	AddId = function() end,
	SetIds = function() end,
	FilteredIds = {},
	UnitAdded = UnitAdded,
})

local function PromptProvider(props)
	local Visible, SetVisible = React.useState(false)
	local FilteredIds, SetFilteredIds = React.useState({} :: { string })

	local ClearIds = React.useCallback(function()
		SetFilteredIds({})
	end, {})

	local AddId = React.useCallback(function(Id: string)
		local Index = table.find(FilteredIds, Id)
		if Index then
			return
		end
		table.insert(FilteredIds, Id)
		SetFilteredIds(table.clone(FilteredIds))
		UnitAdded:Fire(Id)
	end, { FilteredIds })

	local SetIds = React.useCallback(function(Ids: { string })
		SetFilteredIds(Ids)
	end, {})

	return e(React.Fragment, nil, {
		PromptContext = e(PromptContext.Provider, {
			value = {
				SetVisible = SetVisible,
				Visible = Visible,
				ClearIds = ClearIds,
				FilteredIds = FilteredIds,
				AddId = AddId,
				SetIds = SetIds,
				UnitAdded = UnitAdded,
			},
		}, props.children),
		InventoryPromptGui = e(NewGui, {
			native = {
				DisplayOrder = 5,
			},
		}, {
			InventoryPrompt = e(InventoryPrompt.Prompt, {
				Visible = Visible,
				FilteredIds = FilteredIds,
				SetVisible = SetVisible,
				ClearIds = ClearIds,
				Add = AddId,
				CloseClick = function()
					SetVisible(false)
				end,
			}),
		}),
	})
end

return {
	Context = PromptContext,
	Provider = PromptProvider,
}
