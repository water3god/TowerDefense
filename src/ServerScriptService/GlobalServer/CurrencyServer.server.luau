--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Remotes = ReplicatedStorage.Remotes
local Core = Remotes.Core
local CurrencyChanged = Core.CurrencyChanged

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
		CurrencyChanged:FireClient(Data.Player, Data.Profile.Data.Gold)

		Data.GoldChanged:Connect(function(Gold: number)
			CurrencyChanged:FireClient(Data.Player, Gold)
		end)
	end

	for _, Data in pairs(PlayerData.GetDatas()) do
		HandlePlayerData(Data)
	end

	PlayerData.DataAdded:Connect(HandlePlayerData)
else
	local function SendPlayerData(GlobalWave: GlobalWave.GlobalWave, Player: Player)
		local CoinCount = GlobalWave.Coins[Player.UserId]
		if CoinCount then
			CurrencyChanged:FireClient(Player, CoinCount)
		end
	end

	GlobalWave.Added:Connect(function(GlobalWave: GlobalWave.GlobalWave)
		for _, Player in ipairs(Players:GetPlayers()) do
			if GlobalWave.Coins[Player.UserId] then
				SendPlayerData(GlobalWave, Player)
			end
		end

		GlobalWave.CoinsChanged:Connect(function(UserId: number, Coins: number)
			local Player = Players:GetPlayerByUserId(UserId)

			if Player then
				CurrencyChanged:FireClient(Player, Coins)
			end
		end)
	end)

	SafePlayerAdded:Connect(function(Player: Player)
		local Wave = GlobalWave.GetWave()

		if Wave and Wave.Coins[Player.UserId] then
			CurrencyChanged:FireClient(Player, Wave.Coins[Player.UserId])
		end
	end, true)
end
