--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local ReactSpring = require(Packages.ReactSpring)
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local JoinDicts = HelperFunctions.joinDicts

local Gui = ReplicatedStorage.Gui
local InventoryGUI = Gui.Inventory
local InfoFrame = require(InventoryGUI.InfoFrame)
local InventoryContext = require(InventoryGUI.InventoryContext)

local UnitFrame = require(InventoryGUI.UnitFrame)
local ProductFrame = require(InventoryGUI.ProductFrame)
local ResourceFrame = require(InventoryGUI.ResourceFrame)

local GameFrames = Gui.GameFrames
local EquippedUnitsContext = require(GameFrames.EquippedUnitsContext)

local Store = Gui.Store
local PurchaseContext = require(Store.PurchaseContext)

local CoreGame = Gui.CoreGame
local CloseButton = require(CoreGame.CloseButton)
local Main = require(CoreGame.Main)
local Title = require(CoreGame.Title)
local BaseButton = require(CoreGame.BaseButton)
local Hooks = require(CoreGame.Hooks)
local UIStroke = require(CoreGame.UIStroke)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)
local ProductInfo = require(Shared.ProductInfo)
local GameInfo = require(Shared.GameInfo)
local Types = require(Shared.Types)

export type Properties = {
	FilteredIds: { string },
	Add: (HoveredId: string) -> (),
	Visible: boolean,
	CloseClick: () -> ()?,
	native: { [any]: any }?,
}

local Filters = { "Rarity", "Level", "Name" }
local NormalFilters = { "Rarity", "Name" }

local FilterFunctions = {}

type FData = {
	Name: string,
	Level: number,
	Rarity: string,
}

do
	function FilterFunctions.Rarity(a: FData, b: FData)
		local PriorityA = RarityInfo[a.Rarity :: any].Priority
		local PriorityB = RarityInfo[b.Rarity :: any].Priority

		if PriorityA == PriorityB then
			return a.Name < b.Name
		else
			return PriorityA > PriorityB
		end
	end

	function FilterFunctions.Level(a: FData, b: FData)
		if a.Level == b.Level then
			return a.Name < b.Name
		else
			return a.Level > b.Level
		end
	end

	function FilterFunctions.Name(a: FData, b: FData)
		if a.Name == b.Name and a.Level then
			return a.Level > b.Level
		else
			return a.Name < b.Name
		end
	end
end

