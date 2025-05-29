--!strict

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local EnemyEvents = ReplicatedStorage.Remotes.Enemy
local SpawnEvent = EnemyEvents.SpawnEvent
local LocationEvent = EnemyEvents.LocationEvent
local SpeedEvent = EnemyEvents.SpeedEvent
local HealthEvent = EnemyEvents.HealthEvent
local DestroyEvent = EnemyEvents.DestroyEvent

local Modules = ReplicatedStorage.Modules
local BezierPath = require(Modules.BezierPath)
local HelperFunctions = require(Modules.HelperFunctions)

local Utility = ServerScriptService.Utility
local SafePlayer = Utility.SafePlayer
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded)

local Enemy = require(script.Parent)
local Enemies = Enemy.GetEnemies()

local function AddInfoToSpawn(Data: any, NewEnemy: Enemy.Enemy)
	Data.UniqueId = NewEnemy.UniqueId
	Data.ModelName = NewEnemy.ModelName
	Data.Health = NewEnemy.Health
	Data.MaxHealth = NewEnemy.MaxHealth
	Data.Speed = NewEnemy.Speed
	Data.IsBoss = NewEnemy.IsBoss
	Data.Ally = NewEnemy.Ally
	Data.OriginalSpeed = NewEnemy.OriginalSpeed
	Data.VectorOffset = NewEnemy.VectorOffset
	Data.BezierId = NewEnemy.BezierId
	Data.AdornmentName = NewEnemy.AdornmentName
	Data.TimePosition = NewEnemy.TimePosition
	Data.Time = workspace:GetServerTimeNow()
	Data.SpeedChanges = NewEnemy.SpeedChanges
end

local Beziers = Enemy.GetBeziers()

SafePlayerAdded:Connect(function(Player: Player)
	for UniqueId, Bezier in pairs(Beziers) do
		LocationEvent:FireAllClients(UniqueId, Bezier.Waypoints)
	end

	local FullEnemyTable = {}

	for Id, Enemy in pairs(Enemies) do
		local Table = {}
		AddInfoToSpawn(Table, Enemy)
		FullEnemyTable[Enemy.UniqueId] = Table
	end

	SpawnEvent:FireClient(Player, FullEnemyTable, false)
end)

Enemy.Spawned:Connect(function(NewEnemy: Enemy.Enemy)
	local Data = {}
	AddInfoToSpawn(Data, NewEnemy)
	HelperFunctions.FireClients(SpawnEvent, NewEnemy.ReplicateTo, { Data }, true)

	local UniqueId = NewEnemy.UniqueId

	NewEnemy.SpeedChanged:Connect(function(Speed: number, Time: number)
		HelperFunctions.FireClients(SpeedEvent, NewEnemy.ReplicateTo, {
			UniqueId = NewEnemy.UniqueId,
			Speed = Speed,
			Time = workspace:GetServerTimeNow(),
		})
	end)

	local function HandleHealth(Health: number, MaxHealth: number)
		HelperFunctions.FireClients(HealthEvent, NewEnemy.ReplicateTo, NewEnemy.UniqueId, Health, MaxHealth)
	end

	NewEnemy.HealthChanged:Connect(function(Health)
		HandleHealth(Health, NewEnemy.MaxHealth)
	end)

	NewEnemy.MaxHealthChanged:Connect(function(MaxHealth)
		HandleHealth(NewEnemy.Health, MaxHealth)
	end)

	NewEnemy.Destroying:Once(function()
		HelperFunctions.FireClients(DestroyEvent, NewEnemy.ReplicateTo, { UniqueId })
	end)
end)

Enemy.BezierAdded:Connect(function(Bezier: BezierPath.Path, UniqueId: string)
	LocationEvent:FireAllClients(UniqueId, Bezier.Waypoints)
end)

Enemy.BezierRemoving:Connect(function(UniqueId: string)
	LocationEvent:FireAllClients(UniqueId)
end)

@native
local function CalculateTimePosition(Enemy: Enemy.Enemy)
	local NewTime = 0
	local CurrentTime = workspace:GetServerTimeNow()

	for _, Data in ipairs(Enemy.SpeedChanges) do
		local EndTime = Data.TimeEnd or CurrentTime
		local Difference = EndTime - Data.TimeStart

		NewTime += (Data.Speed / Enemy.PathLength) * Difference
	end

	NewTime = math.clamp(NewTime, 0, 1)
	if Enemy.Ally then
		NewTime = math.abs(NewTime - 1)
	end

	return NewTime
end

@native
local function OnFrame()
	for Id, Enemy in pairs(Enemies) do
		local TimePosition = CalculateTimePosition(Enemy)

		Enemy.TimePosition = TimePosition

		Enemy.CFrame = Enemy.Bezier:CalculateUniformCFrame(Enemy.TimePosition) + Enemy.VectorOffset

		if Enemy.TimePosition == 0 or Enemy.TimePosition == 1 then
			Enemy.ReachedEnd:Fire()
		end
	end

	for _, Ally in pairs(Enemies) do
		if Ally.Ally then
			for _, Enemy in pairs(Enemies) do
				if not Enemy.Ally then
					if Ally.TimePosition <= Enemy.TimePosition then
						if Ally.Health == Enemy.Health then
							Enemy:Destroy()
							Ally:Destroy()
						elseif Ally.Health < Enemy.Health then
							Enemy:Damage(Ally.Health)
							Ally:Destroy()
						elseif Ally.Health > Enemy.Health then
							Ally:Damage(Enemy.Health)
							Enemy:Destroy()
						end
					end
				end
			end
		end
	end
end

RunService.PostSimulation:Connect(OnFrame)
