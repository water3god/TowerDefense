--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Trove = require(Packages.Trove)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local TradeService = require(ReplicatedStorage.Client.LobbyClient.TradeService)

local TradeContext = React.createContext({})

export type props = {
	children: { [any]: any }?,
}

local function TradeContextProvider(props: props)
	local TradeStatuses, SetTradeStatuses = React.useState({} :: { [Player]: string })

	React.useEffect(function()
		local Trove = Trove.new()
		Trove:Connect(TradeService.SyncedStatus, function(OtherPlayer: Player, Status: string)
			if Player ~= OtherPlayer then
				SetTradeStatuses(Join(TradeStatuses, {
					[OtherPlayer] = Status,
				}))
			end
		end)

		Trove:Connect(Players.PlayerRemoving, function(OtherPlayer)
			if Player ~= OtherPlayer then
				local NewTable = table.clone(TradeStatuses)
				NewTable[OtherPlayer] = nil
				SetTradeStatuses(NewTable)
			end
		end)

		return Trove:WrapClean()
	end, {})

	return e(TradeContext.Provider, {
		value = TradeStatuses,
	}, props.children)
end

return {
	Context = TradeContext,
	Provider = TradeContextProvider,
}
