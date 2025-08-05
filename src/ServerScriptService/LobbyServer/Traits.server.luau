--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Network = require(ReplicatedStorage.Network.Server)
local RollTrait = Network.RollTrait
local TraitRolled = Network.TraitRolled

local Modules = ReplicatedStorage.Modules
local RandomGenerate = require(Modules.RandomGenerate)

local Shared = ReplicatedStorage.Shared
local Traits = require(Shared.Traits)
local IsLobby = require(Shared.IsLobby)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local TraitChances = {}

for TraitName, TraitData in pairs(Traits.Traits) do
	TraitChances[TraitName] = TraitData.Chance
end

if not IsLobby then
	return
end

RollTrait.SetCallback(function(Player: Player, Data: { UniqueId: string })
	local PlayerDataModule = PlayerData.GetPlayerData(Player)
	if not PlayerDataModule then
		return
	end

	local Unit = PlayerDataModule:GetUnitFromId(Data.UniqueId)
	if not Unit then
		return
	end

	local HasEnoughCoins = PlayerDataModule:HasEnoughResource("Omen Coins", 1)
	if not HasEnoughCoins then
		return
	end

	local TraitName = RandomGenerate(TraitChances)

	if TraitName then
		PlayerDataModule:RemoveResource("Omen Coins", 1)
		PlayerDataModule:ChangeUnitTrait(Unit.UniqueId, TraitName)
		TraitRolled.Fire(Player, {
			UniqueId = Unit.UniqueId,
			NewTrait = TraitName,
		})
	end
end)
