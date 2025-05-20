--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
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

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local InventoryService = require(GlobalClient.InventoryService)

local CoreGame = Gui.CoreGame
local CloseButton = require(CoreGame.CloseButton)
local Main = require(CoreGame.Main)
local Confirm = require(CoreGame.Confirm)
local Title = require(CoreGame.Title)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)
local ProductInfo = require(Shared.ProductInfo)
local GameInfo = require(Shared.GameInfo)
local Types = require(Shared.Types)

export type Properties = {
	CloseClick: () -> ()?,
	native: { [any]: any }?,
}

local Filters = { "Rarity", "Level", "Name" }
local NormalFilters = { "Rarity", "Name" }

local FilterFunctions = {}

type FData = Types.VisualUnitData

do
	local Data = UnitInfo.UnitInfo
	@native
	function FilterFunctions.Rarity(a: FData, b: FData)
		local RarityA = Data[a.Unit].Rarity
		local RarityB = Data[b.Unit].Rarity
		local PriorityA = RarityInfo[RarityA :: any].Priority
		local PriorityB = RarityInfo[RarityB :: any].Priority

		if PriorityA == PriorityB then
			return a.Unit < b.Unit
		else
			return PriorityA > PriorityB
		end
	end

	@native
	function FilterFunctions.Level(a: FData, b: FData)
		if a.Level == b.Level then
			return a.Unit < b.Unit
		else
			return a.Level > b.Level
		end
	end

	@native
	function FilterFunctions.Name(a: FData, b: FData)
		if a.Unit == b.Unit and a.Level then
			return a.Level > b.Level
		else
			return a.Unit < b.Unit
		end
	end
end

local function Sell(UniqueIds: { string })
	InventoryService.SellUnits(UniqueIds)
end

local function CreateBaseButton(Properties: {
	Text: string,
	OnClick: () -> (),
	native: { [any]: any }?,
})
	return React.createElement(Main.Animateables.ImageButton, {
		native = JoinDicts({
			Size = UDim2.fromScale(0.2, 1),
			Image = "rbxassetid://90225038866735",
			[React.Event.MouseButton1Click] = Properties.OnClick,
		}, Properties.native),
	}, {
		TextLabel = React.createElement(Main.TextLabel, {
			native = {
				Text = Properties.Text,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.9, 0.6),
			},
		}),
	})
end

local function BeingSoldFrame(props)
	return e(Main.ImageLabel, {
		native = {
			Visible = props.Visible,
			Size = UDim2.fromScale(0.9, 0.9),
			Image = "rbxassetid://84303396250595",
			ImageColor3 = Color3.fromRGB(255, 6, 0),
			ZIndex = 3,
		},
	})
end

export type UnitData = {
	Data: Types.VisualUnitData,
	SmallFrameClick: (
		{ Data: { CurrentUnit: Types.VisualUnitData, Rarity: string, RarityData: any }, UniqueId: string }
	) -> (),
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
	}, {
		BeingSoldFrame = e(BeingSoldFrame, {
			Visible = Data.XVisible,
		}),
	}, Data.children)
end

export type ProductData = {
	Data: Types.ProductData,
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
		Name = Data.Name,
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
	}, {
		BeingSoldFrame = e(BeingSoldFrame, {
			Visible = props.XVisible,
		}),
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
	}, {
		BeingSoldFrame = e(BeingSoldFrame, {
			Visible = props.XVisible,
		}),
	}, props.children)
end

export type ClickedUnitData = {
	CurrentUnit: any,
	Rarity: string,
	RarityData: typeof(RarityInfo["Common" :: RarityInfo.Rarity]),
}?

