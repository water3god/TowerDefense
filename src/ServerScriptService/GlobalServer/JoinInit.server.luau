--!strict

-- By Wa1er_God --

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

if require(ReplicatedStorage.Shared.IsLobby) then
	return
end

local ServerOnly = require(ReplicatedStorage.Network.ServerOnly)
local StartGame = ServerOnly.StartGame

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

local Modules = ReplicatedStorage.Modules
local Lerps = require(Modules.Lerps)
local HelperFunctions = require(Modules.HelperFunctions)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)
local Types = require(Shared.Types)
local GameInfo = require(Shared.GameInfo)
local IsTutorial = require(Shared.IsTutorial)

local Map = workspace:FindFirstChild("GameMap")

local DataFolder = ServerStorage.Data
local WaveData = require(DataFolder.WaveData)
local MapData = require(DataFolder.MapData)

local GlobalModules = ServerScriptService.GlobalModules
local GlobalWave = require(GlobalModules.GlobalWave)
local UnitModule = require(GlobalModules.Unit)
local PlayerData = require(GlobalModules.PlayerData)

local MapStore = MemoryStoreService:GetHashMap(Constants.INFORMATIONHASHMAP)

local OldValues: Types.RecieveData? = nil

local TimeLerp = Lerps.string("14:30:00", "20:30:00")

local currentp: Promise.Promise? = nil

local function ChangeDay(Day: boolean)
	if currentp then
		currentp:cancel()
		currentp = nil
	end
	currentp = HelperFunctions.TweenPromise(1, function(Time: number)
		if Day then
			Time = 1 - Time
		end
		Time = TweenService:GetValue(Time, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
		local NewTime = TimeLerp(Time)
		Lighting.TimeOfDay = NewTime
	end):finally(function()
		currentp = nil
	end)
end

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
	if LevelInfo then
		for _, Unit in pairs(UnitModule.GetUnits()) do
			Unit:Delete()
		end
		local Wave = nil
		if LevelInfo.Index == 0 then
			local FoundData = WaveData.InfiniteData[Data.LevelId]
			Wave = GlobalWave.infinite({
				PlayerIds = Data.PlayerIds,
				XPMultiplier = XPMultiplier,
				RewardInfo = (LevelInfo :: any).RewardInfo[Data.Difficulty],
				Data = FoundData,
				Positions = Positions,
				Difficulty = Data.Difficulty,
				MapId = Data.MapId,
				StageId = Data.LevelId,
			})
		else
			local FoundData = WaveData.WaveData[Data.LevelId]
			if FoundData then
				Wave = GlobalWave.new({
					PlayerIds = Data.PlayerIds,
					XPMultiplier = XPMultiplier,
					RewardInfo = (LevelInfo :: any).RewardInfo[Data.Difficulty],
					Data = FoundData,
					Positions = Positions,
					Difficulty = Data.Difficulty,
					IsInfinite = false,
					MapId = Data.MapId,
					StageId = Data.LevelId,
				})

				Wave.Passed:Connect(function(WaveNum: number)
					if WaveNum == #Wave.Data.Data then
						ChangeDay(false)
					end
				end)
			end
		end

		Wave.Ended:Once(function()
			if IsTutorial then
				local _, PData = next(PlayerData.GetDatas())

				if PData and PData.Profile:IsActive() then
					PData.Profile.Data.PassedTutorial = true
				end
			end
			ChangeDay(true)
			if Wave.IsInfinite then
				for PlayerId, _ in pairs(Wave.Coins) do
					local Player = Players:GetPlayerByUserId(PlayerId)

					if Player then
						local DataModule = PlayerData.GetPlayerData(Player)

						if DataModule then
							DataModule:AddInfiniteStage({
								Map = Data.MapId,
								Stage = 0,
								Difficulty = Data.Difficulty,
								Damage = Wave.TotalDamage,
								Wave = Wave.Wave,
							})
						end
					end
				end
			else
				for PlayerId, _ in pairs(Wave.Coins) do
					local Player = Players:GetPlayerByUserId(PlayerId)

					if Player then
						local DataModule = PlayerData.GetPlayerData(Player)

						if DataModule then
							DataModule:AddStage({
								Map = Data.MapId,
								Stage = LevelInfo.Index,
								Difficulty = Data.Difficulty,
								TimeFinished = math.floor(workspace:GetServerTimeNow() - Wave.InitTime),
							})
						end
					end
				end
			end
		end)
	elseif not LevelInfo then
		error(string.format("No LevelInfo! MapId: %s, LevelId: %s", Data.MapId, Data.LevelId))
	end
end

if not IsTutorial then
	StartGame:Connect(Init)
end

if RunService:IsStudio() then
	if not Players:GetPlayers()[1] then
		Players.PlayerAdded:Wait()
	end
	local Ids = { Players:GetPlayers()[1].UserId }

	local MapId = nil
	local LevelId = nil

	local MapName = nil

	for Name, Id in pairs(MapData) do
		if Id == game.PlaceId then
			MapName = Name
			break
		end
	end

	if MapName then
		local Data = GameInfo.GetMapFromId(MapName)
		if Data then
			MapId = Data.MapId
			LevelId = Data.LevelInfo[1].GameId
		end
	end

	if not MapId or not LevelId then
		MapId = "Rome"
		LevelId = "Rome_LegionsMarch"
	end

	Init({
		PlayerIds = Ids,
		MapId = MapId,
		LevelId = LevelId,
		Difficulty = "Normal",
		AccessCode = "",
	})

	return
end

local Message = "Error While Loading Game. Please Rejoin."

local function OnError()
	for _, Player in ipairs(Players:GetPlayers()) do
		Player:Kick(Message)
	end

	Players.PlayerAdded:Connect(function(Player)
		Player:Kick(Message)
	end)
end

local function Check()
	game:BindToClose(function()
		Promise.retryWithDelay(function()
			return Promise.new(function(resolve)
				MapStore:RemoveAsync(tostring(game.PrivateServerId))
				resolve()
			end)
		end, 5, 0.01)

		for _, Data in pairs(PlayerData.GetDatas()) do
			if Data.Profile:IsActive() then
				Data.Profile.Data.MostRecentGameId = nil
			end
		end
	end)
end

if not IsTutorial then
	Check()
end

Promise.retryWithDelay(function()
	return Promise.new(function(resolve, reject)
		local Value = MapStore:GetAsync(tostring(game.PrivateServerId))
		if Value then
			resolve(Value)
		else
			reject("No value found")
		end
	end)
end, 5, 1)
	:andThen(function(Value)
		Init(Value)
	end)
	:catch(function()
		OnError()
	end)
