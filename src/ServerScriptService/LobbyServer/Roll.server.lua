--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes

local Roll = Remotes.Roll
local AutoRoll = Roll.AutoRoll
local RollEvent = Roll.RollEvent

AutoRoll.OnServerEvent:Connect(function(Player: Player, Enabled: boolean) end)

local Counts = { 1, 3, 10 }

RollEvent.OnServerEvent:Connect(function(Player: Player, Count: number)
	if typeof(Count) ~= "number" then
		return
	end
	if not table.find(Counts, Count) then
		return
	end
end)
