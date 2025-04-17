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

local function Sell(UniqueIds: { string })
	InventoryService.SellUnits(UniqueIds)
end

local function CreateBaseButton(Properties: {
	Position: UDim2,
	Text: string,
	OnClick: () -> (),
})
	return React.createElement(Main.Animateables.ImageButton, {
		native = {
			Position = Properties.Position,
			Size = UDim2.fromScale(0.175, 0.14),
			Image = "rbxassetid://90225038866735",
		},
		children = {
			TextLabel = React.createElement(Main.TextLabel, {
				native = {
					Text = Properties.Text,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.9, 0.6),
				},
			}),
		},
	})
end

local CreateInventory = React.forwardRef(function(Properties, ref)
	local InventoryContext = React.useContext(InventoryContext.Context)
	local Units, SetUnits = React.useState({} :: { [string]: any })
	local SellingUnits, SetSellingUnits = React.useState({} :: { string })
	local HoveredId: string?, SetHovered = React.useState(nil :: string?)
	local InSell, ToggleSell = React.useState(false)

	local ClickedUnitData, SetClickedUnitData = React.useState(nil :: {
		CurrentUnit: Types.VisualUnitData?,
		Rarity: string,
		RarityData: typeof(RarityInfo["Common" :: RarityInfo.Rarity]),
	}?)

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
	end, { InSell, HoveredId :: any, Units :: any })

	React.useImperativeHandle(ref, function()
		return {
			Hover = function(UniqueId: string?)
				if UniqueId == nil or Units[UniqueId] then
					SetHovered(UniqueId)
				end
			end,
			GetHovered = function()
				return HoveredId
			end,
		}
	end, { HoveredId })

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

	local function HandleUnit(Data: Types.VisualUnitData)
		local UnitData = UnitInfo.UnitInfo[Data.Unit]
		local RarityData = RarityInfo[UnitData.Rarity]

		local Value = e(UnitFrame.CreateUnitFrame, {
			UnitName = Data.Unit,
			Level = Data.Level,
			Cost = UnitData.PlacementCost,

			OnClick = function()
				SmallFrameClick({
					Data = {
						CurrentUnit = Data,
						Rarity = UnitData.Rarity,
						RarityData = RarityData,
					},
					UniqueId = Data.UniqueId,
				})
			end,

			Hovered = if HoveredId and HoveredId == Data.UniqueId then true else false,

			children = {
				BeingSoldFrame = e(Main.ImageLabel, {
					native = {
						Visible = if table.find(SellingUnits, Data.UniqueId) then true else false,
						Size = UDim2.fromScale(0.9, 0.9),
						Image = "rbxassetid://84303396250595",
						ImageColor3 = Color3.fromRGB(255, 6, 0),
						ZIndex = 3,
					},
				}),
			},
		})

		local Merged = JoinDicts(Units, { [Data.UniqueId] = Value })
		SetUnits(Merged)
	end

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
	end, { HoveredId })

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
	end, { SellingUnits, InSell :: any })

	React.useEffect(function()
		for _, Data in pairs(InventoryContext.Units) do
			HandleUnit(Data)
		end
	end, { InSell, SellingUnits :: any, HoveredId :: any, InventoryContext :: any })

	return e(
		"ImageLabel",
		JoinDicts({
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.55, 0.5),
			Image = "rbxassetid://103903141717286",
		}, Properties.native),
		{
			IndConfirm = e(Confirm, {
				Title = "Selling Unit",
				Description = ClickedUnitData
					and ClickedUnitData.CurrentUnit
					and string.format("Are you sure you want to Sell %s", ClickedUnitData.CurrentUnit.Unit),
				Enabled = IndEnabled,
				Handler = IndividualSell,
			}),
			BulkConfirm = e(Confirm, {
				Title = "Selling Units",
				Description = string.format("Are yo sure you want to Sell %u Units", #SellingUnits),
				Enabled = BulkEnabled,
				Handler = BulkSell,
			}),
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 2,
			}),
			MainDataFrame = e(Main.ScrollingFrame, {
				BarSize = 0.05,
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
				children = JoinDicts({
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
				}, Units),
			}),
			CheckButton = e(Main.Animateables.ImageButton, {
				native = {
					Visible = if InSell then true else false,
					Position = UDim2.fromScale(0.64, 0.175),
					Size = UDim2.fromScale(0.05, 0.1),
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
					Position = UDim2.fromScale(0.7, 0.175),
					Size = UDim2.fromScale(0.05, 0.1),
					Image = "rbxassetid://135893657768702",
					ImageColor3 = Color3.fromRGB(255, 0, 4),
					[React.Event.MouseButton1Click] = OnSellPressed,
				},
			}),

			InfoFrame = e(InfoFrame, {
				Visible = if HoveredId and ClickedUnitData then true else false,

				Type = OpenFrame,
				Rarity = ClickedUnitData and ClickedUnitData.Rarity :: any,
				RarityData = ClickedUnitData and ClickedUnitData.RarityData :: any,

				OnEquipClick = OnEquip,
				OnSellClick = IndSellClick,
			}),
			UnitsButton = e(CreateBaseButton, {
				Position = UDim2.fromScale(0.14, 0.175),
				Text = "Units",
				OnClick = function()
					SetOpenFrame("Units")
				end,
			}),
			GamepassesButton = e(CreateBaseButton, {
				Position = UDim2.fromScale(0.33, 0.175),
				Text = "Gamepasses",
				OnClick = function() end,
			}),
			Title = e(Title, {
				Title = "INVENTORY",
				Position = UDim2.fromScale(0.15, -0.03),
				Size = UDim2.fromScale(0.5, 0.5),
			}),
		}
	)
