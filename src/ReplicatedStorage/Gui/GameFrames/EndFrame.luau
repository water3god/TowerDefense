--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactSpring = require(Packages.ReactSpring)
local Promise = require(Packages.Promise)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local NetworkFolder = ReplicatedStorage.Network
local Network = require(NetworkFolder.Client)
local ClientOnly = require(NetworkFolder.ClientOnly)

local OnVote = Network.OnEndVote
local OnEnd = Network.OnEnd
local Vote = Network.EndVoteAction
local Warning = ClientOnly.Warning

local TeleportBack = Network.TeleportBack

local TPGuiSet = ClientOnly.TPGuiSet

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)
local CloseButton = require(CoreGame.CloseButton)

local Inventory = Gui.Inventory
local UnitFrame = require(Inventory.UnitFrame)
local ResourceFrame = require(Inventory.ResourceFrame)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local WaveService = require(GlobalClient.WaveService)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)
local IsTutorial = require(Shared.IsTutorial)
local GameInfo = require(Shared.GameInfo)
local XPData = GameInfo.XPData

export type Props = {
	Enabled: boolean,
	Success: boolean,
	SetVisible: ((Visible: boolean) -> ())?,
	PlayerData: React.Binding<{ Votes: number, Total: number }>,
	EndData: GameInfo.ResourceData,
	MainXPData: WaveService.MainXPData,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type ResourceProps = {
	Name: string,
	Value: number,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type UnitXPProps = {
	Data: { Name: string, Trait: string?, OldLevel: number, NewLevel: number, OldXP: number, NewXP: number },
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type MainXPProps = {
	MainXPData: WaveService.MainXPData,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

type UnitXP = { Level: number, XP: number, NeededXP: number }

local function CreateMainXPFrame(props: MainXPProps)
	local Styles, API = ReactSpring.useSpring(function()
		return {
			alpha = 0,
		}
	end)

	local BindingData = React.useRef(1)

	local XPInfo: React.Binding<UnitXP> = Styles.alpha:map(function(alpha: number)
		local Level: number = 1
		local XP: number = 0
		local NeededXP: number = 100

		local LerpGain = math.lerp(0, BindingData.current, alpha)
		local total = 0

		for i = props.MainXPData.OldLevel, props.MainXPData.NewLevel, 1 do
			local Goal = XPData.CalculatePlayerXP(i)
			total += Goal

			if LerpGain <= total then
				Level = i
				XP = (Goal - (total - LerpGain))
				NeededXP = Goal
				break
			end
		end

		return {
			Level = Level,
			XP = XP,
			NeededXP = NeededXP,
		}
	end)

	React.useEffect(function()
		local XPGain = 0
		for i = props.MainXPData.OldLevel, props.MainXPData.NewLevel - 1, 1 do
			local Gain = XPData.CalculatePlayerXP(i)
			XPGain += Gain
		end

		XPGain += props.MainXPData.NewXP

		BindingData.current = XPGain
		if Styles.alpha:getValue() == 1 then
			API.start({
				config = { precision = 1 },
				alpha = 0,
			}):andThen(function()
				API.start({
					alpha = 1,
				})
			end)
		else
			API.start({
				alpha = 1,
			})
		end
	end, { props.MainXPData })

	return e(Main.CanvasGroup, {
		native = Join({
			BackgroundColor3 = Color3.new(0.180392, 0.180392, 0.180392),
			BackgroundTransparency = 0,
			Size = UDim2.fromScale(0.4, 0.08),
			Position = UDim2.fromScale(0.3, 0.775),
		}, props.native),
	}, {
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.4, 0),
		}),
		XPLabel = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.9, 0.8),
				Position = UDim2.fromScale(0.5, 0.5),
				Text = XPInfo:map(function(data: UnitXP)
					return string.format("Level %u (%u / %u)", data.Level, data.XP, data.NeededXP)
				end),
				ZIndex = 3,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
			}),
		}),
		Bar = e(Main.Frame, {
			native = {
				BackgroundColor3 = Color3.new(0.211765, 0.756863, 0.090196),
				BackgroundTransparency = 0,
				Size = XPInfo:map(function(data: UnitXP)
					return UDim2.fromScale(math.clamp(data.XP / data.NeededXP, 0, 1), 1)
				end),
				Position = UDim2.fromScale(0, 0.5),
				AnchorPoint = Vector2.new(0, 0.5),
				ZIndex = 2,
			},
		}),
	}, props.children)
