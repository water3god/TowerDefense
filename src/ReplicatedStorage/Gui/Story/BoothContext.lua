--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Hooks = require(CoreGame.Hooks)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Booth = require(ServerScriptService.LobbyModules.Booth)

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
	MapId = "BattleOfHastings",
	LevelId = "Hastingsv1",
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
		local Booth = Booth.GetBooth(props.BoothId)

		if Booth then
			local function HandleWaiting()
				local Data = Booth.Data :: any
				local Table = {
					MapId = Data.MapId,
					LevelId = Data.LevelId,
					Difficulty = Data.Difficulty,
					PlayerCount = #Booth.Players,
					MaxPlayerCount = 4,
					StartTime = Booth.StartTime,
					EndTime = Booth.StartTime + Booth.TimeLeft,
					Status = "LoadingPlayers",
				}
				SetValue(Table :: any)
			end

			local function HandleChoosing()
				local Table = Join(Value, {
					Status = "ChoosingMap",
				})
				SetValue(Table :: any)
			end

			local function HandleOther()
				local Table = Join(Value, {
					Status = "Idle",
				})
				SetValue(Table :: any)
			end

			local function OnPlayerChanged()
				local Table = Join(Value, {
					Players = #Booth.Players,
				})
				SetValue(Table :: any)
			end

			if Booth.Status == "LoadingPlayers" or Booth.Status == "LoadingIn" then
				HandleWaiting()
			elseif Booth.Status == "ChoosingMap" then
			else
				HandleOther()
			end

			local Connection1 = Booth.StartedWaiting:Connect(function()
				HandleWaiting()
			end)
			local Connection2 = Booth.BoothEnded:Connect(HandleOther)
			local Connection3 = Booth.PlayerAdded:Connect(OnPlayerChanged)
			local Connection4 = Booth.PlayerRemoving:Connect(OnPlayerChanged)
			local Connection5 = Booth.StartedChoosing:Connect(HandleChoosing)

			return function()
				Connection1:Disconnect()
				Connection2:Disconnect()
				Connection3:Disconnect()
				Connection4:Disconnect()
				Connection5:Disconnect()
			end
		end

		return function() end
	end, {})

	return e(Context.Provider, {
		value = Value,
	}, props.children)
end

return {
	Context = Context,
	Provider = Provider,
}
