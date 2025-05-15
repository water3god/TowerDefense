--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local ReactSpring = require(Packages.ReactSpring)
local Promise = require(Packages.Promise)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Remotes = ReplicatedStorage.Remotes

local GameEndEvents = Remotes.Waves.GameEnd
local OnVote: RemoteEvent = GameEndEvents.OnVote
local OnEnd: RemoteEvent = GameEndEvents.OnEnd
local Vote: RemoteEvent = GameEndEvents.Vote

local TPGuiSet: BindableEvent = Remotes.Booth.ClientOnly.TPGuiSet

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)

local Inventory = Gui.Inventory
local UnitFrame = require(Inventory.UnitFrame)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local WaveService = require(GlobalClient.WaveService)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)

export type Props = {
	Enabled: boolean,
	Success: React.Binding<boolean>,
	PlayerData: React.Binding<{ Votes: number, Total: number }>,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateResourceFrame(props)
	return e(Main.Frame, {
		native = Join({}, props.native),
	}, props.children)
end

local function CreateUnitXPFrame(props)
	local Image = React.useMemo(function()
		return UnitInfo.UnitInfo[props.UnitName].Image
	end, { props.UnitName })

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(0.9, 0.2),
		}, props.native),
	}, {
		Background = e(Main.Frame, {
			native = {
				BackgroundColor3 = Color3.new(0.478431, 0.145098, 0.623529),
				BackgroundTransparency = 0,
				ZIndex = -1,
				Size = UDim2.fromScale(1, 0.9),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.25, 0),
			}),
		}),
		UnitImage = e(UnitFrame.CreateUnitFrame, {
			native = {
				Size = UDim2.fromScale(0.5, 0.9),
				Position = UDim2.fromScale(0.15, 0.5),
			},

			UnitName = props.UnitName,
			Level = 3,
		}),
		NameLabel = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.7, 0.3),
				Position = UDim2.fromScale(0.6, 0.25),
				Text = props.UnitName,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.02,
			}),
		}),
		XPBar = e(Main.CanvasGroup, {
			native = {
				BackgroundColor3 = Color3.new(0.180392, 0.180392, 0.180392),
				BackgroundTransparency = 0,
				Size = UDim2.fromScale(0.6, 0.3),
				Position = UDim2.fromScale(0.6, 0.65),
			},
		}, {
			XPLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.8),
					Position = UDim2.fromScale(0.5, 0.5),
					Text = "50 / 100",
					ZIndex = 3,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.02,
				}),
			}),
			Bar = e(Main.Frame, {
				native = {
					BackgroundColor3 = Color3.new(0.211765, 0.756863, 0.090196),
					BackgroundTransparency = 0,
					Size = UDim2.fromScale(0.5, 1),
					Position = UDim2.fromScale(0, 0.5),
					AnchorPoint = Vector2.new(0, 0.5),
					ZIndex = 2,
				},
			}),
		}),
	}, props.children)
end

