--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Client = ReplicatedStorage.Client
local LobbyClient = Client.LobbyClient
local QuestsService = require(LobbyClient.QuestsService)

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local Title = require(CoreGame.Title)
local CloseButton = require(CoreGame.CloseButton)
local UIStroke = require(CoreGame.UIStroke)
local BaseButton = require(CoreGame.BaseButton)
local Hooks = require(CoreGame.Hooks)

local QuestsFolder = Gui.Quests
local QuestsContext = require(QuestsFolder.QuestsContext)

-- Frames --
local UnitFrame = require(Gui.Inventory.UnitFrame)
local ResourceFrame = require(Gui.Inventory.ResourceFrame)
local ProductFrame = require(Gui.Inventory.ProductFrame)

local Shared = ReplicatedStorage.Shared
local QuestsInfo = require(Shared.Quests)
local ProductInfo = require(Shared.ProductInfo)
local TitleInfo = require(Shared.Titles)
local Constants = require(Shared.Constants)

export type Properties = {
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local Names = {
	DailyQuests = "Daily Quests",
	WeeklyQuests = "Weekly Quests",
	EventQuests = "Event Quests",
	GlobalQuests = "Global Quests",
}

local Priorities = {
	DailyQuests = 1,
	WeeklyQuests = 2,
	EventQuests = 3,
	GlobalQuests = 4,
}

export type QuestProps = {
	QuestData: QuestsInfo.DefaultQuestData,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateQuest(props: QuestProps)
	local RedeemColor, RedeemText = React.useMemo(function()
		if props.QuestData.Redeemed then
			return Color3.new(), "Redeemed"
		else
			if props.QuestData.CurrentValue >= props.QuestData.NeededValue then
				return Color3.new(0.27451, 0.929412, 0.188235), "Redeem"
			else
				return Color3.new(0.254902, 0.254902, 0.254902), "Redeem"
			end
		end
	end, { props.QuestData })

	local Reward = React.useMemo(function(): React.Node
		local QuestReward = props.QuestData.QuestReward

		if QuestReward.Type == "Title" then
			local TitleData = TitleInfo[QuestReward.Value]

			if TitleData then
				return e(Main.TextLabel, {
					native = {
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(0.6, 0.3),
						TextXAlignment = Enum.TextXAlignment.Right,
						Text = QuestReward.Value,
					},
				}, {
					UIGradient = e("UIGradient", {
						Color = TitleData.Color,
					}),
					UIStroke = e(UIStroke.UIStrokeAdvanced, {
						Stroke = 0.015,
					}),
				})
			else
				warn("NO TITLE DATA FOR TITLE: " .. QuestReward.Value)
			end
		elseif QuestReward.Type == "Resource" then
			return e(ResourceFrame, {
				Name = QuestReward.Value,
				Value = QuestReward.Count,
			})
		elseif QuestReward.Type == "Product" then
			local _, ProductId = ProductInfo.GetProductFromName({
				IsGamepass = false,
				Name = QuestReward.Value,
			})
			if ProductId then
				return e(ProductFrame, {
					Name = QuestReward.Value,
					IsGamepass = false,
					ProductId = ProductId,
					Count = QuestReward.Count,
				})
			else
				warn("No Product For Name: " .. QuestReward.Value)
			end
		elseif QuestReward.Type == "Unit" then
			return e(UnitFrame.CreateUnitFrame, {
				UnitName = QuestReward.Value,
				Level = 1,
			})
		end

		return e("Frame")
	end, { props.QuestData })

	local Redeem = React.useCallback(function()
		if not props.QuestData.Redeemed and props.QuestData.CurrentValue >= props.QuestData.NeededValue then
			QuestsService.RedeemQuest(props.QuestData.Id)
		end
	end, {})

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(1, 0.3),
		}, props.native),
	}, {
		Container = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(1, 0.9),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.298039, 0.094118, 0.470588),
			},
		}, {
			QuestName = e(Main.TextLabel, {
				native = {
					Text = props.QuestData.Name,
					Size = UDim2.fromScale(0.5, 0.5),
					Position = UDim2.fromScale(0.2, 0.3),
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}),
			QuestDescription = e(Main.TextLabel, {
				native = {
					Text = props.QuestData.Description,
					Size = UDim2.fromScale(0.5, 0.5),
					Position = UDim2.fromScale(0.2, 0.6),
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}),
			QuestBar = e(Main.Frame, {
				native = {
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.new(0.160784, 0.082353, 0.203922),
					Position = UDim2.fromScale(0.35, 0.8),
					Size = UDim2.fromScale(0.7, 0.5),
				},
			}, {
				InnerBar = e(Main.Frame, {
					native = {
						BackgroundTransparency = 0,
						BackgroundColor3 = Color3.new(0.505882, 0.137255, 0.709804),
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.8),
						Size = UDim2.fromScale(0.8, 0.5),
					},
				}, {
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(0.2, 0),
					}),
				}),
				ProgressLabel = e(Main.TextLabel, {
					native = {
						Size = UDim2.fromScale(0.9, 0.8),
						Text = string.format("%u / %u", props.QuestData.CurrentValue, props.QuestData.NeededValue),
					},
				}),
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.2, 0),
				}),
			}),
			RedeemButton = e(Main.Animateables.TextButton, {
				native = {
					Size = UDim2.fromScale(0.3, 0.5),
					Position = UDim2.fromScale(0.8, 0.8),
					BackgroundTransparency = 0,
					BackgroundColor3 = RedeemColor,
					Text = "",
					[React.Event.MouseButton1Click] = Redeem,
				},
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.2, 0),
				}),
				Label = e(Main.TextLabel, {
					native = {
						Size = UDim2.fromScale(0.9, 0.8),
						Text = RedeemText,
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeAdvanced, {
						Stroke = 0.015,
					}),
				}),
			}),
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.2, 0),
		}),
		Reward = Reward,
	}, props.children)
