--!strict

-- By Wa1er_God --

local DifficultyInfo = {};

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage") ;
local ServerStorage = game:GetService("ServerStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local MessagingService = game:GetService("MessagingService");
local MemoryStoreService = game:GetService("MemoryStoreService");

local StartGame = ReplicatedStorage.Remotes.Waves.Server.StartGame;

local Shared = ReplicatedStorage.Shared;
local Constants = require(Shared.Constants);
local Types = require(Shared.Types);

local Map = workspace:FindFirstChild("GameMap");

local WaveData = require(ServerStorage.Data.WaveData);

local GlobalModules = ServerScriptService.GlobalModules;
local GlobalWave = require(GlobalModules.GlobalWave);
local UnitModule = require(GlobalModules.Unit);

local MapStore = MemoryStoreService:GetHashMap(Constants.INFORMATIONHASHMAP);

local OldValues: Types.RecieveData? = nil;

local function Init(DataInput: Types.RecieveData?)
	if not Map then
		return;
	end
	
	local PositionFolder = Map:FindFirstChild("Positions") :: Folder;
	local Positions = {};
	
	if not PositionFolder then
		return;
	end

	for _, Base in ipairs(PositionFolder:GetChildren()) do
		if Base:IsA("BasePart") then
			table.insert(Positions, Base.CFrame.Position);
		end
	end
	
	local Data = DataInput or OldValues :: Types.RecieveData;
	OldValues = Data;

	local FoundData = WaveData[Data.LevelId];

	if FoundData then
		for _, Unit in pairs(UnitModule.GetUnits()) do
			Unit:Delete();
		end
		GlobalWave.new({
			Data = FoundData;
			Positions = Positions;
			Difficulty = Data.Difficulty;
		});
	end
end

StartGame.Event:Connect(Init);

if game["Run Service"]:IsStudio() then
	Init({
		LevelId = "Hastingsv1";
		Difficulty = "Normal";
	})
	return;
end

local function KickPlayer(Player: Player)
	--Player:Kick("Error Whille Loading Game");
end

local function OnError()
	for _, Player in ipairs(Players:GetPlayers()) do
		KickPlayer(Player);
	end

	Players.PlayerAdded:Connect(KickPlayer);
end

local Success, Value = xpcall(function()
	return MapStore:GetAsync(tostring(game.PrivateServerId));
end, OnError)

print(Success, Value);

if Success then
	if Value then
		Init(Value);
		return;
	end
end

OnError();