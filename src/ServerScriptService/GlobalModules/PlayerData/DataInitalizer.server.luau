--!strict

-- By Wa1er_God --

local ServerScriptService = game:GetService("ServerScriptService");

local PlayerData = require(script.Parent);

require(game:GetService("ServerScriptService").Utility.SafePlayer.SafePlayerAdded):Connect(function(Player)
	PlayerData.new(Player);
end, true);