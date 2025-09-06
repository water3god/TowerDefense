--!strict

-- By Wa1er_God --

local START_POINT_TAG = "StartPoint"

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local TeleportService = game:GetService("TeleportService")
local MemoryStoreService = game:GetService("MemoryStoreService")

if not require(ReplicatedStorage.Shared.IsLobby) then
	return
end

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local Story = Gui.Story
local BoothContext = require(Story.BoothContext)
local BoothFrame = require(Story.BoothFrame)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local ObserveTag = require(Modules.ObserveTag)

local NetworkFolder = ReplicatedStorage.Network
local Network = require(NetworkFolder.Server)
local ServerOnly = require(NetworkFolder.ServerOnly)
local BoothLoaded = ServerOnly.BoothLoaded

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)
local Types = require(Shared.Types)
local Constants = require(Shared.Constants)

local ServerData = ServerStorage.Data
local MapData = require(ServerData.MapData)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local LobbyModules = ServerScriptService.LobbyModules
local Booth = require(LobbyModules.Booth)

local _BoothsInstance = workspace.MainMap.Medieval.Booths

local MapStore = MemoryStoreService:GetHashMap(Constants.INFORMATIONHASHMAP)

type TimeData = {
	StartTime: number,
	EndTime: number,
}

local function AddTimeData(Table: any, BoothData: Booth.Booth)
	Table.StartTime = BoothData.StartTime
	Table.EndTime = BoothData.StartTime + BoothData.TimeLeft
end

local function SendWaitingData(Players: { Player }, BoothInfo: Booth.Booth)
	if BoothInfo.Data then
		local BoothData = {
			OwnerId = BoothInfo.Players[1].UserId,
			MapId = BoothInfo.Data.MapId,
			LevelId = BoothInfo.Data.LevelId,
			Difficulty = BoothInfo.Data.Difficulty,
			Players = Players,
		}
		AddTimeData(BoothData, BoothInfo)

		Network.BoothWaiting.FireList(Players, BoothData :: typeof(BoothData) & TimeData)
	end
end

local function TpToMap(Data: Types.SentData)
	local MapId = MapData[Data.MapId]

	local PlayerIds = {}
	for _, Player in ipairs(Data.Players) do
		table.insert(PlayerIds, Player.UserId)
	end

	local AccessCode, ServerId = TeleportService:ReserveServer(MapId)

	local NewData: Types.RecieveData = {
		PlayerIds = PlayerIds,
		MapId = Data.MapId,
		LevelId = Data.LevelId,
		Difficulty = Data.Difficulty,
		AccessCode = AccessCode,
	}

	for _, Player in ipairs(Data.Players) do
		task.spawn(function()
			local PData = PlayerData.GetPlayerData(Player)

			if PData then
				PData.Profile.Data.MostRecentGameId = ServerId
			end
		end)
	end

	local Success = pcall(function()
		MapStore:SetAsync(tostring(ServerId), NewData, Constants.MAPSTORETIME)
	end)

	local MapInfo, LevelInfo = GameInfo.GetDataFromInfo(Data.MapId, Data.LevelId)
	if MapInfo and LevelInfo then
		local FullName = GameInfo.GetFullName(MapInfo.Name, LevelInfo.Index, LevelInfo.Name)
		Network.TPGuiSet.FireList(Data.Players, { MapName = FullName, ImageId = MapInfo.Image })
	else
		error("Is Nil while sending mapdata")
	end

	if not Success then
		error("Error in success")
		return
	end

	local TeleportOptions = Instance.new("TeleportOptions")
	TeleportOptions.ReservedServerAccessCode = AccessCode

	task.delay(3, function()
		HelperFunctions.SafeTeleport(function()
			return TeleportService:TeleportAsync(MapId, Data.Players, TeleportOptions)
		end, 5)
	end)
end

BoothLoaded:Connect(function(BoothId: string)
	local NewBooth = Booth.GetBooth(BoothId)

	if NewBooth then
		NewBooth.TouchPart.CanTouch = true
	end
end)

local function InitLoadingBooth(Model: typeof(_BoothsInstance.Booth1))
	local NewBooth = Booth.new({
		Folder = Model,
		TouchPart = Model.TouchPart,
		TPInPart = Model.TPInPart,
		TPOutPart = Model.TPOutPart,
	})

	local GUI = Model.TouchPart.BoothGui

	-- Render React component immediately - the polling in BoothContext will handle booth availability
	local Root = ReactRoblox.createRoot(Instance.new("Folder"))
	Root:render(ReactRoblox.createPortal(
		e(BoothContext.Provider, {
			BoothId = NewBooth.UniqueId,
		}, {
			BoothFrame = e(BoothFrame, {
				UniqueId = NewBooth.UniqueId,
			}),
		}),
		GUI
	))

	NewBooth.PlayerAdded:Connect(function(Player: Player)
		Network.BoothPlayerChanged.FireList(NewBooth.Players, Player.UserId, true)
		if NewBooth.Status == "LoadingPlayers" then
			SendWaitingData(NewBooth.Players, NewBooth)
		end
	end)

	NewBooth.PlayerRemoving:Connect(function(Player: Player)
		Network.BoothPlayerChanged.FireList(NewBooth.Players, Player.UserId, false)
	end)

	NewBooth.StartedChoosing:Connect(function(Player: Player)
		local Data = {}
		AddTimeData(Data, NewBooth)
		Network.BoothChoosing.Fire(Player, Data :: TimeData)
	end)

	NewBooth.StartedWaiting:Connect(function()
		SendWaitingData(NewBooth.Players, NewBooth)
	end)

	NewBooth.MapLoading:Connect(function()
		Network.BoothMapLoading.FireList(NewBooth.Players)
		if NewBooth.Data then
			TpToMap(NewBooth.Data)
		end
	end)

	NewBooth.BoothEnded:Connect(function()
		Network.BoothRestarted.FireList(NewBooth.Players)
	end)
end

ObserveTag.ObserveTag(START_POINT_TAG, function(Model: Instance)
	if Model:IsA("Model") then
		InitLoadingBooth(Model)
	end

	return function() end
end)

Network.ChooseMap.SetCallback(
	function(Player: Player, Data: { MapId: string, LevelId: string, Difficulty: GameInfo.Difficulty | string })
		if typeof(Data) ~= "table" then
			return
		end
		if
			typeof(Data.MapId) ~= "string"
			or typeof(Data.LevelId) ~= "string"
			or typeof(Data.Difficulty) ~= "string"
		then
			return
		end
		if Data.MapId == "Tutorial" then
			return
		end
		if not GameInfo.GetDataFromInfo(Data.MapId, Data.LevelId) then
			return
		end
		if not table.find(GameInfo.Difficulty, Data.Difficulty) then
			return
		end

		local CurrentBooth = Booth.GetBoothFromPlayer(Player)

		if CurrentBooth then
			CurrentBooth:ChooseMap(Data.MapId, Data.LevelId, Data.Difficulty)
		end
	end
)

Network.LeaveBooth.SetCallback(function(Player: Player)
	local CurrentBooth = Booth.GetBoothFromPlayer(Player)

	if CurrentBooth then
		CurrentBooth:RemovePlayer(Player)
	end
end)

Network.OwnerStart.SetCallback(function(Player: Player)
	local CurrentBooth = Booth.GetBoothFromPlayer(Player)

	if CurrentBooth then
		if CurrentBooth.Players[1] == Player then
			CurrentBooth:Start()
		end
	end
end)
