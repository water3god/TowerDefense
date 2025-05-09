--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

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
local CloseButton = require(CoreGame.CloseButton)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)

local Story = Gui.Story
local StoryContext = require(Story.StoryContext)

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)

local StoryService = require(ReplicatedStorage.Client.LobbyClient.StoryService)

local Player = Players.LocalPlayer

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateWaitingFrame(Props: Properties)
	local StoryData = React.useContext(StoryContext.Context)

	local Time, TotalTime, SetTimeData = Hooks.UseTime()
	local GameData, SetGameData = React.useState(nil :: { MapData: GameInfo.MapInfo, StageData: GameInfo.LevelInfo }?)

	React.useEffect(function()
		if StoryData.Data then
			SetTimeData(StoryData.Data.EndTime - StoryData.Data.StartTime, StoryData.Data.StartTime)
		end
	end, { StoryData })

	React.useEffect(function()
		if StoryData.Data then
			local Data = StoryData.Data
			local MapData, StageData = GameInfo.GetDataFromInfo(Data.MapId, Data.LevelId)
			if MapData and StageData then
				SetGameData({
					MapData = MapData,
					StageData = StageData,
				})
			end
		end
	end, { StoryData })

	local StartClick = React.useCallback(function()
		StoryService.OwnerStart()
	end, {})

	local OnLeave = React.useCallback(function()
		StoryService.LeaveBooth()
	end, {})

	return e(Main.ImageLabel, {
		native = Join({
			Position = UDim2.fromScale(0.5, 0.65),
			Size = UDim2.fromScale(0.4, 0.25),
			Image = "rbxassetid://100546338175267",
			Visible = if StoryData.Data and StoryData.Enabled then true else false,
		}, Props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 2,
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.3, 0.3),
			OnClick = OnLeave,
		}),
		StartButton = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.35, 0.8),
				Size = UDim2.fromScale(0.4, 0.2),
				Image = "rbxassetid://121336998793729",
				Visible = StoryData.Data and Player.UserId == StoryData.Data.OwnerId,
				[React.Event.MouseButton1Click] = StartClick,
			},
		}, {
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.7, 0.7),
					Text = "Start",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeBasic, {
					Stroke = 0.002,
				}),
			}),
		}),
		MapImage = e(Main.ImageLabel, {
			native = {
				Position = UDim2.fromScale(0.8, 0.6),
				Size = UDim2.fromScale(0.4, 0.55),
				Image = GameData and GameData.MapData.Image,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		DifficultyLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.35, 0.575),
				Size = UDim2.fromScale(0.5, 0.1),
				Text = StoryData.Data and GameInfo.GetDifficultyString(StoryData.Data.Difficulty) or "Difficulty: N/A",
			},
		}),
		PlayersLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.35, 0.4),
				Size = UDim2.fromScale(0.5, 0.1),
				Text = StoryData.Data and string.format("Players: %u/%u", #StoryData.Data.Players, 4) or "0/4",
			},
		}),
		TitleLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.2),
				Size = UDim2.fromScale(0.9, 0.2),
				Text = GameData and GameInfo.GetFullName(
					GameData.MapData.Name,
					GameData.StageData.Index,
					GameData.StageData.Name
				) or "N/A",
			},
		}),
		TimeBar = e(Main.CanvasGroup, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(),
				Position = UDim2.fromScale(0.5, 1.2),
				Size = UDim2.fromScale(0.8, 0.15),
			},
			children = {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.3, 0),
				}),
				UIStroke = e(UIStroke.UIStrokeBasic, {
					Stroke = 0.005,
					native = {
						LineJoinMode = Enum.LineJoinMode.Round,
					},
				}),
				Bar = e(Main.Frame, {
					native = {
						BackgroundTransparency = 0,
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Color3.fromRGB(109, 255, 56),
						Position = UDim2.fromScale(0, 0.5),
						Size = React.joinBindings({ Time, TotalTime }):map(function(Times: { number })
							return UDim2.fromScale(Times[1] / Times[2], 1)
						end),
					},
				}),
				TimeLabel = e(Main.TextLabel, {
					native = {
						Size = UDim2.fromScale(1, 0.7),
						Text = Time:map(function(Time: number)
							return string.format("Time Left: %u", math.floor(Time))
						end),
						ZIndex = 2,
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.003,
					}),
				}),
			},
		}),
	}, Props.children)
end

return CreateWaitingFrame