local function CreateVoteFrame(Props: Props)
	local RestartClick = React.useCallback(function()
		Vote:FireServer()
	end, {})

	local ReturnClick = React.useCallback(function()
		TPGuiSet:Fire({ MapName = "Lobby", ImageId = "rbxasseid://1" })
		Promise.delay(3):andThen(function()
			HelperFunctions.SafeTeleport(function()
				return TeleportService:TeleportAsync(6695736136, { Player })
			end, 10)
		end)
	end, {})

	return e(Main.Frame, {
		native = Join({
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(),
			Size = UDim2.fromScale(0.95, 0.7),
			Visible = Props.Enabled,
		}, Props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.75,
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.15, 0),
		}),
		UIStroke = e(UIStroke.UIStrokeBasic, {
			Stroke = 0.002,
			native = {
				Color = Color3.fromRGB(103, 103, 104),
				LineJoinMode = Enum.LineJoinMode.Round,
			},
		}),
		RestartButton = e(Main.Animateables.TextButton, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(117, 119, 115),
				Position = UDim2.fromScale(0.25, 0.9),
				Size = UDim2.fromScale(0.2, 0.1),
				Text = "",
				[React.Event.MouseButton1Click] = RestartClick,
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.4, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.01,
				native = {
					Color = Color3.fromRGB(73, 71, 69),
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.8),
					Text = "Restart",
				},
				children = {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.004,
					}),
				},
			}),
		}),
		ReturnButton = e(Main.Animateables.TextButton, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(117, 119, 115),
				Position = UDim2.fromScale(0.75, 0.9),
				Size = UDim2.fromScale(0.2, 0.1),
				Text = "",
				[React.Event.MouseButton1Click] = ReturnClick,
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.4, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.01,
				native = {
					Color = Color3.fromRGB(73, 71, 69),
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.8),
					Text = "Return",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeBasic, {
					Stroke = 0.004,
				}),
			}),
		}),
		Players = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.5, 0.08),
				Position = UDim2.fromScale(0.3, 0.3),
				Text = Props.PlayerData:map(function(Data)
					return string.format("Play Again: %u/%u", Data.Votes, Data.Total)
				end),
			},
		}),
		Title = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.5, 0.1),
				Position = UDim2.fromScale(0.3, 0.12),
				Text = if Props.Success then "Game Won" else "Game Lost",
			},
		}),
		UnitsContainer = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.243137, 0.054902, 0.368627),
				Position = UDim2.fromScale(0.75, 0.45),
				Size = UDim2.fromScale(0.35, 0.7),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),
			Scrolling = e(Main.ScrollingFrame, {
				BarSize = 0.01,
				native = {
					Size = UDim2.fromScale(1, 0.95),
				},
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				TestFrame = e(CreateUnitXPFrame, {
					UnitName = "Scout",
				}),
				TestFrame2 = e(CreateUnitXPFrame, {
					UnitName = "Scout",
				}),
				TestFrame3 = e(CreateUnitXPFrame, {
					UnitName = "Scout",
				}),
				TestFrame4 = e(CreateUnitXPFrame, {
					UnitName = "Scout",
				}),
				TestFrame5 = e(CreateUnitXPFrame, {
					UnitName = "Scout",
				}),
			}),
		}),
	}, Props.children)
end

local function VoteConnected(props)
	local Enabled, SetEnabled = React.useState(false)
	local Success, SetSuccess = React.useBinding(false)
	local PlayerData, SetData = React.useBinding({
		Votes = 0,
		Total = #Players:GetPlayers(),
	})

	React.useEffect(function()
		if not WaveService.GetWaveData() and WaveService.Win ~= nil then
			SetSuccess(WaveService.Win)
			SetEnabled(true)
		end
	end, {})

	Hooks.useEventConnection(WaveService.Added, function()
		SetEnabled(false)
	end, {})

	Hooks.useEventConnection(OnEnd.OnClientEvent, function(Data: { VotedCount: number, Win: boolean })
		SetData(Join(PlayerData:getValue(), {
			Votes = Data.VotedCount,
		}) :: any)
		SetSuccess(Data.Win)
		SetEnabled(true)
	end, {})

	Hooks.useEventConnection(OnVote.OnClientEvent, function(VotedCount: number)
		SetData(Join(PlayerData:getValue(), {
			Votes = VotedCount,
		}) :: any)
		SetEnabled(true)
	end, {})

	Hooks.useEventConnection(Players.PlayerAdded, function(Player: Player)
		SetData(Join(PlayerData:getValue(), {
			Total = #Players:GetPlayers(),
		}) :: any)
	end, {})

	Hooks.useEventConnection(Players.PlayerRemoving, function(Player: Player)
		SetData(Join(PlayerData:getValue(), {
			Total = #Players:GetPlayers(),
		}) :: any)
	end, {})

	return e(CreateVoteFrame, {
		Enabled = Enabled,
		Success = Success,
		PlayerData = PlayerData,
		native = props.native,
	}, props.children)
end

return {
	Create = CreateVoteFrame,
	Connected = VoteConnected,
}
