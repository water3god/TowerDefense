--!strict

-- By Wa1er_God --

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Network = require(ReplicatedStorage.Network.Server)
local SendWarning = Network.SendWarning

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local SafePlayerAdded = require(ServerScriptService.Utility.SafePlayer.SafePlayerAdded)

local IsLobby = require(Shared.IsLobby)

if not IsLobby then
	return
end

type JoinData = {
	SourceGameId: number,
	SourcePlaceId: number,
	ReferredByPlayerId: number,
	Members: { number },
	TeleportData: any,
	LaunchData: string,
	GameJoinContext: {
		JoinSource: Enum.JoinSource?,
		ItemType: Enum.AvatarItemType?,
		AssetId: string?,
		OutfitId: string?,
		AssetType: Enum.AssetType?,
	},
}

local function AddReferral(PData: PlayerData.PlayerData, RefferedPlayer: Player)
	local Data = PData.Profile.Data

	if #Data.Referrals < Constants.MaxReferrals then
		table.insert(Data.Referrals, RefferedPlayer.UserId)
		PData:AddGold(Constants.GoldReferral)
		SendWarning.Fire(
			PData.Player,
			string.format("You have gained %d gold for referring a friend!", Constants.GoldReferral),
			Color3.fromRGB(0, 255, 0)
		)
	else
		SendWarning.Fire(
			PData.Player,
			string.format("You have reached the maximum number (%d) of referrals for today.", Constants.MaxReferrals),
			Color3.fromRGB(255, 0, 0)
		)
	end
end

SafePlayerAdded:Connect(function(Player)
	local JoinData: JoinData = Player:GetJoinData() :: JoinData

	if JoinData.ReferredByPlayerId then
		local ReferredByPlayer = Players:GetPlayerByUserId(JoinData.ReferredByPlayerId)

		if ReferredByPlayer then
			local PData = PlayerData.GetPlayerData(ReferredByPlayer)
			if PData then
				AddReferral(PData, Player)
			end
		end
	end
end, true)
