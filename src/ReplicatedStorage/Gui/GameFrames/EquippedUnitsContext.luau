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
	Units: { [number]: { UniqueId: string, Unit: string, Level: number, Trait: string? } },
	GlobalLevel: number,
	XP: number,
	NeededXP: number,
}

local Context = React.createContext({
	Units = {},
	GlobalLevel = 1,
	XP = 10,
	NeededXP = 10,
} :: Value)

local InventoryCache = {
	Units = {},
	GlobalLevel = 1,
	XP = 10,
	NeededXP = 10,
}

local function Provider(props)
	local Equipped, SetEquipped = React.useState(InventoryCache :: Value)

	React.useEffect(function()
		local function Convert(EquippedUnits: { string })
			local NewTable = {}
			local InventoryUnits = InventoryService:GetInventory().Units
			for Index, Id in pairs(EquippedUnits) do
				if Id then
					local Data = InventoryUnits[Id]
					if Data then
						NewTable[Index] = {
							UniqueId = Id,
							Unit = Data.Unit,
							Level = Data.Level,
							Trait = Data.Trait,
						}
					else
						warn("Missing data for equipped unit:", Id)
					end
				end
			end

			return NewTable
		end

		local function Update()
			local Table = {
				Units = Convert(InventoryService.EquippedUnits :: any),
				GlobalLevel = InventoryService.Level,
				XP = InventoryService.XP,
				NeededXP = InventoryService.NeededXP,
			}

			SetEquipped(Table)
			InventoryCache = Table
		end

		task.spawn(function()
			if not InventoryService.IsSynced then
				InventoryService.Synced:Wait()
			end
			Update()
		end)

		local Connection3 = InventoryService.UnitChanged:Connect(Update)
		local Connection = InventoryService.UnitEquipChanged:Connect(Update)
		local Connection1 = InventoryService.LevelChanged:Connect(Update)
		local Connection2 = InventoryService.XPChanged:Connect(Update)

		return function()
			Connection3:Disconnect()
			Connection:Disconnect()
			Connection1:Disconnect()
			Connection2:Disconnect()
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
