--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

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

local CachedNames: { [number]: string } = {}

local function CreatePlayerFrame(props: PlayerProps)
	local Name = React.useMemo(function()
		if CachedNames[props.UserId] then
			return CachedNames[props.UserId]
		else
			CachedNames[props.UserId] = Players:GetNameFromUserIdAsync(props.UserId)
			return CachedNames[props.UserId]
		end
	end, { props.UserId })

	local Icon = React.useMemo(function()
		return HelperFunctions.GetThumbnailIdAsync(props.UserId)
	end, { props.UserId })

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(1, 0.1),
		}, props.native),
	}, {
		Main = e(Main.Frame, {
			native = {
				BackgroundColor3 = Color3.new(0.282353, 0.133333, 0.403922),
				BackgroundTransparency = 0,
				Size = UDim2.fromScale(1, 0.9),
			},
		}, {
			Rank = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.075, 0.5),
					Size = UDim2.fromScale(0.1, 0.5),
					Text = tostring(props.Rank),
				},
			}),
			Icon = e(Main.ImageLabel, {
				native = {
					Position = UDim2.fromScale(0.2, 0.5),
					Size = UDim2.fromScale(0.2, 0.8),
					Image = Icon,
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
			}),
			Name = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.4, 0.5),
					Text = Name,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}),
			Value = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.825, 0.5),
					Size = UDim2.fromScale(0.25, 0.5),
					Text = props.Value,
					TextXAlignment = Enum.TextXAlignment.Right,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
			}),
		}),
	}, props.children)
end

local function CreateLobbyLeaderboard(props: Props)
	local LeaderboardData = React.useMemo(function()
		return LeaderboardData[props.Type]
	end, { props.Type })

	local PlayerFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for Index, Data in ipairs(props.Data) do
			Frames["Rank" .. Index] = e(CreatePlayerFrame, {
				Rank = Index,
				UserId = Data.UserId,
				Value = Data.Value,
			})
		end

		return Frames
	end, { props.Data })

	return e(Main.Frame, {
		native = Join({
			BackgroundColor3 = Color3.new(0.282353, 0.133333, 0.403922),
			BackgroundTransparency = 0,
		}, props.native),
	}, {
		Title = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.9, 0.06),
				Position = UDim2.fromScale(0.5, 0.05),
				Text = LeaderboardData.Title,
			},
		}),
		TopFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.13),
				Size = UDim2.fromScale(0.9, 0.06),
				BackgroundColor3 = Color3.new(0.396078, 0.168627, 0.529412),
				BackgroundTransparency = 0,
			},
		}, {
			RankLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.11, 0.5),
					Size = UDim2.fromScale(0.3, 0.6),
					Text = "Rank",
					ZIndex = 2,
				},
			}),
			UserNameLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.4, 0.5),
					Size = UDim2.fromScale(0.4, 0.6),
					Text = "Player",
					ZIndex = 2,
				},
			}),
			ValueLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.85, 0.5),
					Size = UDim2.fromScale(0.4, 0.6),
					Text = LeaderboardData.ValueName,
					ZIndex = 2,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.18, 0),
			}),
		}),

		LeaderboardContainer = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.9, 0.75),
				Position = UDim2.fromScale(0.5, 0.55),
				BackgroundColor3 = Color3.new(0.396078, 0.168627, 0.529412),
				BackgroundTransparency = 0,
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.02, 0),
			}),
			Leaderboard = e(Main.ScrollingFrame, {
				BarSize = 0.01,
				native = {
					Size = UDim2.fromScale(0.95, 0.95),
				},
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
			}, PlayerFrames),
		}),
	}, props.children)
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
		native = Join({
			Position = UDim2.fromScale(0.5, 0.508),
			Size = UDim2.fromScale(0.965, 0.98),
		}, props.native),
	}, {}, props.children)
end

return {
	Create = CreateLobbyLeaderboard,
	Connected = LeaderboardConnected,
}
