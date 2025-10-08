--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Network = require(ReplicatedStorage.Network.ClientOnly)
local SendWarning = Network.Warning

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Title = require(CoreGame.Title)
local Hooks = require(CoreGame.Hooks)
local NewGui = require(CoreGame.NewGui)

local Inventory = Gui.Inventory
local InventoryContext = require(Inventory.InventoryContext)
local UnitFrame = require(Inventory.UnitFrame)
local ProductFrame = require(Inventory.ProductFrame)
local ResourceFrame = require(Inventory.ResourceFrame)
local PromptContext = require(Inventory.PromptContext)

local Components = Gui.Components
local Plus = require(Components.Plus)
local SelectCount = require(Components.SelectCount)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Client = ReplicatedStorage.Client
local TradeService = require(Client.LobbyClient.TradeService)

local Shared = ReplicatedStorage.Shared
local Types = require(Shared.Types)
local ProductInfo = require(Shared.ProductInfo)

export type Properties = {
	Visible: boolean,
	Toggle: (Visible: boolean) -> (),
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateTradeFrame(Properties: any)
	local BackgroundColor = React.useMemo(function()
		return Properties.Confirmed and Color3.fromRGB(48, 158, 31) or Color3.fromRGB(56, 15, 88)
	end, { Properties.Confirmed })

	local StrokeColor = React.useMemo(function()
		return Properties.Confirmed and Color3.fromRGB(89, 225, 79) or Color3.fromRGB(116, 26, 155)
	end, { Properties.Confirmed })

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(0.45, 0.5),
			BackgroundTransparency = 0,
			BackgroundColor3 = BackgroundColor,
		}, Properties.native),
	}, {
		UIStroke = e(UIStroke.UIStrokeAdvanced, {
			Stroke = 0.005,
			Color = StrokeColor,
			native = {
				LineJoinMode = Enum.LineJoinMode.Round,
			},
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.1, 0),
		}),
		UIGridLayout = e("UIGridLayout", {
			CellPadding = UDim2.fromScale(0, 0),
			CellSize = UDim2.fromScale(0.33, 0.5),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}, Properties.children)
end

local function CreateButton(Properties: any)
	return e(Main.Animateables.ImageButton, {
		native = Join({
			Size = UDim2.fromScale(0.2, 0.2),
			Image = Properties.Image,
		}, Properties.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 3.163,
		}),
		TextLabel = e(Main.TextLabel, {
			native = {
				Size = UDim2.fromScale(0.9, 0.7),
				Text = Properties.Text,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.04,
			}),
		}),
	}, Properties.children)
end

local function ConvertStatus(Status: Types.Status): string
	if Status == "InTrade" then
		return "In Trade"
	end

	return Status
end

type Trades = { Types.VisualUnitData | Types.TradeProductData | Types.TradeResourceData }

