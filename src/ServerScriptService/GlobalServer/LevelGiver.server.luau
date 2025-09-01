--!strict

-- By Wa1er_God --

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local NetworkFolder = ReplicatedStorage.Network
local Network = require(NetworkFolder.Server)
local ServerOnly = require(NetworkFolder.ServerOnly)
local SendWarning = Network.SendWarning

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)

if not IsLobby then
	return
end

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local PlayerLoaded = require(GlobalModules.Short.PlayerLoaded)

local Units = {
	[50] = "Cao Cao",
	[100] = "Qin Shi Huang",
}

local function OnDataAdded(PData: PlayerData.PlayerData)
	local Data = PData.Profile.Data

	local PlayerLoadedSignal = PlayerLoaded(PData.Player)

	PlayerLoadedSignal:Wait()

	if not PData.Player:IsDescendantOf(Players) then
		return
	end

	local function HandleLevel(Level: number)
		for UnitLevel, Unit in pairs(Units) do
			if Level < UnitLevel then
				return
			end

			if table.find(Data.RedeemedLevels, UnitLevel) then
				return
			end

			if Unit then
				PData:AddUnit(Unit)
				SendWarning.Fire(PData.Player, string.format("Level %u: Gained %s", UnitLevel, Unit))
				table.insert(Data.RedeemedLevels, UnitLevel)
			end
		end
	end

	HandleLevel(Data.Level)
	PData.LeveledUp:Connect(HandleLevel)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	OnDataAdded(Data)
end

PlayerData.DataAdded:Connect(OnDataAdded)
