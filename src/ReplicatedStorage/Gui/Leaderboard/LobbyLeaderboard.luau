--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local Timer = require(Packages.Timer)
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)

local Datastores: { [string]: OrderedDataStore } = {
	LevelXPStore = DataStoreService:GetOrderedDataStore(Constants.LevelXPStore),
	TotalGoldStore = DataStoreService:GetOrderedDataStore(Constants.TotalGoldStore),
	RobuxSpentStore = DataStoreService:GetOrderedDataStore(Constants.RobuxSpentStore),
}

local LeaderboardData: { [string]: { Title: string, ValueName: string } } = {
	LevelXPStore = { Title = "Level Leaderboard", ValueName = "Level" },
	TotalGoldStore = { Title = "Gold Leaderboard", ValueName = "Gold" },
	RobuxSpentStore = { Title = "Robux Leaderboard", ValueName = "Robux" },
}

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)

export type PlayerProps = {
	Rank: number,
	UserId: number,
	Value: number,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type Props = {
	Type: string,
	Data: { { UserId: number, Value: number } },
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type ConnectedProps = {
	Type: string,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreatePlayerFrame(props: PlayerProps)
	return e(Main.Frame, {
		native = Join({}, props.native),
	}, {}, props.children)
end

local function CreateLobbyLeaderboard(props: Props)
	local LeaderboardData = React.useMemo(function()
		return LeaderboardData[props.Type]
	end, { props.Type })

	local PlayerFrames = React.useMemo(function()
		local Frames = {}

		for Index, Data in ipairs(props.Data) do
			Frames[Index] = e(CreatePlayerFrame, {
				Rank = Index,
				UserId = Data.UserId,
				Value = Data.Value,
			})
		end

		return Frames
	end, { props.Data })

	return e(Main.Frame, {
		native = Join({}, props.native),
	}, {}, props.children)
end

local function LeaderboardConnected(props: ConnectedProps)
	local Data, SetData = React.useState({})

	React.useEffect(function()
		local DataTimer = Timer.new(100)
		local Datastore = Datastores[props.Type]

		local function Set()
			local Success, Pages = pcall(function()
				return Datastore:GetSortedAsync(false, 100)
			end)

			if Success then
				local DataToSet = {}
				for Index, PageData in ipairs(Pages:GetCurrentPage()) do
					DataToSet[Index] = { UserId = PageData.key, Value = PageData.value }
				end
				SetData(DataToSet)
			end
		end

		Set()

		DataTimer.Tick:Connect(Set)

		return function()
			DataTimer:Destroy()
		end
	end, {})

	return e(CreateLobbyLeaderboard, {
		Type = props.Type,
		Data = Data,
		native = Join({}, props.native),
	}, {}, props.children)
end

return {
	Create = CreateLobbyLeaderboard,
	Connected = LeaderboardConnected,
}
