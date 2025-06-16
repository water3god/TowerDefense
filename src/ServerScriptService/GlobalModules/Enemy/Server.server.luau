--!strict
--!native

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

	for _, self in pairs(Enemies) do
		local Table = {}
		AddInfoToSpawn(Table, self)
		FullEnemyTable[self.UniqueId] = Table
	end

	SpawnEvent:FireClient(Player, FullEnemyTable, false)
end)

Enemy.Spawned:Connect(function(NewEnemy: Enemy.Enemy)
	local Data = {}
	AddInfoToSpawn(Data, NewEnemy)
	HelperFunctions.FireClients(SpawnEvent, NewEnemy.ReplicateTo, { Data }, true)

	local UniqueId: string = NewEnemy.UniqueId

	NewEnemy.SpeedChanged:Connect(function(Speed: number)
		HelperFunctions.FireClients(SpeedEvent, NewEnemy.ReplicateTo, {
			UniqueId = NewEnemy.UniqueId,
			Speed = Speed,
			Time = workspace:GetServerTimeNow(),
		})
	end)

	local function HandleHealth(Health: number, MaxHealth: number)
		HelperFunctions.FireClients(HealthEvent, NewEnemy.ReplicateTo, NewEnemy.UniqueId, Health, MaxHealth)
	end

	NewEnemy.HealthChanged:Connect(function(Health: number)
		HandleHealth(Health, NewEnemy.MaxHealth)
	end)

	NewEnemy.MaxHealthChanged:Connect(function(MaxHealth: number)
		HandleHealth(NewEnemy.Health, MaxHealth)
	end)

	NewEnemy.Destroying:Once(function(Animate: boolean)
		HelperFunctions.FireClients(DestroyEvent, NewEnemy.ReplicateTo, { UniqueId }, Animate)
	end)
end)

Enemy.BezierAdded:Connect(function(Bezier: BezierPath.Path, UniqueId: string)
	LocationEvent:FireAllClients(UniqueId, Bezier.Waypoints)
end)

Enemy.BezierRemoving:Connect(function(UniqueId: string)
	LocationEvent:FireAllClients(UniqueId)
end)

local function CalculateTimePosition(EnemyInput: Enemy.Enemy)
	local NewTime: number = 0
	local CurrentTime: number = workspace:GetServerTimeNow()

	for _, Data in ipairs(EnemyInput.SpeedChanges) do
		local EndTime: number = Data.TimeEnd or CurrentTime
		local Difference: number = EndTime - Data.TimeStart

		NewTime += (Data.Speed / EnemyInput.PathLength) * Difference
	end

	NewTime = math.clamp(NewTime, 0, 1)
	if EnemyInput.Ally then
		NewTime = math.abs(NewTime - 1)
	end

	return NewTime
end

local function OnFrame()
	for _, self in pairs(Enemies) do
		local TimePosition: number = CalculateTimePosition(self)

		self.TimePosition = TimePosition

		self.CFrame = self.Bezier:CalculateUniformCFrame(self.TimePosition) + self.VectorOffset

		if self.TimePosition == 0 or self.TimePosition == 1 then
			self.ReachedEnd:Fire()
		end
	end

	for _, Ally in pairs(Enemies) do
		if Ally.Ally then
			for _, self in pairs(Enemies) do
				if not self.Ally then
					if Ally.TimePosition <= self.TimePosition then
						if Ally.Health == self.Health then
							self:Destroy(false)
							Ally:Destroy(false)
						elseif Ally.Health < self.Health then
							self:Damage(Ally.Health)
							Ally:Destroy(false)
						elseif Ally.Health > self.Health then
							Ally:Damage(self.Health)
							self:Destroy(false)
						end
					end
				end
			end
		end
	end
end

RunService.PostSimulation:Connect(OnFrame)