export type UnitData = {
	Data: Types.VisualUnitData,
	SmallFrameClick: (
		{ Data: { CurrentUnit: Types.VisualUnitData, Rarity: string, RarityData: any }, UniqueId: string }
	) -> (),
	IsEquipped: boolean,
	HoveredId: string?,
	UniqueId: string,
	XVisible: boolean,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function HandleUnit(Data: UnitData)
	local UnitData = React.useMemo(function()
		return UnitInfo.UnitInfo[Data.Data.Unit]
	end, { Data.Data })

	local RarityData = React.useMemo(function()
		return RarityInfo[UnitData.Rarity]
	end, { UnitData })

	return e(UnitFrame.CreateUnitFrame, {
		UnitName = Data.Data.Unit,
		Level = Data.Data.Level,
		Cost = UnitData.UnitData[0].Cost,

		OnClick = function()
			Data.SmallFrameClick({
				Data = {
					CurrentUnit = Data.Data,
					Rarity = UnitData.Rarity,
					RarityData = RarityData,
				},
				UniqueId = Data.Data.UniqueId,
			})
		end,

		Hovered = Data.HoveredId == Data.UniqueId,
		native = Data.native,
		containerChildren = {
			CheckMark = Data.IsEquipped and e(Main.ImageLabel, {
				native = {
					Size = UDim2.fromScale(0.25, 0.25),
					Position = UDim2.fromScale(0.75, 0.6),
					ImageColor3 = Color3.new(0, 1, 0),
					Image = "rbxassetid://78742556758797",
					ZIndex = 3,
				},
			}),
		},
	}, Data.children)
end

export type ProductData = {
	Data: Types.ProductData,
	Name: string,
	SmallFrameClick: (
		{ Data: { CurrentUnit: Types.ProductData, Rarity: string, RarityData: any }, UniqueId: string }
	) -> (),
	HoveredId: string?,
	XVisible: boolean,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function HandleProduct(props: ProductData)
	local Rarity = React.useMemo(function()
		if props.Data.IsGamepass then
			return ProductInfo.GamepassInfo[props.Data.ProductId].Rarity
		else
			return ProductInfo.ProductInfo[props.Data.ProductId].Rarity
		end
	end, { props.Data })

	local RarityData = React.useMemo(function()
		return RarityInfo[Rarity :: any]
	end, { Rarity })

	local Data = props.Data
	return e(ProductFrame, {
		IsGamepass = Data.IsGamepass,
		Name = props.Name,
		OnClick = function()
			props.SmallFrameClick({
				Data = {
					CurrentUnit = Data,
					Rarity = Rarity,
					RarityData = RarityData,
				},
				UniqueId = Data.UniqueId,
			})
		end,
		Count = Data.Count,
		ProductId = Data.ProductId,
		native = props.native,
	}, props.children)
end

export type ResourceData = {
	Data: Types.ResourceData,
	SmallFrameClick: (
		{ Data: { CurrentUnit: Types.ResourceData, Rarity: string, RarityData: any }, UniqueId: string }
	) -> (),
	HoveredId: string?,
	XVisible: boolean,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function HandleResource(props: ResourceData)
	local Rarity = React.useMemo(function()
		return GameInfo.RewardInfo[props.Data.Resource].Rarity
	end, { props.Data })

	local RarityData = React.useMemo(function()
		return RarityInfo[Rarity :: any]
	end, { Rarity })

	local Data = props.Data
	return e(ResourceFrame, {
		Name = Data.Resource,
		Value = Data.Count,
		OnClick = function()
			props.SmallFrameClick({
				Data = {
					CurrentUnit = Data,
					Rarity = Rarity,
					RarityData = RarityData,
				},
				UniqueId = Data.UniqueId,
			})
		end,
		native = props.native,
	}, props.children)
end

export type ClickedUnitData = {
	CurrentUnit: any,
	Rarity: string,
	RarityData: typeof(RarityInfo["Common" :: RarityInfo.Rarity]),
}?

local function InventoryPrompt(Properties: Properties)
	local InventoryData = React.useContext(InventoryContext.Context)
	local EquippedUnits = React.useContext(EquippedUnitsContext.Context)
	local PurchaseData = React.useContext(PurchaseContext.Context)

	local HoveredId: string?, SetHovered = React.useState(nil :: string?)

	local ClickedUnitData: ClickedUnitData, SetClickedUnitData = React.useState(nil :: ClickedUnitData)
	local ClickedProductData: ClickedUnitData, SetClickedProductData = React.useState(nil :: ClickedUnitData)
	local ClickedResourceData: ClickedUnitData, SetClickedResourceData = React.useState(nil :: ClickedUnitData)

	local OpenFrame: string, SetOpenFrame = React.useState("Unit")

	local Translator = Hooks.useTranslator()

	local Styles, API = ReactSpring.useSpring(function()
		return {
			alpha = 0,
			config = { mass = 1, tension = 500, friction = 40, clamp = true, precision = 0.01, velocity = 0.03 :: any },
		}
	end)

	React.useEffect(function()
		if Properties.Visible then
			API.start({
				alpha = 1,
			})
		else
			API.start({
				alpha = 0,
			})
		end
	end, { Properties.Visible })

	React.useEffect(function()
		if HoveredId and table.find(Properties.FilteredIds, HoveredId) then
			SetHovered(nil)
		end
	end, { Properties.FilteredIds, HoveredId } :: { unknown })

	React.useEffect(function()
		SetHovered(nil)
		if OpenFrame == "Unit" then
			SetClickedProductData(nil)
			SetClickedResourceData(nil)
		elseif OpenFrame == "Product" then
			SetClickedUnitData(nil)
			SetClickedResourceData(nil)
		elseif OpenFrame == "Resource" then
			SetClickedUnitData(nil)
			SetClickedProductData(nil)
		end
	end, { OpenFrame })

	local SmallFrameClick = React.useCallback(function(Data: { Data: any, UniqueId: string })
		local function SetClicked(ClickData: any)
			if OpenFrame == "Unit" then
				SetClickedUnitData(ClickData)
			elseif OpenFrame == "Product" then
				SetClickedProductData(ClickData)
			elseif OpenFrame == "Resource" then
				SetClickedResourceData(ClickData)
			end
		end

		if HoveredId ~= Data.UniqueId then
			SetClicked(Data.Data)
			SetHovered(Data.UniqueId)
		else
			SetClickedUnitData(nil)
			SetHovered(nil)
		end
	end, { HoveredId, ClickedUnitData, OpenFrame } :: { unknown })

	local Filter, SetFilter = React.useState("")
	local FilterMethod, SetFilterMethod = React.useState(Filters[1])

	React.useEffect(function()
		SetFilter("")
		if FilterMethod == "Level" then
			SetFilterMethod(Filters[1])
		end
	end, { OpenFrame })

	local SortData = React.useMemo(function()
		local Sorts = {}
		if OpenFrame == "Unit" then
			for _, Data in pairs(InventoryData.Units) do
				table.insert(Sorts, {
					Name = Translator and Translator:Translate(game, Data.Unit) or Data.Unit,
					Level = Data.Level,
					Rarity = UnitInfo.UnitInfo[Data.Unit].Rarity :: string,
					UniqueId = Data.UniqueId,
				})
			end
		elseif OpenFrame == "Product" then
			for _, Data in pairs(InventoryData.Products) do
				local Product = if Data.IsGamepass
					then PurchaseData.GamepassData[Data.ProductId]
					else PurchaseData.ProductData[Data.ProductId]
				local Name = Product.ProductInfo.Name
				table.insert(Sorts, {
					Name = Translator and Translator:Translate(game, Name) or Name,
					Level = 1,
					Rarity = Product.Rarity,
					UniqueId = Data.UniqueId,
				})
			end
		elseif OpenFrame == "Resource" then
			for _, Data in pairs(InventoryData.Resources) do
				table.insert(Sorts, {
					Name = Translator and Translator:Translate(game, Data.Resource) or Data.Resource,
					Level = 1,
					Rarity = GameInfo.RewardInfo[Data.Resource].Rarity :: any,
					UniqueId = Data.UniqueId,
				})
			end
		end

		table.sort(Sorts, FilterFunctions[FilterMethod])

		local Data = {}

		for i, DataItem in ipairs(Sorts) do
			Data[DataItem.UniqueId] = i
		end

		return Data
	end, { InventoryData, FilterMethod, OpenFrame, Translator } :: { unknown })

	React.useEffect(function()
		if not HoveredId then
			return
		end
		if OpenFrame == "Unit" then
			if not InventoryData.Units[HoveredId] then
				SetHovered(nil)
			end
		elseif OpenFrame == "Product" then
			if not InventoryData.Products[HoveredId] then
				SetHovered(nil)
			end
		elseif OpenFrame == "Resource" then
			if not InventoryData.Resources[HoveredId] then
				SetHovered(nil)
			end
		end
	end, { InventoryData, HoveredId } :: { unknown })

	local function Translate(String: string)
		if Translator then
			return Translator:Translate(game, String)
		else
			return String
		end
	end

	local InventoryNodes = React.useMemo(
		function()
			local Table: { [string]: React.Node } = {}

			local function IsEquipped(Id: string)
				for _, Data in pairs(EquippedUnits.Units) do
					if Data.UniqueId == Id then
						return true
					end
				end

				return false
			end

			local function HandleUnitData(Data: Types.VisualUnitData)
				if Filter ~= "" then
					if not string.lower(Translate(Data.Unit)):match(string.lower(Filter)) then
						return
					end
				end

				if table.find(Properties.FilteredIds, Data.UniqueId) then
					return
				end

				local Unit = e(HandleUnit, {
					Data = Data,
					HoveredId = HoveredId,
					SmallFrameClick = SmallFrameClick,
					UniqueId = Data.UniqueId,
					IsEquipped = IsEquipped(Data.UniqueId),
					XVisible = false,
					native = {
						LayoutOrder = SortData[Data.UniqueId] or 1,
					},
				})
				Table[Data.UniqueId] = Unit
			end

			local function HandleProductData(Data: Types.ProductData)
				local Name: string = nil

				if Data.IsGamepass then
					Name = PurchaseData.GamepassData[Data.ProductId].ProductInfo.Name
				else
					Name = PurchaseData.ProductData[Data.ProductId].ProductInfo.Name
				end

				if Filter ~= "" then
					if not string.lower(Translate(Name)):match(string.lower(Filter)) then
						return
					end
				end

				if table.find(Properties.FilteredIds, Data.UniqueId) then
					return
				end

				local Product = e(HandleProduct, {
					Data = Data,
					Name = Name,
					HoveredId = HoveredId,
					SmallFrameClick = SmallFrameClick,
					UniqueId = Data.UniqueId,
					XVisible = false,
					native = {
						LayoutOrder = SortData[Data.UniqueId] or 1,
					},
				})
				Table[Data.UniqueId] = Product
			end

			local function HandleResourceData(Data: Types.ResourceData)
				if Filter ~= "" then
					if not string.lower(Translate(Data.Resource)):match(string.lower(Filter)) then
						return
					end
				end

				if table.find(Properties.FilteredIds, Data.UniqueId) then
					return
				end

				local Resource = e(HandleResource, {
					Data = Data,
					HoveredId = HoveredId,
					SmallFrameClick = SmallFrameClick,
					UniqueId = Data.UniqueId,
					XVisible = false,
					native = {
						LayoutOrder = SortData[Data.UniqueId] or 1,
					},
				})
				Table[Data.UniqueId] = Resource
			end

			if OpenFrame == "Unit" then
				for _, Data in pairs(InventoryData.Units) do
					HandleUnitData(Data)
				end
			elseif OpenFrame == "Product" then
				for _, Data in pairs(InventoryData.Products) do
					HandleProductData(Data)
				end
			elseif OpenFrame == "Resource" then
				for _, Data in pairs(InventoryData.Resources) do
					HandleResourceData(Data)
				end
			end
			return Table
		end,
		{ HoveredId, InventoryData, Filter, FilterMethod, OpenFrame, EquippedUnits, Translator, Properties.FilteredIds } :: { unknown }
	)

	local FilterMethodCallback = React.useCallback(function()
		if OpenFrame == "Unit" then
			local Index = table.find(Filters, FilterMethod) or 100
			local NewFilter = Filters[Index + 1] or Filters[1]

			SetFilterMethod(NewFilter)
		else
			local Index = table.find(NormalFilters, FilterMethod) or 100
			local NewFilter = NormalFilters[Index + 1] or NormalFilters[1]

			SetFilterMethod(NewFilter)
		end
	end, { FilterMethod, OpenFrame })

	local SearchCallback = React.useCallback(function(rbx: TextBox)
		SetFilter(rbx.Text)
	end, {})

	local UnitCountText = React.useMemo(function()
		if OpenFrame == "Unit" then
			return string.format("%u / %u", HelperFunctions.Len(InventoryData.Units), InventoryData.MaxUnitCount)
		else
			return ""
		end
	end, { OpenFrame, InventoryData } :: { unknown })

	local InfoFrameData = React.useMemo(
		function()
			local Default = {
				Data = nil,
				Name = "",
				Rarity = nil,
				RarityInfo = nil,
				Type = OpenFrame,
				Visible = false,
				IsEquipped = false,
				OnFirstClick = function() end,
				OnSellClick = function() end,
			} :: any

			local function IsEquipped(Id: string)
				for _, Data in pairs(EquippedUnits.Units) do
					if Data.UniqueId == Id then
						return true
					end
				end

				return false
			end

			local function GetProduct(Data: ClickedUnitData)
				if not Data then
					return Default
				end
				local IsEquippedBool = if OpenFrame == "Unit"
						and HoveredId
						and IsEquipped(HoveredId)
					then true
					else false

				local FirstClick = function()
					if HoveredId then
						Properties.Add(HoveredId)
					end
				end

				local Name = ""

				if OpenFrame == "Unit" then
					Name = Data.CurrentUnit.Unit
				elseif OpenFrame == "Product" then
					if Data.CurrentUnit.IsGamepass then
						local ProductData = PurchaseData.GamepassData[Data.CurrentUnit.ProductId]
						Name = ProductData and ProductData.ProductInfo.Name or "Loading..."
					else
						local ProductData = PurchaseData.ProductData[Data.CurrentUnit.ProductId]
						Name = ProductData and ProductData.ProductInfo.Name or "Loading..."
					end
				elseif OpenFrame == "Resource" then
					Name = Data.CurrentUnit.Resource
				end

				if Data then
					return {
						Data = Data.CurrentUnit,
						Name = Name,
						Rarity = Data.Rarity,
						RarityInfo = Data.RarityData,
						Type = OpenFrame,
						Visible = if HoveredId then true else false,
						IsEquipped = IsEquippedBool,
						OnFirstClick = FirstClick,
					}
				end

				return Default
			end

			if OpenFrame == "Unit" then
				return GetProduct(ClickedUnitData)
			elseif OpenFrame == "Product" then
				return GetProduct(ClickedProductData)
			elseif OpenFrame == "Resource" then
				return GetProduct(ClickedResourceData)
			end

			return Default
		end,
		{
			OpenFrame,
			ClickedProductData,
			ClickedResourceData,
			ClickedUnitData,
			EquippedUnits,
			HoveredId,
			Properties.Add,
		} :: { unknown }
	)

	return e(Main.Frame, {
		native = JoinDicts({
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
			Size = Styles.alpha:map(function(alpha)
				return UDim2.fromScale(0.475, 0.45):Lerp(UDim2.fromScale(0.55, 0.5), alpha)
			end),
			Visible = Styles.alpha:map(function(alpha)
				return alpha > 0
			end),
		}, Properties.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 2,
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
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
		MainDataFrame = e(Main.ScrollingFrame, {
			BarSize = 0.02,
			native = {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.375, 0.55),
				Size = UDim2.fromScale(0.65, 0.6),
				CanvasSize = UDim2.fromScale(0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarImageColor3 = Color3.fromRGB(68, 11, 93),
				BorderSizePixel = 0,
			},
		}, {
			UIGridLayout = e("UIGridLayout", {
				CellPadding = UDim2.fromScale(0, 0),
				CellSize = UDim2.fromScale(0.2, 0.41),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				StartCorner = Enum.StartCorner.TopLeft,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			}),
			UIPadding = e("UIPadding", {
				PaddingRight = UDim.new(0.03, 0),
			}),
		}, InventoryNodes),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.1, 0.2),
			OnClick = Properties.CloseClick,
		}),
		InfoFrame = e(
			InfoFrame,
			JoinDicts(InfoFrameData, {
				FirstText = "Use",
			})
		),
		UnitsButton = e(BaseButton, {
			Text = "Units",
			OnClick = function()
				SetOpenFrame("Unit")
			end,
			Highlighted = OpenFrame == "Unit",
			native = {
				Position = UDim2.fromScale(0.12, 0.175),
			},
		}),
		GamepassesButton = e(BaseButton, {
			Text = "Products",
			OnClick = function()
				SetOpenFrame("Product")
			end,
			Highlighted = OpenFrame == "Product",
			native = {
				Position = UDim2.fromScale(0.26, 0.175),
			},
		}),
		ResourcesButton = e(BaseButton, {
			Text = "Resources",
			OnClick = function()
				SetOpenFrame("Resource")
			end,
			Highlighted = OpenFrame == "Resource",
			native = {
				Position = UDim2.fromScale(0.40, 0.175),
			},
		}),
		Search = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.447059, 0.447059, 0.447059),
				Size = UDim2.fromScale(0.2, 0.08),
				Position = UDim2.fromScale(0.63, 0.175),
			},
		}, {
			Box = e(Main.TextBox, {
				native = {
					Size = UDim2.fromScale(0.9, 0.7),
					TextXAlignment = Enum.TextXAlignment.Left,
					PlaceholderText = "Search...",
					Text = "",
					[React.Change.Text] = SearchCallback,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.3, 0),
			}),
			Icon = e(Main.ImageLabel, {
				native = {
					Position = UDim2.fromScale(-0.15, 0.5),
					Size = UDim2.fromScale(0.3, 0.9),
					Image = "rbxassetid://109198874827438",
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
			}),
		}),
		SortButton = e(Main.Animateables.TextButton, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.137255, 0.796078, 0.223529),
				Size = UDim2.fromScale(0.08, 0.08),
				Position = UDim2.fromScale(0.79, 0.175),
				Text = "",
				[React.Event.MouseButton1Click] = FilterMethodCallback,
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.3, 0),
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.6),
					Text = FilterMethod,
				},
			}),
		}),
		Title = e(Title, {
			Title = "INVENTORY",
			Position = UDim2.fromScale(0.15, -0.03),
			Size = UDim2.fromScale(0.5, 0.5),
		}),
		MaxUnitsCount = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.7, 0.9),
				Size = UDim2.fromScale(0.2, 0.05),
				Text = UnitCountText,
				ZIndex = 5,
			},
		}),
	})
end

return {
	Prompt = InventoryPrompt,
}
