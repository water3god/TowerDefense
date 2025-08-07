--!strict
--!native

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Network = require(ReplicatedStorage.Network.Server)

local SpawnEvent = Network.EnemySpawnEvent
local LocationEvent = Network.EnemyLocationEvent
local SpeedEvent = Network.EnemySpeedEvent
local HealthEvent = Network.EnemyHealthEvent
local DestroyEvent = Network.EnemyDestroyEvent

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
		LocationEvent.FireAll(UniqueId, Bezier.Waypoints)
	end

	local FullEnemyTable = {}

	for _, self in pairs(Enemies) do
		local Table = {}
		AddInfoToSpawn(Table, self)
		FullEnemyTable[self.UniqueId] = Table
	end

	SpawnEvent.Fire(Player, FullEnemyTable :: any, false)
end, true)

Enemy.Spawned:Connect(function(NewEnemy: Enemy.Enemy)
	local Data = {}
	AddInfoToSpawn(Data, NewEnemy)
	SpawnEvent.FireList(NewEnemy.ReplicateTo, { [NewEnemy.UniqueId] = Data } :: any, true)

	local UniqueId: string = NewEnemy.UniqueId

	NewEnemy.SpeedChanged:Connect(function(Speed: number)
		SpeedEvent.FireList(NewEnemy.ReplicateTo, {
			UniqueId = NewEnemy.UniqueId,
			Speed = Speed,
			Time = workspace:GetServerTimeNow(),
		})
	end)

	local function HandleHealth(Health: number, MaxHealth: number)
		HealthEvent.FireList(NewEnemy.ReplicateTo, NewEnemy.UniqueId, Health, MaxHealth)
	end

	NewEnemy.HealthChanged:Connect(function(Health: number)
		HandleHealth(Health, NewEnemy.MaxHealth)
	end)

	NewEnemy.MaxHealthChanged:Connect(function(MaxHealth: number)
		HandleHealth(NewEnemy.Health, MaxHealth)
	end)

	NewEnemy.Destroying:Once(function(Animate: boolean)
		DestroyEvent.FireList(NewEnemy.ReplicateTo, { UniqueId }, Animate)
	end)
end)

Enemy.BezierAdded:Connect(function(Bezier: BezierPath.Path, UniqueId: string)
	LocationEvent.FireAll(UniqueId, Bezier.Waypoints)
end)

Enemy.BezierRemoving:Connect(function(UniqueId: string)
	LocationEvent.FireAll(UniqueId)
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

	local _, Bezier = next(Enemy.GetBeziers())
	if not Bezier then
		return
	end
	local DifferenceNeeded = 1 / Bezier.PathLength

	for _, Ally in pairs(Enemies) do
		if Ally.Ally then
			for _, self in pairs(Enemies) do
				if not self.Ally and getmetatable(self) and getmetatable(Ally) then
					if Ally.TimePosition - DifferenceNeeded <= self.TimePosition + DifferenceNeeded then
						if Ally.Health == self.Health then
							Ally.Damaged:Fire(Ally.Health)
							self:Destroy(true)
							Ally:Destroy(true)
						elseif Ally.Health < self.Health then
							Ally.Damaged:Fire(Ally.Health)
							self:Damage(Ally.Health)
							Ally:Destroy(true)
						elseif Ally.Health > self.Health then
							Ally.Damaged:Fire(self.Health)
							Ally:Damage(self.Health)
							self:Destroy(true)
						end
					end
				end
			end
		end
	end
end

RunService.Heartbeat:Connect(OnFrame)
