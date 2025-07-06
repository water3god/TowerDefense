--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)

local SafePlayer = ServerScriptService.Utility.SafePlayer
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)
local GlobalWave = require(GlobalModules.GlobalWave)

SafePlayerAdded:Connect(function(Player: Player)
	local Data = PlayerData.GetPlayerDataAsync(Player)

	if Data then
		local Leaderstats = Instance.new("Folder")
		Leaderstats.Name = "leaderstats"
		Leaderstats.Parent = Player

		if IsLobby then
			local GoldCount = Instance.new("IntValue")
			GoldCount.Name = "Gold Count"
			GoldCount.Value = Data.Profile.Data.Gold
			GoldCount.Parent = Leaderstats

			Data.GoldChanged:Connect(function(Gold: number)
				GoldCount.Value = Gold
			end)
		else
			local CoinCount = Instance.new("IntValue")
			CoinCount.Name = "Coin Count"

			local function HandleWave(Wave: GlobalWave.GlobalWave)
				CoinCount.Value = Wave.Coins[Player.UserId]
				CoinCount.Parent = Leaderstats

				local Connection = Wave:GetCoinsChangedSignal(Player.UserId):Connect(function(Coins: number)
					CoinCount.Value = Coins
				end)

				local OtherConnection = Player.Destroying:Once(function()
					Connection:Disconnect()
				end)

				Wave.Ended:Once(function()
					OtherConnection:Disconnect()
				end)
			end

			do
				local Wave = GlobalWave.GetWave()
				if Wave then
					HandleWave(Wave)
				end
			end

			GlobalWave.Added:Connect(HandleWave)
		end
	end
end, true)
