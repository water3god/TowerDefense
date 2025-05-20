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
local BaseFrame = require(Gui.CoreGame.BaseFrame)
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

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)

local StoryService = require(ReplicatedStorage.Client.LobbyClient.StoryService)

export type Properties = {
	Toggle: (Visible: boolean) -> ()?,
	IsVisible: boolean,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateStage(Props: { Hovered: boolean, Number: number, OnClick: () -> () })
	return e(Main.Animateables.TextButton, {
		native = {
			BackgroundTransparency = 0,
			BackgroundColor3 = if Props.Hovered then Color3.fromRGB(127, 32, 165) else Color3.fromRGB(93, 11, 141),
			Size = UDim2.fromScale(0.78, 0.78),
			LayoutOrder = Props.Number,
			Text = "",
			[React.Event.MouseButton1Click] = Props.OnClick,
		},
		children = {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.6, 0.6),
					Text = tostring(Props.Number),
				},
			}),
		},
	})
end

local HoveredColor = Color3.fromRGB(183, 42, 255)
local DefaultColor = Color3.new(0.227451, 0.082353, 0.290196)

local function CreateMainStory(Properties: Properties)
	local StoryData = React.useContext(StoryContext.Context)

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

		for Index, Reward in ipairs(Data.Resources) do
			local RewardData = GameInfo.RewardInfo[Reward.Resource]
			FrameTable["Reward" .. Reward.Resource] = e(ResourceFrame, {
				Name = Reward.Resource,
				Value = Reward.Count,
				native = {
					ZIndex = ResourceOrder(),
				},
			})
		end
		return FrameTable
	end, { Difficulty })

	local MapData = React.useMemo(function()
		local Data = {}
		for Index, MapData in ipairs(GameInfo.GameInfo) do
			Data[MapData.MapId] = e(Main.Animateables.TextButton, {
				native = {
					Text = "",
					Size = UDim2.fromScale(0.9, 0.25),
					ZIndex = Index,
					[React.Event.MouseButton1Click] = function()
						MapClicked(MapData.MapId)
					end,
				},
				children = {
					Main = e(Main.Frame, {
						native = {
							Size = UDim2.fromScale(1, 0.7),
						},
						children = {
							MapImage = e(Main.ImageLabel, {
								native = {
									Image = MapData.Image,
									ScaleType = Enum.ScaleType.Crop,
								},
								children = {
									UICorner = e("UICorner", {
										CornerRadius = UDim.new(0.2, 0),
									}),
									FrameGrad = e(Main.Frame, {
										native = {
											BackgroundTransparency = 0,
										},
										children = {
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
										},
									}),
								},
							}),
							MapName = e(Main.TextLabel, {
								native = {
									Position = UDim2.fromScale(0.5, 0),
									Size = UDim2.fromScale(0.9, 0.4),
									Text = MapData.Name,
								},
							}),
							MapsCleared = e(Main.TextLabel, {
								native = {
									Position = UDim2.fromScale(0.5, 1),
									Size = UDim2.fromScale(0.9, 0.4),
									Text = StoryData.CompletedMaps[MapData.MapId] and string.format(
										"%u/%u",
										Len(StoryData.CompletedMaps[MapData.MapId]),
										#MapData.LevelInfo
									) or string.format("0/%u", #MapData.LevelInfo),
								},
							}),
						},
					}),
				},
			})
		end
		return Data
	end, { StoryData })

	React.useEffect(function()
		SetStage(1)
	end, { CurrentMap })

	React.useEffect(function()
		SetDifficulty("Normal")
	end, { Stage })

	local DifficultyLayoutOrder = LayoutOrder()

	local CancelCallback = React.useCallback(function()
		StoryService.LeaveBooth()
	end, {})

	local ConfirmCallback = React.useCallback(function()
		StoryService.ChooseMap({
			MapId = CurrentMap,
			LevelId = (GameInfo.GetMapFromId(CurrentMap) :: GameInfo.MapInfo).LevelInfo[Stage].GameId,
			Difficulty = Difficulty,
		})
	end, { CurrentMap :: any, Stage :: any, Difficulty :: any })

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
	end, { CurrentMap :: any, Stage :: any })

	local LevelCount = React.useMemo(function()
		return #(GameInfo.GetMapFromId(CurrentMap) :: any).LevelInfo
	end, { CurrentMap :: any })

	local FirstValue = React.useMemo(function()
		local MapData = StoryData.CompletedMaps[CurrentMap]

		if MapData and MapData[Stage] and MapData[Stage][Difficulty] and MapData[Stage][Difficulty].FinishedCount then
			return tostring(MapData[Stage][Difficulty].FinishedCount)
		else
			return "N/A"
		end
	end, { CurrentMap :: any, Stage :: any, Difficulty :: any, StoryData :: any })

	local SecondValue = React.useMemo(function()
		local MapData = StoryData.CompletedMaps[CurrentMap]

		if MapData and MapData[Stage] and MapData[Stage][Difficulty] and MapData[Stage][Difficulty].FastestTime then
			return tostring(MapData[Stage][Difficulty].FastestTime)
		else
			return "N/A"
		end
	end, { CurrentMap :: any, Stage :: any, Difficulty :: any, StoryData :: any })

	local MapImage = React.useMemo(function()
		return (GameInfo.GetMapFromId(CurrentMap) :: any).Image :: string
	end, { CurrentMap :: any })

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
				children = {
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(0.4, 0),
					}),
				},
			}),
			TimeLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.8),
					Text = Time:map(function(Time: number)
						return string.format("Time Left: %u", math.floor(Time))
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
				children = {
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
				},
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
				children = {
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
				},
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
				children = {
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
				},
			}),
		}),
		LevelFrame = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(1, 1, 1),
				Position = UDim2.fromScale(0.9, 0.5),
				Size = UDim2.fromScale(0.1, 0.8),
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
				BarSize = 0.002,
				native = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
				},
				children = {
					UIListLayout = e("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0.02, 0),
					}),
					UIPadding = e("UIPadding", {
						PaddingTop = UDim.new(0.02, 0),
					}),
					Stage1 = e(CreateStage, {
						Number = 1,
						Hovered = Stage == 1,
						Visible = LevelCount >= 1,
						OnClick = function()
							SetStage(1)
						end,
					}),
					Stage2 = e(CreateStage, {
						Number = 2,
						Hovered = Stage == 2,
						Visible = LevelCount >= 2,
						OnClick = function()
							SetStage(2)
						end,
					}),
					Stage3 = e(CreateStage, {
						Number = 3,
						Hovered = Stage == 3,
						Visible = LevelCount >= 3,
						OnClick = function()
							SetStage(3)
						end,
					}),
					Stage4 = e(CreateStage, {
						Number = 4,
						Hovered = Stage == 4,
						Visible = LevelCount >= 4,
						OnClick = function()
							SetStage(4)
						end,
					}),
					Stage5 = e(CreateStage, {
						Number = 5,
						Hovered = Stage == 5,
						Visible = LevelCount >= 5,
						OnClick = function()
							SetStage(5)
						end,
					}),
				},
			}),
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
				children = Join({
					UIListLayout = e("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),
				}, ResourceFrames),
			}),
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
					Size = UDim2.fromScale(0.7, 0.7),
					Text = "Cancel",
				},
				children = {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.002,
					}),
				},
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
					Size = UDim2.fromScale(0.7, 0.7),
					Text = "Confirm",
				},
				children = {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.002,
					}),
				},
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
				children = Join({
					UIListLayout = e("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 0),
					}),
				}, MapData),
			}),
		}),
		Title = e(Title, {
			Title = "STORY",
			Position = UDim2.fromScale(0.25, -0.04),
			Size = UDim2.fromScale(0.7, 0.3),
		}),
	}, Properties.children)
end

return CreateMainStory
