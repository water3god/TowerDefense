--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Roles = {
	[255] = "Owner",
	[254] = "Developer",
	[253] = "Admin",
	[200] = "Tester",
	[1] = "Group Member",
}

local function HandleData(Data: PlayerData.PlayerData)
	Promise.try(function()
		return Data.Player:GetRankInGroup(Constants.GroupId)
	end)
		:andThen(function(RoleNumber: number)
			if RoleNumber ~= 0 then
				if Roles[RoleNumber] then
					Data:AddTitle(Roles[RoleNumber])
				end
			end
		end)
		:catch(function(err)
			warn("Error getting group role for player " .. Data.Player.Name .. ": " .. err)
		end)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandleData(Data)
end

PlayerData.DataAdded:Connect(HandleData)
