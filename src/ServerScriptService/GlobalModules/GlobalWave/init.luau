--!strict

-- By Wa1er_God --

local StartTime = 30
local WaveTweenTime = 6

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local BezierPath = require(Modules.BezierPath)
local GenerateId = require(Modules.GenerateId)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)
local GameInfo = require(Shared.GameInfo)

local GlobalModules = ServerScriptService.GlobalModules
local Enemy = require(GlobalModules.Enemy)

local Data = ServerStorage.Data
local WaveData = require(Data.WaveData)
local EnemyData = require(Data.EnemyData)
local DifficultyData = require(Data.DifficultyData)

export type Input = {
	Data: WaveData.WaveData,
	RewardInfo: GameInfo.RewardInfo,
	IsInfinite: boolean,
	XPMultiplier: number,
	Positions: { Vector3 },
	PlayerIds: { number },
	Difficulty: string,
}

export type InfiniteInput = {
	Data: WaveData.InfiniteData,
	RewardInfo: GameInfo.RewardInfo,
	XPMultiplier: number,
	Positions: { Vector3 },
	PlayerIds: { number },
	Difficulty: string,
}

type Data = {
	Trove: Trove.Trove,
	WaveTrove: Trove.Trove,

	Wave: number,
	Time: number,
	StartTime: number,

	RewardInfo: GameInfo.RewardInfo,
	DifficultyData: DifficultyData.Data,
	IsInfinite: boolean,
	XPMultiplier: number,

	BaseHealth: number,
	MaxHealth: number,

	Coins: { [number]: number },
	Positions: { Vector3 },
	Data: WaveData.WaveData,

	Bezier: BezierPath.Path,
	BezierId: string,

	CoinsChanged: Signal.Signal<number, number>,
	Passed: Signal.Signal<number>,
	TimeChanged: Signal.Signal<number, number>,
	Damaged: Signal.Signal<number>,
	Healed: Signal.Signal<number>,
	HealthChanged: Signal.Signal<number>,
	MaxHealthChanged: Signal.Signal<number>,
	OnSkipPrompt: Signal.Signal<>,

	EnemyAdded: Signal.Signal<Enemy.Enemy>,
	EnemyDestroying: Signal.Signal<Enemy.Enemy>,
	Ended: Signal.Signal<boolean>,
}

type Impl = {
	new: (Input: Input) -> GlobalWave,
	infinite: (Input: InfiniteInput) -> GlobalWave,

	NextWave: (self: GlobalWave) -> (),

	AddCoins: (self: GlobalWave, Coins: number) -> (),
	HasEnoughCoins: (self: GlobalWave, UserId: number, NeededCoins: number) -> (),

	SetCoinsUser: (self: GlobalWave, UserId: number, Coins: number) -> (),
	SubtractCoinsFromUser: (self: GlobalWave, UserId: number, Coins: number) -> (),
	AddCoinsToUser: (self: GlobalWave, UserId: number, Coins: number) -> (),

	Damage: (self: GlobalWave, Damage: number) -> (),
	Heal: (self: GlobalWave, Healing: number) -> (),
	SetHealth: (self: GlobalWave, Health: number) -> (),

	AddAlly: (self: GlobalWave, Ally: string) -> (),

	End: (self: GlobalWave, Win: boolean) -> (),

	_SetTime: (self: GlobalWave, Time: number) -> (),

	GetWave: () -> GlobalWave?,

	Added: Signal.Signal<GlobalWave>,

	__index: Impl,
}

export type GlobalWave = typeof(setmetatable({} :: Data, {} :: Impl))

local GlobalWave: Impl = {} :: Impl
GlobalWave.__index = GlobalWave

GlobalWave.Added = Signal.new()
local CurrentWave: GlobalWave? = nil

