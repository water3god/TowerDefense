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

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local CloseButton = require(CoreGame.CloseButton)
local Title = require(CoreGame.Title)
local UIStroke = require(CoreGame.UIStroke)
local UnitView = require(CoreGame.UnitView)
local Hooks = require(CoreGame.Hooks)

local Inventory = Gui.Inventory
local InventoryContext = require(Inventory.InventoryContext)

local Roll = Gui.Roll
local RollContext = require(Roll.RollContext)

local Warning = Gui.Warning
local WarningContext = require(Warning.WarningContext)

local GameFrames = Gui.GameFrames
local CurrencyContext = require(GameFrames.Currency)

local Client = ReplicatedStorage.Client
local LobbyClient = Client.LobbyClient
local RollService = require(LobbyClient.RollService)

local SettingService = require(Client.GlobalClient.SettingsService)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)
local Constants = require(Shared.Constants)

export type Properties = {
	CloseClick: () -> (),
	SetVisible: () -> (),
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type ViewportProps = {
	UnitName: string?,
	Rotation: number,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local Multipliers = { 1, 3, 10 }
local Rotations = { 20, 0, -20 }

local function CreateUnitViewport(props: ViewportProps)
	local Data = React.useMemo(function()
		if props.UnitName then
			local UnitData = UnitInfo.UnitInfo[props.UnitName]
			local RarityData = RarityInfo[UnitData.Rarity]

			return {
				UnitName = props.UnitName,
				Rarity = UnitData.Rarity,
				RarityData = RarityData,
			}
		else
			return {} :: any
		end
	end, { props.UnitName })

	local RotationCFrame = React.useBinding(CFrame.Angles(math.rad(20), math.rad(props.Rotation), 0))

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(0.3, 0.6),
		}, props.native),
	}, {
		UnitView = e(UnitView, {
			UnitName = Data.UnitName,
			RotationCFrame = RotationCFrame,
			Offset = Vector3.new(0, -1, 0),
			Distance = 4,
			native = {
				Position = UDim2.fromScale(0.5, 0.6),
			},
		}),
		NameLabel = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.8, 0.15),
				Position = UDim2.fromScale(0.5, 0.75),
				Text = Data.UnitName or "",
				ZIndex = 2,
			},
		}, {
			UIStroke = e(UIStroke.UIStroke, {
				Stroke = 0.0015,
				GradColor = Data.RarityData and Data.RarityData.StrokeColor,
			}),
			UIGradient = e("UIGradient", {
				Color = Data.RarityData and Data.RarityData.Color,
			}),
		}),
		RarityLabel = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.8, 0.15),
				Position = UDim2.fromScale(0.5, 0.9),
				Text = Data.Rarity or "",
				ZIndex = 2,
			},
		}, {
			UIStroke = e(UIStroke.UIStroke, {
				Stroke = 0.0015,
				GradColor = Data.RarityData and Data.RarityData.StrokeColor,
			}),
			UIGradient = e("UIGradient", {
				Color = Data.RarityData and Data.RarityData.Color,
			}),
		}),
	}, props.children)
end

