--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

local NetworkFolder = ReplicatedStorage.Network
local Network = require(NetworkFolder.Server)
local ServerOnly = require(NetworkFolder.ServerOnly)

local OnVote = Network.OnEndVote
local OnEnd = Network.OnEnd
local Vote = Network.EndVoteAction

local StartGame = ServerOnly.StartGame

local GlobalWave = require(script.Parent)

local EndedTrove = Trove.new()
type Data = {
	VotedCount: number,
	Win: boolean,
	Players: { Player },
}

local Data: Data? = nil

local function Update()
	if Data then
		local OldCount = Data.VotedCount
		Data.VotedCount = #Data.Players

		if Data.VotedCount == #Players:GetPlayers() then
			EndedTrove:Destroy()
			return
		end

		if OldCount ~= Data.VotedCount then
			OnVote.FireAll(Data.VotedCount)
		end
	end
end

local function OnAdded(Wave: GlobalWave.GlobalWave)
	Wave.Ended:Connect(function(Win: boolean)
		Data = {
			VotedCount = 0,
			Win = Win,
			Players = {},
		}

		OnEnd.FireAll(Data :: Data)

		EndedTrove:Connect(Players.PlayerAdded, function(Player: Player)
			OnEnd.Fire(Player, Data :: Data)
		end)

		EndedTrove:Connect(Players.PlayerRemoving, function(Player: Player)
			if Data then
				local Index = table.find(Data.Players, Player)
				if Index then
					table.remove(Data.Players, Index)
					Update()
				end
			end
		end)

		EndedTrove:Add(function()
			StartGame:Fire()
		end)

		EndedTrove:Add(function()
			Data = nil
		end)
	end)
end

local Wave = GlobalWave.GetWave()
if Wave then
	OnAdded(Wave)
end

GlobalWave.Added:Connect(OnAdded)

Vote.SetCallback(function(Player: Player)
	if Data then
		if not table.find(Data.Players, Player) then
			table.insert(Data.Players, Player)
			Update()
		end
	end
end)
