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
local JoinDicts = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Title = require(CoreGame.Title)
local CloseButton = require(CoreGame.CloseButton)
local Hooks = require(CoreGame.Hooks)

local Inventory = Gui.Inventory
local ResourceFrame = require(Inventory.ResourceFrame)
local ProductFrame = require(Inventory.ProductFrame)
local UnitFrame = require(Inventory.UnitFrame)

local DailyFolder = Gui.Daily
local DailyContext = require(DailyFolder.DailyContext)

local Shared = ReplicatedStorage.Shared
local DailyRewards = require(Shared.DailyRewards)
local ProductInfo = require(Shared.ProductInfo)

export type Properties = {
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateDailyFrame(Properties: Properties)
	local DailyData = React.useContext(DailyContext.Context)
	local Time, _, SetTime = Hooks.UseTime()

	React.useEffect(function()
		SetTime(60 * 60 * 24, DailyData.LastRedeemed)
	end, { DailyData.LastRedeemed })

	local OnClick = React.useCallback(function(Day: number)
		if Day <= DailyData.Day then
			DailyData.Redeem()
		end
	end, { DailyData.Day, DailyData.Redeem } :: { unknown })

	local Dailys = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}
		local LayoutOrder = Hooks.LayoutOrder()

		local Check = e(Main.ImageLabel, {
			native = {
				Size = UDim2.fromScale(0.7, 0.7),
				ImageColor3 = Color3.new(0.066667, 1, 0.098039),
				Image = "rbxassetid://78742556758797",
				LayoutOrder = 10,
			},
		})

		for Day, RewardData in ipairs(DailyRewards.Rewards) do
			local DayName = string.format("Day%u", Day)
			if RewardData.Type == "Unit" then
				local Level = 1

				if RewardData.ExtraData and RewardData.ExtraData.Level then
					Level = RewardData.ExtraData.Level
				end

				Frames[DayName] = e(UnitFrame.CreateUnitFrame, {
					Level = Level,
					UnitName = RewardData.Name,
					OnClick = function()
						OnClick(Day)
					end,
					native = {
						LayoutOrder = LayoutOrder(),
					},
					containerChildren = {
						Check = Day < DailyData.Day and Check,
					},
				})
			elseif RewardData.Type == "Resource" then
				Frames[DayName] = e(ResourceFrame, {
					Name = RewardData.Name,
					Value = RewardData.Count,
					OnClick = function()
						OnClick(Day)
					end,
					native = {
						LayoutOrder = LayoutOrder(),
					},
					containerChildren = {
						Check = Day < DailyData.Day and Check,
					},
				})
			elseif RewardData.Type == "Product" then
				local _, ProductId, IsGamepass = ProductInfo.GetProductFromNameOnly(RewardData.Name)

				Frames[DayName] = e(ProductFrame, {
					Name = RewardData.Name,
					IsGamepass = IsGamepass :: any,
					ProductId = ProductId :: any,
					Count = RewardData.Count,
					OnClick = function()
						OnClick(Day)
					end,
					native = {
						LayoutOrder = LayoutOrder(),
					},
					containerChildren = {
						Check = Day < DailyData.Day and Check,
					},
				})
			end
		end

		return Frames
	end, { DailyData } :: { unknown })

	return e(Main.Frame, {
		native = JoinDicts({
			Size = UDim2.fromScale(0.5, 0.6),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
		}, Properties.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.5,
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
		}),
		Title = e(Title, {
			Position = UDim2.fromScale(0.2, 0),
			Size = UDim2.fromScale(1, 0.18),
			Title = "DAILY REWARDS",
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.1, 0.2),
			OnClick = Properties.CloseClick,
		}),
		InnerFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.52),
				Size = UDim2.fromScale(0.94, 0.87),
				ZIndex = 0,
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
		DayLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.4, 0.175),
				Size = UDim2.fromScale(0.4, 0.08),
				Text = string.format("Day: %u", DailyData.Day),
				TextXAlignment = Enum.TextXAlignment.Left,
			},
		}),
		Timer = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.6, 0.175),
				Size = UDim2.fromScale(0.4, 0.08),
				Text = Time:map(function(TimeValue: number)
					return string.format("Time Left: %s", HelperFunctions.FormatTime(TimeValue))
				end),
				TextXAlignment = Enum.TextXAlignment.Right,
			},
		}),
		List = e(Main.ScrollingFrame, {
			BarSize = 0.01,
			native = {
				Position = UDim2.fromScale(0.5, 0.575),
				Size = UDim2.fromScale(0.9, 0.65),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
			},
		}, {
			UIGridLayout = e("UIGridLayout", {
				CellPadding = UDim2.fromScale(0, 0),
				CellSize = UDim2.fromScale(0.2, 0.4),
				StartCorner = Enum.StartCorner.TopLeft,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		}, Dailys),
	})
end

return CreateDailyFrame
