--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Client = ReplicatedStorage.Client
local WaveService = require(Client.GlobalClient.WaveService)

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
	local IsVisible, SetVisible = React.useState(false)
	local Styles, API = ReactSpring.useSpring(function()
		return {
			Scale = 0.9,
			config = {
				mass = 1,
				tension = 500,
				friction = 30,
			},
		}
	end)
	local Time, _, SetTime = Hooks.UseTime()
	local PlayerData, SetData = React.useBinding({
		Votes = 1,
		Total = 3,
	})

	React.useEffect(function()
		local Data = WaveService.GetVoteData()
		if Data then
			SetData({
				Votes = Data.CurrentCount,
				Total = Data.NeededCount,
			})
			SetTime(Data.Time, Data.StartTime)
			SetVisible(true)
		end
	end, {})

	Hooks.useEventConnection(WaveService.VoteData.VoteStarted, function(Data)
		SetData({
			Votes = Data.CurrentCount,
			Total = Data.NeededCount,
		})
		SetTime(Data.Time, Data.StartTime)
		SetVisible(true)
	end, {})

	Hooks.useEventConnection(WaveService.VoteData.VoteChanged, function(CurrentCount, NeededCount)
		SetData({
			Votes = CurrentCount,
			Total = NeededCount,
		})
	end, {})

	Hooks.useEventConnection(WaveService.VoteData.VoteEnded, function()
		SetVisible(false)
	end, {})

	local Visiblity, SetVisibility = React.useBinding(false)

	React.useEffect(function()
		if IsVisible then
			SetVisibility(true)

			API.start({
				Scale = 1,
			})
		else
			API.start({
				Scale = 0.9,
			}):andThen(function()
				SetVisibility(false)
			end)
		end
	end, { IsVisible })

	local YesClick = React.useCallback(function()
		WaveService.Vote()
		SetVisible(false)
	end, {})

	local NoClick = React.useCallback(function()
		SetVisible(false)
	end, {})

	return e(Main.Frame, {
		native = Join({
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(),
			Position = UDim2.fromScale(0.5, 0.225),
			Size = UDim2.fromScale(0.175, 0.2),
			Visible = Visiblity,
		}, Props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 2.15,
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
		NoButton = e(Main.Animateables.TextButton, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(255, 0, 3),
				Position = UDim2.fromScale(0.75, 0.75),
				Size = UDim2.fromScale(0.4, 0.25),
				Text = "",
				[React.Event.MouseButton1Click] = NoClick,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeBasic, {
				Stroke = 0.002,
				native = {
					Color = Color3.fromRGB(128, 36, 20),
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.4, 0),
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.9),
					Text = "No",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeBasic, {
					Stroke = 0.004,
				}),
			}),
		}),
		YesButton = e(Main.Animateables.TextButton, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(0, 255, 19),
				Position = UDim2.fromScale(0.25, 0.75),
				Size = UDim2.fromScale(0.4, 0.25),
				Text = "",
				[React.Event.MouseButton1Click] = YesClick,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeBasic, {
				Stroke = 0.002,
				native = {
					Color = Color3.fromRGB(40, 93, 28),
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.4, 0),
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.9),
					Text = "Yes",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeBasic, {
					Stroke = 0.004,
				}),
			}),
		}),
		PlayerCount = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.45),
				Size = UDim2.fromScale(0.3, 0.2),
				Text = PlayerData:map(function(Data)
					return string.format("%u/%u", Data.Votes, Data.Total)
				end),
			},
		}),
		TimeLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 1.15),
				Size = UDim2.fromScale(0.6, 0.2),
				Text = Time:map(function(Time)
					return string.format("Starts In: %u", math.floor(Time))
				end),
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeBasic, {
				Stroke = 0.003,
			}),
		}),
		Title = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.2),
				Size = UDim2.fromScale(0.7, 0.225),
				Text = "Vote Start",
			},
		}),
		Scale = e("UIScale", {
			Scale = Styles.Scale,
		}),
	}, Props.children)
end

return CreateVoteFrame