local function CreateRollMain(props: Properties)
	local RollData = React.useContext(RollContext.Context)
	local WarningData = React.useContext(WarningContext.Context)
	local CurrencyContext = React.useContext(CurrencyContext.Context)
	local InventoryContext = React.useContext(InventoryContext.Context)

	local RollMultiplier, SetRollMultiplier = React.useState(1)

	local UnitFrames: { [string]: any } = React.useMemo(function()
		local Frames = {}

		for i = 1, 3, 1 do
			local Id = RollData.Units[i]
			Frames["Unit" .. i] = e(CreateUnitViewport, {
				UnitName = Id,
				Rotation = Rotations[i],
				native = {
					Position = UDim2.fromScale(i * 0.25, 0.45),
				},
			})
		end

		return Frames
	end, { RollData.Units })

	Hooks.useEventConnection(RollService.Touched, function()
		props.SetVisible()
	end, { props.SetVisible })

	local Time, _, SetTime = Hooks.UseTime()

	React.useEffect(function()
		SetTime(RollData.TimeStart, RollData.TotalTime)
	end, { RollData.TimeStart, RollData.TotalTime })

	local OnMultiplierClick = React.useCallback(function()
		local Index = table.find(Multipliers, RollMultiplier) :: number
		local NewMultiplier = Multipliers[Index + 1] or Multipliers[1]
		SetRollMultiplier(NewMultiplier)
	end, { RollMultiplier })

	local InAutoSell, SetAutoSell = React.useState(false)

	React.useEffect(function()
		SetAutoSell(SettingService.GetSetting("AutoRoll"))
	end, {})

	Hooks.useEventConnection(SettingService.Synced, function()
		SetAutoSell(SettingService.GetSetting("AutoRoll"))
	end, {})

	Hooks.useEventConnection(SettingService.GetSettingChangedSignal("AutoRoll"), function(AutoRoll: boolean)
		if AutoRoll then
			SetAutoSell(AutoRoll)
		end
	end, {})

	local Cost = React.useMemo(function()
		return Constants.ROLLCOSTS.MAIN * RollMultiplier
	end, { RollMultiplier })

	local SummonClick = React.useCallback(function()
		local Cost = Constants.ROLLCOSTS.MAIN * RollMultiplier

		if CurrencyContext.Value < Cost then
			WarningData.Add(string.format("You are missing %u Gold!", Cost - CurrencyContext.Value))
			return
		end

		if HelperFunctions.Len(InventoryContext.Units) >= InventoryContext.MaxUnitCount then
			WarningData.Add("Your Inventory is Full!")
			return
		end

		RollService.Roll(RollMultiplier)
	end, { RollMultiplier, WarningData.Warnings :: any, CurrencyContext.Value, InventoryContext :: any })

	local OnAutoClick = React.useCallback(function()
		local Value = not InAutoSell
		SettingService.ChangeSetting("AutoRoll", Value)
		SetAutoSell(Value)
	end, { InAutoSell })

	local SummonText = React.useMemo(function()
		local CostString = HelperFunctions.NumberScaler.ShortenNumber(Cost)
		return string.format("Summon: %s Gold", CostString)
	end, { Cost })

	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.6, 0.5),
			Image = "rbxassetid://100546338175267",
		}, props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.7,
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.25, 0.2),
			OnClick = props.CloseClick,
		}),
		Title = e(Title, {
			Title = "SUMMON",
			Size = UDim2.fromScale(0.6, 0.4),
			Position = UDim2.fromScale(0.225, -0.02),
		}),
		UnitsButton = e(Main.Animateables.ImageButton, {
			native = {
				Image = "rbxassetid://80739823452825",
				Size = UDim2.fromScale(0.25, 0.15),
				Position = UDim2.fromScale(0.17, 0.88),
				ImageColor3 = Color3.fromRGB(135, 1, 203),
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 3.16,
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.6, 0.6),
					Text = "Units",
				},
				children = {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.002,
					}),
				},
			}),
		}),
		AutoCellButton = e(Main.Animateables.ImageButton, {
			native = {
				Image = "rbxassetid://80739823452825",
				Size = UDim2.fromScale(0.25, 0.15),
				Position = UDim2.fromScale(0.82, 0.88),
				ImageColor3 = Color3.fromRGB(135, 1, 203),
				[React.Event.MouseButton1Click] = OnAutoClick,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 3.16,
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.6),
					Text = string.format("Auto Roll: %s", if InAutoSell then "On" else "Off"),
				},
				children = {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.002,
					}),
				},
			}),
		}),
		SummonButton = e(Main.Animateables.ImageButton, {
			native = {
				Image = "rbxassetid://80739823452825",
				Size = UDim2.fromScale(0.45, 0.16),
				Position = UDim2.fromScale(0.5, 0.87),
				ImageColor3 = Color3.fromRGB(135, 1, 203),
				[React.Event.MouseButton1Click] = SummonClick,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 3.2,
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.4),
					Text = SummonText,
				},
				children = {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.002,
					}),
				},
			}),
		}),
		SummonCountButton = e(Main.Animateables.TextButton, {
			native = {
				Size = UDim2.fromScale(0.15, 0.125),
				Position = UDim2.fromScale(0.9, 0.7),
				BackgroundTransparency = 0,
				Text = "",
				AutoLocalize = false,
				BackgroundColor3 = Color3.new(0.376471, 0.066667, 0.564706),
				[React.Event.MouseButton1Click] = OnMultiplierClick,
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
			}),
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.7, 0.6),
					Text = string.format("x%u", RollMultiplier),
				},
				children = {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.002,
					}),
				},
			}),
		}),
		RightContainer = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.4, 0.8),
				Position = UDim2.fromScale(1.25, 0.5),
			},
		}),
		TimeLeft = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.5, 0.1),
				Position = UDim2.fromScale(0.5, 0.2),
				Text = Time:map(function(Time: number)
					return string.format("Next Banner: %s", HelperFunctions.FormatTime(Time))
				end),
				ZIndex = 2,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.02,
			}),
		}),
	}, UnitFrames, props.children)
end

return CreateRollMain
