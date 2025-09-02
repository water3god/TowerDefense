--!strict

-- By Wa1er_God --

-- Services --

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local TeleportService = game:GetService("TeleportService")

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local Network = require(ReplicatedStorage.Network.Server)
local RejoinPrompted = Network.RejoinPrompted
local Rejoin = Network.Rejoin
local SendWarning = Network.SendWarning

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)
local Types = require(Shared.Types)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local MapStore = MemoryStoreService:GetHashMap(Constants.INFORMATIONHASHMAP)

local function HandlePlayerData(PData: PlayerData.PlayerData)
	local Data = PData.Profile.Data

	if Data.MostRecentGameId then
		local Success, GameData = pcall(function()
			return MapStore:GetAsync(tostring(Data.MostRecentGameId))
		end)

		if Success and GameData then
			RejoinPrompted.Fire(PData.Player)
		end
	end
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandlePlayerData(Data)
end

PlayerData.DataAdded:Connect(HandlePlayerData)

Rejoin.SetCallback(function(Player: Player)
	local PData = PlayerData.GetPlayerData(Player)

	if PData then
		local GameId = PData.Profile.Data.MostRecentGameId

		if GameId then
			local Success, GameData: Types.RecieveData = pcall(function()
				return MapStore:GetAsync(tostring(GameId))
			end)
			if Success and GameData then
				local TeleportOptions = Instance.new("TeleportOptions")
				TeleportOptions.ReservedServerAccessCode = GameData.AccessCode

				task.delay(3, function()
					HelperFunctions.SafeTeleport(function()
						return TeleportService:TeleportAsync(GameId, { Player }, TeleportOptions)
					end, 5)
				end)

				SendWarning.Fire(Player, "Teleporting back to your last game...", Color3.fromRGB(0, 255, 0))
			end
		end
	end
end)