end

local function CreateQuestsFrame(props: Properties)
	local QuestData = React.useContext(QuestsContext.Context)
	local OpenFrame, SetOpenFrame = React.useState("DailyQuests")
	local TimerVisible, SetTimerVisible = React.useState(false)
	local Time, _, SetTime = Hooks.UseTime()

	React.useEffect(function(): any
		if OpenFrame == "DailyQuests" or OpenFrame == "WeeklyQuests" or OpenFrame == "EventQuests" then
			SetTimerVisible(true)
			if OpenFrame == "DailyQuests" then
				local function DailyQuestsPromise()
					return Promise.new(function(resolve)
						local CurrentTime = DateTime.now()
						local NewTime = math.ceil(CurrentTime.UnixTimestamp / 86400) * 86400
						local Seconds = NewTime - CurrentTime.UnixTimestamp
						task.wait(Seconds + 1)
						resolve(NewTime)
					end)
						:andThen(function(NewTime)
							SetTime(86400, NewTime)
						end)
						:andThen(function()
							return DailyQuestsPromise()
						end)
				end

				local promise = DailyQuestsPromise()

				return function()
					promise:cancel()
				end
			elseif OpenFrame == "WeeklyQuests" then
				local function WeeklyQuestsPromise()
					return Promise.new(function(resolve)
						local CurrentTime = DateTime.now()
						local NewTime = math.ceil(CurrentTime.UnixTimestamp / 604800) * 604800
						local Seconds = NewTime - CurrentTime.UnixTimestamp
						task.wait(Seconds + 1)
						resolve(NewTime)
					end)
						:andThen(function(NewTime)
							SetTime(604800, NewTime)
						end)
						:andThen(function()
							return WeeklyQuestsPromise()
						end)
				end

				local promise = WeeklyQuestsPromise()

				return function()
					promise:cancel()
				end
			else
				local TimeDifference = Constants.EndTime - DateTime.now().UnixTimestamp
				SetTime(TimeDifference, workspace:GetServerTimeNow())
			end
		else
			SetTimerVisible(false)
		end

		return
	end, { OpenFrame })

	local QuestFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		local QuestInnerData: QuestsInfo.QuestSubType = QuestData.Data[OpenFrame]

		for Index, Data in ipairs(QuestInnerData) do
			Frames["Quest" .. Data.Id] = e(CreateQuest, {
				QuestData = Data,
				native = {
					LayoutOrder = Index,
				},
			})
		end

		return Frames
	end, { OpenFrame, QuestData } :: { unknown })

	local QuestButtons = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for Name, DisplayName in pairs(Names) do
			local Priority = Priorities[Name]
			Frames[Name] = e(BaseButton, {
				Highlighted = OpenFrame == Name,
				Text = DisplayName,
				OnClick = function()
					SetOpenFrame(Name)
				end,
				native = {
					Position = UDim2.fromScale(0.15 + (0.233 * (Priority - 1)), 0.5),
					Size = UDim2.fromScale(0.2, 0.9),
				},
			})
		end

		return Frames
	end, { OpenFrame })

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(0.7, 0.7),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
		}, props.native),
	}, {
		Title = e(Title, {
			Position = UDim2.fromScale(0.2, 0),
			Size = UDim2.fromScale(1, 0.14),
			Title = "QUESTS",
		}),
		Timer = TimerVisible and e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.22),
				Size = UDim2.fromScale(0.4, 0.05),
				Text = Time:map(function(t)
					return string.format("Time Left: %s", HelperFunctions.FormatTime(t))
				end),
				TextScaled = true,
			},
		}),
		QuestButtons = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.13),
				Size = UDim2.fromScale(1, 0.1),
			},
		}, QuestButtons),
		MainFrame = e(Main.ScrollingFrame, {
			BarSize = 0.01,
			native = {
				Position = UDim2.fromScale(0.5, 0.6),
				Size = UDim2.fromScale(0.9, 0.675),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
			},
		}, {
			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
			}),
		}, QuestFrames),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.2,
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.2, 0.15),
			OnClick = props.CloseClick,
		}),
		InnerFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.52),
				Size = UDim2.fromScale(0.94, 0.9),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.015, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Color = Color3.new(0.388235, 0.101961, 0.486275),
				Stroke = 0.002,
				native = {
					Transparency = 0.1,
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
		}),
		UIStroke = e(UIStroke.UIStrokeAdvanced, {
			Color = Color3.new(0.866667, 0.866667, 0.866667),
			Stroke = 0.002,
			native = {
				LineJoinMode = Enum.LineJoinMode.Round,
			},
		}),
	}, props.children)
end

return CreateQuestsFrame
