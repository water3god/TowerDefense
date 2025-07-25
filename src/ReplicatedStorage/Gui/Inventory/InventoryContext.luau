--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Trove = require(Packages.Trove)

local InventoryService = require(ReplicatedStorage.Client.GlobalClient.InventoryService)

local InventoryContext = React.createContext({
	Units = {} :: { [string]: InventoryService.VisualUnitData },
	Products = {} :: { [string]: InventoryService.ProductData },
	Resources = {} :: { [string]: InventoryService.ResourceData },
	MaxUnitCount = 100,
})

export type props = {
	children: { [any]: any }?,
}

local function ContextProvider(props)
	local Inventory, SetInventory = React.useState({
		Units = {},
		Products = {},
		Resources = {},
		MaxUnitCount = 100,
	})

	React.useEffect(function()
		local InvTrove = Trove.new()

		local function Update()
			local NewInventory = table.clone(InventoryService:GetInventory()) :: any
			NewInventory.MaxUnitCount = InventoryService.MaxUnitCount
			SetInventory(NewInventory)
		end

		InvTrove:Add(task.spawn(function()
			if not InventoryService.IsSynced then
				InventoryService.Synced:Wait()
			end
			Update()
		end))

		InvTrove:Connect(InventoryService.UnitAdded, Update)
		InvTrove:Connect(InventoryService.UnitRemoved, Update)
		InvTrove:Connect(InventoryService.UnitChanged, Update)
		InvTrove:Connect(InventoryService.ProductAdded, Update)
		InvTrove:Connect(InventoryService.ProductChanged, Update)
		InvTrove:Connect(InventoryService.ProductRemoved, Update)
		InvTrove:Connect(InventoryService.ResourceAdded, Update)
		InvTrove:Connect(InventoryService.ResourceChanged, Update)
		InvTrove:Connect(InventoryService.ResourceRemoved, Update)

		return InvTrove:WrapClean()
	end, {})

	return e(InventoryContext.Provider, {
		value = Inventory,
	}, props.children)
end

return {
	Context = InventoryContext,
	Provider = ContextProvider,
}
