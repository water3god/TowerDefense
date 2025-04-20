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

local Trade = Gui.Trade
local TradeFrame = require(Trade.TradeFrame)
local TradeMenu = require(Trade.TradeMenu)

local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local MainButtonFrame = require(CoreGame.MainButtonFrame)
local Hooks = require(CoreGame.Hooks)

local GameFrames = Gui.GameFrames
local Bottom = require(GameFrames.Bottom)
local Top = require(GameFrames.Top)

local Story = Gui.Story
local MainStory = require(Story.MainStory)
local WaitingFrame = require(Story.WaitingFrame)

-- Contexts --
local InventoryContext = require(Inventory.InventoryContext)
local TradeMenuContext = require(Trade.TradeContext)
local EquippedUnitsContext = require(GameFrames.EquippedUnitsContext)
local WaveContext = require(GameFrames.WaveContext)
local StoryContext = require(Story.StoryContext)

local IsRunning = RunService:IsRunning()

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)

local Constants = require(script.Constants)
local OriginalPositions = require(script.OriginalPositions)

export type InventoryProps = {
	CloseClick: () -> (),
	Visible: boolean,
}

export type TradeMenuProps = {
	CloseClick: () -> (),
	Visible: boolean,
}

export type TradeFrameProps = {
	Toggle: (Visible: boolean) -> (),
	Visible: boolean,
}

export type StoryFrameProps = {
	Visible: boolean,
}

local GlobalNotVisiblePosition = UDim2.fromScale(0.5, 2)

local function AnimateWrapper(Props: { Visible: boolean, Name: string })
	local Styles, API = ReactSpring.useSpring(function()
		return {
			alpha = 1,
		}
	end)

	local OriginalPosition, SetPosition = React.useState(nil :: UDim2?)
	local NotVisiblePosition, SetNotVisiblePosition = React.useState(GlobalNotVisiblePosition)

	React.useEffect(function()
		SetPosition(OriginalPositions[Props.Name])
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
	end) :: React.Binding<UDim2>,
		Styles.alpha:map(function(alpha)
			return alpha ~= 1
		end) :: React.Binding<boolean>
end

local RenderInventory = React.forwardRef(function(Props: InventoryProps, ref)
	local Position, Visiblity = AnimateWrapper({
		Visible = Props.Visible,
		Name = Constants.INVENTORY_FRAME,
	})

	return e(Hooks.ContextStack, {
		providers = {
			InventoryContext.Provider,
			EquippedUnitsContext.Provider,
		},
	}, {
		InventoryMain = e(InventoryMain, {
			CloseClick = Props.CloseClick,
			ref = ref,
			native = {
				Position = Position,
				Visible = Visiblity,
			},
		}),
	})
end)

local function RenderTradeMenu(Props: TradeMenuProps)
	local Position, Visiblity = AnimateWrapper({
		Visible = Props.Visible,
		Name = Constants.TRADE_MENU,
	})

	return e(TradeMenuContext.Provider, {}, {
		TradeMenu = e(TradeMenu, {
			CloseClick = Props.CloseClick,
			native = {
				Position = Position,
				Visible = Visiblity,
			},
		}),
	})
end

local function RenderTradeFrame(Props: TradeFrameProps)
	local Position, Visiblity = AnimateWrapper({
		Visible = Props.Visible,
		Name = Constants.TRADE_FRAME,
	})

	return e(TradeFrame, {
		Toggle = Props.Toggle,
		native = {
			Position = Position,
			Visible = Visiblity,
		},
	})
end

local function RenderStoryFrame(Props: any)
	local Position, Visiblity = AnimateWrapper({
		Visible = Props.Visible,
		Name = Constants.STORY_FRAME,
	})

	return e(StoryContext.Provider, {}, {
		MainStory = e(MainStory, {
			Toggle = Props.Toggle,
			IsVisible = Props.Visible,
			native = {
				Position = Position,
				Visible = Visiblity,
			},
		}),
	})
end

