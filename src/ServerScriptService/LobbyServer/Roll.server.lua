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

local Remotes = ReplicatedStorage.Remotes

local RollEvents = Remotes.Roll
local AutoRoll = RollEvents.AutoRoll
local RollEvent = RollEvents.RollEvent
local StopAutoRoll = RollEvents.StopAutoRoll

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)
local RollDelayTime = Constants.ROLLDELAYTIME

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Utility = ServerScriptService.Utility
local SafePlayer = Utility.SafePlayer
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded)

local ServerData = ServerStorage.Data
local ChanceData = require(ServerData.ChanceData)

AutoRoll.OnServerEvent:Connect(function(Player: Player, Enabled: boolean)
	if typeof(Enabled) ~= "boolean" then
		return
	end

	local PlayerData = PlayerData.GetPlayerData(Player)

	if PlayerData then
		PlayerData.Profile.Data.AutoRoll = Enabled
	end
end)

local Counts = { 1, 3, 10 }

local Delays: { [Player]: { MinimumTime: number, Timer: any } } = {}

local function Roll(Data: PlayerData.PlayerData, Count: number, Auto: boolean)
	Delays[Data.Player].MinimumTime = tick() + RollDelayTime

	local SendData = {}

	for i = 1, Count, 1 do
		local UnitName = RandomGenerate(ChanceData) :: string
		Data:AddUnit(UnitName)
		table.insert(SendData, UnitName)
	end

	if #SendData > 0 then
		RollEvent:FireClient(Data.Player, {
			SentTime = workspace:GetServerTimeNow(),
			Data = SendData,
			AutoRoll = Auto,
		})
	end
end

local function InitTimer(Data: PlayerData.PlayerData, Count: number)
	local Trove = Trove.new()
	local Time = Trove:Add(Timer.new(RollDelayTime))
	Time.AllowDrift = false

	Time.Tick:Connect(function()
		Roll(Data, Count, true)
	end)

	Trove:Connect(Data.Player.Destroying, function()
		if Time.Tick then
			Time:Destroy()
		end
	end)

	if Delays[Data.Player].Timer then
		Time:Destroy()
	end

	Delays[Data.Player].Timer = Time

	return Time
end

RollEvent.OnServerEvent:Connect(function(Player: Player, Count: number)
	if typeof(Count) ~= "number" then
		return
	end
	if not table.find(Counts, Count) then
		return
	end

	local PlayerData = PlayerData.GetPlayerData(Player)

	if PlayerData and Delays[Player].MinimumTime <= tick() then
		Roll(PlayerData, Count, PlayerData.Profile.Data.AutoRoll)
		if PlayerData.Profile.Data.AutoRoll then
			InitTimer(PlayerData, Count)
		end
	end
end)

StopAutoRoll.OnServerEvent:Connect(function(Player)
	local PlayerData = PlayerData.GetPlayerData(Player)

	if PlayerData and Delays[Player].Timer then
		Delays[Player].Timer:Destroy()
		StopAutoRoll:FireClient(Player)
	end
end)

SafePlayerAdded:Connect(function(Player: Player)
	Delays[Player] = { MinimumTime = 0, Timer = nil }
	Player.Destroying:Connect(function()
		Delays[Player] = nil
	end)
end, true)
