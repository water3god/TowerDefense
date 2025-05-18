--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Trove = require(Packages.Trove)
local TableUtil = require(Packages.TableUtil)
local Input = require(Packages.Input)
local Touch = Input.Touch
local Keyboard = Input.Keyboard
local Mouse = Input.Mouse
local Gamepad = Input.Gamepad

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

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
local VoteFrame = require(GameFrames.VoteFrame)
local EndFrame = require(GameFrames.EndFrame)
local UpgradeFrame = require(GameFrames.UpgradeFrame)
local UnitToolTip = require(GameFrames.UnitToolTip)
local EnemyToolTip = require(GameFrames.EnemyToolTip)

local Story = Gui.Story
local MainStory = require(Story.MainStory)
local WaitingFrame = require(Story.WaitingFrame)

local Roll = Gui.Roll
local InRoll = require(Roll.InRoll)
local RollMain = require(Roll.RollMain)

-- Contexts --
local InventoryContext = require(Inventory.InventoryContext)
local TradeMenuContext = require(Trade.TradeContext)
local EquippedUnitsContext = require(GameFrames.EquippedUnitsContext)
local WaveContext = require(GameFrames.WaveContext)
local UpgradeContext = require(GameFrames.UpgradeContext)
local CurrencyContext = require(GameFrames.Currency)
local StoryContext = require(Story.StoryContext)
local RollContext = require(Roll.RollContext)

local IsRunning = RunService:IsRunning()

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)
local EnemyClient = require(GlobalClient.EnemyClient)

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)

local Constants = require(script.Constants)
local OriginalPositions = require(script.OriginalPositions)
local Restricted = require(script.Restricted)

local GlobalWorkspace = workspace.GlobalWorkspace

local Player = Players.LocalPlayer

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

local function RenderRollFrame(Props: any)
	local Position, Visiblity = AnimateWrapper({
		Visible = Props.Visible,
		Name = Constants.ROLL_FRAME,
	})

	return e(RollContext.Provider, {}, {
		MainStory = e(RollMain, {
			CloseClick = Props.CloseClick,
			SetVisible = Props.SetVisible,
			native = {
				Position = Position,
				Visible = Visiblity,
			},
		}),
	})
end

local PlayCFrame = CFrame.new(145.5, 7.834, 143.5) * CFrame.Angles(0, math.rad(25), 0)
local SummonCFrame = CFrame.new(-170, 10, -215)