end

local function CreateUnitXPFrame(props: UnitXPProps)
	local Styles, API = ReactSpring.useSpring(function()
		return {
			alpha = 0,
		}
	end)

	local BindingData = React.useRef(1)

	local XPInfo: React.Binding<UnitXP> = Styles.alpha:map(function(alpha: number)
		local Level: number = nil
		local XP: number = nil
		local NeededXP: number = nil
		local Data = props.Data

		local LerpGain = math.lerp(0, BindingData.current, alpha)
		local total = 0

		for i = Data.OldLevel, Data.NewLevel, 1 do
			local Goal = XPData.CalculateUnitXP(i)
			total += Goal

			if LerpGain <= total then
				Level = i
				XP = (Goal - (total - LerpGain))
				NeededXP = Goal
				break
			end
		end

		return {
			Level = Level,
			XP = XP,
			NeededXP = NeededXP,
		}
	end)

	React.useEffect(function()
		local XPGain = 0
		local Data = props.Data
		for i = Data.OldLevel, Data.NewLevel - 1, 1 do
			XPGain += XPData.CalculateUnitXP(i)
		end

		XPGain += Data.NewXP

		BindingData.current = XPGain
		if Styles.alpha:getValue() == 1 then
			API.start({
				config = { precision = 1 },
				alpha = 0,
			}):andThen(function()
				API.start({
					alpha = 1,
				})
			end)
		else
			API.start({
				alpha = 1,
			})
		end
	end, { props.Data })

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
				CornerRadius = UDim.new(0.2, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
				native = {
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
		}),
		UnitImage = e(UnitFrame.CreateUnitFrame, {
			native = {
				Size = UDim2.fromScale(0.5, 0.9),
				Position = UDim2.fromScale(0.15, 0.5),
			},
			UnitName = props.Data.Name,
			Trait = props.Data.Trait,
			Level = XPInfo:map(function(data: UnitXP)
				return data.Level
			end),
		}),
		NameLabel = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.7, 0.3),
				Position = UDim2.fromScale(0.6, 0.25),
				Text = props.Data.Name,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
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
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.4, 0),
			}),
			XPLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.8),
					Position = UDim2.fromScale(0.5, 0.5),
					Text = XPInfo:map(function(data: UnitXP)
						return string.format("%u / %u", data.XP, data.NeededXP)
					end),
					AutoLocalize = false,
					ZIndex = 3,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.015,
				}),
			}),
			Bar = e(Main.Frame, {
				native = {
					BackgroundColor3 = Color3.new(0.211765, 0.756863, 0.090196),
					BackgroundTransparency = 0,
					Size = XPInfo:map(function(data: UnitXP)
						return UDim2.fromScale(math.clamp(data.XP / data.NeededXP, 0, 1), 1)
					end),
					Position = UDim2.fromScale(0, 0.5),
					AnchorPoint = Vector2.new(0, 0.5),
					ZIndex = 2,
				},
			}),
		}),
	}, props.children)
end

local TransparencySequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.1, 0.8),
	NumberSequenceKeypoint.new(0.9, 0.8),
	NumberSequenceKeypoint.new(1, 1),
})

local WinData = {
	[true] = {
		GradColor = ColorSequence.new(Color3.new(0.341176, 0.87451, 0.294118)),
		StrokeColor = ColorSequence.new(Color3.new(0.235294, 0.752941, 0.188235)),
	},
	[false] = {
		GradColor = ColorSequence.new(Color3.new(0.701961, 0.105882, 0.105882)),
		StrokeColor = ColorSequence.new(Color3.new(0.627451, 0.12549, 0.109804)),
	},
}

