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
	1361762028,

	-- new Testers --

	861744925,
	2509799144,
	856431429,
	2337174744,
	1629810400,
	8775339786,
	8546427672,
	731523741,
	3594198499,
	4292137549,
	1044032395,
	4292137549,
	4891720065,
	943361193,
	3217413440,
	3204827141,
	5604197193,
	7637470296,
	2267421684,
	3332765179,
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
