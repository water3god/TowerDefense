--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Network = require(ReplicatedStorage.Network.Server)
local ChooseStarter = Network.ChooseStarter
local FirstJoin = Network.FirstJoin

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)

if not IsLobby then
	return
end

local function HandleData(PData: PlayerData.PlayerData)
	local Data = PData.Profile.Data

	if not Data.StarterChosen then
		FirstJoin.Fire(PData.Player)
	end
end

for _, PData in pairs(PlayerData.GetDatas()) do
	HandleData(PData)
end

PlayerData.DataAdded:Connect(HandleData)

local Units = {
	"Pyrrhus",
	"Robert the Bruce",
	"Pompey",
}

ChooseStarter.SetCallback(function(Player: Player, StarterName: string)
	if not table.find(Units, StarterName) then
		error("Invalid starter unit chosen: " .. StarterName .. " for player " .. Player.Name)
	end

	local PData = PlayerData.GetPlayerData(Player)

	if PData then
		local Data = PData.Profile.Data

		if not Data.StarterChosen then
			Data.StarterChosen = true
			local UnitData = PData:AddUnit(StarterName)
			if UnitData then
				PData:EquipUnit(UnitData.UniqueId)
			end
		end
	end
end)
