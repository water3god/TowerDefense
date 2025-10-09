--!strict

-- By Wa1er_God --

local Banners = {
	Egypt = "rbxassetid://81730317336118",
	Rome = "rbxassetid://74963095419523",
	Greece = "rbxassetid://120734686321148",
	Medieval = "rbxassetid://80598570223220",
}

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

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
local AnimatedGradient = require(CoreGame.AnimatedGradient)

local Inventory = Gui.Inventory
local InventoryContext = require(Inventory.InventoryContext)
local ProductFrame = require(Inventory.ProductFrame)

local Roll = Gui.Roll
local RollContext = require(Roll.RollContext)
local UnitInformation = require(Roll.UnitInformation)

local Warning = Gui.Warning
local WarningContext = require(Warning.WarningContext)

local GameFrames = Gui.GameFrames
local CurrencyContext = require(GameFrames.Currency)

local Store = Gui.Store
local PurchaseContext = require(Store.PurchaseContext)

local Components = Gui.Components
local Button = require(Components.Button)

local Client = ReplicatedStorage.Client
local LobbyClient = Client.LobbyClient
local RollService = require(LobbyClient.RollService)

local SettingService = require(Client.GlobalClient.SettingsService)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)
local Constants = require(Shared.Constants)
local ProductInfo = require(Shared.ProductInfo)

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
			UIStroke = e(UIStroke.UIStrokeGradient, {
				Stroke = 0.02,
				GradColor = Data.RarityData and Data.RarityData.StrokeColor,
			}),
			UIGradient = e(AnimatedGradient, {
				GradColor = Data.RarityData and Data.RarityData.Color or ColorSequence.new(Color3.new(1, 1, 1)),
				Animate = true,
				Speed = 1,
			}),
		}),
		RarityLabel = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.75, 0.10),
				Position = UDim2.fromScale(0.5, 0.9),
				Text = Data.Rarity or "",
				ZIndex = 2,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeGradient, {
				Stroke = 0.02,
				GradColor = Data.RarityData and Data.RarityData.StrokeColor,
			}),
			UIGradient = e(AnimatedGradient, {
				GradColor = Data.RarityData and Data.RarityData.Color or ColorSequence.new(Color3.new(1, 1, 1)),
				Animate = true,
				Speed = 1,
			}),
		}),
	}, props.children)
end

local Products = {
	3348441372,
	3348441586,
	3348442115,
	3348442394,
	3348443298,
	3359651817,
	3359652520,
}

