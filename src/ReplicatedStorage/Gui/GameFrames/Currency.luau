--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local CurrencyService = require(GlobalClient.CurrencyService)

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)
local GameInfo = require(Shared.GameInfo)

export type CurrencyName = "Gold" | "Coins"

export type Currency = {
	CurrencyName: CurrencyName | string,
	Icon: string,
	Value: number,
}

local CurrencyContext = React.createContext({
	CurrencyName = "Gold",
	Icon = "",
	Value = 0,
})

local function CurrencyProvider(props)
	local CurrencyName: CurrencyName, SetCurrencyName = React.useState("Gold" :: CurrencyName)
	local Icon: string, SetIcon = React.useState("")
	local Value, SetValue = React.useState(0)

	React.useEffect(function()
		if IsLobby then
			SetCurrencyName("Gold")
			SetIcon(GameInfo.RewardInfo["Gold"].Image)
		else
			SetCurrencyName("Coins")
			SetIcon("rbxassetid://72304165589077")
		end
	end, {})

	React.useEffect(function()
		SetValue(CurrencyService.Value)
		local Connection = CurrencyService.CurrencyChanged:Connect(SetValue)

		return function()
			Connection:Disconnect()
		end
	end, {})

	return e(CurrencyContext.Provider, {
		value = {
			CurrencyName = CurrencyName,
			Icon = Icon,
			Value = Value,
		},
	}, props.children)
end

return {
	Context = CurrencyContext,
	Provider = CurrencyProvider,
}
