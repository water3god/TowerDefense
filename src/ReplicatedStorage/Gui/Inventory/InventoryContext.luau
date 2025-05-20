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
		local Inventory = InventoryService:GetInventory()

		Trove:Add(task.spawn(function()
			if not InventoryService.IsSynced then
				InventoryService.Synced:Wait()
			end
			SetInventory(Inventory)
		end))

		Trove:Connect(InventoryService.UnitAdded, function()
			SetInventory(table.clone(Inventory))
		end)

		Trove:Connect(InventoryService.UnitRemoved, function()
			SetInventory(table.clone(Inventory))
		end)

		Trove:Connect(InventoryService.UnitChanged, function()
			SetInventory(table.clone(Inventory))
		end)

		Trove:Connect(InventoryService.ProductAdded, function()
			SetInventory(table.clone(Inventory))
		end)

		Trove:Connect(InventoryService.ProductChanged, function()
			SetInventory(table.clone(Inventory))
		end)

		Trove:Connect(InventoryService.ProductRemoved, function()
			SetInventory(table.clone(Inventory))
		end)

		Trove:Connect(InventoryService.ResourceAdded, function()
			SetInventory(table.clone(Inventory))
		end)

		Trove:Connect(InventoryService.ResourceChanged, function()
			SetInventory(table.clone(Inventory))
		end)

		Trove:Connect(InventoryService.ResourceRemoved, function()
			SetInventory(table.clone(Inventory))
		end)

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
