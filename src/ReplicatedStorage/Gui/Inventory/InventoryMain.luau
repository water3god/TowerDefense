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
local StatsFrame = require(InventoryGUI.StatsFrame)

local UnitFrame = require(InventoryGUI.UnitFrame)
local ProductFrame = require(InventoryGUI.ProductFrame)
local ResourceFrame = require(InventoryGUI.ResourceFrame)

local GameFrames = Gui.GameFrames
local EquippedUnitsContext = require(GameFrames.EquippedUnitsContext)

local Store = Gui.Store
local PurchaseContext = require(Store.PurchaseContext)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local InventoryService = require(GlobalClient.InventoryService)
local PurchaseService = require(GlobalClient.PurchaseService)

local CoreGame = Gui.CoreGame
local CloseButton = require(CoreGame.CloseButton)
local Main = require(CoreGame.Main)
local Confirm = require(CoreGame.Confirm)
local Title = require(CoreGame.Title)
local BaseButton = require(CoreGame.BaseButton)
local Hooks = require(CoreGame.Hooks)

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

local function Sell(UniqueIds: { string }, Type: string)
	if Type == "Unit" then
		InventoryService.SellUnits(UniqueIds)
	elseif Type == "Product" then
		InventoryService.SellProducts(UniqueIds)
	elseif Type == "Resource" then
		InventoryService.SellResources(UniqueIds)
	end
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
	IsEquipped: boolean,
	HoveredId: string?,
	UniqueId: string,
	XVisible: boolean,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function HandleUnit(props: UnitData)
	local UnitData = React.useMemo(function()
		return UnitInfo.UnitInfo[props.Data.Unit]
	end, { props.Data })

	local RarityData = React.useMemo(function()
		return RarityInfo[UnitData.Rarity]
	end, { UnitData })

	return e(UnitFrame.CreateUnitFrame, {
		UnitName = props.Data.Unit,
		Level = props.Data.Level,
		Trait = props.Data.Trait,
		Cost = UnitData.UnitData[0].Cost,

		OnClick = function()
			props.SmallFrameClick({
				Data = {
					CurrentUnit = props.Data,
					Rarity = UnitData.Rarity,
					RarityData = RarityData,
				},
				UniqueId = props.Data.UniqueId,
			})
		end,

		Hovered = props.HoveredId == props.UniqueId,
		native = props.native,
		containerChildren = {
			CheckMark = props.IsEquipped and e(Main.ImageLabel, {
				native = {
					Size = UDim2.fromScale(0.25, 0.25),
					Position = UDim2.fromScale(0.75, 0.6),
					ImageColor3 = Color3.new(0, 1, 0),
					Image = "rbxassetid://78742556758797",
					ZIndex = 3,
				},
			}),
		},
	}, {
		BeingSoldFrame = e(BeingSoldFrame, {
			Visible = props.XVisible,
		}),
	}, props.children)
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
		return RarityInfo[Rarity :: RarityInfo.Rarity]
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
		Hovered = props.HoveredId == Data.UniqueId,
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
		return RarityInfo[Rarity :: RarityInfo.Rarity]
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
		Hovered = props.HoveredId == Data.UniqueId,
		native = props.native,
	}, {
		BeingSoldFrame = e(BeingSoldFrame, {
			Visible = props.XVisible,
		}),
	}, props.children)
end

export type ClickedUnitData<T> = {
	CurrentUnit: T,
	Rarity: string,
	RarityData: typeof(RarityInfo["Common" :: RarityInfo.Rarity]),
}?