local function CreateRollMain(props: Properties)
	local RollData = React.useContext(RollContext.Context)
	local WarningData = React.useContext(WarningContext.Context)
	local CurrencyData = React.useContext(CurrencyContext.Context)
	local InventoryData = React.useContext(InventoryContext.Context)
	local PurchaseData = React.useContext(PurchaseContext.Context)

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
		local NewCost = Constants.ROLLCOSTS.MAIN * RollMultiplier

		if CurrencyData.Value < NewCost then
			WarningData.Add(string.format("You are missing %u Gold!", NewCost - CurrencyData.Value))
			MarketplaceService:PromptProductPurchase(LocalPlayer, 3348441372)
			return
		end

		if HelperFunctions.Len(InventoryData.Units) >= InventoryData.MaxUnitCount then
			local Gamepass50 = PurchaseData.GamepassData[1435928862].Owned
			local Gamepass100 = PurchaseData.GamepassData[1435582002].Owned

			if not Gamepass50 then
				MarketplaceService:PromptGamePassPurchase(LocalPlayer, 1435928862)
			elseif not Gamepass100 then
				MarketplaceService:PromptGamePassPurchase(LocalPlayer, 1435582002)
			end
			WarningData.Add("Your Inventory is Full!")
			return
		end

		RollService.Roll(RollMultiplier)
	end, { RollMultiplier, CurrencyData.Value, InventoryData } :: { unknown })

	local OnAutoClick = React.useCallback(function()
		local Value = not InAutoSell
		SettingService.ChangeSetting("AutoRoll", Value)
		SetAutoSell(Value)
	end, { InAutoSell })

	local SummonText = React.useMemo(function()
		local CostString = HelperFunctions.NumberScaler.ShortenNumber(Cost)
		return string.format("Summon: %s Gold", CostString)
	end, { Cost })

	local UnitInfoVis, SetUnitInfoVis = React.useState(false)

	local UnitVisCloseClick = React.useCallback(function()
		SetUnitInfoVis(false)
	end, {})

	local ProductFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		if not PurchaseData.Loaded then
			return Frames
		end

		for Index, ProductId in ipairs(Products) do
			local ProductData, IsGamepass = ProductInfo.GetProductFromIdOnly(ProductId)

			if ProductData and IsGamepass ~= nil then
				Frames["Product" .. ProductId] = e(ProductFrame, {
					ProductId = ProductId,
					Count = 0,
					IsGamepass = IsGamepass,
					Purchaseable = true,
					native = {
						LayoutOrder = Index,
					},
				})
			end
		end

		return Frames
	end, { PurchaseData.Loaded })

	local BannerImage = React.useMemo(function()
		return Banners[RollData.Banner]
	end, {})

	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.6, 0.5),
			Image = "rbxassetid://114227430892447",
		}, props.native),
	}, {
		UISizeConstraint = e("UISizeConstraint", {
			MinSize = Vector2.new(250, 150),
			MaxSize = Vector2.new(1000, 600),
		}),
		BackgroundImage = e(Main.ImageLabel, {
			native = {
				Size = UDim2.fromScale(0.9, 0.8),
				Image = BannerImage,
				Visible = BannerImage ~= nil,
				ZIndex = 0,
			},
		}, {
			UIGradient = e("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.3, 0.6),
					NumberSequenceKeypoint.new(0.5, 0.4),
					NumberSequenceKeypoint.new(0.7, 0.6),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
		}),
		UnitInformation = e(UnitInformation, {
			Visible = UnitInfoVis,
			CloseClick = UnitVisCloseClick,
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.77,
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.25, 0.2),
			OnClick = props.CloseClick,
		}),
		Title = e(Title, {
			Title = "SUMMON",
			Size = UDim2.fromScale(0.6, 0.275),
			Position = UDim2.fromScale(0.5, 0),
		}),
		UnitsButton = e(Button, {
			Size = UDim2.fromScale(0.3, 0.2),
			Position = UDim2.fromScale(0.17, 0.85),
			OnClick = function()
				SetUnitInfoVis(not UnitInfoVis)
			end,
			Text = "Units",
		}, {}),
		AutoRollButton = e(Button, {
			Size = UDim2.fromScale(0.3, 0.2),
			Position = UDim2.fromScale(0.82, 0.85),
			OnClick = OnAutoClick,
			Text = string.format("Auto Roll: %s", if InAutoSell then "On" else "Off"),
		}, {}),
		SummonButton = e(Button, {
			Size = UDim2.fromScale(0.5, 0.25),
			Position = UDim2.fromScale(0.5, 0.825),
			OnClick = SummonClick,
			Text = SummonText,
		}, {}),
		SummonCountButton = e(Main.Animateables.ImageButton, {
			native = {
				Size = UDim2.fromScale(0.15, 0.15),
				Position = UDim2.fromScale(0.89, 0.675),
				Image = "rbxassetid://77645625759735",
				AutoLocalize = false,
				[React.Event.MouseButton1Click] = OnMultiplierClick,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.7, 0.5),
					Text = string.format("x%u", RollMultiplier),
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
				}),
			}),
		}),
		RightContainer = e(Main.ImageLabel, {
			native = {
				Size = UDim2.fromScale(0.3, 0.8),
				Position = UDim2.fromScale(1.2, 0.5),
				Image = "rbxassetid://85053227818414",
			},
		}, {
			MainProductFrame = e(Main.ScrollingFrame, {
				BarSize = 0.01,
				native = {
					Position = UDim2.fromScale(0.5, 0.51),
					Size = UDim2.fromScale(0.95, 0.9),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
				},
			}, {
				UIGridLayout = e("UIGridLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					CellSize = UDim2.fromScale(0.5, 0.3),
					CellPadding = UDim2.fromScale(0, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top,
				}),
			}, ProductFrames),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.02, 0),
			}),
		}),
		TimeLeft = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.5, 0.1),
				Position = UDim2.fromScale(0.5, 0.175),
				Text = Time:map(function(TimeInput: number)
					return string.format("Next Banner: %s", HelperFunctions.FormatTime(TimeInput))
				end),
				ZIndex = 2,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.01,
			}),
		}),
	}, UnitFrames, props.children)
end

return CreateRollMain
