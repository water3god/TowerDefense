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
	Units = {},
	Products = {},
	Resources = {},
})

export type props = {
	children: { [any]: any }?,
}

local function ContextProvider(props)
	local Inventory, SetInventory = React.useState({
		Units = {},
		Products = {},
		Resources = {},
	})

	React.useEffect(function()
		local Trove = Trove.new()

		local function Update()
			SetInventory(table.clone(InventoryService:GetInventory()))
		end

		Trove:Add(task.spawn(function()
			if not InventoryService.IsSynced then
				InventoryService.Synced:Wait()
			end
			Update()
		end))

		Trove:Connect(InventoryService.UnitAdded, Update)
		Trove:Connect(InventoryService.UnitRemoved, Update)
		Trove:Connect(InventoryService.UnitChanged, Update)
		Trove:Connect(InventoryService.ProductAdded, Update)
		Trove:Connect(InventoryService.ProductChanged, Update)
		Trove:Connect(InventoryService.ProductRemoved, Update)
		Trove:Connect(InventoryService.ResourceAdded, Update)
		Trove:Connect(InventoryService.ResourceChanged, Update)
		Trove:Connect(InventoryService.ResourceRemoved, Update)

		return Trove:WrapClean()
	end, {})

	return e(InventoryContext.Provider, {
		value = Inventory,
	}, props.children)
end

return {
	Context = InventoryContext,
	Provider = ContextProvider,
}
