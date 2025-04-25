--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Remotes = ReplicatedStorage.Remotes
local CurrencyEvents = Remotes.Currencies
local CoinChanged = CurrencyEvents.CoinChanged
local CoinSync = CurrencyEvents.CoinSync
local YenChanged = CurrencyEvents.YenChanged

local Data = {}
Data.CoinIsSynced = false
Data.CoinSynced = Signal.new()

Data.CoinChanged = Signal.new()
Data.YenChanged = Signal.new()

Data.YenConnected = false
Data.YenConnect = Signal.new()

local CurrentData = {
	Coins = 0,
	Yen = 0,
}

Data.CurrencyData = CurrentData

CoinSync.OnClientEvent:Connect(function(Coins: number)
	CurrentData.Coins = Coins
	Data.CoinIsSynced = true
	Data.CoinSynced:Fire()
end)

CoinChanged.OnClientEvent:Connect(function(Coins: number)
	CurrentData.Coins = Coins

	Data.CoinChanged:Fire(Coins)
end)

YenChanged.OnClientEvent:Connect(function(Yen: number)
	CurrentData.Yen = Yen
	Data.YenChanged:Fire(Yen)

	if not Data.YenConnected then
		Data.YenConnected = true
		Data.YenConnect:Fire(true)
	end
end)

return Data
