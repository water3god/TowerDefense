--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

local Modules = ReplicatedStorage.Modules
local RandomGenerate = require(Modules.RandomGenerate)
local HelperFunctions = require(Modules.HelperFunctions)

local Network = require(ReplicatedStorage.Network.Server)

local NewBanner = Network.NewBanner

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)
local Variables = require(Shared.Variables)

local Utility = ServerScriptService.Utility
local SafePlayer = Utility.SafePlayer
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded)
local SafePlayerRemoving = require(SafePlayer.SafePlayerRemoving)

if not IsLobby then
	return
end

local Banner = {
	Egypt = 0.25,
	Rome = 0.25,
	Medieval = 0.25,
	Greece = 0.25,
}

local Data = {
	Egypt = {
		"Akhenaten",
		"Tutankhamun",
		"Ramesses II",
	},
	Greece = {
		"Themistocles",
		"Leonidas",
		"Alexander The Great",
	},
	Rome = {
		"Julius Caesar",
		"Trajan",
		"Augustus",
	},
	Medieval = {
		"Joan of Arc",
		"Richard the Lionheart",
		"William the Conqueror",
	},
}

local CurrentBanner = nil
local NextTime = nil

local function Start()
	return Promise.try(function()
		local CurrentTime = DateTime.now().UnixTimestamp
		NextTime = math.ceil(CurrentTime / 3600) * 3600
		local WaitTime = NextTime - CurrentTime
		local SelectedBanner = RandomGenerate(Banner, NextTime)
		CurrentBanner = SelectedBanner
		Variables.Banner = Data[SelectedBanner]
		NewBanner.FireAll({
			Id = "MAIN",
			TimeEnd = workspace:GetServerTimeNow() + WaitTime,
			Units = Data[SelectedBanner],
		})
		task.wait(WaitTime)
	end):andThen(function()
		return Start()
	end)
end

Start()

SafePlayerAdded:Connect(function(Player: Player)
	if not CurrentBanner then
		repeat
			task.wait()
		until CurrentBanner
	end
	local WaitTime = NextTime - DateTime.now().UnixTimestamp
	NewBanner.Fire(Player, {
		Id = "MAIN",
		TimeEnd = workspace:GetServerTimeNow() + WaitTime,
		Units = Data[CurrentBanner],
	})
end, true)