local function Render()
	local VisibleFrame: string?, SetVisibleFrame = React.useState(nil :: string?)

	local Styles, API = ReactSpring.useSpring(function()
		return {
			Size = 0,
			Inverted = 0,
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
		if VisibleFrame and table.find(Restricted, VisibleFrame) then
			if VisibleFrame ~= Name then
				return
			end
		end
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

	local SetVisibleRetricted = React.useCallback(function(Name: string, Visible: boolean)
		if VisibleFrame and table.find(Restricted, VisibleFrame) then
			if VisibleFrame ~= Name then
				return
			end
		end

		if Visible then
			SetVisibleFrame(Name)
		else
			if VisibleFrame == Name then
				SetVisibleFrame(nil)
			end
		end
	end, { VisibleFrame })

	local OnPlay = React.useCallback(function()
		local Character = Player.Character

		if Character then
			Character:PivotTo(PlayCFrame)
		end
	end, {})

	local OnSummon = React.useCallback(function()
		local Character = Player.Character

		if Character then
			Character:PivotTo(SummonCFrame)
		end
	end, {})

	local PlacingUnitId: string?, SetUnitId = React.useState(nil :: string?)
	local HoveredData: {
		Type: "Unit" | "Enemy",
		Id: string,
	}?, SetHoveredData = React.useState(nil :: {
		Type: "Unit" | "Enemy",
		Id: string,
	}?)
	local HoveredPos, SetHoveredPos = React.useBinding(Vector2.new())

	local OnBottomUnitClick = React.useCallback(function()
		SetUnitId(nil)
	end, { PlacingUnitId })

	if not IsLobby then
		React.useEffect(function()
			for _, Unit in pairs(UnitClient.GetUnits()) do
				if Unit.IsClicked then
					Unit:ClickCharacter(false)
				end
			end
			if PlacingUnitId then
				local Unit = UnitClient.GetUnit(PlacingUnitId)
				if Unit and not Unit.IsClicked then
					Unit:ClickCharacter(true)
				end
			end
		end, { PlacingUnitId })

		React.useEffect(function()
			local Params = RaycastParams.new()
			Params.CollisionGroup = "PlacedCharacters"

			local function OnPress(Position: Vector2)
				local Result = HelperFunctions.Raycast(Position, Params)
				if Result and Result.Instance then
					if Result.Instance:IsDescendantOf(GlobalWorkspace) then
						for _, Unit in pairs(UnitClient.GetUnits()) do
							if Unit:PartIsDescendantOf(Result.Instance) then
								SetUnitId(Unit.UniqueId)
								return
							end
						end
					end
				end
				SetUnitId(nil)
			end

			local Count = 0

			local function OnFrame(Position: Vector2)
				local Result = HelperFunctions.Raycast(Position, Params)
				if Result and Result.Instance then
					if Result.Instance:IsDescendantOf(GlobalWorkspace) then
						for _, Unit in pairs(UnitClient.GetUnits()) do
							if PlacingUnitId == Unit.UniqueId then
								continue
							end
							if Unit:PartIsDescendantOf(Result.Instance) then
								if not HoveredData or HoveredData.Id ~= Unit.UniqueId then
									SetHoveredData({
										Type = "Unit",
										Id = Unit.UniqueId,
									})
								end
								SetHoveredPos(Position)
								return
							end
						end
						for _, Enemy in pairs(EnemyClient.GetEnemies()) do
							if Enemy:PartIsDescendantOf(Result.Instance) then
								if not HoveredData or HoveredData.Id ~= Enemy.UniqueId then
									SetHoveredData({
										Type = "Enemy",
										Id = Enemy.UniqueId,
									})
								end
								SetHoveredPos(Position)
								return
							end
						end
					end
				end

				if Count > 10 then
					Count = 0
					SetHoveredData(nil)
				else
					Count += 1
				end
			end

			local Trove = Trove.new()

			local Disconnect = Input.PreferredInput.Observe(function(Preferred)
				Trove:Destroy()
				if Preferred == "MouseKeyboard" then
					local Mouse = Trove:Construct(Mouse)
					local Keyboard = Trove:Construct(Keyboard)

					Mouse.LeftDown:Connect(function()
						OnPress(Mouse:GetPosition())
					end)

					Trove:Connect(RunService.PostSimulation, function()
						OnFrame(Mouse:GetPosition())
					end)
				elseif Preferred == "Gamepad" then
				elseif Preferred == "Touch" then
					local Touch = Trove:Construct(Touch)

					Touch.TouchTap:Connect(function(TouchPositions: { Vector2 }, Processed: boolean)
						if Processed then
							return
						end

						OnFrame(TouchPositions[1])
						OnPress(TouchPositions[1])
					end)
				end
			end)

			return function()
				Trove:Destroy()
				Disconnect()
			end
		end, {})
	end

	React.useEffect(function()
		API.stop()
		API.start({
			Size = if VisibleFrame then 20 else 0,
			Inverted = if VisibleFrame then 1 else 0,
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
				[Constants.TRADE_FRAME] = e(RenderTradeFrame, {
					Visible = if VisibleFrame == Constants.TRADE_FRAME then true else false,
					Toggle = function(Visible)
						SetVisibleInternal(Constants.TRADE_FRAME, Visible)
					end,
				}) :: any,
				[Constants.TRADE_MENU] = e(RenderTradeMenu, {
					Visible = if VisibleFrame == Constants.TRADE_MENU then true else false,
					CloseClick = function()
						OnCloseClick(Constants.TRADE_MENU)
					end,
				}),
				[Constants.STORY_FRAME] = e(RenderStoryFrame, {
					Visible = if VisibleFrame == Constants.STORY_FRAME then true else false,
					Toggle = function(Visible)
						SetVisibleInternal(Constants.STORY_FRAME, Visible)
					end,
					CloseClick = function()
						OnCloseClick(Constants.STORY_FRAME)
					end,
				}),
				[Constants.ROLL_FRAME] = e(RenderRollFrame, {
					Visible = if VisibleFrame == Constants.ROLL_FRAME then true else false,
					CloseClick = function()
						OnCloseClick(Constants.ROLL_FRAME)
					end,
					SetVisible = function()
						SetVisibleRetricted(Constants.ROLL_FRAME, true)
					end,
				}),
				[Constants.IN_ROLL] = e(InRoll.Connected, {
					SetVisible = function(Visible: boolean)
						SetVisibleInternal(Constants.IN_ROLL, Visible)
					end,
					CloseClick = function()
						SetVisibleInternal(Constants.ROLL_FRAME, true)
					end,
				}) :: any,
			} :: any
		),
		OtherGui = e("Folder", {}, {
			GameOnly = not IsLobby and e("Folder", {}, {
				TopFrame = e(WaveContext.Provider, {}, {
					TopFrame = e(Top),
				}),
				VoteFrame = e(VoteFrame),
				EndFrame = e(EndFrame.Connected, {
					Enabled = true,
				}),
				UpgradeContext = e(UpgradeContext.Provider, {
					UnitId = PlacingUnitId,
				}, {
					UpgradeContainer = e(Main.Frame, {
						native = {
							Position = UDim2.fromScale(0, 0.5),
							Size = UDim2.fromScale(0.4, 0.55),
							AnchorPoint = Vector2.new(0, 0.5),
						},
					}, {
						UpgradeFrame = e(UpgradeFrame, {
							IsVisible = PlacingUnitId ~= nil and UnitClient.GetUnit(PlacingUnitId) ~= nil,
						}),
					}),
				}),
				UnitToolTip = e(UnitToolTip.Connected, {
					UnitId = HoveredData and HoveredData.Type == "Unit" and HoveredData.Id :: any,
					Position = HoveredPos,
					native = {
						Visible = HoveredData ~= nil and HoveredData.Type == "Unit",
					},
				}),
				EnemyToolTip = e(EnemyToolTip.Connected, {
					EnemyId = HoveredData and HoveredData.Type == "Enemy" and HoveredData.Id :: any,
					Position = HoveredPos,
					native = {
						Visible = HoveredData ~= nil and HoveredData.Type == "Enemy",
					},
				}),
			}),
			LobbyOnly = IsLobby and e("Folder", {}, {
				WaitingFrame = e(StoryContext.Provider, {}, {
					WaitingFrame = e(WaitingFrame),
				}),
			}),

			BottomFrame = e(Hooks.ContextStack, {
				providers = {
					EquippedUnitsContext.Provider,
					CurrencyContext.Provider,
				},
			}, {
				BottomFrame = e(Bottom, {
					SetHovered = SetHovered,
					GetHovered = GetHovered,
					UnitClick = OnBottomUnitClick,
					SetVisible = function(Visible: boolean)
						SetVisibleInternal(Constants.INVENTORY_FRAME, Visible)
					end,
					native = {
						Position = Styles.Inverted:map(function(Size: number)
							return UDim2.fromScale(0.5, 0.9):Lerp(UDim2.fromScale(0.5, 1.2), Size)
						end),
					},
				}),
			}),
		}),
		Buttons = IsLobby and e(Main.Frame, {
			native = {
				Position = Styles.Inverted:map(function(Size: number)
					return UDim2.fromScale(0.1, 0.5):Lerp(UDim2.fromScale(-0.1, 0.5), Size)
				end),
				Size = UDim2.fromScale(0.15, 0.4),
			},
		}, {
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
				Icon = "rbxassetid://126162489334707",
				OnClick = function()
					OnMainButtonClick(Constants.INVENTORY_FRAME)
				end,
			}),
			PlayButton = e(MainButtonFrame, {
				Position = UDim2.fromScale(0.1, 0.5),
				Size = UDim2.fromScale(0.1, 0.15),
				Name = "Play",
				Icon = "rbxassetid://123087872755553",
				OnClick = OnPlay,
			}),
			StoreButton = e(MainButtonFrame, {
				Position = UDim2.fromScale(0.1, 0.5),
				Size = UDim2.fromScale(0.1, 0.15),
				Name = "Store",
				Icon = "rbxassetid://101802087294765",
				OnClick = function()
					--OnMainButtonClick("InventoryFrame")
				end,
			}),
			SummonButton = e(MainButtonFrame, {
				Position = UDim2.fromScale(0.1, 0.5),
				Size = UDim2.fromScale(0.1, 0.15),
				Name = "Summon",
				Icon = "rbxassetid://103961311594276",
				OnClick = OnSummon,
			}),
			TradeButton = e(MainButtonFrame, {
				Position = UDim2.fromScale(0.1, 0.5),
				Size = UDim2.fromScale(0.1, 0.15),
				Name = "Trade",
				Icon = "rbxassetid://71136210616050",
				IconColor = ColorSequence.new(Color3.fromRGB(137, 77, 178)),
				OnClick = function()
					OnMainButtonClick(Constants.TRADE_MENU)
				end,
			}),
		}),
	})
end

return Render
