--!strict

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");

local Enemy2 = ReplicatedStorage.Remotes.Enemy;
local SpawnEvent = Enemy2.SpawnEvent;
local LocationEvent = Enemy2.LocationEvent;
local SpeedEvent = Enemy2.SpeedEvent;
local DestroyEvent = Enemy2.DestroyEvent;

local Modules = ReplicatedStorage.Modules;
local BezierPath = require(Modules.BezierPath);
local HelperFunctions = require(Modules.HelperFunctions);

local Utility = ServerScriptService.Utility;
local SafePlayer = Utility.SafePlayer;
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded);
local SafePlayerRemoving = require(SafePlayer.SafePlayerRemoving);

local Enemy = require(script.Parent);
local Enemies = Enemy.GetEnemies();

local Count = 0;

local function AddInfoToSpawn(Data: any, NewEnemy: Enemy.Enemy)
	Data.UniqueId = NewEnemy.UniqueId;
	Data.ModelName = NewEnemy.ModelName;
	Data.Health = NewEnemy.Health;
	Data.MaxHealth = NewEnemy.MaxHealth;
	Data.Speed = NewEnemy.Speed;
	Data.Reverse = NewEnemy.Reverse;
	Data.IsBoss = NewEnemy.IsBoss;	
	Data.OriginalSpeed = NewEnemy.OriginalSpeed;
	Data.VectorOffset = NewEnemy.VectorOffset;
	Data.BezierId = NewEnemy.BezierId;
	Data.AdornmentName = NewEnemy.AdornmentName;
	Data.TimePosition = NewEnemy.TimePosition;
	Data.Time = workspace:GetServerTimeNow();
	Data.SpeedChanges = NewEnemy.SpeedChanges;
end

local Beziers = Enemy.GetBeziers();

SafePlayerAdded:Connect(function(Player: Player)
	for UniqueId, Bezier in pairs(Beziers) do
		LocationEvent:FireAllClients(UniqueId, Bezier.Waypoints);
	end
	
	local FullEnemyTable = {};

	for Id, Enemy in pairs(Enemies) do
		local Table = {};
		AddInfoToSpawn(Table, Enemy);
		FullEnemyTable[Enemy.UniqueId] = Table;
	end

	SpawnEvent:FireClient(Player, FullEnemyTable, false);
end)

Enemy.Spawned:Connect(function(NewEnemy: Enemy.Enemy)
	local Data = {};
	AddInfoToSpawn(Data, NewEnemy);
	SpawnEvent:FireAllClients({Data}, false);

	local UniqueId = NewEnemy.UniqueId;
	
	NewEnemy.SpeedChanged:Connect(function(Speed: number, Time: number)
		SpeedEvent:FireAllClients(
		{
			UniqueId = NewEnemy.UniqueId;
			Speed = Speed;
			Time = workspace:GetServerTimeNow();
		});
	end)
	
	NewEnemy.Destroying:Once(function()
		DestroyEvent:FireAllClients({UniqueId}, false);
	end)
end)

Enemy.BezierAdded:Connect(function(Bezier: BezierPath.Path, UniqueId: string)
	LocationEvent:FireAllClients(UniqueId, Bezier.Waypoints);
end)

Enemy.BezierRemoving:Connect(function(UniqueId: string)
	LocationEvent:FireAllClients(UniqueId);
end)

@native
local function OnFrame()
	local CurrentTime = workspace:GetServerTimeNow();
	for Id, Enemy in pairs(Enemies) do
		local NewTime = 0;

		for _, Data in ipairs(Enemy.SpeedChanges) do
			local EndTime = Data.TimeEnd or CurrentTime;
			local Difference = EndTime - Data.TimeStart;

			NewTime += ((Data.Speed / Enemy.PathLength)) * Difference;
		end
		NewTime = math.clamp(NewTime, 0, 1);
		if Enemy.Reverse then
			NewTime = math.abs(NewTime - 1);
		end
		Enemy.TimePosition = NewTime;

		Enemy.CFrame = Enemy.Bezier:CalculateUniformCFrame(Enemy.TimePosition);

		if Enemy.TimePosition == 0 or Enemy.TimePosition == 1 then
			Enemy.ReachedEnd:Fire();
		end
	end
end

RunService.PostSimulation:Connect(OnFrame);

