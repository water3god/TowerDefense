--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local MemoryStoreService = game:GetService("MemoryStoreService")
local TeleportService = game:GetService("TeleportService")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local DelayHandler = require(Modules.DelayHandler)

local Network = require(ReplicatedStorage.Network.Server)
local RejoinPrompted = Network.RejoinPrompted
local Rejoin = Network.Rejoin
local SendWarning = Network.SendWarning

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)
local Constants = require(Shared.Constants)
local Types = require(Shared.Types)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local DataFolder = ServerStorage.Data
local MapData = require(DataFolder.MapData)

local MapStore = MemoryStoreService:GetHashMap(Constants.INFORMATIONHASHMAP)

local function HandlePlayerData(PData: PlayerData.PlayerData)
	local Data = PData.Profile.Data

	if Data.MostRecentGameId then
		Promise.retryWithDelay(function()
			return Promise.new(function(resolve)
				resolve(MapStore:GetAsync(Data.MostRecentGameId))
			end)
		end, 5, 1):andThen(function(GameData)
			if GameData then
				RejoinPrompted.Fire(PData.Player)
			end
		end)
	end
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandlePlayerData(Data)
end

PlayerData.DataAdded:Connect(HandlePlayerData)

Rejoin.SetCallback(function(Player: Player)
	if not DelayHandler("RejoinPlayer" .. Player.UserId, 20) then
		return
	end

	local PData = PlayerData.GetPlayerData(Player)

	if not PData then
		return
	end

	if PData then
		local PrivateServerId = PData.Profile.Data.MostRecentGameId

		Promise.new(function(resolve, reject)
			if PrivateServerId then
				local Data = MapStore:GetAsync(PrivateServerId)
				if Data then
					resolve(Data)
				else
					reject()
				end
			else
				reject()
			end
		end)
			:andThen(function(GameData: Types.RecieveData)
				local GameMapData = GameInfo.GetMapFromId(GameData.MapId)

				if not GameMapData then
					error("No GameMapData for " .. GameData.MapId)
				end

				return GameData, GameMapData
			end)
			:tap(function()
				task.wait(3)
			end)
			:andThen(function(GameData: Types.RecieveData, GameMapData: GameInfo.MapInfo)
				local TeleportOptions = Instance.new("TeleportOptions")
				TeleportOptions.ReservedServerAccessCode = GameData.AccessCode
				local MapId = MapData[GameMapData.MapId]

				HelperFunctions.SafeTeleport(function()
					return TeleportService:TeleportAsync(MapId, { Player }, TeleportOptions)
				end, 5)
			end)
			:catch(function()
				SendWarning.Fire(Player, "Error rejoining game.", Color3.fromRGB(255, 0, 0))
			end)
	end
end)
