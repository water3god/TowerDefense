--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)

export type Props = {
	VoteStartCount: number,
	Success: boolean,
	RestartClick: (() -> ())?,
	ReturnClick: (() -> ())?,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateVoteFrame(Props: Props)
	local PlayerData, SetData = React.useBinding({
		Votes = 1,
		Total = #Players:GetPlayers(),
	})

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

	return e(Main.Frame, {
		native = Join({
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(),
			Size = UDim2.fromScale(0.4, 0.3),
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
				[React.Event.MouseButton1Click] = Props.RestartClick,
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
				[React.Event.MouseButton1Click] = Props.ReturnClick,
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
				Text = if Props.Success then "Game Won" else "Game Lost",
			},
		}),
	}, Props.children)
end

return CreateVoteFrame
