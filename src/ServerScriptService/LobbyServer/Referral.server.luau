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

	if #Data.Referrals < 5 then
		table.insert(Data.Referrals, RefferedPlayer.UserId)
		PData:AddGold(100)
		SendWarning.Fire(PData.Player, "You have gained 100 gold for referring a friend!", Color3.fromRGB(0, 255, 0))
	else
		SendWarning.Fire(
			PData.Player,
			"You have reached the maximum number of referrals for today.",
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
