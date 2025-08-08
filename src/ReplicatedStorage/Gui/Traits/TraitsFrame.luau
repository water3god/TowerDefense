--!strict

-- By Wa1er_God --

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local Player = Players.LocalPlayer

-- Libraries --
local Packages = ReplicatedStorage.Packages
local ReactSpring = require(Packages.ReactSpring)
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Network = require(ReplicatedStorage.Network.Client)
local RollTrait = Network.RollTrait
local TraitRolled = Network.TraitRolled

local Touched = require(ReplicatedStorage.Network.ClientOnly).TraitsTouched

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Title = require(CoreGame.Title)
local CloseButton = require(CoreGame.CloseButton)
local AnimatedGradient = require(CoreGame.AnimatedGradient)
local Hooks = require(CoreGame.Hooks)

local InventoryFolder = Gui.Inventory
local InventoryContext = require(InventoryFolder.InventoryContext)
local PromptContext = require(InventoryFolder.PromptContext)
local ProductFrame = require(InventoryFolder.ProductFrame)

local UnitFrame = require(InventoryFolder.UnitFrame)
local ResourceFrame = require(InventoryFolder.ResourceFrame)

local Components = Gui.Components
local Plus = require(Components.Plus)

local TraitsFolder = Gui.Traits
local TraitsInfo = require(TraitsFolder.TraitsInfo)

local WarningFolder = Gui.Warning
local WarningContext = require(WarningFolder.WarningContext)

local Store = Gui.Store
local PurchaseContext = require(Store.PurchaseContext)

local Shared = ReplicatedStorage.Shared
local Traits = require(Shared.Traits)
local RarityInfo = require(Shared.RarityInfo)
local Types = require(Shared.Types)
local ProductInfo = require(Shared.ProductInfo)

