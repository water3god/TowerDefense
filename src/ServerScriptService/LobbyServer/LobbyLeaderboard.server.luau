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

local LevelXPStore = DataStoreService:GetOrderedDataStore(Constants.LevelXPStore)
local TotalGoldStore = DataStoreService:GetOrderedDataStore(Constants.TotalGoldStore)
local RobuxSpentStore = DataStoreService:GetOrderedDataStore(Constants.RobuxSpentStore)

local DataTimer = Timer.new(100)
DataTimer:Start()

local function OnTick() end

OnTick()
DataTimer.Tick:Connect(OnTick)
