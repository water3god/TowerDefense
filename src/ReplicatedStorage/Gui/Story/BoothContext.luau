--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Trove = require(Packages.Trove)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Booth = not RunService:IsClient() and require(ServerScriptService.LobbyModules.Booth)
	or {} :: typeof(require(ServerScriptService.LobbyModules.Booth))

export type Properties = {
	BoothId: string,

	children: { [any]: any }?,
}

export type BoothData = {
	MapId: string,
	LevelId: string,
	Difficulty: string,
	PlayerCount: number,
	MaxPlayerCount: number,
	StartTime: number,
	EndTime: number,
	Status: string,
}

local Default: BoothData = {
	MapId = "Rome",
	LevelId = "Rome_LegionsMarch",
	Difficulty = "Normal",
	PlayerCount = 1,
	MaxPlayerCount = 2,
	StartTime = 1,
	EndTime = 1,
	Status = "Idle",
}

local Context = React.createContext(Default :: BoothData)

local function Provider(props: Properties)
	local Value, SetValue = React.useState(table.clone(Default))

	React.useEffect(function()
		local NewBooth = Booth.GetBooth(props.BoothId)
		local BoothTrove = Trove.new()

		if NewBooth then
			local function HandleWaiting()
				local Data = NewBooth.Data
				local Table = {
					MapId = Data.MapId,
					LevelId = Data.LevelId,
					Difficulty = Data.Difficulty,
					PlayerCount = #NewBooth.Players,
					MaxPlayerCount = 4,
					StartTime = NewBooth.StartTime,
					EndTime = NewBooth.StartTime + NewBooth.TimeLeft,
					Status = "LoadingPlayers",
				}

				SetValue(Table)
			end

			local function HandleChoosing()
				SetValue(function(currentValue)
					return Join(currentValue, {
						Status = "ChoosingMap",
					}) :: any
				end)
			end

			local function HandleOther()
				SetValue(function(currentValue)
					return Join(currentValue, {
						Status = "Idle",
					}) :: any
				end)
			end

			local function OnPlayerAdded()
				SetValue(function(currentValue)
					return Join(currentValue, {
						PlayerCount = #NewBooth.Players,
					}) :: any
				end)
			end

			local function OnPlayerRemoving()
				SetValue(function(currentValue)
					return Join(currentValue, {
						PlayerCount = #NewBooth.Players - 1,
					}) :: any
				end)
			end

			if NewBooth.Status == "LoadingPlayers" or NewBooth.Status == "LoadingIn" then
				HandleWaiting()
			elseif NewBooth.Status ~= "ChoosingMap" then
				HandleOther()
			end

			BoothTrove:Connect(NewBooth.StartedWaiting, HandleWaiting)
			BoothTrove:Connect(NewBooth.BoothEnded, HandleOther)
			BoothTrove:Connect(NewBooth.PlayerAdded, OnPlayerAdded)
			BoothTrove:Connect(NewBooth.PlayerRemoving, OnPlayerRemoving)
			BoothTrove:Connect(NewBooth.StartedChoosing, HandleChoosing)
		end

		return BoothTrove:WrapClean()
	end, { props.BoothId })

	return e(Context.Provider, {
		value = Value,
	}, props.children)
end

return {
	Context = Context,
	Provider = Provider,
}
