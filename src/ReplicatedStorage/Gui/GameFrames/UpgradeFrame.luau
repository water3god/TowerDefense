--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactSpring = require(Packages.ReactSpring)
local Promise = require(Packages.Promise)
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
local UnitView = require(CoreGame.UnitView)
local BaseFrame = require(CoreGame.BaseFrame)

local GameFrames = Gui.GameFrames
local UpgradeContext = require(GameFrames.UpgradeContext)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)
local Constants = require(Shared.Constants)
local Stats = UnitInfo.Stats

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)

export type Properties = {
	IsVisible: boolean,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type PropertyProperties = {
	PropertyName: UnitInfo.StatProperty & string,
	Inital: number,
	Final: number,
	Other: string,
	Maxxed: boolean,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type AbilityProps = {
	UniqueId: string,
	Index: number,
	Name: string,
	Icon: string,
	BackgroundColor: ColorSequence,
	LastUsed: number,
	Length: number,
	Cooldown: number,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreatePropertyFrame(Props: PropertyProperties)
	local Color = Stats.Colors[Props.PropertyName]
	local Order = Hooks.LayoutOrder()

	local IsSpecial = Props.PropertyName == "Specials"

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(1, 0.25),
		}, Props.native),
	}, {
		UIFlex = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		Icon = e(Main.ImageLabel, {
			native = {
				Size = UDim2.fromScale(0.2, 1),
				Image = Stats.Icons[Props.PropertyName],
				LayoutOrder = Order(),
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		BeforeLabel = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.2, 1),
				Text = if IsSpecial then Props.Other else HelperFunctions.NumberScaler.ShortenNumber(Props.Inital),
				AutoLocalize = false,
				TextColor3 = Color,
				LayoutOrder = Order(),
			},
		}),
		ArrowImage = e(Main.ImageLabel, {
			native = {
				Size = UDim2.fromScale(0.2, 0.7),
				Image = "rbxassetid://90650317828395",
				LayoutOrder = Order(),
				ImageColor3 = Color,
				Visible = not (IsSpecial or Props.Maxxed),
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1.5,
			}),
		}),
		Frame = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.05, 1),
				LayoutOrder = Order(),
			},
		}),
		AfterLabel = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.3, 1),
				Text = HelperFunctions.NumberScaler.ShortenNumber(Props.Final),
				AutoLocalize = false,
				TextColor3 = Color,
				LayoutOrder = Order(),
				Visible = not (IsSpecial or Props.Maxxed),
				TextXAlignment = Enum.TextXAlignment.Left,
			},
		}),
	}, Props.children)
end

local function CreateAbilityFrame(props: AbilityProps)
	local Time, TotalTime, SetTime = Hooks.UseTime()

	local InAbility = React.joinBindings({ Time, TotalTime }):map(function(Times: { number })
		return props.Length >= Times[2] - Times[1]
	end)

	React.useEffect(function()
		SetTime(props.LastUsed + props.Cooldown, props.LastUsed)
	end, { props.LastUsed, props.Cooldown })

	local Click = React.useCallback(function()
		local Unit = UnitClient.GetUnit(props.UniqueId)

		if Unit then
			Unit:UseAbility(props.Index)
		end
	end, { props.UniqueId, props.Index :: any })

	return e(BaseFrame, {
		LeftText = "",
		Name = props.Name,
		RightText = React.joinBindings({ Time, TotalTime, InAbility }):map(function(Times: any)
			if Times[3] then
				return tostring(math.floor(math.clamp(Times[1] - Times[2] + props.Length, 0, props.Length)))
			else
				if Times[1] == 0 then
					return ""
				else
					return tostring(math.floor(math.clamp(Times[1] - Times[2] + props.Cooldown, 0, props.Cooldown)))
				end
			end
		end),
		BackgroundColor = props.BackgroundColor,
		Hovered = true,
		Icon = props.Icon,
		OnClick = Click,
		native = Join({}, props.native),
	}, {
		BgFrame = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0.8,
				BackgroundColor3 = Color3.new(),
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.fromScale(0.5, 1),
				ZIndex = 5,
				Size = React.joinBindings({ Time, TotalTime, InAbility }):map(function(Times: any)
					if Times[3] then
						return UDim2.fromScale(0, 0)
					else
						return UDim2.fromScale(1, math.clamp(Times[1] / Times[2], 0, 1))
					end
				end),
			},
		}),
	}, props.children)