--[=[
	Constructs a new Wave.
]=]
function GlobalWave.new(Input: Input)
	local self = setmetatable({}, GlobalWave) :: GlobalWave

	self.Trove = Trove.new()
	self.WaveTrove = self.Trove:Extend()

	self.CoinsChanged = self.Trove:Construct(Signal)
	self.Passed = self.Trove:Construct(Signal)
	self.TimeChanged = self.Trove:Construct(Signal)
	self.Damaged = self.Trove:Construct(Signal)
	self.Healed = self.Trove:Construct(Signal)
	self.HealthChanged = self.Trove:Construct(Signal)
	self.MaxHealthChanged = self.Trove:Construct(Signal)
	self.OnSkipPrompt = self.Trove:Construct(Signal)

	self.EnemyAdded = self.Trove:Construct(Signal)
	self.EnemyDestroying = self.Trove:Construct(Signal)
	self.Ended = self.Trove:Construct(Signal)

	self.Wave = 0
	self.Time = 0
	self.StartTime = 0

	self.DifficultyData = DifficultyData[Input.Difficulty]
	self.IsInfinite = Input.IsInfinite
	self.XPMultiplier = Input.XPMultiplier
	self.RewardInfo = Input.RewardInfo

	if not Input.IsInfinite then
		self.DifficultyData.HealthRatio = 1
		self.DifficultyData.HeathIncrRatio = 1
		self.DifficultyData.SpeedAdditive = 0
	end

	self.MaxHealth = self.DifficultyData.Health
	self.BaseHealth = self.MaxHealth

	self.Positions = Input.Positions
	self.Data = Input.Data

	self.Coins = {}

	for _, PlayerId in ipairs(Input.PlayerIds) do
		self.Coins[PlayerId] = 0
		self:AddCoinsToUser(PlayerId, Constants.STARTCOINS)
	end

	self.Bezier = BezierPath.new(self.Positions, Constants.BEZIERCURVE)
	self.BezierId = GenerateId.GenerateId()
	Enemy.AddBezier(self.BezierId, self.Bezier)

	self.Trove:Add(function()
		Enemy.RemoveBezier(self.BezierId)
	end)

	self:_SetTime(StartTime)

	self.WaveTrove:Add(task.delay(StartTime, function()
		self:NextWave()
	end))

	self.Damaged:Connect(function()
		if self.BaseHealth == 0 then
			task.defer(function()
				self:End(false)
			end)
		end
	end)

	self.EnemyAdded:Connect(function(Enemy: Enemy.Enemy)
		Enemy.ReachedEnd:Once(function()
			local Health = Enemy.Health
			self:Damage(Health)
		end)
	end)

	self.Passed:Connect(function(Wave: number)
		self:AddCoins(Input.Data.Data[Wave].CoinBonus)
	end)

	CurrentWave = self
	self.Added:Fire(self)
	return self
end

function GlobalWave.infinite(InfInput: InfiniteInput)
	local Data: WaveData.WaveData = {
		Data = {},
		EnemyData = InfInput.Data.EnemyData,
	}

	local Input: Input = {
		Data = Data,
		RewardInfo = InfInput.RewardInfo,
		XPMultiplier = InfInput.XPMultiplier,
		Positions = InfInput.Positions,
		Difficulty = InfInput.Difficulty,
		PlayerIds = InfInput.PlayerIds,
		IsInfinite = true,
	}

	local OrderPriority = {}
	local InfEnemyData = InfInput.Data.Data

	for Enemy, Info in pairs(InfEnemyData) do
		OrderPriority[Info.OrderPriority] = Enemy
	end

	local Wave = GlobalWave.new(Input)

	local function AddInfoToWave(WaveNum: number)
		WaveNum += 1

		local EnemiesData = {}
		local Time = 1

		for _, EnemyName in ipairs(OrderPriority) do
			local Info = InfEnemyData[EnemyName]

			if Info.FirstSpawnWave > WaveNum then
				continue
			end
			if Info.WaveDelay and math.fmod(WaveNum + Info.FirstSpawnWave, Info.WaveDelay) ~= 0 then
				continue
			end

			EnemiesData[EnemyName] = {}

			for i = 1, Info.SpawnCount or 1, 1 do
				table.insert(EnemiesData[EnemyName], Time)
				Time += 1
			end
			Time += 2
		end

		Data.Data[WaveNum] = { Enemies = EnemiesData, Length = Time, CoinBonus = 200 + 50 * WaveNum }
	end

	AddInfoToWave(Wave.Wave)
	Wave.Passed:Connect(AddInfoToWave)

	return Wave
end

