--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)

local SafePlayerAdded = require(ServerScriptService.Utility.SafePlayer.SafePlayerAdded)

local WhiteListedIds = {
	1349722010,
	343804839,
	5007322059,
	1511682135,
	84196769,
	144385534,
	759263,
	1025769455,
	2671136136,
	621274712,
	604935177,
	3574179167,
}

SafePlayerAdded:Connect(function(Player: Player)
	if not table.find(WhiteListedIds, Player.UserId) and Player.UserId > 0 then
		Promise.try(function()
			return Player:GetRankInGroup(Constants.GroupId), Player:IsFriendsWith(343804839)
		end)
			:andThen(function(Rank: number, IsFriend: boolean)
				if Rank < 200 or not IsFriend then
					Player:Kick("You Are not Whitelisted!")
				end
			end)
			:catch(function()
				Player:Kick("Error Validating Whitelist Configuration.")
			end)
	end
end, true)
