--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local TeleportService = game:GetService("TeleportService")
local MemoryStoreService = game:GetService("MemoryStoreService")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

local Network = require(ReplicatedStorage.Network.Server)
local TutorialSent = Network.TutorialSent
local AcceptTutorial = Network.AcceptTutorial
local SendWarning = Network.SendWarning

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)
local IsTutorial = require(Shared.IsTutorial)
local Constants = require(Shared.Constants)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local DataFolder = ServerStorage.Data
local MapData = require(DataFolder.MapData)

local MapStore = MemoryStoreService:GetHashMap(Constants.INFORMATIONHASHMAP)

if IsTutorial then
	return
end

if not require(ReplicatedStorage.Shared.IsLobby) then
	return
end

local function HandlePlayerData(PData: PlayerData.PlayerData)
	local Data = PData.Profile.Data

	if not Data.PassedTutorial then
		TutorialSent.Fire(PData.Player)
	end
end

for _, Data in pairs(PlayerData.GetDatas()) do
	HandlePlayerData(Data)
end

PlayerData.DataAdded:Connect(HandlePlayerData)

local MapInfo = GameInfo.GetMapFromId("Tutorial") :: GameInfo.MapInfo

AcceptTutorial.SetCallback(function(Player: Player)
	local PData = PlayerData.GetPlayerData(Player)

	if PData then
		local Data = PData.Profile.Data
		if Data.PassedTutorial then
			local AccessCode, ServerId = TeleportService:ReserveServer(MapData.Tutorial)

			Promise.try(function()
				MapStore:SetAsync(tostring(ServerId), {
					PlayerIds = { Player.UserId },
					MapId = "Tutorial",
					LevelId = "Tutorial",
					Difficulty = "Normal",
					AccessCode = AccessCode,
				}, Constants.MAPSTORETIME)
			end)
				:andThen(function()
					local TeleportOptions = Instance.new("TeleportOptions")
					TeleportOptions.ShouldReserveServer = true

					HelperFunctions.SafeTeleport(function()
						return TeleportService:TeleportAsync(ServerId, { Player }, TeleportOptions)
					end, 3)
				end)
				:andThen(function()
					SendWarning.Fire(Player, "Teleporting...", Color3.new(0, 1, 0))
					Network.TPGuiSet.Fire(Player, { MapName = "Tutorial", ImageId = MapInfo.Image })
				end)
				:catch(function()
					SendWarning.Fire(Player, "Failed to teleport.")
				end)
		end
	end
end)
