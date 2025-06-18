--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local Packages = ReplicatedStorage.Packages
local Timer = require(Packages.Timer)
local Trove = require(Packages.Trove)

local Modules = ReplicatedStorage.Modules
local RandomGenerate = require(Modules.RandomGenerate)
local HelperFunctions = require(Modules.HelperFunctions)

local Remotes = ReplicatedStorage.Remotes

local RollEvents = Remotes.Roll
local AutoRoll = RollEvents.AutoRoll
local RollEvent = RollEvents.RollEvent
local StopAutoRoll = RollEvents.StopAutoRoll

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)
local Constants = require(Shared.Constants)
local RollDelayTime = Constants.ROLLDELAYTIME

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Utility = ServerScriptService.Utility
local SafePlayer = Utility.SafePlayer
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded)

local ServerData = ServerStorage.Data
local ChanceData = require(ServerData.ChanceData)

if not IsLobby then
	return
end

local InAutoRolls: { [Player]: boolean } = {}

AutoRoll.OnServerEvent:Connect(function(Player: Player, Enabled: boolean)
	if typeof(Enabled) ~= "boolean" then
		return
	end

	InAutoRolls[Player] = Enabled
end)

local Counts = { 1, 3, 10 }

local Delays: { [Player]: { MinimumTime: number, Timer: any } } = {}

local function Roll(Data: PlayerData.PlayerData, Count: number, Auto: boolean)
	Delays[Data.Player].MinimumTime = tick() + RollDelayTime

	local SendData = {}

	for _ = 1, Count, 1 do
		local UnitName = RandomGenerate(ChanceData) :: string
		local UnitData = Data:AddUnit(UnitName)

		if UnitData then
			table.insert(SendData, { Name = UnitName, Id = UnitData.UniqueId })
		else
			warn("NO Unit Available for " .. UnitName)
		end
	end

	if #SendData > 0 then
		RollEvent:FireClient(Data.Player, {
			SentTime = workspace:GetServerTimeNow(),
			Data = SendData,
			AutoRoll = Auto,
		})
	end
end

local function LessThanMaxUnits(Data: PlayerData.PlayerData)
	if not Data.Profile then
		return false, 1
	end
	local Given = Data.Profile.Data
	local Difference = Given.MaxUnitCount - HelperFunctions.Len(Given.Units)
	return Difference > 0, Difference
end

local function LessThanGold(Data: PlayerData.PlayerData)
	if not Data.Profile then
		return false, 1
	end

	local Price = Constants.ROLLCOSTS.MAIN
	local Given = Data.Profile.Data
	local LessThan = Given.Gold / Price

	return LessThan >= 1, math.floor(LessThan)
end

local function InitTimer(Data: PlayerData.PlayerData, Count: number)
	local TimerTrove = Trove.new()
	local Time = TimerTrove:Add(Timer.new(RollDelayTime))
	Time.AllowDrift = false

	Time.Tick:Connect(function()
		local Price = Constants.ROLLCOSTS.MAIN * Count
		local LessThan, Difference = LessThanMaxUnits(Data)
		local LessThanGoldConst, GoldDifference = LessThanGold(Data)
		if LessThanGoldConst and LessThan then
			Data:SubtractGold(Price)
			Roll(Data, math.min(Difference, Count, GoldDifference), true)
		else
			if Delays[Data.Player] then
				Delays[Data.Player].Timer:Destroy()
			end
		end
	end)

	TimerTrove:Add(function()
		if InAutoRolls[Data.Player] then
			InAutoRolls[Data.Player] = false
		end
		StopAutoRoll:FireClient(Data.Player)
	end)

	TimerTrove:Connect(Data.Player.Destroying, function()
		Delays[Data.Player].Timer:Destroy()
	end)

	if Delays[Data.Player].Timer then
		Delays[Data.Player].Timer:Destroy()
	end

	Time:Start()

	Delays[Data.Player].Timer = TimerTrove

	return Time
end

RollEvent.OnServerEvent:Connect(function(Player: Player, Count: number)
	if typeof(Count) ~= "number" then
		return
	end
	if not table.find(Counts, Count) then
		return
	end

	local Data = PlayerData.GetPlayerData(Player)

	if Data then
		local GivenData = Data.Profile.Data
		if GivenData.Gold >= Constants.ROLLCOSTS.MAIN * Count then
			local LessThan, Difference = LessThanMaxUnits(Data)
			local LessThanGoldConst, GoldDifference = LessThanGold(Data)
			if Delays[Player].MinimumTime <= tick() and LessThan and LessThanGoldConst then
				Data:SubtractGold(Constants.ROLLCOSTS.MAIN * Count)

				local AutoRollSetting = Data:GetSetting("AutoRoll")

				InAutoRolls[Player] = AutoRollSetting

				local InAutoRoll = InAutoRolls[Player]
				Roll(Data, math.min(Difference, Count, GoldDifference), InAutoRoll)
				if InAutoRoll then
					InitTimer(Data, Count)
				end
			end
		end
	end
end)

StopAutoRoll.OnServerEvent:Connect(function(Player)
	if Delays[Player].Timer then
		Delays[Player].Timer:Destroy()
		InAutoRolls[Player] = false
		StopAutoRoll:FireClient(Player)
	end
end)

SafePlayerAdded:Connect(function(Player: Player)
	Delays[Player] = { MinimumTime = 0, Timer = nil }
	Player.Destroying:Connect(function()
		Delays[Player] = nil
	end)
end, true)
