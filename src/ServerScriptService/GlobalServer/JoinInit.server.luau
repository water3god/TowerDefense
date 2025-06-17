--!strict

-- By Wa1er_God --

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MemoryStoreService = game:GetService("MemoryStoreService")

if require(ReplicatedStorage.Shared.IsLobby) then
	return
end

local StartGame = ReplicatedStorage.Remotes.Waves.Server.StartGame

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)
local Types = require(Shared.Types)
local GameInfo = require(Shared.GameInfo)

local Map = workspace:FindFirstChild("GameMap")

local WaveData = require(ServerStorage.Data.WaveData)

local GlobalModules = ServerScriptService.GlobalModules
local GlobalWave = require(GlobalModules.GlobalWave)
local UnitModule = require(GlobalModules.Unit)

local MapStore = MemoryStoreService:GetHashMap(Constants.INFORMATIONHASHMAP)

local OldValues: Types.RecieveData? = nil

local function Init(DataInput: Types.RecieveData?)
	if not Map then
		return
	end

	local PositionFolder = Map:FindFirstChild("Positions") :: Folder
	local Positions = {}

	if not PositionFolder then
		return
	end

	local Children = PositionFolder:GetChildren()

	table.sort(Children, function(a, b)
		return tonumber(a.Name) < tonumber(b.Name)
	end)

	for _, Base in ipairs(Children) do
		if Base:IsA("BasePart") then
			table.insert(Positions, Base.CFrame.Position)
		end
	end

	local Data = DataInput or OldValues :: Types.RecieveData
	OldValues = Data

	local _, LevelInfo = GameInfo.GetDataFromInfo(Data.MapId, Data.LevelId)
	local XPMultiplier: number = (LevelInfo :: any).XPMultiplier

	local FoundData = WaveData[Data.LevelId]

	if FoundData then
		for _, Unit in pairs(UnitModule.GetUnits()) do
			Unit:Delete()
		end
		GlobalWave.new({
			PlayerIds = Data.PlayerIds,
			XPMultiplier = XPMultiplier,
			RewardInfo = (LevelInfo :: any).RewardInfo[Data.Difficulty],
			Data = FoundData,
			Positions = Positions,
			Difficulty = Data.Difficulty,
			IsInfinite = false,
		})
	end
end

StartGame.Event:Connect(Init)

if game["Run Service"]:IsStudio() then
	local Ids = { 343804839 }
	Init({
		PlayerIds = Ids,
		MapId = "Rome",
		LevelId = "Hastingsv1",
		Difficulty = "Insane",
	})
	return
end

local function KickPlayer(Player: Player)
	Player:Kick("Error Whille Loading Game. Please Rejoin.")
end

local function OnError()
	for _, Player in ipairs(Players:GetPlayers()) do
		KickPlayer(Player)
	end

	Players.PlayerAdded:Connect(KickPlayer)
end

local Success, Value = xpcall(function()
	return MapStore:GetAsync(tostring(game.PrivateServerId))
end, OnError)

if Success then
	if Value then
		Init(Value)
		return
	end
end

OnError()
