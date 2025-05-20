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
local UnitFrame = require(InventoryGUI.UnitFrame)
local InfoFrame = require(InventoryGUI.InfoFrame)
local InventoryContext = require(InventoryGUI.InventoryContext)

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
local Types = require(Shared.Types)

export type Properties = {
	CloseClick: () -> ()?,
	native: { [any]: any }?,
}

local Filters = { "Rarity", "Level", "Name" }

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
		if a.Unit == b.Unit then
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
	end, { Data })

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
		BeingSoldFrame = e(Main.ImageLabel, {
			native = {
				Visible = Data.XVisible,
				Size = UDim2.fromScale(0.9, 0.9),
				Image = "rbxassetid://84303396250595",
				ImageColor3 = Color3.fromRGB(255, 6, 0),
				ZIndex = 3,
			},
		}),
	}, Data.children)
end

export type ClickedUnitData = {
	CurrentUnit: Types.VisualUnitData,
	Rarity: string,
	RarityData: typeof(RarityInfo["Common" :: RarityInfo.Rarity]),
}?

local CreateInventory = React.forwardRef(function(Properties, ref)
	local InventoryData = React.useContext(InventoryContext.Context)
	local EquippedUnits = React.useContext(EquippedUnitsContext.Context)

	local SellingUnits, SetSellingUnits = React.useState({} :: { string })
	local HoveredId: string?, SetHovered = React.useState(nil :: string?)
	local InSell, ToggleSell = React.useState(false)

	local ClickedUnitData: ClickedUnitData, SetClickedUnitData = React.useState(nil :: ClickedUnitData)

	local OpenFrame: string, SetOpenFrame = React.useState("Unit")

	local BulkEnabled, SetBulkEnabled = React.useState(false)
	local IndEnabled, SetIndEnabled = React.useState(false)

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
		local SellingUnitsCloned = table.clone(SellingUnits)
		for i = #SellingUnitsCloned, 1, -1 do
			local Id = SellingUnitsCloned[i]
			if not InventoryData.Units[Id] then
				table.remove(SellingUnitsCloned, i)
			end
		end
		if #SellingUnits ~= #SellingUnitsCloned then
			SetSellingUnits(SellingUnitsCloned)
		end
	end, { InventoryData })

	local SmallFrameClick = React.useCallback(function(Data: { Data: any, UniqueId: string })
		if (HoveredId ~= Data.UniqueId) and not InSell then
			SetClickedUnitData(Data.Data)
			SetHovered(Data.UniqueId)
		end
		if InSell then
			local Index = table.find(SellingUnits, Data.UniqueId)
			local NewTable = table.clone(SellingUnits)
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
				SetClickedUnitData(Data.Data)
				SetHovered(Data.UniqueId)
			end
		end
	end, { InSell :: any, HoveredId :: any, ClickedUnitData :: any, SellingUnits :: any })

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
	end, { InSell, HoveredId :: any, SellingUnits :: any })

	local OnCheckPressed = React.useCallback(function()
		if InSell and #SellingUnits > 0 then
			SetBulkEnabled(true)
		end
	end, { BulkEnabled, SellingUnits :: any })

	local BulkSell = React.useCallback(function(Input: boolean?)
		if not InSell then
			return
		end

		if Input == true then
			if #SellingUnits > 0 then
				Sell(SellingUnits)
			end

			ToggleSell(false)
		elseif Input == false then
			SetSellingUnits({})
			ToggleSell(false)
		end

		SetIndEnabled(false)
	end, { SellingUnits, InSell :: any })

	local Filter, SetFilter = React.useState("")
	local FilterMethod, SetFilterMethod = React.useState(Filters[1])

	local SortData = React.useMemo(function()
		local Sorts = {}
		for _, Data in pairs(InventoryData.Units) do
			table.insert(Sorts, Data)
		end
		table.sort(Sorts, FilterFunctions[FilterMethod])

		return Sorts
	end, { InventoryData, FilterMethod :: any })

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
				XVisible = if table.find(SellingUnits, Data.UniqueId) then true else false,
				native = {
					LayoutOrder = table.find(SortData, Data) or 1,
				},
			})
			Table[Data.UniqueId] = Unit
		end

		local function HandleResourceData(Data: Types.RewardData)
			if Filter ~= "" then
				if not string.lower(Data.Resource):match(string.lower(Filter)) then
					return
				end
			end
		end

		if OpenFrame == "Unit" then
			for _, Data in pairs(InventoryData.Units) do
				HandleUnitData(Data)
			end
			if HoveredId and not InventoryData.Units[HoveredId] then
				SetHovered(nil)
			end
		elseif OpenFrame == "Resource" then
		end
		return Table
	end, {
		InSell :: any,
		SellingUnits :: any,
		HoveredId :: any,
		InventoryData :: any,
		Filter :: any,
		FilterMethod :: any,
		OpenFrame :: any,
	})

	local function IsEquipped(Id: string)
		for _, Data in ipairs(EquippedUnits.Units) do
			if Data.UniqueId == Id then
				return true
			end
		end

		return false
	end

	local FilterMethodCallback = React.useCallback(function()
		local Index = table.find(Filters, FilterMethod) :: number
		local NewFilter = Filters[Index + 1] or Filters[1]

		SetFilterMethod(NewFilter)
	end, { FilterMethod })

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
		if SellingUnits then
			local TotalCost = 0

			for _, Id in ipairs(SellingUnits) do
				local UnitData: Types.VisualUnitData = InventoryData.Units[Id]
				local Rarity = UnitInfo.UnitInfo[UnitData.Unit].Rarity
				TotalCost += RarityInfo[Rarity :: any].Value
			end

			return string.format("Are you sure you want to Sell %u Units for %u Gold?", #SellingUnits, TotalCost)
		else
			return ""
		end
	end, { SellingUnits })

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

		InfoFrame = e(InfoFrame, {
			Visible = if HoveredId and ClickedUnitData then true else false,

			Type = OpenFrame,
			Data = ClickedUnitData and ClickedUnitData.CurrentUnit,
			Name = ClickedUnitData and ClickedUnitData.CurrentUnit.Unit,
			Rarity = ClickedUnitData and ClickedUnitData.Rarity :: any,
			RarityInfo = ClickedUnitData and ClickedUnitData.RarityData :: any,

			IsEquipped = HoveredId and IsEquipped(HoveredId) or false,
			OnEquipClick = OnEquip,
			OnSellClick = IndSellClick,
		}),
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
				Text = "Gamepasses",
				OnClick = function()
					SetOpenFrame("Gamepass")
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
