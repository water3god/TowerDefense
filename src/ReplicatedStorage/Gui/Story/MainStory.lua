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

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local BaseFrame = require(Gui.CoreGame.BaseFrame)
local Title = require(CoreGame.Title)
local CloseButton = require(CoreGame.CloseButton)
local UIStroke = require(CoreGame.UIStroke)

local Story = Gui.Story

local Shared = ReplicatedStorage.Shared
local LevelRequirements = require(Shared.LevelRequirements)

export type Properties = {
	CloseClick: () -> ()?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function LayoutOrder(): () -> number
	local layoutOrder = 0

	return function()
		layoutOrder += 1
		return layoutOrder
	end
end

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
	local DifficultyLayoutOrder = LayoutOrder()

	local Difficulty, SetDifficulty = React.useState("Normal")
	local Stage, SetStage = React.useState(1)

	return e(Main.ImageLabel, {
		native = Join({
			Position = UDim2.fromScale(0.4, 0.45),
			Size = UDim2.fromScale(0.5, 0.6),
			Image = "rbxassetid://100546338175267",
		}, Properties.native),
		children = Join({
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1.787,
			}),
			MapName = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.17),
					Size = UDim2.fromScale(0.7, 0.1),
					Text = "Colussem: 1 - Survival",
				},
			}),
			Bar = e(Main.CanvasGroup, {
				native = {
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(93, 11, 141),
					Position = UDim2.fromScale(0.7, 1.07),
					Size = UDim2.fromScale(0.9, 0.08),
				},
				children = {
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(0.4, 0),
					}),
					InnerBar = e(Main.Frame, {
						native = {
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 0,
							BackgroundColor3 = Color3.fromRGB(127, 32, 165),
							Position = UDim2.fromScale(0, 0.5),
							Size = UDim2.fromScale(0.8, 1),
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
							Text = "Time Left:",
							ZIndex = 3,
						},
					}),
				},
			}),
			CloseButton = e(CloseButton, {
				Size = UDim2.fromScale(0.14, 0.2),
				Position = UDim2.fromScale(1, 0),
				OnClick = Properties.CloseClick,
			}),
			DifficultyFrame = e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(0.65, 0.7),
					Size = UDim2.fromScale(0.3, 0.18),
					ZIndex = 3,
				},
				children = {
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
				},
			}),
			LevelFrame = e(Main.Frame, {
				native = {
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.new(1, 1, 1),
					Position = UDim2.fromScale(0.9, 0.5),
					Size = UDim2.fromScale(0.1, 0.8),
				},
				children = {
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
								OnClick = function()
									SetStage(1)
								end,
							}),
							Stage2 = e(CreateStage, {
								Number = 2,
								Hovered = Stage == 2,
								OnClick = function()
									SetStage(2)
								end,
							}),
							Stage3 = e(CreateStage, {
								Number = 3,
								Hovered = Stage == 3,
								OnClick = function()
									SetStage(3)
								end,
							}),
							Stage4 = e(CreateStage, {
								Number = 4,
								Hovered = Stage == 4,
								OnClick = function()
									SetStage(4)
								end,
							}),
							Stage5 = e(CreateStage, {
								Number = 5,
								Hovered = Stage == 5,
								OnClick = function()
									SetStage(5)
								end,
							}),
						},
					}),
				},
			}),
			ResourcesFrame = e(Main.Frame, {
				native = {
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(65, 19, 94),
					Position = UDim2.fromScale(0.275, 0.675),
					Size = UDim2.fromScale(0.35, 0.25),
				},
				children = {
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
							Position = UDim2.fromScale(0.5, 0.6),
							Size = UDim2.fromScale(0.95, 0.7),
						},
						children = {
							UIListLayout = e("UIListLayout", {
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								FillDirection = Enum.FillDirection.Horizontal,
								SortOrder = Enum.SortOrder.LayoutOrder,
							}),
						},
					}),
				},
			}),
			StatsFrame = e(Main.Frame, {
				native = {
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(65, 19, 94),
					Position = UDim2.fromScale(0.275, 0.375),
					Size = UDim2.fromScale(0.35, 0.25),
				},
				children = {
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
							Text = "N/A",
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
							Text = "N/A",
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
				},
			}),
			CancelButton = e(Main.Animateables.ImageButton, {
				native = {
					Image = "rbxassetid://120986367718593",
					Size = UDim2.fromScale(0.175, 0.175),
					Position = UDim2.fromScale(0.6, 0.89),
				},
				children = {
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
								Stroke = 0.004,
							}),
						},
					}),
				},
			}),
			ConfirmButton = e(Main.Animateables.ImageButton, {
				native = {
					Image = "rbxassetid://76295055563521",
					Size = UDim2.fromScale(0.175, 0.175),
					Position = UDim2.fromScale(0.35, 0.89),
				},
				children = {
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
								Stroke = 0.004,
							}),
						},
					}),
				},
			}),
			MapImage = e(Main.ImageLabel, {
				native = {
					Position = UDim2.fromScale(0.65, 0.525),
					Size = UDim2.fromScale(0.6, 0.55),
				},
				children = {
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(0.05, 0),
					}),
					UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
						AspectRatio = 1,
					}),
				},
			}),
			StageFrame = e(Main.ImageLabel, {
				native = {
					Image = "rbxassetid://94302946042531",
					Position = UDim2.fromScale(1.2, 0.525),
					Size = UDim2.fromScale(0.4, 0.95),
				},
				children = {
					UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
						AspectRatio = 0.6,
					}),
					MainStageFrame = e(Main.ScrollingFrame, {
						BarSize = 0.002,
						native = {
							AutomaticCanvasSize = Enum.AutomaticSize.Y,
						},
						children = {
							UIListLayout = e("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 0),
							}),
						},
					}),
				},
			}),
			Title = e(Title, {
				Title = "STORY",
				Position = UDim2.fromScale(0.25, -0.04),
				Size = UDim2.fromScale(0.7, 0.3),
			}),
		}, Properties.children),
	})
end

return CreateMainStory