local function CreateVoteFrame(Props: Props)
	local CloseClick = React.useCallback(function()
		if Props.SetVisible then
			Props.SetVisible(false)
		end
	end, { Props.SetVisible })

	local RestartClick = React.useCallback(function()
		if IsTutorial then
			Warning:Fire("Cannot restart in tutorial.")
		else
			Vote.Fire()
		end
	end, {})

	local ReturnClick = React.useCallback(function()
		TPGuiSet:Fire({ MapName = "Lobby", ImageId = Constants.LOBBYICON })
		Promise.delay(3):andThen(function()
			TeleportBack.Fire(true)
		end)
	end, {})

	local RewardFrames = React.useMemo(function()
		local RewardOrder = Hooks.LayoutOrder()
		local Frames: { [string]: React.Node } = {}

		for Index, Unit in ipairs(Props.EndData.Units) do
			Frames["Unit" .. Unit .. Index] = e(UnitFrame.CreateUnitFrame, {
				Level = 1,
				UnitName = Unit,
				native = {
					LayoutOrder = RewardOrder(),
				},
			})
		end

		for _, Data in ipairs(Props.EndData.Resources) do
			local Amount: number = Data.Count

			if Data.Resource == "Gold" and not Props.Success and WaveService.Percentage then
				Amount = math.floor(Data.Count / WaveService.Percentage / 2)
			end

			Frames["Resource" .. Data.Resource] = e(ResourceFrame, {
				Name = Data.Resource,
				Value = Amount,
				native = {
					LayoutOrder = RewardOrder(),
				},
			})
		end

		return Frames
	end, { Props.EndData })

	local ExistingUnits = React.useMemo(function()
		local Frames = {}

		for Index, UnitData in pairs(Props.EndData.ExistingUnits) do
			Frames[UnitData.Name .. Index] = e(CreateUnitXPFrame, {
				Data = UnitData,
				native = {
					LayoutOrder = Index,
				},
			})
		end

		return Frames
	end, { Props.EndData.ExistingUnits })

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(0.95, 0.7),
			Visible = Props.Enabled,
			ZIndex = 2,
		}, Props.native),
	}, {
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.3, 0.2),
			OnClick = CloseClick,
			native = {
				ZIndex = 4,
			},
		}),
		MainBackground = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(),
				Size = UDim2.fromScale(1, 1),
				ZIndex = 0,
				Visible = Props.Enabled,
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeGradient, {
				Stroke = 0.005,
				GradColor = WinData[Props.Success].StrokeColor,
				native = {
					Color = Color3.new(1, 1, 1),
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.75,
		}),
		RestartButton = e(Main.Animateables.TextButton, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(117, 119, 115),
				Position = UDim2.fromScale(0.3, 0.9),
				Size = UDim2.fromScale(0.2, 0.08),
				Text = "",
				[React.Event.MouseButton1Click] = RestartClick,
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.4, 0),
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.8),
					Text = "Restart",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
				}),
			}),
		}),
		ReturnButton = e(Main.Animateables.TextButton, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(117, 119, 115),
				Position = UDim2.fromScale(0.7, 0.9),
				Size = UDim2.fromScale(0.2, 0.08),
				Text = "",
				[React.Event.MouseButton1Click] = ReturnClick,
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.4, 0),
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.8),
					Text = "Return",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
				}),
			}),
		}),
		Players = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.5, 0.08),
				Position = UDim2.fromScale(0.3, 0.275),
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
				Position = UDim2.fromScale(0.775, 0.425),
				Size = UDim2.fromScale(0.4, 0.8),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
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
			}, ExistingUnits :: any),
		}),
		Rewards = e(Main.Frame, {
			native = {
				BackgroundColor3 = Color3.new(0.243137, 0.054902, 0.368627),
				BackgroundTransparency = 0,
				Position = UDim2.fromScale(0.3, 0.55),
				Size = UDim2.fromScale(0.4, 0.3),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),
			RewardsTitle = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.15),
					Size = UDim2.fromScale(0.6, 0.2),
					Text = "Rewards",
				},
			}),
			MainFrame = e(Main.ScrollingFrame, {
				BarSize = 0.002,
				native = {
					AutomaticCanvasSize = Enum.AutomaticSize.X,
					Position = UDim2.fromScale(0.5, 0.65),
					Size = UDim2.fromScale(0.95, 0.65),
				},
			}, {
				UIListLayout = e("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
			}, RewardFrames),
		}),
		MainXPFrame = e(CreateMainXPFrame, {
			MainXPData = Props.MainXPData,
		}),
		BackgroundFrame1 = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				Size = UDim2.fromScale(2, 2),
				ZIndex = -2,
			},
		}, {
			UIGradient = e("UIGradient", {
				Color = WinData[Props.Success].GradColor,
				Transparency = TransparencySequence,
			}),
		}),
		BackgroundFrame2 = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				Size = UDim2.fromScale(2, 2),
				ZIndex = -2,
			},
		}, {
			UIGradient = e("UIGradient", {
				Color = WinData[Props.Success].GradColor,
				Transparency = TransparencySequence,
				Rotation = 90,
			}),
		}),
	}, Props.children)
