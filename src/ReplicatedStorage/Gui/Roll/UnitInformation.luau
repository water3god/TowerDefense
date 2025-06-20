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

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Title = require(CoreGame.Title)
local CloseButton = require(CoreGame.CloseButton)
local NewGui = require(CoreGame.NewGui)
local Hooks = require(CoreGame.Hooks)

local Inventory = Gui.Inventory
local UnitFrame = require(Inventory.UnitFrame)
local StatsFrame = require(Inventory.StatsFrame)

export type Props = {
	Visible: boolean,
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local Data: {
	[string]: { Color: Color3, Index: number, Units: { string } },
} = {
	Egypt = {
		Color = Color3.new(0.827451, 0.862745, 0.141176),
		Index = 1,
		Units = {
			"Ptolemy",
			"Cleopatra",
			"Narmer",
			"Akhenaten",
			"Ramesses II",
			"Tutankhamun",
		},
	},
	Greece = {
		Color = Color3.new(0.12549, 0.721569, 0.854902),
		Index = 2,
		Units = {
			"Pyrrhus",
			"Pericles",
			"Socrates",
			"Themistocles",
			"Alexander The Great",
			"Leonidas",
		},
	},
	Rome = {
		Color = Color3.new(0.831373, 0.145098, 0.145098),
		Index = 3,
		Units = {
			"Pompey",
			"Spartacus",
			"Cicero",
			"Julius Caesar",
			"Augustus",
			"Trajan",
		},
	},
	China = {
		Color = Color3.new(0.572549, 0.109804, 0.109804),
		Index = 3,
		Units = {},
	},
	Medieval = {
		Color = Color3.new(0.160784, 0.141176, 0.305882),
		Index = 4,
		Units = {
			"Robert the Bruce",
			"Leif Erikson",
			"Charlemagne",
			"Joan of Arc",
			"William the Conqueror",
			"Richard the Lionheart",
		},
	},
}

local function CreateUnitInfo(Props: Props)
	local Styles, API = ReactSpring.useSpring(function()
		return {
			alpha = 1,
			config = { mass = 1, tension = 400, friction = 30, velocity = 0.02, precision = 0.01, clamp = true } :: any,
		}
	end)

	React.useEffect(function()
		API.start({
			alpha = if Props.Visible then 0 else 1,
		})
	end, { Props.Visible })

	local StatsVisible: boolean, SetStatsVisible = React.useState(false)
	local CurrentStats: string?, SetCurrentStats = React.useState(nil :: string?)

	local StatsCloseClick = React.useCallback(function()
		SetCurrentStats(nil)
		SetStatsVisible(false)
	end, {})

	local UnitFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for Name, GenreData in pairs(Data) do
			if #GenreData.Units ~= 0 then
				local GenreUnits: { [string]: React.Node } = {}

				for Index, Unit in ipairs(GenreData.Units) do
					GenreUnits[Unit] = e(UnitFrame.CreateUnitFrame, {
						UnitName = Unit,
						Level = 1,
						OnClick = function()
							SetCurrentStats(Unit)
							SetStatsVisible(true)
						end,
						native = {
							LayoutOrder = Index,
						},
					})
				end

				Frames[Name] = e(Main.Frame, {
					native = {
						Size = UDim2.fromScale(1, 0.3),
						LayoutOrder = GenreData.Index,
					},
				}, {
					Container = e(Main.Frame, {
						native = {
							BackgroundColor3 = GenreData.Color,
							BackgroundTransparency = 0,
							Size = UDim2.fromScale(0.9, 0.9),
						},
					}, {
						NameLabel = e(Main.TextLabel, {
							native = {
								Text = Name,
								Position = UDim2.fromScale(0.525, 0.175),
								Size = UDim2.fromScale(0.9, 0.2),
								TextXAlignment = Enum.TextXAlignment.Left,
							},
						}, {
							UIStroke = e(UIStroke.UIStrokeAdvanced, {
								Stroke = 0.01,
							}),
						}),
						UIStroke = e(UIStroke.UIStrokeAdvanced, {
							Stroke = 0.005,
							Color = Color3.new(1, 1, 1),
							native = {
								LineJoinMode = Enum.LineJoinMode.Round,
							},
						}),
						UICorner = e("UICorner", {
							CornerRadius = UDim.new(0.1, 0),
						}),
						UnitFrame = e(Main.ScrollingFrame, {
							BarSize = 0.02,
							native = {
								Size = UDim2.fromScale(0.9, 0.7),
								Position = UDim2.fromScale(0.5, 0.65),
								AutomaticCanvasSize = Enum.AutomaticSize.Y,
							},
						}, {
							UIGridLayout = e("UIGridLayout", {
								CellPadding = UDim2.fromScale(0, 0),
								CellSize = UDim2.fromScale(0.25, 0.85),
								SortOrder = Enum.SortOrder.LayoutOrder,
							}),
							Padding = e("UIPadding", {
								PaddingRight = UDim.new(0.02, 0),
							}),
						}, GenreUnits),
					}),
				})
			end
		end

		return Frames
	end, {})

	return e(NewGui, {
		DisplayOrder = 3,
	}, {
		UnitInformation = e(Main.Frame, {
			native = Join({
				Size = UDim2.fromScale(0.6, 0.8),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
				Visible = Styles.alpha:map(function(alphaInput: number)
					return alphaInput ~= 1
				end),
			}, Props.native),
		}, {
			UIScale = e("UIScale", {
				Scale = Styles.alpha:map(function(alphaInput: number)
					return 1 - alphaInput / 6
				end),
			}),
			StatsFrame = e(StatsFrame, {
				UnitName = CurrentStats,
				Visible = StatsVisible,
				CloseClick = StatsCloseClick,
			}),
			MainFrame = e(Main.ScrollingFrame, {
				BarSize = 0.01,
				native = {
					Position = UDim2.fromScale(0.5, 0.52),
					Size = UDim2.fromScale(0.9, 0.9),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ZIndex = 3,
				},
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Top,
				}),
			}, UnitFrames),
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 0.8,
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.02, 0),
			}),
			CloseButton = e(CloseButton, {
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromScale(0.2, 0.15),
				OnClick = Props.CloseClick,
			}),
			Title = e(Title, {
				Title = "UNIT INFORMATION",
				Position = UDim2.fromScale(0.3, 0),
				Size = UDim2.fromScale(0.9, 0.3),
			}),
			InnerFrame = e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
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
		}, Props.children),
	})
end

return CreateUnitInfo