end)

--[[local function CreateInventory(Properties: Properties)
	local InventoryContext = React.useContext(InventoryContext.Context)
	local Units, SetUnits = React.useState({} :: { [string]: any })
	local SellingUnits, SetSellingUnits = React.useState({} :: { string })
	local HoveredId: string?, SetHovered = React.useState(nil :: string?)
	local InSell, ToggleSell = React.useState(false)

	local ClickedUnitData, SetClickedUnitData = React.useState(nil :: {
		CurrentUnit: Types.VisualUnitData?,
		Rarity: string,
		RarityData: typeof(RarityInfo["Common" :: RarityInfo.Rarity]),
	}?)

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
	end, { InSell, HoveredId :: any, Units :: any })

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

	local function HandleUnit(Data: Types.VisualUnitData)
		local UnitData = UnitInfo.UnitInfo[Data.Unit]
		local RarityData = RarityInfo[UnitData.Rarity]

		local Value = e(UnitFrame.CreateUnitFrame, {
			UnitName = Data.Unit,
			Level = Data.Level,
			Cost = UnitData.PlacementCost,

			OnClick = function()
				SmallFrameClick({
					Data = {
						CurrentUnit = Data,
						Rarity = UnitData.Rarity,
						RarityData = RarityData,
					},
					UniqueId = Data.UniqueId,
				})
			end,

			Hovered = if HoveredId and HoveredId == Data.UniqueId then true else false,

			children = {
				BeingSoldFrame = e(Main.ImageLabel, {
					native = {
						Visible = if table.find(SellingUnits, Data.UniqueId) then true else false,
						Size = UDim2.fromScale(0.9, 0.9),
						Image = "rbxassetid://84303396250595",
						ImageColor3 = Color3.fromRGB(255, 6, 0),
						ZIndex = 3,
					},
				}),
			},
		})

		local Merged = JoinDicts(Units, { [Data.UniqueId] = Value })
		SetUnits(Merged)
	end

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
	end, { HoveredId })

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
	end, { SellingUnits, InSell :: any })

	React.useEffect(function()
		for _, Data in pairs(InventoryContext.Units) do
			HandleUnit(Data)
		end
	end, { InSell, SellingUnits :: any, HoveredId :: any, InventoryContext :: any })

	return e(
		"ImageLabel",
		JoinDicts({
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.55, 0.5),
			Image = "rbxassetid://103903141717286",
		}, Properties.native),
		{
			IndConfirm = e(Confirm, {
				Title = "Selling Unit",
				Description = ClickedUnitData
					and ClickedUnitData.CurrentUnit
					and string.format("Are you sure you want to Sell %s", ClickedUnitData.CurrentUnit.Unit),
				Enabled = IndEnabled,
				Handler = IndividualSell,
			}),
			BulkConfirm = e(Confirm, {
				Title = "Selling Units",
				Description = string.format("Are yo sure you want to Sell %u Units", #SellingUnits),
				Enabled = BulkEnabled,
				Handler = BulkSell,
			}),
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 2,
			}),
			MainDataFrame = e(Main.ScrollingFrame, {
				BarSize = 0.05,
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
				children = JoinDicts({
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
				}, Units),
			}),
			CheckButton = e(Main.Animateables.ImageButton, {
				native = {
					Visible = if InSell then true else false,
					Position = UDim2.fromScale(0.64, 0.175),
					Size = UDim2.fromScale(0.05, 0.1),
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
					Position = UDim2.fromScale(0.7, 0.175),
					Size = UDim2.fromScale(0.05, 0.1),
					Image = "rbxassetid://135893657768702",
					ImageColor3 = Color3.fromRGB(255, 0, 4),
					[React.Event.MouseButton1Click] = OnSellPressed,
				},
			}),

			InfoFrame = e(InfoFrame, {
				Visible = if HoveredId and ClickedUnitData then true else false,

				Type = OpenFrame,
				Rarity = ClickedUnitData and ClickedUnitData.Rarity :: any,
				RarityData = ClickedUnitData and ClickedUnitData.RarityData :: any,

				OnEquipClick = OnEquip,
				OnSellClick = IndSellClick,
			}),
			UnitsButton = e(CreateBaseButton, {
				Position = UDim2.fromScale(0.14, 0.175),
				Text = "Units",
				OnClick = function()
					SetOpenFrame("Units")
				end,
			}),
			GamepassesButton = e(CreateBaseButton, {
				Position = UDim2.fromScale(0.33, 0.175),
				Text = "Gamepasses",
				OnClick = function() end,
			}),
			Title = e(Title, {
				Title = "INVENTORY",
				Position = UDim2.fromScale(0.15, -0.03),
				Size = UDim2.fromScale(0.5, 0.5),
			}),
		}
	)
end]]

return CreateInventory
