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
})

export type props = {
	children: { [any]: any }?,
}

local function ContextProvider(props)
	local Inventory, SetInventory = React.useState({
		Units = {},
	})

	React.useEffect(function()
		local Trove = Trove.new()

		Trove:Add(task.spawn(function()
			if not InventoryService.IsSynced then
				InventoryService.Synced:Wait()
			end
			SetInventory(InventoryService:GetInventory())
		end))

		Trove:Connect(InventoryService.UnitAdded, function()
			SetInventory(table.clone(InventoryService:GetInventory()))
		end)

		Trove:Connect(InventoryService.UnitRemoved, function()
			SetInventory(table.clone(InventoryService:GetInventory()))
		end)

		Trove:Connect(InventoryService.UnitChanged, function()
			SetInventory(table.clone(InventoryService:GetInventory()))
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