function GlobalWave:NextWave()
	self.WaveTrove:Destroy()

	if self.Wave >= #self.Data.Data then
		self:End(true)
		return
	end

	self:_SetTime(WaveTweenTime)

	self.Trove:Add(task.delay(WaveTweenTime, function()
		self.Wave += 1
		self.Passed:Fire(self.Wave)
		local WaveData = self.Data.Data[self.Wave]

		self:_SetTime(WaveData.Length)

		self.WaveTrove:Add(task.delay(WaveData.Length, function()
			self:NextWave()
		end))

		local ThreadCount = 0
		local EnemyCount = 0
		local LongestTime = 0

		local Destroying = self.WaveTrove:Construct(Signal)

		self.WaveTrove:Connect(Destroying, function(Enemy: Enemy.Enemy)
			EnemyCount -= 1
			if ThreadCount <= 0 and EnemyCount <= 0 then
				self:NextWave()
			end
		end)

		for EnemyName, Times in pairs(WaveData.Enemies) do
			local EnemyData = HelperFunctions.DeepClone(EnemyData[EnemyName])

			EnemyData.Health *= self.DifficultyData.HealthRatio

			for _, Time in ipairs(Times) do
				ThreadCount += 1
				EnemyCount += 1
				if Time > LongestTime then
					LongestTime = Time
				end
				self.WaveTrove:Add(task.delay(Time, function()
					ThreadCount -= 1
					local Enemy = self.Trove:Construct(Enemy, { EnemyInfo = EnemyData, BezierId = self.BezierId })

					Enemy.HealthChanged:Connect(function(Health: number)
						if Health == 0 then
							self.Trove:Remove(Enemy :: any)
						end
					end)

					self.EnemyAdded:Fire(Enemy)
					Enemy.Destroying:Once(function()
						self.EnemyDestroying:Fire(Enemy)
						Destroying:Fire(Enemy)
					end)
				end))
			end
		end

		self.WaveTrove:Add(task.delay(LongestTime + 5, function()
			self.OnSkipPrompt:Fire()
		end))
	end))
end

function GlobalWave:SetCoinsUser(UserId: number, Coins: number)
	if self.Coins[UserId] then
		self.Coins[UserId] = math.max(Coins, 0)
	end
	self.CoinsChanged:Fire(UserId, Coins)
end

function GlobalWave:SubtractCoinsFromUser(UserId: number, Coins: number)
	if self.Coins[UserId] then
		self:SetCoinsUser(UserId, self.Coins[UserId] - Coins)
	end
end

function GlobalWave:AddCoinsToUser(UserId: number, Coins: number)
	if self.Coins[UserId] then
		self:SetCoinsUser(UserId, self.Coins[UserId] + Coins)
	end
end

function GlobalWave:AddCoins(Coins: number)
	for UserId, _ in pairs(self.Coins) do
		self:AddCoinsToUser(UserId, Coins)
	end
end

function GlobalWave:HasEnoughCoins(UserId: number, NeededCoins: number)
	local Coins = self.Coins[UserId]
	if Coins then
		if NeededCoins <= Coins then
			return true
		end
	end
	return false
end

function GlobalWave:Damage(Damage: number)
	self:SetHealth(self.BaseHealth - Damage)
end

function GlobalWave:Heal(Healing: number)
	self:SetHealth(self.BaseHealth + Healing)
end

function GlobalWave:SetHealth(Health: number)
	local Old = self.BaseHealth
	self.BaseHealth = math.clamp(Health, 0, self.MaxHealth)
	self.HealthChanged:Fire(self.BaseHealth)

	if Old > self.BaseHealth then
		self.Damaged:Fire(Old - self.BaseHealth)
	elseif Old < self.BaseHealth then
		self.Healed:Fire(self.BaseHealth - Old)
	end
end

function GlobalWave:AddAlly(Ally: string)
	self.Trove:Construct(Enemy, {
		EnemyInfo = EnemyData[Ally],
		BezierId = self.BezierId,
	})
end

function GlobalWave:End(Win: boolean)
	self.Ended:Fire(Win)
	self.Trove:Destroy()
	CurrentWave = nil
end

function GlobalWave:_SetTime(Time: number)
	self.Time = Time
	self.StartTime = workspace:GetServerTimeNow()
	self.TimeChanged:Fire(self.Time, self.StartTime)
end

function GlobalWave.GetWave()
	return CurrentWave
end

return table.freeze(GlobalWave)
