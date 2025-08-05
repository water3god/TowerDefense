--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Network = require(ReplicatedStorage.Network.Server)
local BoostsSync = Network.BoostsSync

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local function HandleData(Data: PlayerData.PlayerData)
	local function ProcessDateTime(Time: number)
		local Difference = Time - DateTime.now().UnixTimestamp

		return workspace:GetServerTimeNow() + Difference
	end

	local TableToSend = {}

	for Boost, EndTime in pairs(Data.Profile.Data.Boosts) do
		TableToSend[Boost] = ProcessDateTime(EndTime)
	end

	BoostsSync.Fire(Data.Player, TableToSend)

	Data.BoostChanged:Connect(function(Boost: string, EndTime: number)
		BoostsSync.Fire(Data.Player, {
			[Boost] = ProcessDateTime(EndTime),
		})
	end)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandleData(Data)
end

PlayerData.DataAdded:Connect(HandleData)
