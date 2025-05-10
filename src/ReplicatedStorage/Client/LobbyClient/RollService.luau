--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Remotes = ReplicatedStorage.Remotes
local RollRemotes = Remotes.Roll
local AutoRoll = RollRemotes.AutoRoll
local RollEvent = RollRemotes.RollEvent
local StopAutoRollEvent = RollRemotes.StopAutoRoll

export type RollData = {
	SentTime: number,
	Data: { string },
	AutoRoll: boolean,
}

local function SetAutoRoll(Enabled: boolean)
	AutoRoll:FireServer(Enabled)
end

local function StopAutoRoll()
	StopAutoRollEvent:FireServer()
end

local function Roll(Count: number)
	RollEvent:FireServer(Count)
end

local Module: {
	Data: RollData,
	Rolled: Signal.Signal<RollData>,
	AutoRollStopped: Signal.Signal<>,
	Roll: (Count: number) -> (),
	SetAutoRoll: (Enabled: boolean) -> (),
	StopAutoRoll: () -> (),
} =
	{
		Data = {
			SentTime = 0,
			Data = {},
			AutoRoll = false,
		},
		Rolled = Signal.new(),
		AutoRollStopped = Signal.new(),
		Roll = Roll,
		SetAutoRoll = SetAutoRoll,
		StopAutoRoll = StopAutoRoll,
	}

local function HandleRoll(Data: { SentTime: number, Data: { string }, AutoRoll: boolean })
	Module.Data = Data
	Module.Rolled:Fire(Data)
end

local function HandleStopAutoRoll()
	Module.AutoRollStopped:Fire()
end

StopAutoRollEvent.OnClientEvent:Connect(HandleStopAutoRoll)
RollEvent.OnClientEvent:Connect(HandleRoll)

return Module
