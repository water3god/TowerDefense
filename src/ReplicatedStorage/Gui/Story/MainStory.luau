--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts
local Len = HelperFunctions.Len

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local Title = require(CoreGame.Title)
local CloseButton = require(CoreGame.CloseButton)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)
local LayoutOrder = Hooks.LayoutOrder

local Inventory = Gui.Inventory
local UnitFrame = require(Inventory.UnitFrame)
local ResourceFrame = require(Inventory.ResourceFrame)

local Story = Gui.Story
local StoryContext = require(Story.StoryContext)

local WarningFolder = Gui.Warning
local WarningContext = require(WarningFolder.WarningContext)

local MiscContexts = Gui.MiscContexts
local MultiplierContext = require(MiscContexts.GoldMultiplier)

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)

local StoryService = require(ReplicatedStorage.Client.LobbyClient.StoryService)

export type Properties = {
	Toggle: (Visible: boolean) -> ()?,
	IsVisible: boolean,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateStage(Props: { Hovered: boolean, Number: number, OnClick: () -> (), Enabled: boolean })
	local WarningData = React.useContext(WarningContext.Context)

	local NoLevel = React.useCallback(function()
		WarningData.Add(string.format("You do not have Level %u Unlocked!", Props.Number))
	end, { Props.Number })

	return e(Main.Frame, {
		native = {
			LayoutOrder = Props.Number,
			Size = UDim2.fromScale(0.85, 0.225),
		},
	}, {
		Button = e(Main.Animateables.TextButton, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = if Props.Enabled then Color3.fromRGB(127, 32, 165) else Color3.fromRGB(93, 11, 141),
				Size = UDim2.fromScale(0.9, 0.9),
				Text = "",
				[React.Event.MouseButton1Click] = Props.Enabled and Props.OnClick or NoLevel,
			},
		}, {

			UIStroke = Props.Hovered and e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.02,
				Color = Color3.new(1, 1, 1),
				native = {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.55),
					Text = Props.Number == 0 and "∞" or tostring(Props.Number),
				},
			}),
		}),
	})
end

local function CreateMap(Props: {
	Enabled: boolean,
	CurrentMap: string,
	MapInfo: GameInfo.MapInfo,
	Index: number,
	MapClicked: (MapId: string) -> (),
})
	local StoryData = React.useContext(StoryContext.Context)
	local WarningData = React.useContext(WarningContext.Context)

	local InvalidMap = React.useCallback(function()
		WarningData.Add(string.format("You do not have %s Unlocked!", Props.MapInfo.Name))
	end, { Props.MapInfo })

	return e(Main.Animateables.TextButton, {
		native = {
			Text = "",
			Size = UDim2.fromScale(0.9, 0.25),
			LayoutOrder = Props.Index,
			[React.Event.MouseButton1Click] = Props.Enabled and function()
				Props.MapClicked(Props.MapInfo.MapId)
			end or InvalidMap,
		},
	}, {
		Main = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(1, 0.7),
			},
		}, {
			MapImage = e(Main.ImageLabel, {
				native = {
					Image = Props.MapInfo.Image,
					ScaleType = Enum.ScaleType.Crop,
					ImageTransparency = Props.Enabled and 0 or 0.7,
				},
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.2, 0),
				}),
				UIStroke = Props.CurrentMap == Props.MapInfo.MapId and e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.015,
					Color = Color3.new(1, 1, 1),
					native = {
						LineJoinMode = Enum.LineJoinMode.Round,
					},
				}),
				Locked = not Props.Enabled and e(Main.TextLabel, {
					native = {
						Text = "Locked!",
						Rotation = 10,
						Size = UDim2.fromScale(0.9, 0.5),
						ZIndex = 10,
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeAdvanced, {
						Stroke = 0.02,
						Color = Color3.new(0, 0, 0),
					}),
				}),
				FrameGrad = e(Main.Frame, {
					native = {
						BackgroundTransparency = 0,
					},
				}, {
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(0.2, 0),
					}),
					UIGradient = e("UIGradient", {
						Color = ColorSequence.new(Color3.new()),
						Rotation = 90,
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 1),
							NumberSequenceKeypoint.new(1, 0.4),
						}),
					}),
				}),
			}),
			MapName = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0),
					Size = UDim2.fromScale(0.9, 0.4),
					Text = Props.MapInfo.Name,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.02,
					Color = Color3.new(0, 0, 0),
				}),
			}),
			MapsCleared = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 1),
					Size = UDim2.fromScale(0.9, 0.4),
					Text = StoryData.CompletedMaps[Props.MapInfo.MapId] and string.format(
						"%u/%u",
						Len(StoryData.CompletedMaps[Props.MapInfo.MapId]),
						#Props.MapInfo.LevelInfo
					) or string.format("0/%u", #Props.MapInfo.LevelInfo),
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.02,
					Color = Color3.new(0, 0, 0),
				}),
			}),
		}),
	})