local function Render()
	local VisibleFrame: string?, SetVisibleFrame = React.useState(nil :: string?)

	local Styles, API = ReactSpring.useSpring(function()
		return {
			Size = 0,
		}
	end)

	local InventoryRef = React.useRef(nil)

	local SetHovered = React.useCallback(function(HoveredId: string?)
		if InventoryRef.current then
			InventoryRef.current.Hover(HoveredId)
		end
	end, {})

	local GetHovered = React.useCallback(function(): string?
		if InventoryRef.current then
			return InventoryRef.current.GetHovered()
		end

		return nil
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
	end, { VisibleFrame })

	local SetVisibleInternal = React.useCallback(function(Name: string, Visible: boolean)
		if Visible then
			SetVisibleFrame(Name)
		else
			if VisibleFrame == Name then
				SetVisibleFrame(nil)
			end
		end
	end, { VisibleFrame })

	React.useEffect(function()
		API.stop()
		API.start({
			Size = if VisibleFrame then 20 else 0,
		})
	end, { VisibleFrame })

	return e(React.Fragment, nil, {
		GuiBlur = IsRunning and ReactRoblox.createPortal(
			e("BlurEffect", {
				Size = Styles.Size,
			}),
			Lighting
		),
		Main = IsLobby and e(
			"Folder",
			{},
			{
				[Constants.INVENTORY_FRAME] = e(RenderInventory, {
					Visible = if VisibleFrame == Constants.INVENTORY_FRAME then true else false,
					ref = InventoryRef,
					CloseClick = function()
						OnCloseClick(Constants.INVENTORY_FRAME)
					end,
				}),
			} :: any,
			{
				[Constants.TRADE_FRAME] = e(RenderTradeFrame, {
					Visible = if VisibleFrame == Constants.TRADE_FRAME then true else false,
					Toggle = function(Visible)
						SetVisibleInternal(Constants.TRADE_FRAME, Visible)
					end,
				}),
			} :: any,
			{
				[Constants.TRADE_MENU] = e(RenderTradeMenu, {
					Visible = if VisibleFrame == Constants.TRADE_MENU then true else false,
					CloseClick = function()
						OnCloseClick(Constants.TRADE_MENU)
					end,
				}) :: any,
				[Constants.STORY_FRAME] = e(RenderStoryFrame, {
					Visible = if VisibleFrame == Constants.STORY_FRAME then true else false,
					Toggle = function(Visible)
						SetVisibleInternal(Constants.STORY_FRAME, Visible)
					end,
					CloseClick = function()
						OnCloseClick(Constants.STORY_FRAME)
					end,
				}) :: any,
			}
		),
		OtherGui = e("Folder", {}, {
			TopFrame = not IsLobby and e(WaveContext.Provider, {}, {
				TopFrame = e(Top),
			}),
			BottomFrame = e(EquippedUnitsContext.Provider, {}, {
				BottomFrame = e(Bottom, {
					SetHovered = SetHovered,
					GetHovered = GetHovered,
					SetVisible = function(Visible: boolean)
						SetVisibleInternal(Constants.INVENTORY_FRAME, Visible)
					end,
				}),
			}),
			WaitingFrame = IsLobby and e(StoryContext.Provider, {}, {
				WaitingFrame = e(WaitingFrame, {}, {}),
			}),
		}),
		Buttons = IsLobby and e(Main.Frame, {
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
						OnMainButtonClick(Constants.INVENTORY_FRAME)
					end,
				}),
				PlayButton = e(MainButtonFrame, {
					Position = UDim2.fromScale(0.1, 0.5),
					Size = UDim2.fromScale(0.1, 0.15),
					Name = "Play",
					Icon = "",
					OnClick = function()
						--OnMainButtonClick("InventoryFrame")
					end,
				}),
				StoreButton = e(MainButtonFrame, {
					Position = UDim2.fromScale(0.1, 0.5),
					Size = UDim2.fromScale(0.1, 0.15),
					Name = "Store",
					Icon = "",
					OnClick = function()
						--OnMainButtonClick("InventoryFrame")
					end,
				}),
				TradeButton = e(MainButtonFrame, {
					Position = UDim2.fromScale(0.1, 0.5),
					Size = UDim2.fromScale(0.1, 0.15),
					Name = "Trade",
					Icon = "",
					OnClick = function()
						OnMainButtonClick(Constants.TRADE_MENU)
					end,
				}),
			},
		}),
	})
end

return Render