local function TradeMain(Properties: Properties)
	local PromptData = React.useContext(PromptContext.Context)
	local InventoryData = React.useContext(InventoryContext.Context)
	local TradeData: TradeService.TradeData?, SetTradeData = React.useState(nil :: TradeService.TradeData?)

	local YourFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		if TradeData then
			local LayoutOrder = Hooks.LayoutOrder()

			for _, Unit in ipairs(TradeData.YourUnits) do
				Frames["Unit" .. Unit.UniqueId] = e(UnitFrame.CreateUnitFrame, {
					UnitName = Unit.Unit,
					Level = Unit.Level,
					Trait = Unit.Trait,
					native = {
						LayoutOrder = LayoutOrder(),
					},
					OnClick = function()
						TradeService.RemoveUnit(Unit.UniqueId)
					end,
				})
			end

			for _, Product in ipairs(TradeData.YourProducts) do
				local IsGamepass = ProductInfo.ProductIsGamepass(Product.Product)
				Frames["Product" .. Product.Product] = e(ProductFrame, {
					IsGamepass = IsGamepass,
					ProductId = Product.Product,
					Count = Product.Count,
					native = {
						LayoutOrder = LayoutOrder(),
					},
					OnClick = function()
						TradeService.ChangeProduct(Product.UniqueId, 0)
					end,
				})
			end

			for _, Resource in ipairs(TradeData.YourResources) do
				Frames["Resource" .. Resource.Resource] = e(ResourceFrame, {
					Name = Resource.Resource,
					Value = Resource.Count,
					native = {
						LayoutOrder = LayoutOrder(),
					},
					OnClick = function()
						TradeService.ChangeResource(Resource.UniqueId, 0)
					end,
				})
			end
		end

		return Frames
	end, { TradeData })

	local OtherFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		if TradeData then
			local LayoutOrder = Hooks.LayoutOrder()

			for _, Unit in ipairs(TradeData.OtherUnits) do
				Frames["Unit" .. Unit.UniqueId] = e(UnitFrame.CreateUnitFrame, {
					UnitName = Unit.Unit,
					Trait = Unit.Trait,
					Level = Unit.Level,
					native = {
						LayoutOrder = LayoutOrder(),
					},
				})
			end

			for _, Product in ipairs(TradeData.OtherProducts) do
				local IsGamepass = ProductInfo.ProductIsGamepass(Product.Product)
				Frames["Product" .. Product.Product] = e(ProductFrame, {
					IsGamepass = IsGamepass,
					ProductId = Product.Product,
					Count = Product.Count,
					native = {
						LayoutOrder = LayoutOrder(),
					},
				})
			end

			for _, Resource in ipairs(TradeData.OtherResources) do
				Frames["Resource" .. Resource.Resource] = e(ResourceFrame, {
					Name = Resource.Resource,
					Value = Resource.Count,
					native = {
						LayoutOrder = LayoutOrder(),
					},
				})
			end
		end

		return Frames
	end, { TradeData })

	Hooks.useEventConnection(TradeService.NewTrade, function(NewTradeData)
		SetTradeData(NewTradeData)
		Properties.Toggle(true)
		PromptData.ClearIds()
	end, { Properties.Toggle, PromptData })

	Hooks.useEventConnection(TradeService.Ended, function()
		SetTradeData(nil)
		Properties.Toggle(false)
		PromptData.ClearIds()
	end, { Properties.Toggle, PromptData })

	local function UpdateTrade()
		local Data = TradeService.GetTradeData()
		if Data then
			SetTradeData(table.clone(Data))
		end
	end

	Hooks.useEventConnection(TradeService.UnitAdded, UpdateTrade, {})
	Hooks.useEventConnection(TradeService.UnitRemoving, UpdateTrade, {})
	Hooks.useEventConnection(TradeService.ProductChanged, UpdateTrade, {})
	Hooks.useEventConnection(TradeService.ResourceChanged, UpdateTrade, {})
	Hooks.useEventConnection(TradeService.StatusChanged, UpdateTrade, {})

	local ProgressText = React.useMemo(function()
		if not TradeData then
			return "Finalize"
		end

		if TradeData.Status == "InTrade" then
			return "Finalize"
		elseif TradeData.Status == "Finalized" then
			return "Accept"
		end

		return "Accept"
	end, { TradeData })

	local ProgressClick = React.useCallback(function()
		if not TradeData then
			return
		end

		TradeService.ToggleStatus(true)
	end, { TradeData })

	local CancelClick = React.useCallback(function()
		if not TradeData then
			return
		end

		if TradeData.YourStatus == "InTrade" then
			TradeService.EndTrade()
		else
			TradeService.ToggleStatus(false)
		end
	end, { TradeData })

	local PromptVisible = React.useRef(false)

	local PlusClick = React.useCallback(function()
		if not TradeData then
			return
		end
		if TradeData.Status ~= "InTrade" then
			return
		end

		local Count = 0

		Count += #TradeData.YourUnits
		Count += #TradeData.YourProducts
		Count += #TradeData.YourResources

		if Count >= 5 then
			SendWarning:Fire("You can only trade up to 5 items at a time.")
			return
		end

		PromptVisible.current = true
		PromptData.SetVisible(true)
	end, { TradeData, PromptData } :: { unknown })

	local SelectCountFrame, SetSelectCountFrame = React.useState(nil :: any)
	local SelectedId = React.useRef(nil :: {
		UniqueId: string,
		Type: string,
	}?)

	Hooks.useEventConnection(TradeService.UnitRemoving, function(UniqueId: string, OtherPlayer: Player)
		if Player == OtherPlayer then
			PromptData.RemoveId(UniqueId)
		end
	end, { SelectCountFrame, PromptData } :: { unknown })

	local oldvis = React.useRef(false)

	React.useEffect(function()
		if not Properties.Visible and oldvis.current then
			TradeService.EndTrade()
		end
		oldvis.current = Properties.Visible
	end, { Properties.Visible })

	Hooks.useEventConnection(PromptData.Added, function(Id: string, OpenFrame: string)
		if not PromptVisible.current then
			return
		end

		if OpenFrame == "Unit" then
			TradeService.AddUnit(Id)
		elseif OpenFrame == "Product" then
			local ProductData = InventoryData.Products[Id]
			local IsGamepass = ProductInfo.ProductIsGamepass(ProductData.ProductId)
			if ProductData then
				SelectedId.current = {
					UniqueId = ProductData.UniqueId,
					Type = "Product",
				}

				SetSelectCountFrame(e(ProductFrame, {
					ProductId = ProductData.ProductId,
					Count = ProductData.Count,
					IsGamepass = IsGamepass,
				}))
			end
		elseif OpenFrame == "Resource" then
			local ResourceData = InventoryData.Resources[Id]
			if ResourceData then
				SelectedId.current = {
					UniqueId = ResourceData.UniqueId,
					Type = "Resource",
				}
				SetSelectCountFrame(e(ResourceFrame, {
					Name = ResourceData.Resource,
					Value = ResourceData.Count,
				}))
			end
		end

		PromptData.SetVisible(false)
		PromptVisible.current = false
	end, { PromptData })

	local SelectClick = React.useCallback(function(Count: number)
		if not SelectCountFrame then
			return
		end
		if not SelectedId.current then
			return
		end
		local SelectData = SelectedId.current
		if SelectedId.current.Type == "Product" then
			TradeService.ChangeProduct(SelectData.UniqueId, Count)
		elseif SelectData.Type == "Resource" then
			TradeService.ChangeResource(SelectData.UniqueId, Count)
		end

		SetSelectCountFrame(nil)
	end, { SelectCountFrame })

	local OldYourStatus = React.useRef("In Trade")

	local YourStatus = React.useMemo(function()
		if not TradeData then
			return OldYourStatus.current
		end
		local new = ConvertStatus(TradeData.YourStatus)
		OldYourStatus.current = new
		return new
	end, { TradeData })

	local OldOtherStatus = React.useRef("In Trade")

	local OtherStatus = React.useMemo(function()
		if not TradeData then
			return OldOtherStatus.current
		end
		local new = ConvertStatus(TradeData.OtherStatus)
		OldOtherStatus.current = new
		return new
	end, { TradeData })

	local OldOtherName = React.useRef("")

	local OtherName = React.useMemo(function()
		if not TradeData then
			return OldOtherName.current
		end
		local new = TradeData.OtherPlayer.Name
		OldOtherName.current = new
		return new
	end, { TradeData })

	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.6, 0.6),
			Image = "rbxassetid://114227430892447",
		}, Properties.native),
	}, {
		UISizeConstraint = e("UISizeConstraint", {
			MinSize = Vector2.new(310, 230),
			MaxSize = Vector2.new(1240, 920),
		}),
		SelectCountGui = SelectCountFrame and e(NewGui, {
			native = {
				DisplayOrder = 5,
			},
		}, {
			SelectCount = e(SelectCount, {
				OnClick = SelectClick,
				CloseClick = function()
					SetSelectCountFrame(nil)
				end,
			}, SelectCountFrame),
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.9,
		}),
		NoButton = e(CreateButton, {
			Image = "rbxassetid://97483072794272",
			Text = "Cancel",
			native = {
				Position = UDim2.fromScale(0.7, 1.1),
				[React.Event.MouseButton1Click] = CancelClick,
			},
		}),
		YesButton = e(CreateButton, {
			Image = "rbxassetid://121336998793729",
			Text = ProgressText,
			native = {
				Position = UDim2.fromScale(0.3, 1.1),
				[React.Event.MouseButton1Click] = ProgressClick,
			},
		}),
		YourStatus = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.26, 0.85),
				Size = UDim2.fromScale(0.4, 0.08),
				Text = string.format("Status: %s", YourStatus),
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
			}),
		}),
		OtherStatus = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.74, 0.85),
				Size = UDim2.fromScale(0.4, 0.08),
				Text = string.format("Status: %s", OtherStatus),
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
			}),
		}),
		Status = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.35),
				Size = UDim2.fromScale(0.4, 0.08),
				Text = "Processing Trade...",
				ZIndex = 2,
				Visible = TradeData and TradeData.Status == "Accepted" or false,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
			}),
		}),
		OtherTrades = e(CreateTradeFrame, {
			Confirmed = TradeData and TradeData.OtherStatus ~= "InTrade",
			native = {
				Position = UDim2.fromScale(0.735, 0.5),
			},
		}, OtherFrames),
		YourTrades = e(CreateTradeFrame, {
			Confirmed = TradeData and TradeData.YourStatus ~= "InTrade",
			native = {
				Position = UDim2.fromScale(0.265, 0.5),
			},
		}, {
			AddButton = e(Plus, {
				native = {
					LayoutOrder = 1000,
					[React.Event.MouseButton1Click] = PlusClick,
				},
			}),
		}, YourFrames),
		TradeImage = e(Main.ImageLabel, {
			native = {
				Image = "rbxassetid://71136210616050",
				Size = UDim2.fromScale(0.1, 0.175),
				ZIndex = 3,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		OtherName = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.74, 0.15),
				Size = UDim2.fromScale(0.4, 0.09),
				Text = OtherName,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
			}),
		}),
		YourName = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.26, 0.15),
				Size = UDim2.fromScale(0.4, 0.09),
				Text = Player.Name,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
			}),
		}),
		Title = e(Title, {
			Title = "TRADING",
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromScale(0.6, 0.25),
		}),
	}, Properties.children)
end

return TradeMain