end

local HoveredColor = Color3.fromRGB(183, 42, 255)
local DefaultColor = Color3.new(0.227451, 0.082353, 0.290196)

local function CreateMainStory(Properties: Properties)
	local StoryData = React.useContext(StoryContext.Context)
	local GoldMultiplier = React.useContext(MultiplierContext.Context)
	local Time, TotalTime, SetTime = Hooks.UseTime()

	React.useEffect(function()
		local Data = StoryData.BoothTimeData
		if Data then
			SetTime(Data.EndTime - Data.StartTime, Data.StartTime)
		end
	end, { StoryData })

	local CurrentMap, SetMap = React.useState(GameInfo.GameInfo[1].MapId)
	local Stage, SetStage = React.useState(1)
	local Difficulty, SetDifficulty = React.useState("Normal")

	local IsInfinite = React.useMemo(function()
		return Stage == 0
	end, { Stage })

	local MapClicked = React.useCallback(function(MapId)
		if CurrentMap ~= MapId then
			SetMap(MapId)
		end
	end, { CurrentMap })

	local ResourceFrames = React.useMemo(function()
		local ResourceOrder = LayoutOrder()

		local RewardInfo = (GameInfo.GetMapFromId(CurrentMap) :: GameInfo.MapInfo).LevelInfo[Stage]
		local Data = RewardInfo.RewardInfo[Difficulty]

		local FrameTable: { [string]: React.ReactNode } = {}

		for _, Unit in ipairs(Data.Units) do
			FrameTable["Unit" .. Unit] = e(UnitFrame.CreateUnitFrame, {
				UnitName = Unit,
				Level = 1,
				native = {
					ZIndex = ResourceOrder(),
				},
			})
		end

		for _, Reward in ipairs(Data.Resources) do
			local Value = Reward.Count

			if Reward.Resource == "Gold" then
				Value = math.floor(Reward.Count * GoldMultiplier)
			elseif Reward.Resource == "XP" then
				continue
			end

			FrameTable["Reward" .. Reward.Resource] = e(ResourceFrame, {
				Name = Reward.Resource,
				Value = Value,
				native = {
					ZIndex = ResourceOrder(),
				},
			})
		end
		return FrameTable
	end, { CurrentMap, Stage, Difficulty, GoldMultiplier } :: { unknown })

	local MapData = React.useMemo(function()
		local Data: { [string]: React.Node } = {}
		for Index, MapInfo in ipairs(GameInfo.GameInfo) do
			if MapInfo.Name == "Tutorial" then
				continue
			end

			local Enabled: boolean = nil

			if MapInfo.Prerequisite then
				local PrerequisiteData = StoryData.CompletedMaps[MapInfo.Prerequisite]
				local CurrentMapInfo = GameInfo.GetMapFromId(MapInfo.MapId)
				if PrerequisiteData and CurrentMapInfo and PrerequisiteData[#CurrentMapInfo.LevelInfo] then
					Enabled = true
				else
					Enabled = false
				end
			else
				Enabled = true
			end

			Data[MapInfo.MapId] = e(CreateMap, {
				CurrentMap = CurrentMap,
				Enabled = Enabled,
				MapInfo = MapInfo,
				Index = Index,
				MapClicked = MapClicked,
			})
		end
		return Data
	end, { StoryData, MapClicked } :: { unknown })

	React.useEffect(function()
		SetStage(1)
	end, { CurrentMap })

	local DifficultyLayoutOrder = LayoutOrder()

	local CancelCallback = React.useCallback(function()
		StoryService.LeaveBooth()
	end, {})

	local ConfirmCallback = React.useCallback(function()
		StoryService.ChooseMap({
			MapId = CurrentMap,
			LevelId = (GameInfo.GetMapFromId(CurrentMap) :: GameInfo.MapInfo).LevelInfo[Stage].GameId,
			Difficulty = Difficulty :: any,
		})
	end, { CurrentMap, Stage, Difficulty } :: { unknown })

	React.useEffect(function()
		if Properties.Toggle then
			if StoryData.Enabled and StoryData.BoothTimeData then
				Properties.Toggle(true)
			else
				Properties.Toggle(false)
			end
		end
	end, { StoryData })

	React.useEffect(function()
		if not Properties.IsVisible and not StoryData.Data then
			StoryService.LeaveBooth()
		end
	end, { Properties.IsVisible })

	local FullMapName = React.useMemo(function()
		return GameInfo.GetFullName(
			(GameInfo.GetMapFromId(CurrentMap) :: any).Name,
			Stage,
			(GameInfo.GetMapFromId(CurrentMap) :: any).LevelInfo[Stage].Name
		)
	end, { CurrentMap, Stage } :: { unknown })

	local LevelCount = React.useMemo(function()
		return #(GameInfo.GetMapFromId(CurrentMap) :: any).LevelInfo
	end, { CurrentMap })

	local FirstValue = React.useMemo(function()
		if IsInfinite then
			local MapInfo = StoryData.CompletedInfinites[CurrentMap]

			if
				MapInfo
				and MapInfo[Stage]
				and MapInfo[Stage][Difficulty :: any]
				and MapInfo[Stage][Difficulty :: any].Wave
			then
				return tostring(MapInfo[Stage][Difficulty :: any].Wave)
			else
				return "N/A"
			end
		else
			local MapInfo = StoryData.CompletedMaps[CurrentMap]

			if
				MapInfo
				and MapInfo[Stage]
				and MapInfo[Stage][Difficulty :: any]
				and MapInfo[Stage][Difficulty :: any].FinishedCount
			then
				return tostring(MapInfo[Stage][Difficulty :: any].FinishedCount)
			else
				return "N/A"
			end
		end
	end, { CurrentMap, Stage, Difficulty, StoryData, IsInfinite } :: { unknown })

	local SecondValue = React.useMemo(function()
		if IsInfinite then
			local MapInfo = StoryData.CompletedInfinites[CurrentMap]

			if
				MapInfo
				and MapInfo[Stage]
				and MapInfo[Stage][Difficulty :: any]
				and MapInfo[Stage][Difficulty :: any].Damage
			then
				return HelperFunctions.FormatTime(MapInfo[Stage][Difficulty :: any].Damage)
			else
				return "N/A"
			end
		else
			local MapInfo = StoryData.CompletedMaps[CurrentMap]

			if
				MapInfo
				and MapInfo[Stage]
				and MapInfo[Stage][Difficulty :: any]
				and MapInfo[Stage][Difficulty :: any].FastestTime
			then
				return HelperFunctions.FormatTime(MapInfo[Stage][Difficulty :: any].FastestTime)
			else
				return "N/A"
			end
		end
	end, { CurrentMap, Stage, Difficulty, StoryData, IsInfinite } :: { unknown })

	local MapImage = React.useMemo(function()
		return (GameInfo.GetMapFromId(CurrentMap) :: any).Image :: string
	end, { CurrentMap })

	local EnabledIndex = React.useMemo(function()
		local Data = StoryData.CompletedMaps[CurrentMap]

		if Data then
			return #Data + 1
		end

		return 1
	end, { StoryData, CurrentMap } :: { unknown })

	local StageData = React.useMemo(function()
		local Data: { [string]: React.Node } = {}

		if (GameInfo.GetMapFromId(CurrentMap) :: any).LevelInfo[0] then
			Data["Stage_Infinite"] = e(CreateStage, {
				Number = 0,
				Hovered = Stage == 0,
				Visible = LevelCount >= 0,
				Enabled = EnabledIndex >= 0,
				OnClick = function()
					SetStage(0)
				end,
			})
		end

		for i = 1, LevelCount do
			Data["Stage" .. i] = e(CreateStage, {
				Number = i,
				Hovered = Stage == i,
				Visible = LevelCount >= i,
				Enabled = EnabledIndex >= i,
				OnClick = function()
					SetStage(i)
				end,
			})
		end

		return Data
	end, { CurrentMap, Stage, LevelCount, EnabledIndex } :: { unknown })

	return e(Main.ImageLabel, {
		native = Join({
			Position = UDim2.fromScale(0.4, 0.45),
			Size = UDim2.fromScale(0.5, 0.6),
			Image = "rbxassetid://100546338175267",
		}, Properties.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.787,
		}),
		MapName = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.45, 0.17),
				Size = UDim2.fromScale(0.7, 0.1),
				Text = FullMapName, --"Colussem: 1 - Survival",
			},
		}),
		Bar = e(Main.CanvasGroup, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(93, 11, 141),
				Position = UDim2.fromScale(0.7, 1.07),
				Size = UDim2.fromScale(0.9, 0.08),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.4, 0),
			}),
			InnerBar = e(Main.Frame, {
				native = {
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(127, 32, 165),
					Position = UDim2.fromScale(0, 0.5),
					Size = React.joinBindings({ Time, TotalTime }):map(function(Times: { number })
						return UDim2.fromScale(math.clamp(Times[1] / Times[2], 0, 1), 1)
					end),
				},
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.4, 0),
				}),
			}),
			TimeLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.8),
					Text = Time:map(function(TimeLeft: number)
						return string.format("Time Left: %u", math.floor(TimeLeft))
					end),
					ZIndex = 3,
				},
			}),
		}),
		CloseButton = e(CloseButton, {
			Size = UDim2.fromScale(0.14, 0.2),
			Position = UDim2.fromScale(1, 0),
			OnClick = CancelCallback,
		}),
		DifficultyFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.65, 0.7),
				Size = UDim2.fromScale(0.3, 0.18),
				ZIndex = 3,
			},
		}, {
			UIListLayout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			Normal = e(Main.Animateables.ImageButton, {
				native = {
					Size = UDim2.fromScale(1, 1),
					Image = "rbxassetid://107455378505876",
					ImageColor3 = if Difficulty == "Normal" then HoveredColor else DefaultColor,
					LayoutOrder = DifficultyLayoutOrder(),
					[React.Event.MouseButton1Click] = function()
						SetDifficulty("Normal")
					end,
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
				TextLabel = e(Main.TextLabel, {
					native = {
						Text = "Normal",
						TextColor3 = Color3.fromRGB(88, 226, 65),
						Position = UDim2.fromScale(0.5, 0.75),
						Size = UDim2.fromScale(0.7, 0.3),
					},
				}),
			}),
			Hard = e(Main.Animateables.ImageButton, {
				native = {
					Size = UDim2.fromScale(1, 1),
					Image = "rbxassetid://107455378505876",
					ImageColor3 = if Difficulty == "Hard" then HoveredColor else DefaultColor,
					LayoutOrder = DifficultyLayoutOrder(),
					[React.Event.MouseButton1Click] = function()
						SetDifficulty("Hard")
					end,
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
				TextLabel = e(Main.TextLabel, {
					native = {
						Text = "Hard",
						TextColor3 = Color3.fromRGB(224, 47, 57),
						Position = UDim2.fromScale(0.5, 0.75),
						Size = UDim2.fromScale(0.7, 0.3),
					},
				}),
			}),
			Insane = e(Main.Animateables.ImageButton, {
				native = {
					Size = UDim2.fromScale(1, 1),
					Image = "rbxassetid://107455378505876",
					ImageColor3 = if Difficulty == "Insane" then HoveredColor else DefaultColor,
					LayoutOrder = DifficultyLayoutOrder(),
					[React.Event.MouseButton1Click] = function()
						SetDifficulty("Insane")
					end,
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
				TextLabel = e(Main.TextLabel, {
					native = {
						Text = "Insane",
						TextColor3 = Color3.fromRGB(187, 85, 211),
						Position = UDim2.fromScale(0.5, 0.75),
						Size = UDim2.fromScale(0.7, 0.3),
					},
				}),
			}),
		}),
		LevelFrame = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(1, 1, 1),
				Position = UDim2.fromScale(0.89, 0.525),
				Size = UDim2.fromScale(0.12, 0.85),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
			}),
			UIGradient = e("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.new(0.254902, 0.0745098, 0.368627)),
					ColorSequenceKeypoint.new(1, Color3.new(0.25098, 0.14902, 0.3647067)),
				}),
			}),
			MainFrame = e(Main.ScrollingFrame, {
				BarSize = 0.05,
				native = {
					Size = UDim2.fromScale(1, 0.95),
					Position = UDim2.fromScale(0.5, 0.505),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
				},
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
			}, StageData),
		}),
		ResourcesFrame = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(65, 19, 94),
				Position = UDim2.fromScale(0.275, 0.675),
				Size = UDim2.fromScale(0.35, 0.25),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),
			ResourcesTitle = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.2),
					Size = UDim2.fromScale(0.6, 0.25),
					Text = "Resources",
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
			}, ResourceFrames),
		}),
		StatsFrame = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(65, 19, 94),
				Position = UDim2.fromScale(0.275, 0.375),
				Size = UDim2.fromScale(0.35, 0.25),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),
			StatOne = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.35, 0.5),
					Size = UDim2.fromScale(0.6, 0.2),
					Text = "Total Cleared",
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}),
			OneValue = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.75, 0.5),
					Size = UDim2.fromScale(0.3, 0.2),
					Text = FirstValue,
					TextXAlignment = Enum.TextXAlignment.Right,
				},
			}),
			StatsTwo = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.35, 0.8),
					Size = UDim2.fromScale(0.6, 0.2),
					Text = "Best Time",
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}),
			TwoValue = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.75, 0.8),
					Size = UDim2.fromScale(0.3, 0.2),
					Text = SecondValue,
					TextXAlignment = Enum.TextXAlignment.Right,
				},
			}),
			StatsLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.2),
					Size = UDim2.fromScale(0.5, 0.25),
					Text = "Stats",
				},
			}),
		}),
		CancelButton = e(Main.Animateables.ImageButton, {
			native = {
				Image = "rbxassetid://120986367718593",
				Size = UDim2.fromScale(0.175, 0.175),
				Position = UDim2.fromScale(0.6, 0.89),
				[React.Event.MouseButton1Click] = CancelCallback,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 3.16,
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.7),
					Text = "Cancel",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
				}),
			}),
		}),
		ConfirmButton = e(Main.Animateables.ImageButton, {
			native = {
				Image = "rbxassetid://76295055563521",
				Size = UDim2.fromScale(0.175, 0.175),
				Position = UDim2.fromScale(0.35, 0.89),
				[React.Event.MouseButton1Click] = ConfirmCallback,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 3.16,
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.7),
					Text = "Confirm",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
				}),
			}),
		}),
		MapImage = e(Main.ImageLabel, {
			native = {
				Position = UDim2.fromScale(0.65, 0.525),
				Size = UDim2.fromScale(0.6, 0.55),
				Image = MapImage,
				ScaleType = Enum.ScaleType.Crop,
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		StageFrame = e(Main.ImageLabel, {
			native = {
				Image = "rbxassetid://94302946042531",
				Position = UDim2.fromScale(1.2, 0.525),
				Size = UDim2.fromScale(0.4, 0.95),
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 0.6,
			}),
			MainStageFrame = e(Main.ScrollingFrame, {
				BarSize = 0.002,
				native = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
				},
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 0),
				}),
			}, MapData),
		}),
		Title = e(Title, {
			Title = "STORY",
			Position = UDim2.fromScale(0.25, -0.04),
			Size = UDim2.fromScale(0.7, 0.3),
		}),
	}, Properties.children)
end

return CreateMainStory