end

local function CreateEndFrameButton(props)
	return e(Main.Frame, {
		native = {
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.fromScale(0.4, 0.15),
			Visible = props.Visible,
			ZIndex = 3,
		},
	}, {
		UISizeConstraint = e("UISizeConstraint", {
			MinSize = Vector2.new(230, 60),
			MaxSize = Vector2.new(600, 170),
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 3.555,
		}),
		Button = e(Main.Animateables.ImageButton, {
			native = {
				Image = "rbxassetid://105684513155812",
				Position = UDim2.fromScale(0.5, -0.8),
				Size = UDim2.fromScale(0.9, 0.4),
				[React.Event.MouseButton1Click] = function()
					props.SetVisible(true)
				end,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 3,
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.6),
					Text = "Open End",
				},
			}),
		}),
	})
end

local function VoteConnected(props)
	local Enabled, SetEnabled = React.useState(false)
	local VisualEnabled, SetVisualEnabled = React.useState(false)

	React.useEffect(function()
		if props.Enabled then
			SetVisualEnabled(true)
		end
	end, { Enabled })

	local Success, SetSuccess = React.useState(false)
	local PlayerData, SetData = React.useBinding({
		Votes = 0,
		Total = #Players:GetPlayers(),
	})

	local EndData, SetEndData = React.useState({ Units = {}, Resources = {}, ExistingUnits = {} })
	local MainXPData, SetMainXPData = React.useState({ OldXP = 1, NewXP = 1, OldLevel = 1, NewLevel = 1 })

	React.useEffect(function()
		if not WaveService.GetWaveData() and WaveService.Win ~= nil and WaveService.EndData ~= nil then
			SetSuccess(WaveService.Win)
			SetEndData(WaveService.EndData)
			SetEnabled(true)
		end
	end, {})

	Hooks.useEventConnection(WaveService.Added, function()
		SetEnabled(false)
	end, {})

	Hooks.useZapConnection(OnEnd, function(Data: { VotedCount: number, Win: boolean, Players: { Player } })
		SetData(Join(PlayerData:getValue(), {
			Votes = Data.VotedCount,
		}) :: any)
		SetSuccess(Data.Win)
		SetEnabled(true)
	end, {})

	Hooks.useZapConnection(OnVote, function(VotedCount: number)
		SetData(Join(PlayerData:getValue(), {
			Votes = VotedCount,
		}) :: any)
		SetEnabled(true)
	end, {})

	Hooks.useEventConnection(Players.PlayerAdded, function()
		SetData(Join(PlayerData:getValue(), {
			Total = #Players:GetPlayers(),
		}) :: any)
	end, {})

	Hooks.useEventConnection(Players.PlayerRemoving, function()
		SetData(Join(PlayerData:getValue(), {
			Total = #Players:GetPlayers(),
		}) :: any)
	end, {})

	Hooks.useEventConnection(WaveService.Ended, function(_, Data, OtherData)
		SetEndData(Data)
		SetMainXPData(OtherData)
	end, { EndData, MainXPData })

	return e(React.Fragment, nil, {
		EndFrame = e(CreateVoteFrame, {
			Enabled = Enabled and VisualEnabled,
			SetVisible = SetVisualEnabled,
			Success = Success,
			PlayerData = PlayerData,
			EndData = EndData,
			MainXPData = MainXPData,
			native = props.native,
		}, props.children),
		EndButton = e(CreateEndFrameButton, {
			Visible = not VisualEnabled,
			SetVisible = SetVisualEnabled,
		}),
	})
end

return {
	Create = CreateVoteFrame,
	Connected = VoteConnected,
}
