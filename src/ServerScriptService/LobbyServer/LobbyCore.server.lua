--!strict

-- By Wa1er_God --

local START_POINT_TAG = "StartPoint";

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");
local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local TeleportService = game:GetService("TeleportService");
local MessagingService = game:GetService("MessagingService");
local MemoryStoreService = game:GetService("MemoryStoreService");

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);
local ObserveTag = require(Modules.ObserveTag);
local Trove = require(Modules.Trove);
local DelayHandler = require(Modules.DelayHandler);
local SyncTween = require(Modules.SyncTween);

local BoothEvents = ReplicatedStorage.Remotes.Booth;

local ServerFires = BoothEvents.ServerFires;
local BoothChoosing = ServerFires.BoothChoosing;
local BoothMapLoading = ServerFires.BoothMapLoading;
local BoothRestarted = ServerFires.BoothRestarted;
local BoothWaiting = ServerFires.BoothWaiting;
local PlayerChanged = ServerFires.PlayerChanged;
local TPGuiSet = ServerFires.TPGuiSet;

local ClientFires = BoothEvents.ClientFires;
local ChooseMap = ClientFires.ChooseMap;
local LeaveBooth = ClientFires.LeaveBooth;
local OwnerStart = ClientFires.OwnerStart;

local Shared = ReplicatedStorage.Shared;
local GameInfo = require(Shared.GameInfo);
local Types = require(Shared.Types);
local Constants = require(Shared.Constants);

local Data = ServerStorage.Data;
local MapData = require(Data.MapData);

local LobbyModules = ServerScriptService.LobbyModules;
local Booth = require(LobbyModules.Booth);

local BoothsInstance = workspace.MainMap.Medieval.Booths;

local MapStore = MemoryStoreService:GetHashMap(Constants.INFORMATIONHASHMAP);

local function AddTimeData(Table: any, Booth: Booth.Booth)
	Table.StartTime = Booth.StartTime;
	Table.EndTime = Booth.StartTime + Booth.TimeLeft;
end

local function SendWaitingData(Players: {Player}, Booth: Booth.Booth)
	if Booth.Data then
		local Data = {
			OwnerId = Booth.Players[1].UserId;
			MapId = Booth.Data.MapId;
			LevelId = Booth.Data.LevelId;
			Difficulty = Booth.Data.Difficulty;
		};
		AddTimeData(Data, Booth);
		HelperFunctions.FireClients(BoothWaiting, Players, Data);
	end
end

local function SafeTeleport(func: () -> TeleportAsyncResult)
	local Success, Returned = pcall(func);
	local Count = 1;
	
	if not Returned then
		repeat task.wait(1)
			Success = pcall(func);
			Count += 1;
		until Success or Count >= 3;
	end
end

local function TpToMap(Data: Types.SentData)
	local MapId = MapData[Data.MapId];
	
	local PlayerIds = {};
	for _, Player in ipairs(Data.Players) do
		table.insert(PlayerIds, Player.UserId);
	end

	local NewData: Types.RecieveData = {
		PlayerIds = PlayerIds;
		LevelId = Data.LevelId;
		Difficulty = Data.Difficulty;
	};
	
	local AccessCode, ServerId = TeleportService:ReserveServer(MapId);

	local Success, Error = pcall(function()
		MapStore:SetAsync(tostring(ServerId), NewData, 60);
	end)
	
	local MapInfo, LevelInfo = GameInfo.GetDataFromInfo(Data.MapId, Data.LevelId);
	if MapInfo and LevelInfo then
		local FullName = GameInfo.GetFullName(MapInfo.Name, LevelInfo.Index, LevelInfo.Name);
		HelperFunctions.FireClients(TPGuiSet, Data.Players, {MapName = FullName, ImageId = MapInfo.Image});
	else
		error("Is Nil while sending mapdata");
	end
	
	if not Success then
		error("Error in success")
		return;
	end
	
	local TeleportOptions = Instance.new("TeleportOptions");
	TeleportOptions.ReservedServerAccessCode = AccessCode;
	
	task.delay(3, function()
		HelperFunctions.SafeTeleport(function()
			return TeleportService:TeleportAsync(MapId, Data.Players, TeleportOptions);
		end, 5);
	end)
end

local MainFrameReference = BoothsInstance.Booth1.TouchPart.BoothGui.MainFrame;

local function TweenBar(Group: typeof(MainFrameReference.Main.Group), Players: number)
	local Bar = Group.Bar;
	local PlayersLabel = Group.PlayersLabel;
	
	local Tween = SyncTween.new(Bar, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
		Size = UDim2.fromScale(Players / 4, 1);
	});
	Tween:Play();
	PlayersLabel.Text = string.format("Players: %u/%u", Players, 4);
end

