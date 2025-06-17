--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

local WavesEvents = ReplicatedStorage.Remotes.Waves

local GameEndEvents = WavesEvents.GameEnd
local OnVote = GameEndEvents.OnVote
local OnEnd = GameEndEvents.OnEnd
local Vote = GameEndEvents.Vote

local StartGame = WavesEvents.Server.StartGame

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
			OnVote:FireAllClients(Data.VotedCount)
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

		OnEnd:FireAllClients(Data)

		EndedTrove:Connect(Players.PlayerAdded, function(Player: Player)
			OnEnd:FireClient(Player, Data)
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

Vote.OnServerEvent:Connect(function(Player: Player)
	if Data then
		if not table.find(Data.Players, Player) then
			table.insert(Data.Players, Player)
			Update()
		end
	end
end)
