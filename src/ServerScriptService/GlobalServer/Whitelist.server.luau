--!strict

-- By Wa1er_God --

local ServerScriptService = game:GetService("ServerScriptService")

local SafePlayerAdded = require(ServerScriptService.Utility.SafePlayer.SafePlayerAdded)

local WhiteListedIds = { 1349722010, 343804839, 5007322059, 1511682135, 84196769, 144385534, 759263, 1025769455 }

SafePlayerAdded:Connect(function(Player: Player)
	if not table.find(WhiteListedIds, Player.UserId) and Player.UserId > 0 then
		Player:Kick("You Are not Whitelisted!")
	end
end, true)
