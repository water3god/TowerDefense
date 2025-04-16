--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local InventoryService = require(ReplicatedStorage.Client.GlobalClient.InventoryService)

export type Value = {
	Value: { [number]: { UniqueId: string, Unit: string, Level: number } },
	GlobalLevel: number,
}

local Context = React.createContext({} :: Value)

local function Provider(props)
	local Equipped, SetEquipped = React.useState({} :: Value)
	local Inventory = InventoryService:GetInventory()

	React.useEffect(function()
		local function Convert(EquippedUnits: { string })
			local NewTable = {}
			for Index, Id in pairs(EquippedUnits) do
				local Data = Inventory.Units[Id]
				NewTable[Index] = {
					UniqueId = Id,
					Unit = Data.Unit,
					Level = Data.Level,
				}
			end

			return NewTable
		end

		task.spawn(function()
			if not InventoryService.IsSynced then
				InventoryService.Synced:Wait()
			end
			SetEquipped({ Value = Convert(InventoryService.EquippedUnits), GlobalLevel = InventoryService.Level })
		end)

		local Connection = InventoryService.UnitEquipChanged:Connect(function()
			SetEquipped({ Value = Convert(InventoryService.EquippedUnits), GlobalLevel = InventoryService.Level })
		end)

		local Connection1 = InventoryService.LevelChanged:Connect(function()
			SetEquipped({ Value = Convert(InventoryService.EquippedUnits), GlobalLevel = InventoryService.Level })
		end)

		return function()
			Connection:Disconnect()
			Connection1:Disconnect()
		end
	end, {})

	return e(Context.Provider, {
		value = Equipped,
	}, props.children)
end

return {
	Context = Context,
	Provider = Provider,
}
