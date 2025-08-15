--!strict

-- By Wa1er_God --

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Hooks = require(CoreGame.Hooks)
local PurchaseContext = require(Gui.Store.PurchaseContext)

local MultiplierContext = React.createContext(1)

local function MultiplierProvider(props)
	local PurchaseData = React.useContext(PurchaseContext.Context)
	local MembershipType = Hooks.useMembership(LocalPlayer)

	local Value, SetValue = React.useState(1)

	React.useEffect(function()
		local Multiplier = 1

		for Id, Gamepass in ipairs(PurchaseData.GamepassData) do
			if Id == 1382164818 and Gamepass.Owned then
				Multiplier += 0.2
			end
		end

		if MembershipType == Enum.MembershipType.Premium then
			Multiplier += 0.1
		end

		SetValue(Multiplier)
	end, { PurchaseData.GamepassData, MembershipType } :: { unknown })

	return e(MultiplierContext.Provider, {
		value = Value,
	}, props.children)
end

return {
	Context = MultiplierContext,
	Provider = MultiplierProvider,
}
