--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStoreService = game:GetService("DataStoreService")

local Packages = ReplicatedStorage.Packages
local Timer = require(Packages.Timer)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local LevelXPStore = DataStoreService:GetOrderedDataStore(Constants.LevelXPStore)
local TotalGoldStore = DataStoreService:GetOrderedDataStore(Constants.TotalGoldStore)
local RobuxSpentStore = DataStoreService:GetOrderedDataStore(Constants.RobuxSpentStore)

local DataTimer = Timer.new(100)
DataTimer:Start()

local function HandleData(PlayerData: PlayerData.PlayerData)
	local UserId = PlayerData.Player.UserId
	local Data = PlayerData.Profile.Data

	local function OnTick()
		pcall(function()
			LevelXPStore:UpdateAsync(UserId, function(Level: number?): number?
				if Level ~= Data.Level then
					return Data.Level
				else
					return nil
				end
			end)
		end)

		pcall(function()
			TotalGoldStore:UpdateAsync(UserId, function(Gold: number?): number?
				if Gold ~= Data.TotalGoldGained then
					return Data.TotalGoldGained
				else
					return nil
				end
			end)
		end)

		pcall(function()
			RobuxSpentStore:UpdateAsync(UserId, function(Robux: number?): number?
				if Robux ~= Data.RobuxSpent then
					return Data.RobuxSpent
				else
					return nil
				end
			end)
		end)
	end

	OnTick()
	local Connection = DataTimer.Tick:Connect(OnTick)

	PlayerData.Destroying:Connect(function()
		Connection:Disconnect()
		Connection = nil
	end)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandleData(Data)
end
PlayerData.DataAdded:Connect(HandleData)
