--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local Inventory = Gui.Inventory
local InventoryMain = require(Inventory.InventoryMain)

local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local MainButtonFrame = require(CoreGame.MainButtonFrame)

local IsRunning = RunService:IsRunning()

local Client = ReplicatedStorage.Client
local InventoryService = require(Client.GlobalClient.InventoryService)

local Shared = ReplicatedStorage.Shared
local Types = require(Shared.Types)

local Constants = require(script.Constants)
local OriginalPositions = require(script.OriginalPositions)

export type Properties = {
	Inventory: {
		Units: { [string]: Types.VisualUnitData },
	},
	Visible: boolean,
}

local GlobalNotVisiblePosition = UDim2.fromScale(0.5, 2)

local function AnimateWrapper(Props: { Visible: boolean })
	local Styles, API = ReactSpring.useSpring(function()
		return {
			alpha = 0,
		}
	end)

	local FrameRef = React.useRef(nil :: GuiObject?)
	local OriginalPosition, SetPosition = React.useState(nil :: UDim2?)
	local NotVisiblePosition, SetNotVisiblePosition = React.useState(GlobalNotVisiblePosition)

	React.useEffect(function()
		if FrameRef.current then
			SetPosition(OriginalPositions[FrameRef.current.Name])
		end
	end, {})

	React.useEffect(function()
		if OriginalPosition then
			SetNotVisiblePosition(UDim2.fromScale(OriginalPosition.X.Scale, 2))
		end
	end, { OriginalPosition })

	React.useEffect(function()
		API.start({
			alpha = if Props.Visible then 0 else 1,
		})
	end, { Props.Visible })

	return Styles.alpha:map(function(alpha)
		if OriginalPosition and NotVisiblePosition then
			return OriginalPosition:Lerp(NotVisiblePosition, alpha)
		else
			return GlobalNotVisiblePosition
		end
	end),
		FrameRef
end

local function RenderInventory(Props: Properties)
	local Styles, FrameRef = AnimateWrapper({
		Visible = Props.Visible,
	})

	return e(InventoryMain, {
		Inventory = Props.Inventory,
		native = {
			ref = FrameRef,
			Position = Styles,
		},
	})
end

local function Render()
	local VisibleFrame: string?, SetVisibleFrame = React.useState(nil :: string?)

	local Styles, API = ReactSpring.useSpring(function()
		return {
			Size = 0,
		}
	end)

	local OnMainButtonClick = React.useCallback(function(Name: string)
		if VisibleFrame == Name then
			SetVisibleFrame(nil)
		else
			SetVisibleFrame(Name)
		end
	end, { VisibleFrame })

	local OnCloseClick = React.useCallback(function(Name: string)
		if VisibleFrame == Name then
			SetVisibleFrame(nil)
		end
	end)

	React.useEffect(function()
		API.stop()
		API.start({
			Size = if VisibleFrame then 20 else 0,
		})
	end, { VisibleFrame })

	local function Return()
		return e(React.Fragment, nil, {
			GuiBlur = IsRunning and ReactRoblox.createPortal(
				e("BlurEffect", {
					Size = Styles.Size,
				}),
				Lighting
			),
			Main = e(
				"Folder",
				{},
				{
					[Constants.INVENTORY_FRAME] = e(RenderInventory, {
						Visible = if VisibleFrame == Constants.INVENTORY_FRAME then true else false,
						Inventory = InventoryService:GetInventory(),
						CloseClick = function()
							OnCloseClick(Constants.INVENTORY_FRAME)
						end,
					}),
				} :: any
			),
			Buttons = e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(0.1, 0.5),
					Size = UDim2.fromScale(0.15, 0.4),
				},
				children = {
					UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
						AspectRatio = 0.62,
					}),
					UIGridLayout = e("UIGridLayout", {
						CellPadding = UDim2.fromScale(0, 0),
						CellSize = UDim2.fromScale(0.5, 0.3),
						FillDirection = Enum.FillDirection.Horizontal,
					}),
					InventoryButton = e(MainButtonFrame, {
						Position = UDim2.fromScale(0.1, 0.5),
						Size = UDim2.fromScale(0.1, 0.15),
						Name = "Inventory",
						Icon = "",
						OnClick = function()
							OnMainButtonClick("InventoryFrame")
						end,
					}),
					PlayButton = e(MainButtonFrame, {
						Position = UDim2.fromScale(0.1, 0.5),
						Size = UDim2.fromScale(0.1, 0.15),
						Name = "Play",
						Icon = "",
						OnClick = function()
							OnMainButtonClick("InventoryFrame")
						end,
					}),
					StoreButton = e(MainButtonFrame, {
						Position = UDim2.fromScale(0.1, 0.5),
						Size = UDim2.fromScale(0.1, 0.15),
						Name = "Store",
						Icon = "",
						OnClick = function()
							OnMainButtonClick("InventoryFrame")
						end,
					}),
					TradeButton = e(MainButtonFrame, {
						Position = UDim2.fromScale(0.1, 0.5),
						Size = UDim2.fromScale(0.1, 0.15),
						Name = "Trade",
						Icon = "",
						OnClick = function()
							OnMainButtonClick("InventoryFrame")
						end,
					}),
				},
			}),
		})
	end
	if IsRunning then
		return e("ScreenGui", {
			ResetOnSpawn = false,
		}, {
			Frag = Return(),
		}) :: any
	else
		return e(Main.Frame, {
			children = {
				Name = Return(),
			},
		}) :: any
	end
end

return Render
