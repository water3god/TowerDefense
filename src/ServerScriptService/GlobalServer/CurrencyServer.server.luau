--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Network = require(ReplicatedStorage.Network.Server)
local CurrencyChanged = Network.CurrencyChanged

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)

local GlobalModules = ServerScriptService.GlobalModules
local GlobalWave = require(GlobalModules.GlobalWave)
local PlayerData = require(GlobalModules.PlayerData)

local Utility = ServerScriptService.Utility
local SafePlayer = Utility.SafePlayer
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded)

if IsLobby then
	local function HandlePlayerData(Data: PlayerData.PlayerData)
		CurrencyChanged.Fire(Data.Player, Data.Profile.Data.Gold)

		Data.GoldChanged:Connect(function(Gold: number)
			CurrencyChanged.Fire(Data.Player, Gold)
		end)
	end

	for _, Data in pairs(PlayerData.GetDatas()) do
		HandlePlayerData(Data)
	end

	PlayerData.DataAdded:Connect(HandlePlayerData)
else
	local function SendPlayerData(Wave: GlobalWave.GlobalWave, Player: Player)
		local CoinCount = Wave.Coins[Player.UserId]
		if CoinCount then
			CurrencyChanged.Fire(Player, CoinCount)
		end
	end

	local function OnGlobalWave(Wave: GlobalWave.GlobalWave)
		for _, Player in ipairs(Players:GetPlayers()) do
			if Wave.Coins[Player.UserId] then
				SendPlayerData(Wave, Player)
			end
		end

		Wave.CoinsChanged:Connect(function(UserId: number, Coins: number)
			local Player = Players:GetPlayerByUserId(UserId)

			if Player then
				CurrencyChanged.Fire(Player, Coins)
			end
		end)
	end

	local Wave = GlobalWave.GetWave()

	if Wave then
		OnGlobalWave(Wave)
	end

	GlobalWave.Added:Connect(OnGlobalWave)

	SafePlayerAdded:Connect(function(Player: Player)
		local OtherWave = GlobalWave.GetWave()

		if OtherWave and OtherWave.Coins[Player.UserId] then
			CurrencyChanged.Fire(Player, OtherWave.Coins[Player.UserId])
		end
	end, true)
end
