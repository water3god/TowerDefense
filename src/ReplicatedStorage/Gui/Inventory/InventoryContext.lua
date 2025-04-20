--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local InventoryService = require(ReplicatedStorage.Client.GlobalClient.InventoryService)
local Types = require(ReplicatedStorage.Shared.Types)

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
		task.spawn(function()
			if not InventoryService.IsSynced then
				InventoryService.Synced:Wait()
			end
			SetInventory(InventoryService:GetInventory())
		end)

		local Connection = InventoryService.UnitAdded:Connect(function(Unit: Types.VisualUnitData)
			SetInventory(table.clone(InventoryService:GetInventory()))
		end)

		local Connection1 = InventoryService.UnitRemoved:Connect(function()
			SetInventory(table.clone(InventoryService:GetInventory()))
		end)

		local Connection2 = InventoryService.UnitChanged:Connect(function()
			SetInventory(table.clone(InventoryService:GetInventory()))
		end)

		return function()
			Connection:Disconnect()
			Connection1:Disconnect()
			Connection2:Disconnect()
		end
	end, {})

	return e(InventoryContext.Provider, {
		value = Inventory,
	}, props.children)
end

return {
	Context = InventoryContext,
	Provider = ContextProvider,
}