end

local function CreateUpgradeFrame(Properties: Properties)
	local UpgradeData = React.useContext(UpgradeContext.Context)

	local Styles, API = ReactSpring.useSpring(function()
		return {
			Scale = 0.9,
			config = { mass = 1, tension = 400, friction = 36, clamp = true },
		}
	end)

	local Visible, SetVisible = React.useState(UpgradeData.Enabled)

	React.useEffect(function()
		SetVisible(UpgradeData.Enabled)
	end, { UpgradeData.Enabled })

	React.useEffect(function()
		if UpgradeData.Enabled then
			SetVisible(Properties.IsVisible)
		end
	end, { Properties.IsVisible })

	local TrueVisible, SetTrueVisible = React.useState(false)

	React.useEffect(function()
		if Visible then
			SetTrueVisible(true)

			API.start({
				Scale = 1,
			})
		else
			API.start({
				Scale = 0.9,
				config = { precision = 1 },
			})
			SetTrueVisible(false)
		end
	end, { Visible })

	local InSell, SetSell = React.useState(false)

	React.useEffect(function()
		if InSell then
			local SellPromise = Promise.delay(3):andThen(function()
				SetSell(false)
			end)

			return function()
				SellPromise:cancel()
			end
		end

		return function() end
	end, { InSell })

	React.useEffect(function()
		SetSell(false)
	end, { UpgradeData })

	local UpgradeFrames = React.useMemo(function()
		local LevelData = UpgradeData.UpgradeData[UpgradeData.Level]
		local AboveData = UpgradeData.UpgradeData[UpgradeData.Level + 1]

		local Frames: { [string]: React.Node } = {}

		if AboveData then
			for Property, Data in pairs(LevelData) do
				if table.find(Stats.StatProperties, Property) then
					local function GetValue(PropData: number & { number }, PropertyInput: string): number
						if PropertyInput == "Damage" then
							return (PropData :: any)[1] :: number
						else
							return PropData :: number
						end
					end

					if GetValue(Data, Property) == 0 then
						continue
					end

					Frames[Property] = CreatePropertyFrame({
						PropertyName = Property :: any,
						Inital = GetValue(Data, Property) :: any,
						Final = GetValue(AboveData[Property], Property) :: any,
						Other = tostring(Data),
						Maxxed = false,
						native = {
							LayoutOrder = Stats.Layout[Property :: any],
						},
					})
				end
			end
		else
			for Property, Data in pairs(LevelData) do
				if table.find(Stats.StatProperties, Property) then
					local function GetValue(DataInput: number & { number }, PropertyInput: string): number
						if PropertyInput == "Damage" then
							return (DataInput :: any)[1] :: number
						else
							return DataInput :: number
						end
					end

					if GetValue(Data, Property) == 0 then
						continue
					end

					Frames[Property] = CreatePropertyFrame({
						PropertyName = Property :: any,
						Inital = GetValue(Data, Property) :: any,
						Final = 1,
						Other = tostring(Data),
						Maxxed = true,
						native = {
							LayoutOrder = Stats.Layout[Property :: any],
						},
					})
				end
			end
		end

		return Frames
	end, { UpgradeData.UpgradeData :: any, UpgradeData.Level :: any })

	local AbilityFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for Index, AbilityData in ipairs(UpgradeData.Abilities) do
			Frames["Ability" .. Index] = e(CreateAbilityFrame, {
				UniqueId = UpgradeData.UniqueId,
				Index = Index,
				BackgroundColor = AbilityData.BackgroundColor,
				Name = AbilityData.Name,
				Icon = AbilityData.Icon,
				LastUsed = AbilityData.LastUsed,
				Length = AbilityData.Length,
				Cooldown = AbilityData.Cooldown,
			})
		end

		return Frames
	end, { UpgradeData })

	local PriorityClick = React.useCallback(function()
		local Unit = UnitClient.GetUnit(UpgradeData.UniqueId)

		if Unit then
			Unit:ChangePriority()
		end
	end, { UpgradeData.Priority, UpgradeData.UniqueId })

	local SellClick = React.useCallback(function()
		if InSell then
			local Unit = UnitClient.GetUnit(UpgradeData.UniqueId)

			if Unit then
				Unit:Sell()
			end
		else
			SetSell(true)
		end
	end, { UpgradeData.UniqueId :: any, InSell :: any })

	local UpgradeClick = React.useCallback(function()
		local Unit = UnitClient.GetUnit(UpgradeData.UniqueId)

		if Unit then
			Unit:LevelUp()
		end
	end, { UpgradeData.UniqueId })

	local CloseClick = React.useCallback(function()
		SetVisible(false)
		local CurrentUnit = UnitClient.GetUnit(UpgradeData.UniqueId)
		if CurrentUnit then
			CurrentUnit:ClickCharacter(false)
		end
	end, { Visible })

	local SellText = React.useMemo(function()
		if InSell then
			return "CONFIRM"
		else
			return string.format("Sell: %u", math.floor(UpgradeData.TotalCost / Constants.CostDivider))
		end
	end, { UpgradeData.TotalCost, InSell :: any })

	local HasNextLevel = React.useMemo(function()
		if UpgradeData.UpgradeData[UpgradeData.Level + 1] then
			return true
		else
			return false
		end
	end, { UpgradeData.Level })

	local RarityData: RarityInfo.RarityInfo = React.useMemo(function()
		local Rarity = UnitInfo.UnitInfo[UpgradeData.UnitName].Rarity
		return RarityInfo[Rarity :: any]
	end, { UpgradeData.UniqueId })

	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.8, 0.8),
			Image = "rbxassetid://127454767718648",
			Visible = TrueVisible,
		}, Properties.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.5,
		}),
		UIStroke = e(UIStroke.UIStrokeBasic, {
			Stroke = 0.001,
			Color = Color3.new(1, 1, 1),
			native = {
				LineJoinMode = Enum.LineJoinMode.Round,
			},
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
		}),
		UIGradient = e("UIGradient", {
			Color = RarityData.BackgroundColor,
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.2, 0.25),
			OnClick = CloseClick,
		}),
		UnitName = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.16),
				Size = UDim2.fromScale(0.8, 0.1),
				Text = UpgradeData.UnitName,
			},
		}, {
			UIGradient = e("UIGradient", {
				Color = RarityData.Color,
			}),
			UIStroke = e(UIStroke.UIStrokeGradient, {
				Stroke = 0.01,
				GradColor = RarityData.StrokeColor,
				native = {
					LineJoinMode = Enum.LineJoinMode.Miter,
				},
			}),
		}),
		UnitFrame = e(UnitView, {
			UnitName = UpgradeData.UnitName,
			native = {
				Size = UDim2.fromScale(0.5, 0.525),
				Position = UDim2.fromScale(0.25, 0.525),
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
			UIStroke = e(UIStroke.UIStrokeGradient, {
				Stroke = 0.005,
				GradColor = RarityData.BackgroundColor,
				native = {
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),
		}),
		SellButton = e(Main.Animateables.TextButton, {
			native = {
				BackgroundColor3 = Color3.new(0.874510, 0.000000, 0.000000),
				BackgroundTransparency = 0,
				Position = UDim2.fromScale(0.375, 0.875),
				Size = UDim2.fromScale(0.2, 0.1),
				Text = "",
				[React.Event.MouseButton1Click] = SellClick,
			},
		}, {
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.7),
					Text = SellText,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.04,
					Color = Color3.new(0, 0, 0),
					native = {
						LineJoinMode = Enum.LineJoinMode.Round,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
					},
				}),
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.3, 0),
			}),
		}),
		AttackPriorityButton = e(Main.Animateables.TextButton, {
			native = {
				BackgroundColor3 = Color3.new(0.443137, 0.443137, 0.443137),
				BackgroundTransparency = 0,
				Position = UDim2.fromScale(0.15, 0.875),
				Size = UDim2.fromScale(0.2, 0.1),
				Text = "",
				[React.Event.MouseButton1Click] = PriorityClick,
			},
		}, {
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.7),
					Text = UpgradeData.Priority,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.04,
					Color = Color3.new(0, 0, 0),
					native = {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
					},
				}),
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.3, 0),
			}),
		}),
		UpgradeButton = e(Main.Animateables.TextButton, {
			native = {
				BackgroundColor3 = Color3.new(0.078431, 1.000000, 0.231373),
				BackgroundTransparency = 0,
				Position = UDim2.fromScale(0.7, 0.875),
				Size = UDim2.fromScale(0.25, 0.1),
				Text = "",
				[React.Event.MouseButton1Click] = UpgradeClick,
			},
		}, {
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.7),
					Text = "Upgrade",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.04,
					Color = Color3.new(0, 0, 0),
					native = {
						LineJoinMode = Enum.LineJoinMode.Bevel,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
					},
				}),
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.3, 0),
			}),
		}),
		CurrentData = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.207843, 0.031373, 0.274510),
				Position = UDim2.fromScale(0.7, 0.525),
				Size = UDim2.fromScale(0.45, 0.53),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),
			LevelFrame = e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(0.5, 0.125),
					Size = UDim2.fromScale(0.8, 0.15),
				},
			}, {
				Arrow = e(Main.ImageLabel, {
					native = {
						Size = UDim2.fromScale(1, 0.8),
						Image = "rbxassetid://90650317828395",
						Visible = HasNextLevel,
					},
				}, {
					UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
						AspectRatio = 1.5,
					}),
				}),
				FirstLevel = e(Main.TextLabel, {
					native = {
						Position = UDim2.fromScale(0.14, 0.5),
						Size = UDim2.fromScale(0.45, 0.9),
						Text = string.format("Level %u", UpgradeData.Level),
						TextXAlignment = Enum.TextXAlignment.Right,
						Visible = HasNextLevel,
					},
				}),
				NextLevel = e(Main.TextLabel, {
					native = {
						Position = UDim2.fromScale(0.86, 0.5),
						Size = UDim2.fromScale(0.45, 0.9),
						Text = string.format("Level %u", UpgradeData.Level + 1),
						TextXAlignment = Enum.TextXAlignment.Left,
						Visible = HasNextLevel,
					},
				}),
				MaxedLabel = e(Main.TextLabel, {
					native = {
						Size = UDim2.fromScale(0.8, 0.8),
						Text = string.format("%u - MAX", UpgradeData.Level),
						Visible = not HasNextLevel,
					},
				}),
			}),

			UnitInfo = e(Main.ScrollingFrame, {
				BarSize = 0.01,
				native = {
					AnchorPoint = Vector2.new(),
					Size = UDim2.fromScale(0.8, 0.75),
					Position = UDim2.fromScale(0.1, 0.25),
				},
			}, {
				UIListLayout = e("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 0),
				}),
			}, UpgradeFrames),
		}),
		AbilityFrames = e(Main.ScrollingFrame, {
			BarSize = 0.01,
			native = {
				Size = UDim2.fromScale(0.2, 0.9),
				Position = UDim2.fromScale(1.15, 0.5),
			},
		}, {
			UIListLayout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0),
			}),
		}, AbilityFrames),
		UIScale = e("UIScale", {
			Scale = Styles.Scale,
		}),
	}, Properties.children)
end

return CreateUpgradeFrame
