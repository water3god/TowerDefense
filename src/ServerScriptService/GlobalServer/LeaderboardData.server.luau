--!strict

-- By Wa1er_God --

-- Services --
local ServerScriptService = game:GetService("ServerScriptService")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local Timer = require(Packages.Timer)
local Signal = require(Packages.Signal)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)

local LevelXPStore = DataStoreService:GetOrderedDataStore(Constants.LevelXPStore)
local TotalGoldStore = DataStoreService:GetOrderedDataStore(Constants.TotalGoldStore)
local RobuxSpentStore = DataStoreService:GetOrderedDataStore(Constants.RobuxSpentStore)
local DamageStore = DataStoreService:GetOrderedDataStore(Constants.DamageStore)

local IntTimer = Timer.new(180)
local Updated = Signal.new()

local function HandleInterval(Store: OrderedDataStore)
	return Promise.try(function()
		return Store:GetSortedAsync(false, 100)
	end)
		:andThen(function(Pages)
			return Pages:GetCurrentPage()
		end)
		:andThen(function(Sorted: { [number]: { key: number, value: number } })
			return { Pages = Sorted, Name = Store.Name }
		end)
end

local function HandleAll()
	return Promise.all({
		HandleInterval(LevelXPStore),
		HandleInterval(TotalGoldStore),
		HandleInterval(RobuxSpentStore),
		HandleInterval(DamageStore),
	}):andThen(function(Data)
		Updated:Fire(Data)
	end)
end

local function HandleData(PData: PlayerData.PlayerData)
	local Connection = Updated:Connect(function(Data)
		for _, Leaderboard: { Pages: { [number]: { key: number, value: number } }, Name: string } in pairs(Data) do
			for Position, Entry in ipairs(Leaderboard.Pages) do
				if tonumber(Entry.key) == PData.Player.UserId then
					PData:ChangeLeaderboardPosition(Leaderboard.Name, Position)
				end
			end
		end
	end)

	PData.Destroying:Connect(function()
		Connection:Disconnect()
	end)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandleData(Data)
end

PlayerData.DataAdded:Connect(HandleData)

IntTimer.Tick:Connect(function()
	HandleAll():catch(function(Error)
		warn("Error while updating leaderboard data:", Error)
	end)
end)

IntTimer:Start()
task.wait(2)
HandleAll():catch(function(Error)
	warn("Error while updating leaderboard data:", Error)
end)
