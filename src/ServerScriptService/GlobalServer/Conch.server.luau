--!strict

-- By Wa1er_God --

local ADMIN = { 343804839 }

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local Conch = require(Packages.Conch)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)

local SafePlayer = ServerScriptService.Utility.SafePlayer
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded)

Conch.initiate_default_lifecycle()

SafePlayerAdded:Connect(function(player)
	if table.find(ADMIN, player.UserId) then
		local user = Conch.get_user(player)
		Conch.give_roles(user, "super-user")
	end
end, true)
