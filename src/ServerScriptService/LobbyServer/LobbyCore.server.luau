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

local BoothEvents = ReplicatedStorage.Remotes.Booth

local ServerFires = BoothEvents.ServerFires
local BoothChoosing = ServerFires.BoothChoosing
local BoothMapLoading = ServerFires.BoothMapLoading
local BoothRestarted = ServerFires.BoothRestarted
local BoothWaiting = ServerFires.BoothWaiting
local PlayerChanged = ServerFires.PlayerChanged
local TPGuiSet = ServerFires.TPGuiSet

local ClientFires = BoothEvents.ClientFires
local ChooseMap = ClientFires.ChooseMap
local LeaveBooth = ClientFires.LeaveBooth
local OwnerStart = ClientFires.OwnerStart

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)
local Types = require(Shared.Types)
local Constants = require(Shared.Constants)

local Data = ServerStorage.Data
local MapData = require(Data.MapData)

local LobbyModules = ServerScriptService.LobbyModules
local Booth = require(LobbyModules.Booth)

local BoothsInstance = workspace.MainMap.Medieval.Booths

local MapStore = MemoryStoreService:GetHashMap(Constants.INFORMATIONHASHMAP)

local function AddTimeData(Table: any, Booth: Booth.Booth)
	Table.StartTime = Booth.StartTime
	Table.EndTime = Booth.StartTime + Booth.TimeLeft
end

local function SendWaitingData(Players: { Player }, Booth: Booth.Booth)
	if Booth.Data then
		local Data = {
			OwnerId = Booth.Players[1].UserId,
			MapId = Booth.Data.MapId,
			LevelId = Booth.Data.LevelId,
			Difficulty = Booth.Data.Difficulty,
			Players = Players,
		}
		AddTimeData(Data, Booth)
		HelperFunctions.FireClients(BoothWaiting, Players, Data)
	end
end

local function TpToMap(Data: Types.SentData)
	local MapId = MapData[Data.MapId]

	local PlayerIds = {}
	for _, Player in ipairs(Data.Players) do
		table.insert(PlayerIds, Player.UserId)
	end

	local NewData: Types.RecieveData = {
		PlayerIds = PlayerIds,
		MapId = Data.MapId,
		LevelId = Data.LevelId,
		Difficulty = Data.Difficulty,
	}

	local AccessCode, ServerId = TeleportService:ReserveServer(MapId)

	local Success = pcall(function()
		MapStore:SetAsync(tostring(ServerId), NewData, 60)
	end)

	local MapInfo, LevelInfo = GameInfo.GetDataFromInfo(Data.MapId, Data.LevelId)
	if MapInfo and LevelInfo then
		local FullName = GameInfo.GetFullName(MapInfo.Name, LevelInfo.Index, LevelInfo.Name)
		HelperFunctions.FireClients(TPGuiSet, Data.Players, { MapName = FullName, ImageId = MapInfo.Image })
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

local function InitLoadingBooth(Model: typeof(BoothsInstance.Booth1))
	local Booth = Booth.new({
		Folder = Model,
		TouchPart = Model.TouchPart,
		TPInPart = Model.TPInPart,
		TPOutPart = Model.TPOutPart,
	})

	local GUI = Model.TouchPart.BoothGui

	local Root = ReactRoblox.createRoot(GUI)
	Root:render(e(BoothContext.Provider, {
		BoothId = Booth.UniqueId,
	}, {
		BoothFrame = e(BoothFrame, {}),
	}))

	Booth.PlayerAdded:Connect(function(Player: Player)
		HelperFunctions.FireClients(PlayerChanged, Booth.Players, Player.UserId, true)
		if Booth.Status == "LoadingPlayers" then
			SendWaitingData({ Player }, Booth)
		end
	end)

	Booth.PlayerRemoving:Connect(function(Player: Player)
		HelperFunctions.FireClients(PlayerChanged, Booth.Players, Player.UserId, false)
	end)

	Booth.StartedChoosing:Connect(function(Player: Player)
		local Data = {}
		AddTimeData(Data, Booth)
		BoothChoosing:FireClient(Player, Data)
	end)

	Booth.StartedWaiting:Connect(function()
		SendWaitingData(Booth.Players, Booth)
	end)

	Booth.MapLoading:Connect(function()
		HelperFunctions.FireClients(BoothMapLoading, Booth.Players)
		if Booth.Data then
			TpToMap(Booth.Data)
		end
	end)

	Booth.BoothEnded:Connect(function()
		HelperFunctions.FireClients(BoothRestarted, Booth.Players)
	end)
end

ObserveTag.ObserveTag(START_POINT_TAG, function(Model: Instance)
	if Model:IsA("Model") then
		InitLoadingBooth(Model)
	end

	return function() end
end)

ChooseMap.OnServerEvent:Connect(function(Player: Player, Data: { MapId: string, LevelId: string, Difficulty: string })
	if typeof(Data) ~= "table" then
		return
	end
	if typeof(Data.MapId) ~= "string" or typeof(Data.LevelId) ~= "string" or typeof(Data.Difficulty) ~= "string" then
		return
	end
	if not GameInfo.GetDataFromInfo(Data.MapId, Data.LevelId) then
		return
	end

	local CurrentBooth = Booth.GetBoothFromPlayer(Player)

	if CurrentBooth then
		CurrentBooth:ChooseMap(Data.MapId, Data.LevelId, Data.Difficulty)
	end
end)

LeaveBooth.OnServerEvent:Connect(function(Player: Player)
	local CurrentBooth = Booth.GetBoothFromPlayer(Player)

	if CurrentBooth then
		CurrentBooth:RemovePlayer(Player)
	end
end)

OwnerStart.OnServerEvent:Connect(function(Player: Player)
	local CurrentBooth = Booth.GetBoothFromPlayer(Player)

	if CurrentBooth then
		if CurrentBooth.Players[1] == Player then
			CurrentBooth:Start()
		end
	end
end)
