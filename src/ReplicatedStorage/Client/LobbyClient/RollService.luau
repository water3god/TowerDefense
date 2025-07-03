--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local Modules = ReplicatedStorage.Modules
local ObserveTag = require(Modules.ObserveTag)
local HelperFunctions = require(Modules.HelperFunctions)

local Network = require(ReplicatedStorage.Network.Client)
local AutoRoll = Network.AutoRoll
local RollEventClient = Network.RollEventClient
local RollEventServer = Network.RollEventServer
local StopAutoRollClient = Network.StopAutoRollClient
local StopAutoRollServer = Network.StopAutoRollServer

local Player = Players.LocalPlayer

export type RollData = {
	SentTime: number,
	Data: { { Name: string, Id: string } },
	AutoRoll: boolean,
}

local function SetAutoRoll(Enabled: boolean)
	AutoRoll.Fire(Enabled)
end

local function StopAutoRoll()
	StopAutoRollClient.Fire()
end

local function Roll(Count: number)
	RollEventClient.Fire(Count)
end

local Module: {
	Data: RollData,
	Rolled: Signal.Signal<RollData>,
	AutoRollStopped: Signal.Signal<>,
	Touched: Signal.Signal<>,
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
		Touched = Signal.new(),
		Roll = Roll,
		SetAutoRoll = SetAutoRoll,
		StopAutoRoll = StopAutoRoll,
	}

local function HandleRoll(Data: { SentTime: number, Data: { { Name: string, Id: string } }, AutoRoll: boolean })
	Module.Data = Data
	Module.Rolled:Fire(Data)
end

local function HandleStopAutoRoll()
	Module.AutoRollStopped:Fire()
end

StopAutoRollServer.SetCallback(HandleStopAutoRoll)
RollEventServer.SetCallback(HandleRoll)

ObserveTag.ObserveTag("RollBooth", function(BasePart: Instance)
	if BasePart:IsA("BasePart") then
		local Connection = BasePart.Touched:Connect(function(OtherPart)
			local OtherPlayer = HelperFunctions.GetPlayerFromPart(OtherPart)

			if Player == OtherPlayer then
				Module.Touched:Fire()
			end
		end)

		return function()
			Connection:Disconnect()
		end
	end

	return function() end
end)

return Module
