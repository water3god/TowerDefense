--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStoreService = game:GetService("DataStoreService")

if game.GameId == 0 then
	return
end

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local Timer = require(Packages.Timer)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local LevelXPStore = DataStoreService:GetOrderedDataStore(Constants.LevelXPStore)
local TotalGoldStore = DataStoreService:GetOrderedDataStore(Constants.TotalGoldStore)
local RobuxSpentStore = DataStoreService:GetOrderedDataStore(Constants.RobuxSpentStore)
local DamageStore = DataStoreService:GetOrderedDataStore(Constants.DamageStore)

local DataTimer = Timer.new(100)
DataTimer:Start()

local function HandleData(PData: PlayerData.PlayerData)
	local UserId = PData.Player.UserId
	local Data = PData.Profile.Data

	local function OnTick()
		Promise.try(function()
			LevelXPStore:UpdateAsync(UserId, function(Level: number?): number?
				if Level ~= Data.Level then
					return Data.Level
				else
					return nil
				end
			end)
		end)

		Promise.try(function()
			TotalGoldStore:UpdateAsync(UserId, function(Gold: number?): number?
				if Gold ~= Data.TotalGoldGained then
					return Data.TotalGoldGained
				else
					return nil
				end
			end)
		end)
		Promise.try(function()
			RobuxSpentStore:UpdateAsync(UserId, function(Robux: number?): number?
				if Robux ~= Data.RobuxSpent then
					return Data.RobuxSpent
				else
					return nil
				end
			end)
		end)
		Promise.try(function()
			DamageStore:UpdateAsync(UserId, function(Damage: number?): number?
				if Damage then
					if math.floor(Damage) ~= math.floor(Data.TotalDamageDone) then
						return math.floor(Data.TotalDamageDone)
					end
				else
					return math.floor(Data.TotalDamageDone)
				end

				return nil
			end)
		end)
	end

	OnTick()
	local Connection = DataTimer.Tick:Connect(OnTick)

	PData.Destroying:Connect(function()
		Connection:Disconnect()
		Connection = nil
	end)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandleData(Data)
end
PlayerData.DataAdded:Connect(HandleData)