export type Properties = {
	SetVisible: (() -> ())?,
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local Products = { 3359654911, 3359655092, 3359656288, 3359656647 }

local function CreateTraitsFrame(props: Properties)
	local InventoryData = React.useContext(InventoryContext.Context)
	local PromptData = React.useContext(PromptContext.Context)
	local WarningData = React.useContext(WarningContext.Context)
	local PurchaseData = React.useContext(PurchaseContext.Context)

	local Unit, SetUnit = React.useState(nil :: Types.VisualUnitData?)
	local Count, SetCount = React.useState(0)
	local TraitsInfoVisible, SetTraitsInfoVisible = React.useState(false)

	local Styles, API = ReactSpring.useSpring(function()
		return {
			alpha = 0,
			config = { mass = 1, tension = 1000, friction = 30, clamp = true },
		}
	end, {})

	Hooks.useEventConnection(Touched, function()
		if props.SetVisible then
			props.SetVisible()
		end
	end, { props.SetVisible })

	React.useEffect(function()
		API.start({
			from = { alpha = 1 },
			to = { alpha = 0 },
			config = { mass = 1, tension = 1000, friction = 30, clamp = true },
			reset = true,
		})
	end, { Unit })

	React.useEffect(function()
		for _, ResourceData in pairs(InventoryData.Resources) do
			if ResourceData.Resource == "Omen Coins" then
				SetCount(ResourceData.Count)
				return
			end
		end

		SetCount(0)
	end, { InventoryData })

	local PromptVisible = React.useRef(false)

	local OnPlusClick = React.useCallback(function()
		PromptData.SetVisible(true)
		PromptVisible.current = true
	end, { PromptData })

	Hooks.useEventConnection(PromptData.Added, function(Id: string, OpenFrame: string)
		if PromptVisible.current then
			PromptData.SetVisible(false)
			PromptData.ClearIds()
			PromptVisible.current = false
		else
			return
		end

		if OpenFrame == "Unit" then
			local UnitData = InventoryData.Units[Id]
			if UnitData then
				SetUnit(UnitData)
			end
		else
			WarningData.Add("You can only add Traits to Units.")
		end
	end, { InventoryData })

	local Trait = React.useMemo(function(): string?
		if Unit then
			return Unit.Trait or "None"
		end
		return nil
	end, { Unit })

	local RarityData = React.useMemo(function()
		if Trait and Trait ~= "None" then
			local TraitData = Traits.Traits[Trait]
			if TraitData then
				return RarityInfo[TraitData.Rarity :: any]
			end
		end

		return RarityInfo["Common" :: any]
	end, { Trait } :: { unknown })

	local RollColor = React.useMemo(function()
		if Unit and Count > 0 then
			return Color3.fromRGB(135, 1, 203)
		end

		return Color3.fromRGB(84, 84, 84)
	end, { Unit, Count } :: { unknown })

	local OnRollClick = React.useCallback(function()
		if not Unit then
			WarningData.Add("You need to select a Unit first!")
		elseif Count <= 0 then
			MarketplaceService:PromptProductPurchase(Player, 3359654911)
			WarningData.Add("You don't have any Omen Coins!")
		else
			RollTrait.Fire({
				UniqueId = Unit.UniqueId,
			})
		end
	end, { Unit, Count } :: { unknown })

	Hooks.useZapConnection(TraitRolled, function(Data)
		if Unit and Unit.UniqueId == Data.UniqueId then
			Unit.Trait = Data.NewTrait
			SetUnit(table.clone(Unit))
		end
	end, { Unit })

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

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(0.5, 0.7),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
		}, props.native),
	}, {
		TraitsInfo = TraitsInfoVisible and e(TraitsInfo, {
			CloseClick = function()
				SetTraitsInfoVisible(false)
			end,
		}),
		MainFrame = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.8, 0.5),
				Position = UDim2.fromScale(0.5, 0.475),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.298039, 0.094118, 0.470588),
			},
		}, {
			Plus = not Unit and e(Plus, {
				native = {
					Position = UDim2.fromScale(0.5, 0.25),
					Size = UDim2.fromScale(0.4, 0.4),
					[React.Event.MouseButton1Click] = OnPlusClick,
				},
			}),
			UnitFrame = Unit and e(UnitFrame.CreateUnitFrame, {
				UnitName = Unit.Unit,
				Level = Unit.Level,
				Trait = Unit.Trait,
				OnClick = OnPlusClick,
				native = {
					Position = UDim2.fromScale(0.5, 0.25),
					Size = UDim2.fromScale(0.4, 0.4),
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Color = Color3.new(0.388235, 0.101961, 0.486275),
				Stroke = 0.01,
				native = {
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
			OmenCoinsFrame = e(ResourceFrame, {
				Name = "Omen Coins",
				Value = Count,
				native = {
					Position = UDim2.fromScale(0.5, 0.75),
					Size = UDim2.fromScale(0.4, 0.4),
				},
			}),
		}),
		RerollButton = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.5, 0.89),
				Size = UDim2.fromScale(0.3, 0.15),
				Image = "rbxassetid://80739823452825",
				ImageColor3 = RollColor,
				[React.Event.MouseButton1Click] = OnRollClick,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 2.75,
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.6),
					Text = "Reroll",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
				}),
			}),
		}),
		TraitsInfoButton = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.85, 0.89),
				Size = UDim2.fromScale(0.13, 0.2),
				Image = "rbxassetid://77078349522524",
				ZIndex = 2,
				[React.Event.MouseButton1Click] = function()
					SetTraitsInfoVisible(true)
				end,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		InputLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.15),
				Size = UDim2.fromScale(0.9, 0.1),
				Text = "Select a Unit to change its Trait",
			},
		}),
		CurrentTrait = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.79),
				Size = UDim2.fromScale(0.8, 0.06),
				Text = Unit and string.format("Trait: %s", Trait or "None") or "",
			},
		}, {
			UIGradient = e(AnimatedGradient, {
				GradColor = RarityData.Color,
				Animate = true,
			}),
			UIStroke = e(UIStroke.UIStrokeGradient, {
				GradColor = RarityData.StrokeColor,
				Stroke = 0.01,
			}),
			UIScale = e("UIScale", {
				Scale = Styles.alpha:map(function(alpha)
					return 1 + alpha * 0.2
				end),
			}),
		}),
		Title = e(Title, {
			Position = UDim2.fromScale(0.3, 0),
			Size = UDim2.fromScale(1, 0.14),
			Title = "TRAITS",
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 0.8,
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.2, 0.3),
			OnClick = props.CloseClick,
		}),
		RightContainer = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				Size = UDim2.fromScale(0.55, 0.7),
				Position = UDim2.fromScale(1.32, 0.5),
				BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
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
			InnerFrame = e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(0.5, 0.51),
					Size = UDim2.fromScale(0.9, 0.9),
				},
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.015, 0),
				}),
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Color = Color3.new(0.388235, 0.101961, 0.486275),
					Stroke = 0.004,
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
		}),
		InnerFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.52),
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
	}, props.children)
end

return CreateTraitsFrame
