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

export type Props = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateVoteFrame(Props: Props)
	local Enabled, SetEnabled = React.useState(false)
	local Success, SetSuccess = React.useBinding(false)
	local PlayerData, SetData = React.useBinding({
		Votes = 0,
		Total = #Players:GetPlayers(),
	})

	--[[React.useEffect(function()
		if not WaveService.GetWaveData() and WaveService.Win ~= nil then
			SetSuccess(WaveService.Win)
			SetEnabled(true)
		end
	end, {})]]

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
			Size = UDim2.fromScale(0.4, 0.3),
			Visible = Enabled,
		}, Props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 2,
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
				Position = UDim2.fromScale(0.25, 0.75),
				Size = UDim2.fromScale(0.4, 0.2),
				Text = "",
				[React.Event.MouseButton1Click] = RestartClick,
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.4, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeBasic, {
				Stroke = 0.002,
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
				Position = UDim2.fromScale(0.75, 0.75),
				Size = UDim2.fromScale(0.4, 0.2),
				Text = "",
				[React.Event.MouseButton1Click] = ReturnClick,
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.4, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeBasic, {
				Stroke = 0.002,
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
				Size = UDim2.fromScale(0.5, 0.2),
				Position = UDim2.fromScale(0.5, 0.45),
				Text = PlayerData:map(function(Data)
					return string.format("Play Again: %u/%u", Data.Votes, Data.Total)
				end),
			},
		}),
		Title = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.5, 0.2),
				Position = UDim2.fromScale(0.5, 0.2),
				Text = if Success then "Game Won" else "Game Lost",
			},
		}),
	}, Props.children)
end

return CreateVoteFrame