local function TweenTime(TimeBar: typeof(MainFrameReference.TimeBar), Booth: Booth.Booth)
	TimeBar.Bar.Size = UDim2.fromScale(1, 1);
	local Tween = SyncTween.new(TimeBar.Bar, TweenInfo.new(Booth.TimeLeft, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
		Size = UDim2.fromScale(0, 1);
	});
	Booth.StatusTrove:Add(function()
		Tween:Cancel();
	end)
	Tween:Play();
	
	local TimeLabel = TimeBar.TimeLabel;
	HelperFunctions.ConnectTime(Booth.StartTime, Booth.StartTime + Booth.TimeLeft, function(Time: number)
		TimeLabel.Text = string.format("Time Left: %u", Time);
	end, Booth.StatusTrove);
end

local function InitLoadingBooth(Model: typeof(BoothsInstance.Booth1))
	local Booth = Booth.new({
		Folder = Model;
		TouchPart = Model.TouchPart;
		TPInPart = Model.TPInPart;
		TPOutPart = Model.TPOutPart;
	});
	
	local GUI = Model.TouchPart.BoothGui;
	local MainFrame = GUI.MainFrame;
	
	local Main = MainFrame.Main;
	local MapImage = Main.MapImage;
	local DifficultyLabel = Main.DifficultyLabel;
	local TitleLabel = Main.TitleLabel;
	local Group = Main.Group;
	local Bar = Group.Bar;
	local PlayersLabel = Group.PlayersLabel;
	local TimeBar = Main.TimeBar;
	local Bar = TimeBar.Bar;
	local TimeLabel = TimeBar.TimeLabel;
	
	local MiscLabel = MainFrame.MiscLabel;
	
	Booth.PlayerAdded:Connect(function(Player: Player)
		HelperFunctions.FireClients(PlayerChanged, Booth.Players, Player.UserId, true);
		if Booth.Status == "LoadingPlayers" then
			SendWaitingData({Player}, Booth);
			TweenBar(Group, #Booth.Players);
		end
	end)
	
	Booth.PlayerRemoving:Connect(function(Player: Player)
		HelperFunctions.FireClients(PlayerChanged, Booth.Players, Player.UserId, false);
		if Booth.Status == "LoadingPlayers" then
			TweenBar(Group, #Booth.Players);
		end
	end)
	
	Booth.StartedChoosing:Connect(function(Player: Player)
		local Data = {};
		AddTimeData(Data, Booth);
		BoothChoosing:FireClient(Player, Data);
		MiscLabel.Text = "Choosing Map...";
	end)
	
	Booth.StartedWaiting:Connect(function()
		SendWaitingData(Booth.Players, Booth);
		
		local Data = Booth.Data :: Types.SentData;
		local MapInfo, LevelInfo = GameInfo.GetDataFromInfo(Data.MapId, Data.LevelId);
		
		if MapInfo and LevelInfo then
			TitleLabel.Text = GameInfo.GetFullName(MapInfo.Name, LevelInfo.Index, LevelInfo.Name);
			DifficultyLabel.Text = GameInfo.GetDifficultyString(Data.Difficulty);
			TweenBar(Group, #Booth.Players);
			TweenTime(TimeBar, Booth);
			
			MiscLabel.Visible = false;
			Main.Visible = true;
		end
	end)
	
	Booth.MapLoading:Connect(function()
		HelperFunctions.FireClients(BoothMapLoading, Booth.Players);
		MiscLabel.Text = "Map Loading...";
		
		MiscLabel.Visible = true;
		Main.Visible = false;
		if Booth.Data then
			TpToMap(Booth.Data);
		end
	end)
	
	Booth.BoothEnded:Connect(function()
		MiscLabel.Text = "Empty";
		HelperFunctions.FireClients(BoothRestarted, Booth.Players);
		
		MiscLabel.Visible = true;
		Main.Visible = false;
	end)
end

ObserveTag.ObserveTag(START_POINT_TAG, function(Model: Instance)
	if Model:IsA("Model") then
		InitLoadingBooth(Model);
	end
	
	return function() end
end)


ChooseMap.OnServerEvent:Connect(function(Player: Player, Data: {MapId: string, LevelId: string, Difficulty: string})
	if typeof(Data) ~= 'table' then
		return;
	end
	if typeof(Data.MapId) ~= "string" or typeof(Data.LevelId) ~= "string" or typeof(Data.Difficulty) ~= "string" then
		return;
	end
	if not GameInfo.GetDataFromInfo(Data.MapId, Data.LevelId) then
		return;
	end
	
	local CurrentBooth = Booth.GetBoothFromPlayer(Player);
	
	if CurrentBooth then
		CurrentBooth:ChooseMap(Data.MapId, Data.LevelId, Data.Difficulty);
	end
end)

LeaveBooth.OnServerEvent:Connect(function(Player: Player)
	local CurrentBooth = Booth.GetBoothFromPlayer(Player);
	
	if CurrentBooth then
		CurrentBooth:RemovePlayer(Player);
	end
end)

OwnerStart.OnServerEvent:Connect(function(Player: Player)
	local CurrentBooth = Booth.GetBoothFromPlayer(Player);
	
	if CurrentBooth then
		if CurrentBooth.Players[1] == Player then
			CurrentBooth:Start();
		end
	end
end)