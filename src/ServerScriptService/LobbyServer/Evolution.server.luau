--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Network = require(ReplicatedStorage.Network.Server)
local UnitEvolved = Network.UnitEvolved
local EvolveUnit = Network.EvolveUnit

local Shared = ReplicatedStorage.Shared
local Evolutions = require(Shared.Evolutions)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

EvolveUnit.SetCallback(function(Player: Player, Data: { UniqueId: string })
	local PlayerDataModule = PlayerData.GetPlayerData(Player)
	if not PlayerDataModule then
		return
	end

	local Unit = PlayerDataModule:GetUnitFromId(Data.UniqueId)
	if not Unit then
		return
	end

	local Evolution = Evolutions[Unit.Unit]

	if Evolution then
		PlayerDataModule:DeleteUnit(Data.UniqueId)
		PlayerDataModule:AddUnit(Evolution.Evolution)
		UnitEvolved.Fire(Player, {
			UnitName = Evolution.Evolution,
		})
	end
end)
