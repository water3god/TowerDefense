--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Remotes = ReplicatedStorage.Remotes

local Core = Remotes.Core
local AllEquippedSync = Core.AllEquippedSync

local CurrentData = {}

local function Update(Data: PlayerData.PlayerData)
	CurrentData[Data.Player] = Data.Profile.Data.EquippedUnits
	AllEquippedSync:FireAllClients({ [Data.Player] = Data.Profile.Data.EquippedUnits })
end

local function HandleData(Data: PlayerData.PlayerData)
	Update(Data)
	Data.UnitEquipped:Connect(function()
		Update(Data)
	end)

	Data.UnitUnequipped:Connect(function()
		Update(Data)
	end)

	AllEquippedSync:FireClient(Data.Player, CurrentData)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandleData(Data)
end

PlayerData.DataAdded:Connect(HandleData)
