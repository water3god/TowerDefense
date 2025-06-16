--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

local VotesEvents = ReplicatedStorage.Remotes.Waves.Votes
local VoteRequest = VotesEvents.VoteRequest -- Fires from Server --
local Vote = VotesEvents.Vote -- Fire from Client --
local PlayerVoted = VotesEvents.PlayerVoted

local GlobalWave = require(script.Parent)

local VoteTrove = Trove.new()

type VoteData = {
	Time: number,
	StartTime: number,
	CurrentCount: number,
	NeededCount: number,
	Players: { Player },
}

local VoteData: VoteData? = nil

local function ReturnVotes()
	local CurrentCount = (VoteData and #VoteData.Players) or 0
	local NeededCount = math.ceil(#Players:GetPlayers() / 2)

	return CurrentCount, NeededCount
end

local function Check(Wave: GlobalWave.GlobalWave)
	if not VoteData then
		return
	end

	local CurrentCount, NeededCount = ReturnVotes()

	if CurrentCount >= NeededCount then
		Wave:NextWave()
		VoteTrove:Destroy()
	else
		local OldCCount = VoteData.CurrentCount
		local OldNCount = VoteData.NeededCount

		if CurrentCount ~= OldCCount or NeededCount ~= OldNCount then
			PlayerVoted:FireAllClients({ CurrentCount = CurrentCount, NeededCount = NeededCount })
		end

		VoteData.CurrentCount = CurrentCount
		VoteData.NeededCount = NeededCount
	end
end

local function FireClientInfo(Info: { Time: number, StartTime: number })
	VoteTrove:Destroy()
	local CurrentCount, NeededCount = ReturnVotes()

	VoteData = {
		Time = Info.Time,
		StartTime = Info.StartTime,
		CurrentCount = CurrentCount,
		NeededCount = NeededCount,
		Players = {},
	}

	VoteTrove:Connect(Players.PlayerAdded, function()
		local Wave = GlobalWave.GetWave()
		if Wave then
			Check(Wave)
		end
	end)

	VoteTrove:Add(task.delay(Info.Time, function()
		VoteTrove:Destroy()
	end))

	VoteTrove:Add(function()
		VoteRequest:FireAllClients(nil)
		VoteData = nil
	end)

	VoteRequest:FireAllClients(VoteData)

	VoteTrove:Connect(Players.PlayerAdded, function(Player)
		VoteRequest:FireClient(Player, VoteData)
	end)
end

local function OnAdded(Wave: GlobalWave.GlobalWave)
	FireClientInfo({ StartTime = workspace:GetServerTimeNow(), Time = Wave.Time })

	Wave.OnSkipPrompt:Connect(function()
		local TimeLeft = math.floor((Wave.StartTime + Wave.Time) - workspace:GetServerTimeNow())

		if TimeLeft > 5 then
			FireClientInfo({ StartTime = workspace:GetServerTimeNow(), Time = TimeLeft })
		end
	end)

	Wave.Passed:Connect(function()
		VoteTrove:Destroy()
	end)
end

do
	local Wave = GlobalWave.GetWave()
	if Wave then
		OnAdded(Wave)
	end
end

GlobalWave.Added:Connect(OnAdded)

Vote.OnServerEvent:Connect(function(Player: Player)
	if not VoteData then
		return
	end

	if not table.find(VoteData.Players, Player) then
		table.insert(VoteData.Players, Player)
		local Wave = GlobalWave.GetWave()
		if Wave then
			Check(Wave)
		end
	end
end)
