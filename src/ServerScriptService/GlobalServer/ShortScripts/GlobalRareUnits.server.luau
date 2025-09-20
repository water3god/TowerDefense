--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MessagingService = game:GetService("MessagingService")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

local NetworkFolder = ReplicatedStorage.Network
local Network = require(NetworkFolder.Server)
local ServerOnly = require(NetworkFolder.ServerOnly)
local RareUnitMessage = Network.RareUnitMessage
local PlayerRolled = ServerOnly.PlayerRolled

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local Constants = require(Shared.Constants)
local RARESUMMONID = Constants.RARESUMMONID

local Rares = { "Godly" }

type RareSummonMessage = {
	PlayerName: string,
	PlayerUserId: number,
	UnitName: string,
}

PlayerRolled:Connect(function(Player: Player, UnitName: string)
	local UnitData = UnitInfo.UnitInfo[UnitName]
	if not UnitData then
		return
	end

	if table.find(Rares, UnitData.Rarity) then
		Promise.try(function()
			MessagingService:PublishAsync(
				RARESUMMONID,
				{
					PlayerName = Player.Name,
					PlayerUserId = Player.UserId,
					UnitName = UnitName,
				} :: RareSummonMessage
			)
		end):catch(function(err)
			warn("Failed to publish rare summon message: " .. err)
		end)
	end
end)

MessagingService:SubscribeAsync(RARESUMMONID, function(Message: { Data: RareSummonMessage, Sent: number })
	RareUnitMessage.FireAll(Message.Data)
end)
