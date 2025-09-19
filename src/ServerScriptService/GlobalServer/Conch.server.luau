--!strict

-- By Wa1er_God --

local ADMIN = { -1, 343804839, 1025769455 }

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local Conch = require(Packages.Conch)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local GameInfo = require(Shared.GameInfo)
local ProductInfo = require(Shared.ProductInfo)
local Constants = require(Shared.Constants)
local Conch_types = require(Shared.Conch_types)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)
local GlobalWave = require(GlobalModules.GlobalWave)

local SafePlayer = ServerScriptService.Utility.SafePlayer
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded)
local SafePlayerRemoving = require(SafePlayer.SafePlayerRemoving)

local ServerData = ServerStorage.Data
local EnemyData = require(ServerData.EnemyData)

local Ranks: { [number]: number } = {}

Conch.initiate_default_lifecycle()

Conch.set_role_permissions("developer", "admin", "economy+")
Conch.set_role_permissions("moderator", "admin", "economy+")

Conch.register("addUnit", {
	permissions = { "economy+" },
	arguments = function()
		return Conch.args.player("player", "Player that will receive the unit"),
			Conch_types.UnitType("Unit", "Unit to add")
	end,
	callback = function(player: Player, unit: string)
		local Data = PlayerData.GetPlayerData(player)

		if Data and UnitInfo.UnitInfo[unit] then
			Data:AddUnit(unit)
			Conch.log("info", "Added unit " .. unit .. " to player " .. player.Name)
		else
			Conch.log("error", "Failed to add unit " .. unit .. " to player " .. player.Name)
		end
	end,
})

Conch.register("addProduct", {
	permissions = { "economy+" },
	arguments = function()
		return Conch.args.player("player", "Player that will receive the product"),
			Conch_types.ProductType("product", "Product to add"),
			Conch.args.number("amount", "Amount of product to add")
	end,
	callback = function(player, product, amount)
		local Data = PlayerData.GetPlayerData(player)

		local _, ProductId, _ = ProductInfo.GetProductFromNameOnly(product)

		if Data and ProductId then
			Data:AddProduct(ProductId, amount)
			Conch.log("info", "Added product " .. product .. " to player " .. player.Name)
		else
			Conch.log("error", "Failed to add product " .. product .. " to player " .. player.Name)
		end
	end,
})

Conch.register("addResource", {
	permissions = { "economy+" },
	arguments = function()
		return Conch.args.player("player", "Player that will receive the resource"),
			Conch_types.ResourceType("resource", "Resource to add"),
			Conch.args.number("count", "Amount of resource to add")
	end,
	callback = function(player, resource, count)
		local Data = PlayerData.GetPlayerData(player)

		if Data and GameInfo.RewardInfo[resource] then
			if resource == "Gold" then
				Data:AddGold(count)
			else
				Data:AddResource(resource, count)
			end

			Conch.log("info", "Added resource " .. resource .. " to player " .. player.Name)
		else
			Conch.log("error", "Failed to add resource " .. resource .. " to player " .. player.Name)
		end
	end,
})

Conch.register("addCoins", {
	permissions = { "economy+" },
	arguments = function()
		return Conch.args.player("player", "Player that will receive the coins"),
			Conch.args.number("amount", "Amount of coins to add")
	end,
	callback = function(player, amount)
		local Wave = GlobalWave.GetWave()

		if Wave then
			Wave:AddCoinsToUser(player.UserId, amount)
		else
			Conch.log(
				"error",
				"Failed to add coins to player " .. player.Name .. " because the wave is not initialized"
			)
			return
		end
	end,
})

Conch.register("addEnemy", {
	permissions = { "economy+" },
	arguments = function()
		return Conch_types.EnemyType("enemy", "Enemy to add")
	end,
	callback = function(enemy)
		local Wave = GlobalWave.GetWave()

		if Wave and EnemyData[enemy] then
			Wave:AddEnemy(enemy)
			Conch.log("info", "Added enemy " .. enemy)
		else
			Conch.log("error", "Failed to add enemy " .. enemy)
		end
	end,
})

local function AboveRank(otherPlayer: Player)
	local commandContext = Conch.get_command_context()
	local player = commandContext.executor.player

	if typeof(player) == "Instance" and player:IsA("Player") then
		local OtherRank = Ranks[otherPlayer.UserId]
		if OtherRank then
			return Ranks[player.UserId] and Ranks[player.UserId] > OtherRank
		end
	end

	return false
end

Conch.register("kick", {
	permissions = { "admin" },
	arguments = function()
		return Conch.args.player("player", "Player to kick"), Conch.args.string("reason", "Reason for kicking")
	end,
	callback = function(player, reason)
		if AboveRank(player) then
			player:Kick(reason)
			Conch.log("info", "Kicked player " .. player.Name .. " for reason: " .. reason)
		end
	end,
})

Conch.register("ban", {
	permissions = { "admin" },
	arguments = function()
		return Conch.args.player("player", "Player to ban"),
			Conch.args.duration("duration", "Duration of the ban"),
			Conch.args.string("reason", "Reason for banning")
	end,
	callback = function(player, duration, reason)
		if AboveRank(player) then
			local commandContext = Conch.get_command_context()
			local admin = commandContext.executor.player
			Players:BanAsync({
				UserIds = { player.UserId },
				Duration = duration,
				Reason = reason,
				PrivateReason = reason .. " Banned by " .. admin.Name,
				ApplyToUniverse = true,
			})
			Conch.log("info", "Banned player " .. player.Name .. " for reason: " .. reason)
		end
	end,
})

Conch.register("unban", {
	permissions = { "admin" },
	arguments = function()
		return Conch.args.player("player", "Player to unban")
	end,
	callback = function(player)
		if AboveRank(player) then
			Players:UnbanAsync({
				UserIds = { player.UserId },
				ApplyToUniverse = true,
			})
			Conch.log("info", "Unbanned player " .. player.Name)
		end
	end,
})

SafePlayerAdded:Connect(function(player)
	if table.find(ADMIN, player.UserId) then
		local user = Conch.get_user(player)
		Conch.give_roles(user, "super-user")
	else
		Promise.try(function()
			return player:GetRankInGroup(Constants.GroupId)
		end)
			:andThen(function(rank: number)
				Ranks[player.UserId] = rank
				if rank >= 253 then
					local user = Conch.get_user(player)
					if user then
						Conch.give_roles(user, "super-user")
					end
				end
			end)
			:catch(function()
				Conch.log("error", "Failed to assign role to player " .. player.Name)
			end)
	end
end, true)

SafePlayerRemoving:Connect(function(player)
	Ranks[player.UserId] = nil
end)