local CreateInventory = React.forwardRef(function(Properties, ref)
	local InventoryData = React.useContext(InventoryContext.Context)
	local EquippedUnits = React.useContext(EquippedUnitsContext.Context)
	local PurchaseData = React.useContext(PurchaseContext.Context)

	local SellingItems, SetSellingItems = React.useState({} :: { string })
	local HoveredId: string?, SetHovered = React.useState(nil :: string?)
	local InSell, ToggleSell = React.useState(false)

	local ClickedUnitData: ClickedUnitData<Types.VisualUnitData>, SetClickedUnitData =
		React.useState(nil :: ClickedUnitData<Types.VisualUnitData>)
	local ClickedProductData: ClickedUnitData<Types.ProductData>, SetClickedProductData =
		React.useState(nil :: ClickedUnitData<Types.ProductData>)
	local ClickedResourceData: ClickedUnitData<Types.ResourceData>, SetClickedResourceData =
		React.useState(nil :: ClickedUnitData<Types.ResourceData>)

	local OpenFrame: string, SetOpenFrame = React.useState("Unit")

	local BulkEnabled, SetBulkEnabled = React.useState(false)
	local IndEnabled, SetIndEnabled = React.useState(false)

	local Translator = Hooks.useTranslator()

	React.useEffect(function()
		SetBulkEnabled(false)
		SetIndEnabled(false)
		SetSellingItems({})
		ToggleSell(false)
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

	React.useEffect(function()
		if InSell == false then
			SetBulkEnabled(false)
		end
		if not HoveredId then
			SetIndEnabled(false)
		end
	end, { InSell, HoveredId } :: { unknown })

	React.useEffect(function()
		local SellingUnitsCloned = table.clone(SellingItems)
		for i = #SellingUnitsCloned, 1, -1 do
			local Id = SellingUnitsCloned[i]

			if OpenFrame == "Unit" then
				if not InventoryData.Units[Id] then
					table.remove(SellingUnitsCloned, i)
				end
			elseif OpenFrame == "Product" then
				if not InventoryData.Products[Id] then
					table.remove(SellingUnitsCloned, i)
				end
			elseif OpenFrame == "Resource" then
				if not InventoryData.Resources[Id] then
					table.remove(SellingUnitsCloned, i)
				end
			end
		end
		if #SellingItems ~= #SellingUnitsCloned then
			SetSellingItems(SellingUnitsCloned)
		end
	end, { InventoryData })

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
			SetSellingItems(NewTable)
		else
			if HoveredId == Data.UniqueId then
				SetClickedUnitData(nil)
				SetHovered(nil)
			else
				SetClicked(Data.Data)
				SetHovered(Data.UniqueId)
			end
		end
	end, { InSell, HoveredId, ClickedUnitData, SellingItems, OpenFrame } :: { unknown })

	React.useImperativeHandle(ref, function()
		return {
			Hover = function(Id: string)
				local Info = InventoryData.Units[Id]
				if Info then
					local UnitData = UnitInfo.UnitInfo[Info.Unit]
					local RarityData = RarityInfo[UnitData.Rarity]
					SetOpenFrame("Unit")
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
	end, { HoveredId, InventoryData, SmallFrameClick } :: { unknown })

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
				Sell({ HoveredId }, OpenFrame)
			end
		end

		SetIndEnabled(false)
	end, { HoveredId, IndEnabled, OpenFrame } :: { unknown })

	local OnSellPressed = React.useCallback(function()
		SetHovered(nil)
		SetSellingItems({})
		ToggleSell(not InSell)
	end, { InSell, HoveredId, SellingItems } :: { unknown })

	local OnCheckPressed = React.useCallback(function()
		if InSell and #SellingItems > 0 then
			SetBulkEnabled(true)
		end
	end, { BulkEnabled, SellingItems } :: { unknown })

	local BulkSell = React.useCallback(function(Input: boolean?)
		if not InSell then
			return
		end

		if Input == true then
			if #SellingItems > 0 then
				Sell(SellingItems, OpenFrame)
			end

			ToggleSell(false)
		elseif Input == false then
			SetSellingItems({})
			ToggleSell(false)
		end

		SetIndEnabled(false)
	end, { SellingItems, InSell, OpenFrame } :: { unknown })

	local Filter, SetFilter = React.useState("")
	local FilterMethod, SetFilterMethod = React.useState(Filters[1])

	React.useEffect(function()
		SetFilter("")
		if FilterMethod == "Level" then
			SetFilterMethod(Filters[1])
		end
	end, { OpenFrame })

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

				local Unit = e(HandleUnit, {
					Data = Data,
					HoveredId = HoveredId,
					SmallFrameClick = SmallFrameClick,
					UniqueId = Data.UniqueId,
					IsEquipped = IsEquipped(Data.UniqueId),
					XVisible = if table.find(SellingItems, Data.UniqueId) then true else false,
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

				local Product = e(HandleProduct, {
					Data = Data,
					Name = Name,
					HoveredId = HoveredId,
					SmallFrameClick = SmallFrameClick,
					UniqueId = Data.UniqueId,
					XVisible = if table.find(SellingItems, Data.UniqueId) then true else false,
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

				local Resource = e(HandleResource, {
					Data = Data,
					HoveredId = HoveredId,
					SmallFrameClick = SmallFrameClick,
					UniqueId = Data.UniqueId,
					XVisible = if table.find(SellingItems, Data.UniqueId) then true else false,
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
		{
			InSell,
			SellingItems,
			HoveredId,
			InventoryData,
			Filter,
			FilterMethod,
			OpenFrame,
			EquippedUnits,
			Translator,
		} :: { unknown }
	)

	local UseProduct = React.useCallback(function()
		if ClickedProductData then
			local ProductId = ClickedProductData.CurrentUnit.ProductId
			local IsGamepass = ClickedProductData.CurrentUnit.IsGamepass

			PurchaseService.UsePurchase(ProductId, IsGamepass)
		end
	end, { ClickedProductData })

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
		local Name: string? = nil
		local Cost: number = 0

		if OpenFrame == "Unit" then
			if ClickedUnitData then
				local Info = ClickedUnitData.CurrentUnit
				Name = Info.Unit
				if Name then
					local Rarity = UnitInfo.UnitInfo[Name].Rarity
					Cost = RarityInfo[Rarity :: RarityInfo.Rarity].Value
				end
			end
		elseif OpenFrame == "Product" then
			if ClickedProductData then
				local Info = ClickedProductData.CurrentUnit
				local ProductId = Info.ProductId

				local ProductData = ProductInfo.GetProductFromIdOnly(ProductId)

				if ProductData then
					Name = ProductData.Name
					Cost = RarityInfo[ProductData.Rarity :: RarityInfo.Rarity].Value * Info.Count
				end
			end
		elseif OpenFrame == "Resource" then
			if ClickedResourceData then
				local Info = ClickedResourceData.CurrentUnit
				Name = Info.Resource
				if Name then
					local Rarity = GameInfo.RewardInfo[Name].Rarity
					Cost = (RarityInfo[Rarity :: RarityInfo.Rarity].Value * Info.Count) / 10
				end
			end
		end

		if Name then
			return string.format(Translate("Are you sure you want to Sell %s for %u Gold?"), Name, Cost)
		else
			return ""
		end
	end, { ClickedUnitData, ClickedProductData, ClickedResourceData, Translator, OpenFrame } :: { unknown })

	local BulkConfirmDescription = React.useMemo(function()
		if SellingItems then
			local TotalCost = 0

			for _, Id in ipairs(SellingItems) do
				if OpenFrame == "Unit" then
					local UnitData: Types.VisualUnitData = InventoryData.Units[Id]
					if UnitData then
						local Rarity = UnitInfo.UnitInfo[UnitData.Unit].Rarity
						local RarityData = RarityInfo[Rarity :: RarityInfo.Rarity]

						TotalCost += RarityData.Value
					end
				elseif OpenFrame == "Product" then
					local ProductData: Types.ProductData = InventoryData.Products[Id]
					if ProductData then
						local Rarity = ProductInfo.GetProductFromIdOnly(ProductData.ProductId)

						if Rarity then
							local RarityData = RarityInfo[Rarity.Rarity :: RarityInfo.Rarity]
							TotalCost += (RarityData.Value * ProductData.Count)
						end
					end
				elseif OpenFrame == "Resource" then
					local ResourceData: Types.ResourceData = InventoryData.Resources[Id]
					if ResourceData then
						local Rarity = GameInfo.RewardInfo[ResourceData.Resource].Rarity

						if Rarity then
							local RarityData = RarityInfo[Rarity :: RarityInfo.Rarity]
							TotalCost += (RarityData.Value * ResourceData.Count) / 10
						end
					end
				end
			end

			return string.format(
				Translate("Are you sure you want to Sell %u %s for %u Gold?"),
				#SellingItems,
				OpenFrame .. "s",
				TotalCost
			)
		else
			return ""
		end
	end, { SellingItems, Translator, OpenFrame } :: { unknown })

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
				Level = 0,
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

			local function GetProduct(Data: ClickedUnitData<any>)
				if not Data then
					return Default
				end
				local IsEquippedBool = if OpenFrame == "Unit"
						and HoveredId
						and IsEquipped(HoveredId)
					then true
					else false

				local FirstClick = nil

				if OpenFrame == "Unit" then
					FirstClick = OnEquip
				elseif OpenFrame == "Product" then
					FirstClick = UseProduct
				else
					FirstClick = function() end
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
						Level = Data.CurrentUnit.Level or 0,
						Rarity = Data.Rarity,
						RarityInfo = Data.RarityData,
						Type = OpenFrame,
						Trait = Data.CurrentUnit.Trait,
						Visible = if HoveredId then true else false,
						IsEquipped = IsEquippedBool,
						OnFirstClick = FirstClick,
						OnSellClick = IndSellClick,
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
		{ OpenFrame, ClickedProductData, ClickedResourceData, ClickedUnitData, EquippedUnits, HoveredId } :: { unknown }
	)

	local InfoVisible, SetInfoVisible = React.useState(false)

	local OpenInfoClick = React.useCallback(function()
		SetInfoVisible(true)
	end, {})

	local CloseInfoClick = React.useCallback(function()
		SetInfoVisible(false)
	end, {})

	React.useEffect(function()
		if OpenFrame ~= "Unit" or HoveredId == nil then
			SetInfoVisible(false)
		end
	end, { OpenFrame, HoveredId } :: { unknown })

	return e(Main.ImageLabel, {
		native = JoinDicts({
			Size = UDim2.fromScale(0.55, 0.5),
			Image = "rbxassetid://103903141717286",
		}, Properties.native),
	}, {
		InventoryStatsFrame = e(StatsFrame, {
			Name = if OpenFrame and InfoFrameData.Visible then InfoFrameData.Name else nil,
			Type = OpenFrame,
			Level = InfoFrameData.Level,
			Visible = InfoVisible,
			Trait = InfoFrameData.Trait,
			CloseClick = CloseInfoClick,
		}),
		IndConfirm = e(Confirm, {
			Title = string.format("Selling %s", OpenFrame),
			Description = IndConfirmDescription,
			Enabled = IndEnabled,
			Handler = IndividualSell,
		}),
		BulkConfirm = e(Confirm, {
			Title = string.format("Selling %s", OpenFrame .. "s"),
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
		InfoFrame = e(
			InfoFrame,
			JoinDicts(InfoFrameData, {
				OnInfoClick = OpenInfoClick,
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
end)

return CreateInventory
