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
local Hooks = require(CoreGame.Hooks)

local Story = Gui.Story
local BoothContext = require(Story.BoothContext)

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateBoothFrame(Props: Properties)
	local BoothData = React.useContext(BoothContext.Context)
	local GameData: { MapData: GameInfo.MapInfo, StageData: GameInfo.LevelInfo }?, SetGameData =
		React.useState(nil :: { MapData: GameInfo.MapInfo, StageData: GameInfo.LevelInfo }?)

	React.useEffect(function()
		local MapData, StageData = GameInfo.GetDataFromInfo(BoothData.MapId, BoothData.LevelId)
		SetGameData({
			MapData = MapData :: any,
			StageData = StageData :: any,
		})
	end, { BoothData })

	local Time, TotalTime, SetTime = Hooks.UseTime()

	React.useEffect(function()
		SetTime(BoothData.EndTime - BoothData.StartTime, BoothData.StartTime)
	end, { BoothData })

	return e(Main.ImageLabel, {
		native = Join({
			Position = UDim2.fromScale(0.5, 0.6),
			Size = UDim2.fromScale(0.35, 0.35),
			Image = "rbxassetid://128406610117555",
		}, Props.native),
		children = Join({
			Main = e(Main.Frame, {
				native = {
					Visible = BoothData.Status == "LoadingPlayers",
				},
				children = {
					MapImage = e(Main.ImageLabel, {
						native = {
							Size = UDim2.fromScale(0.8, 0.8),
							Image = GameData and GameData.MapData.Image or "",
						},
						children = {
							UIGradient = e("UIGradient", {
								Transparency = NumberSequence.new({
									NumberSequenceKeypoint.new(0, 1),
									NumberSequenceKeypoint.new(0.275, 0.25),
									NumberSequenceKeypoint.new(0.675, 0.25),
									NumberSequenceKeypoint.new(1, 1),
								}),
							}),
						},
					}),
					DifficultyLabel = e(Main.TextLabel, {
						native = {
							Position = UDim2.fromScale(0.5, 0.6),
							Size = UDim2.fromScale(0.8, 0.1),
							Text = GameInfo.GetDifficultyString(BoothData.Difficulty),
						},
						children = {
							UIStroke = e("UIStroke", {
								Thickness = 2,
							}),
						},
					}),
					TitleLabel = e(Main.TextLabel, {
						native = {
							Position = UDim2.fromScale(0.5, 0.2),
							Size = UDim2.fromScale(0.8, 0.12),
							Text = GameData and GameInfo.GetFullName(
								GameData.MapData.Name,
								GameData.StageData.Index,
								GameData.StageData.Name
							) or "",
						},
						children = {
							UIStroke = e("UIStroke", {
								Thickness = 2,
							}),
						},
					}),
					Group = e(Main.CanvasGroup, {
						native = {
							BackgroundTransparency = 0,
							BackgroundColor3 = Color3.fromRGB(93, 11, 141),
							Position = UDim2.fromScale(0.5, 0.8),
							Size = UDim2.fromScale(0.7, 0.15),
						},
						children = {
							UICorner = e("UICorner", {
								CornerRadius = UDim.new(0.3, 0),
							}),
							UIStroke = e("UIStroke", {
								Thickness = 3,
							}),
							Bar = e(Main.Frame, {
								native = {
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundTransparency = 0,
									BackgroundColor3 = Color3.fromRGB(127, 32, 165),
									Position = UDim2.fromScale(0, 0.5),
									Size = UDim2.fromScale(
										math.clamp(BoothData.PlayerCount / BoothData.MaxPlayerCount, 0, 1),
										1
									),
								},
							}),
							PlayersLabel = e(Main.TextLabel, {
								native = {
									Size = UDim2.fromScale(0.9, 0.6),
									Text = string.format(
										"Players: %u/%u",
										BoothData.PlayerCount,
										BoothData.MaxPlayerCount
									),
									ZIndex = 2,
								},
								children = {
									UIStroke = e("UIStroke", {
										Thickness = 2,
									}),
								},
							}),
						},
					}),
					TimeBar = e(Main.CanvasGroup, {
						native = {
							Position = UDim2.fromScale(0.5, 1.2),
							Size = UDim2.fromScale(0.8, 0.15),
						},
						children = {
							UICorner = e("UICorner", {
								CornerRadius = UDim.new(0.3, 0),
							}),
							UIStroke = e("UIStroke", {
								Thickness = 3,
								Color = Color3.new(1, 1, 1),
							}),
							Bar = e(Main.Frame, {
								native = {
									BackgroundTransparency = 0,
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundColor3 = Color3.fromRGB(109, 255, 56),
									Position = UDim2.fromScale(0, 0.5),
									Size = React.joinBindings({ Time, TotalTime }):map(function(Times)
										return UDim2.fromScale(math.clamp(math.floor(Times[1]) / Times[2], 0, 1), 1)
									end),
								},
							}),
							TimeLabel = e(Main.TextLabel, {
								native = {
									Size = UDim2.fromScale(1, 0.7),
									Text = Time:map(function(Time: number)
										return string.format("Time Left: %u", Time)
									end),
									ZIndex = 2,
								},
								children = {
									UIStroke = e("UIStroke", {
										Thickness = 2,
									}),
								},
							}),
						},
					}),
				},
			}),
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1.5,
			}),
			MiscLabel = e(Main.TextLabel, {
				native = {
					Visible = BoothData.Status == "ChoosingMap" or BoothData.Status == "Idle",
					Size = UDim2.fromScale(0.7, 0.3),
					Text = if BoothData.Status == "ChoosingMap" then "Choosing Map..." else "Empty",
				},
			}),
		}, Props.children),
	})
end

return CreateBoothFrame
