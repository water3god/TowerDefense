--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

-- Reference UI --
local Gui = ReplicatedStorage.Gui

local Default = {
	Day = 1,
	LastRedeemed = 1,
	Redeem = function() end,
}

local DailyContext = React.createContext(Default)

local function DailyProvider(props)
	local DailyValue, SetValue = React.useState(Default)

	React.useEffect(function()
		SetValue({
			Day = 1,
			LastRedeemed = 1,
			Redeem = function() end,
		})
	end, {})

	return e(DailyContext.Provider, {
		value = DailyValue,
	}, props.children)
end

return {
	Context = DailyContext,
	Provider = DailyProvider,
}