local CreateInventory = React.forwardRef(function(Properties, ref)
	local InventoryData = React.useContext(InventoryContext.Context)
	local EquippedUnits = React.useContext(EquippedUnitsContext.Context)

	local SellingItems, SetSellingUnits = React.useState({} :: { string })
	local HoveredId: string?, SetHovered = React.useState(nil :: string?)
	local InSell, ToggleSell = React.useState(false)

	local ClickedUnitData: ClickedUnitData, SetClickedUnitData = React.useState(nil :: ClickedUnitData)
	local ClickedProductData: ClickedUnitData, SetClickedProductData = React.useState(nil :: ClickedUnitData)
	local ClickedResourceData: ClickedUnitData, SetClickedResourceData = React.useState(nil :: ClickedUnitData)

	local OpenFrame: string, SetOpenFrame = React.useState("Unit")

	local BulkEnabled, SetBulkEnabled = React.useState(false)
	local IndEnabled, SetIndEnabled = React.useState(false)

	React.useEffect(function()
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

	React.useEffect(function()
		if InSell == false then
			SetBulkEnabled(false)
		end
		if not HoveredId then
			SetIndEnabled(false)
		end
	end, { InSell, HoveredId :: any })

	React.useEffect(function()
		if not HoveredId then
			SetClickedUnitData(nil)
		end
	end, { HoveredId })

	React.useEffect(function()
		local SellingUnitsCloned = table.clone(SellingItems)
		for i = #SellingUnitsCloned, 1, -1 do
			local Id = SellingUnitsCloned[i]
			if not InventoryData.Units[Id] then
				table.remove(SellingUnitsCloned, i)
			end
		end
		if #SellingItems ~= #SellingUnitsCloned then
			SetSellingUnits(SellingUnitsCloned)
		end
	end, { InventoryData })

	local SmallFrameClick = React.useCallback(function(Data: { Data: any, UniqueId: string })
		local function SetClicked(Data: any)
			if OpenFrame == "Unit" then
				SetClickedUnitData(Data)
			elseif OpenFrame == "Product" then
				SetClickedProductData(Data)
			elseif OpenFrame == "Resource" then
				SetClickedResourceData(Data)
			end
		end

		if (HoveredId ~= Data.UniqueId) and not InSell then
			SetClicked(Data.Data)
			SetHovered(Data.UniqueId)
		end
		if InSell then
			local Index = table.find(SellingItems, Data.UniqueId)
			local NewTable = table.clone(SellingItems)
			if Index then
				table.remove(NewTable, Index)
			else
				table.insert(NewTable, Data.UniqueId)
			end
			SetSellingUnits(NewTable)
		else
			if HoveredId == Data.UniqueId then
				SetClickedUnitData(nil)
				SetHovered(nil)
			else
				SetClicked(Data.Data)
				SetHovered(Data.UniqueId)
			end
		end
	end, { InSell :: any, HoveredId :: any, ClickedUnitData :: any, SellingItems :: any, OpenFrame :: any })

	React.useImperativeHandle(ref, function()
		return {
			Hover = function(Id: string)
				local Info = InventoryData.Units[Id]
				if Info then
					local UnitData = UnitInfo.UnitInfo[Info.Unit]
					local RarityData = RarityInfo[UnitData.Rarity]
					SmallFrameClick({
						Data = {
							CurrentUnit = Info,
							Rarity = UnitData.Rarity,
							RarityData = RarityData,
						},
						UniqueId = Id,
					})
				end
			end,
			GetHovered = function()
				return HoveredId
			end,
		}
	end, { HoveredId, InventoryData :: any })

	local OnEquip = React.useCallback(function()
		if HoveredId then
			if InventoryService.UnitIsEquipped(HoveredId) then
				InventoryService.EquipUnit(HoveredId, false)
			else
				InventoryService.EquipUnit(HoveredId, true)
			end
		end
	end, { HoveredId })

	local IndSellClick = React.useCallback(function()
		SetIndEnabled(true)
	end, { IndEnabled })

	local IndividualSell = React.useCallback(function(Input: boolean?)
		if HoveredId then
			if Input == true then
				Sell({ HoveredId })
			end
		end

		SetIndEnabled(false)
	end, { HoveredId, IndEnabled :: any })

	local OnSellPressed = React.useCallback(function()
		SetHovered(nil :: any)
		SetSellingUnits({})
		ToggleSell(not InSell)
	end, { InSell, HoveredId :: any, SellingItems :: any })

	local OnCheckPressed = React.useCallback(function()
		if InSell and #SellingItems > 0 then
			SetBulkEnabled(true)
		end
	end, { BulkEnabled, SellingItems :: any })

	local BulkSell = React.useCallback(function(Input: boolean?)
		if not InSell then
			return
		end

		if Input == true then
			if #SellingItems > 0 then
				Sell(SellingItems)
			end

			ToggleSell(false)
		elseif Input == false then
			SetSellingUnits({})
			ToggleSell(false)
		end

		SetIndEnabled(false)
	end, { SellingItems, InSell :: any })

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
				table.insert(Sorts, Data)
			end
		elseif OpenFrame == "Product" then
			for _, Data in pairs(InventoryData.Products) do
				table.insert(Sorts, Data)
			end
		elseif OpenFrame == "Resource" then
			for _, Data in pairs(InventoryData.Resources) do
				table.insert(Sorts, Data)
			end
		end

		table.sort(Sorts, FilterFunctions[FilterMethod])

		return Sorts
	end, { InventoryData, FilterMethod :: any, OpenFrame :: any })

	local InventoryNodes = React.useMemo(function()
		local Table: { [string]: React.Node } = {}

		@native
		local function HandleUnitData(Data: Types.VisualUnitData)
			if Filter ~= "" then
				if not string.lower(Data.Unit):match(string.lower(Filter)) then
					return
				end
			end

			local Unit = e(HandleUnit, {
				Data = Data,
				HoveredId = HoveredId,
				SmallFrameClick = SmallFrameClick,
				UniqueId = Data.UniqueId,
				XVisible = if table.find(SellingItems, Data.UniqueId) then true else false,
				native = {
					LayoutOrder = table.find(SortData, Data) or 1,
				},
			})
			Table[Data.UniqueId] = Unit
		end

		@native
		local function HandleProductData(Data: Types.ProductData)
			if Filter ~= "" then
				if not string.lower(Data.Name):match(string.lower(Filter)) then
					return
				end
			end

			local Product = e(HandleProduct, {
				Data = Data,
				HoveredId = HoveredId,
				SmallFrameClick = SmallFrameClick,
				UniqueId = Data.UniqueId,
				XVisible = if table.find(SellingItems, Data.UniqueId) then true else false,
				native = {
					LayoutOrder = table.find(SortData, Data) or 1,
				},
			})
			Table[Data.UniqueId] = Product
		end

		@native
		local function HandleResourceData(Data: Types.ResourceData)
			if Filter ~= "" then
				if not string.lower(Data.Resource):match(string.lower(Filter)) then
					return
				end
			end

			local Resource = e(HandleResource, {
				Data = Data,
				HoveredId = HoveredId,
				SmallFrameClick = SmallFrameClick,
				UniqueId = Data.UniqueId,
				XVisible = if table.find(SellingItems, Data.UniqueId) then true else false,
				native = {
					LayoutOrder = table.find(SortData, Data) or 1,
				},
			})
			Table[Data.UniqueId] = Resource
		end

		if OpenFrame == "Unit" then
			for _, Data in pairs(InventoryData.Units) do
				HandleUnitData(Data)
			end
			if HoveredId and not InventoryData.Units[HoveredId] then
				SetHovered(nil)
			end
		elseif OpenFrame == "Product" then
			for _, Data in pairs(InventoryData.Products) do
				HandleProductData(Data)
			end
			if HoveredId and not InventoryData.Products[HoveredId] then
				SetHovered(nil)
			end
		elseif OpenFrame == "Resource" then
			for _, Data in pairs(InventoryData.Resources) do
				HandleResourceData(Data)
			end
			if HoveredId and not InventoryData.Resources[HoveredId] then
				SetHovered(nil)
			end
		end
		return Table
	end, {
		InSell :: any,
		SellingItems :: any,
		HoveredId :: any,
		InventoryData :: any,
		Filter :: any,
		FilterMethod :: any,
		OpenFrame :: any,
	})

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

	local IndConfirmDescription = React.useMemo(function()
		if ClickedUnitData then
			local UnitName = ClickedUnitData.CurrentUnit.Unit
			local Rarity = UnitInfo.UnitInfo[UnitName].Rarity
			local Cost = RarityInfo[Rarity :: any].Value
			return string.format("Are you sure you want to Sell %s for %u Gold?", UnitName, Cost)
		else
			return ""
		end
	end, { ClickedUnitData })

	local BulkConfirmDescription = React.useMemo(function()
		if SellingItems then
			local TotalCost = 0

			for _, Id in ipairs(SellingItems) do
				local UnitData: Types.VisualUnitData = InventoryData.Units[Id]
				local Rarity = UnitInfo.UnitInfo[UnitData.Unit].Rarity
				TotalCost += RarityInfo[Rarity :: any].Value
			end

			return string.format("Are you sure you want to Sell %u Units for %u Gold?", #SellingItems, TotalCost)
		else
			return ""
		end
	end, { SellingItems })

	local InfoFrameData = React.useMemo(function()
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
			for _, Data in ipairs(EquippedUnits.Units) do
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
			local IsEquipped = if OpenFrame == "" and HoveredId and IsEquipped(HoveredId) then true else false

			local FirstClick = nil
			local SecondClick = nil

			if OpenFrame == "Unit" then
				FirstClick = OnEquip
				SecondClick = IndSellClick
			else
				FirstClick = function() end
				SecondClick = function() end
			end

			local Name = ""

			if OpenFrame == "Unit" then
				Name = Data.CurrentUnit.Unit
			elseif OpenFrame == "Product" then
				Name = Data.CurrentUnit.Name
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
					IsEquipped = IsEquipped,
					OnFirstClick = FirstClick,
					OnSellClick = SecondClick,
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
	end, { OpenFrame :: any, ClickedProductData, ClickedResourceData, ClickedUnitData })

	return e(Main.ImageLabel, {
		native = JoinDicts({
			Size = UDim2.fromScale(0.55, 0.5),
			Image = "rbxassetid://103903141717286",
		}, Properties.native),
	}, {
		IndConfirm = e(Confirm, {
			Title = "Selling Unit",
			Description = IndConfirmDescription,
			Enabled = IndEnabled,
			Handler = IndividualSell,
		}),
		BulkConfirm = e(Confirm, {
			Title = "Selling Units",
			Description = BulkConfirmDescription,
			Enabled = BulkEnabled,
			Handler = BulkSell,
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 2,
		}),
		MainDataFrame = e(Main.ScrollingFrame, {
			BarSize = 0.02,
			native = {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.385, 0.6),
				Size = UDim2.fromScale(0.675, 0.65),
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
		CheckButton = e(Main.Animateables.ImageButton, {
			native = {
				Visible = if InSell then true else false,
				Position = UDim2.fromScale(0.875, 0.175),
				Size = UDim2.fromScale(0.04, 0.08),
				Image = "rbxassetid://78742556758797",
				ImageColor3 = Color3.fromRGB(34, 255, 0),
				[React.Event.MouseButton1Click] = OnCheckPressed,
			},
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.1, 0.2),
			OnClick = Properties.CloseClick,
		}),
		SellButton = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.93, 0.175),
				Size = UDim2.fromScale(0.04, 0.08),
				Image = "rbxassetid://135893657768702",
				ImageColor3 = Color3.fromRGB(255, 0, 4),
				[React.Event.MouseButton1Click] = OnSellPressed,
			},
		}),

		InfoFrame = e(InfoFrame, InfoFrameData),
		Buttons = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.6, 0.09),
				Position = UDim2.fromScale(0.35, 0.175),
			},
		}, {
			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0.05, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			UnitsButton = e(CreateBaseButton, {
				Text = "Units",
				OnClick = function()
					SetOpenFrame("Unit")
				end,
				native = {
					LayoutOrder = 1,
				},
			}),
			GamepassesButton = e(CreateBaseButton, {
				Text = "Products",
				OnClick = function()
					SetOpenFrame("Product")
				end,
				native = {
					LayoutOrder = 2,
				},
			}),
			ResourcesButton = e(CreateBaseButton, {
				Text = "Resources",
				OnClick = function()
					SetOpenFrame("Resource")
				end,
				native = {
					LayoutOrder = 3,
				},
			}),
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
	})
end)

return CreateInventory
