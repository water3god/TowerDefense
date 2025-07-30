--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

-- Packages --

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Trove = require(Packages.Trove)
local Input = require(Packages.Input)
local Touch = Input.Touch
local Mouse = Input.Mouse
local Gamepad = Input.Gamepad

local Network = ReplicatedStorage.Network
local ClientOnly = require(Network.ClientOnly)

local Modules = ReplicatedStorage.Modules
local ContextActionUtility = require(Modules.ContextActionUtility)
local HelperFunctions = require(Modules.HelperFunctions)

-- Gui --

local Gui = ReplicatedStorage.Gui

local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local MainButtonFrame = require(CoreGame.MainButtonFrame)
local NewGui = require(CoreGame.NewGui)
local Hooks = require(CoreGame.Hooks)

local GameFrames = Gui.GameFrames
local Bottom = require(GameFrames.Bottom)
local Top = require(GameFrames.Top)
local VoteFrame = require(GameFrames.VoteFrame)
local EndFrame = require(GameFrames.EndFrame)
local UpgradeFrame = require(GameFrames.UpgradeFrame)
local UnitToolTip = require(GameFrames.UnitToolTip)
local EnemyToolTip = require(GameFrames.EnemyToolTip)
local StarterChoose = require(GameFrames.StarterChoose)

local Inventory = Gui.Inventory
local InventoryMain = require(Inventory.InventoryMain)
local ClickedInventory = require(Inventory.ClickedInventory)
local TitlesFrame = require(Inventory.TitlesFrame)

local Trade = Gui.Trade
local TradeFrame = require(Trade.TradeFrame)
local TradeMenu = require(Trade.TradeMenu)
local TradePopup = require(Trade.TradePopup)

local Story = Gui.Story
local MainStory = require(Story.MainStory)
local WaitingFrame = require(Story.WaitingFrame)

local Roll = Gui.Roll
local InRoll = require(Roll.InRoll)
local RollMain = require(Roll.RollMain)

local WarningFolder = Gui.Warning
local Warning = require(WarningFolder.Warning)

local SettingFolder = Gui.Settings
local Settings = require(SettingFolder.Settings)

local StoreFolder = Gui.Store
local Store = require(StoreFolder.Store)

local TipsFolder = Gui.Tips
local TipsGui = require(TipsFolder.TipsGui)

local DailyFolder = Gui.Daily
local DailyFrame = require(DailyFolder.DailyFrame)

local QuestsFolder = Gui.Quests
local QuestsFrame = require(QuestsFolder.QuestsFrame)

local TraitsFolder = Gui.Traits
local Evolution = require(TraitsFolder.Evolution)

-- Contexts --
local InventoryContext = require(Inventory.InventoryContext)
local PromptContext = require(Inventory.PromptContext)
local TradeMenuContext = require(Trade.TradeContext)
local EquippedUnitsContext = require(GameFrames.EquippedUnitsContext)
local WaveContext = require(GameFrames.WaveContext)
local UpgradeContext = require(GameFrames.UpgradeContext)
local CurrencyContext = require(GameFrames.Currency)
local StoryContext = require(Story.StoryContext)
local RollContext = require(Roll.RollContext)
local WarningContext = require(WarningFolder.WarningContext)
local SettingContext = require(SettingFolder.SettingsContext)
local PurchaseContext = require(StoreFolder.PurchaseContext)
local TipsContext = require(TipsFolder.TipsContext)
local DailyContext = require(DailyFolder.DailyContext)
local QuestsContext = require(QuestsFolder.QuestsContext)

local IsRunning = RunService:IsRunning()

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)
local EnemyClient = require(GlobalClient.EnemyClient)

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)
local Variables = require(Shared.Variables)

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
			config = { mass = 1, tension = 190, friction = 22, velocity = 0.01 :: any },
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

	return e(InventoryMain, {
		CloseClick = Props.CloseClick,
		ref = ref,
		native = {
			Position = Position,
			Visible = Visiblity,
		},
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
		RollFrame = e(RollMain, {
			CloseClick = Props.CloseClick,
			SetVisible = Props.SetVisible,
			native = {
				Position = Position,
				Visible = Visiblity,
			},
		}),
	})
end

local function RenderSettings(Props)
	local Position, Visiblity = AnimateWrapper({
		Visible = Props.Visible,
		Name = Constants.SETTINGS,
	})

	return e(Settings.Create, {
		CloseClick = Props.CloseClick,
		native = {
			Position = Position,
			Visible = Visiblity,
		},
	})
end

local function RenderStore(Props)
	local Position, Visiblity = AnimateWrapper({
		Visible = Props.Visible,
		Name = Constants.STORE,
	})

	return e(Store, {
		CloseClick = Props.CloseClick,
		native = {
			Position = Position,
			Visible = Visiblity,
		},
	})
end

local function RenderDailyFrame(Props: any)
	local Position, Visiblity = AnimateWrapper({
		Visible = Props.Visible,
		Name = Constants.DAILY_FRAME,
	})

	return e(DailyFrame, {
		CloseClick = Props.CloseClick,
		native = {
			Position = Position,
			Visible = Visiblity,
		},
	})
end

local function RenderTitlesFrame(Props: any)
	local Position, Visiblity = AnimateWrapper({
		Visible = Props.Visible,
		Name = Constants.TITLES_FRAME,
	})

	return e(TitlesFrame.Connected, {
		CloseClick = Props.CloseClick,
		native = {
			Position = Position,
			Visible = Visiblity,
		},
	})
end

local function RenderQuestsFrame(Props: any)
	local Position, Visiblity = AnimateWrapper({
		Visible = Props.Visible,
		Name = Constants.QUESTS_FRAME,
	})

	return e(QuestsFrame, {
		CloseClick = Props.CloseClick,
		native = {
			Position = Position,
			Visible = Visiblity,
		},
	})
end

local function RenderStarterChoose(Props: any)
	local Position, Visiblity = AnimateWrapper({
		Visible = Props.Visible,
		Name = Constants.STARTER_CHOOSE,
	})

	return e(StarterChoose, {
		CloseClick = Props.CloseClick,
		SetVisible = Props.SetVisible,
		native = {
			Position = Position,
			Visible = Visiblity,
		},
	})
end

local function RenderEvolution(Props: any)
	local Position, Visiblity = AnimateWrapper({
		Visible = Props.Visible,
		Name = Constants.EVOLUTION,
	})

	return e(Evolution, {
		CloseClick = Props.CloseClick,
		SetVisible = Props.SetVisible,
		native = {
			Position = Position,
			Visible = Visiblity,
		},
	})
end

local function HandleToolTips(props: { PlacingUnitId: string?, SetUnitId: (string: string?) -> () })
	local HoveredDataRef = React.useRef(nil :: {
		Type: "Unit" | "Enemy",
		Id: string,
	}?)
	local HoveredData: {
		Type: "Unit" | "Enemy",
		Id: string,
	}?, SetHoveredData = React.useState(nil :: {
		Type: "Unit" | "Enemy",
		Id: string,
	}?)
	local HoveredPos, SetHoveredPos = React.useBinding(Vector2.new())

	local PlacingUnitId = React.useRef(props.PlacingUnitId)

	React.useEffect(function()
		PlacingUnitId.current = props.PlacingUnitId
	end, { props.PlacingUnitId })

	if not IsLobby then
		React.useEffect(function()
			for _, Unit in pairs(UnitClient.GetUnits()) do
				if Unit.IsClicked then
					Unit:ClickCharacter(false)
				end
			end
			if props.PlacingUnitId then
				local Unit = UnitClient.GetUnit(props.PlacingUnitId)
				if Unit and not Unit.IsClicked then
					Unit:ClickCharacter(true)
				end
			end
		end, { props.PlacingUnitId })

		React.useEffect(function()
			if props.PlacingUnitId then
				local Unit = UnitClient.GetUnit(props.PlacingUnitId)
				if Unit then
					local Connection = Unit.CharacterClicked:Connect(function(Enabled: boolean)
						if Enabled == false then
							props.SetUnitId(nil)
						end
					end)

					return function()
						Connection:Disconnect()
					end
				end
			end
			return function() end
		end, { props.PlacingUnitId })

		Hooks.useEventConnection(UnitClient.NewUnit, function(Unit, New: boolean)
			if New and Unit.OwnerId == Player.UserId then
				if props.PlacingUnitId ~= Unit.UniqueId then
					props.SetUnitId(Unit.UniqueId)
				end
			end
		end, { props.PlacingUnitId })

		React.useEffect(function()
			local Params = RaycastParams.new()
			Params.CollisionGroup = "PlacedCharacters"

			local function OnPress(Position: Vector2)
				local Result = HelperFunctions.Raycast(Position, Params)
				if Result and Result.Instance then
					if Result.Instance:IsDescendantOf(GlobalWorkspace) then
						for _, Unit in pairs(UnitClient.GetUnits()) do
							if Unit:PartIsDescendantOf(Result.Instance) and not Variables.InPlacement then
								props.SetUnitId(Unit.UniqueId)
								return
							end
						end
					end
				end
				props.SetUnitId(nil)
			end

			local function OnFrame(Position: Vector2)
				local NewHoveredData = HoveredDataRef.current
				local Result = HelperFunctions.Raycast(Position, Params)
				if Result and Result.Instance then
					if Result.Instance:IsDescendantOf(GlobalWorkspace) then
						for _, Unit in pairs(UnitClient.GetUnits()) do
							if PlacingUnitId.current == Unit.UniqueId then
								continue
							end
							if Unit:PartIsDescendantOf(Result.Instance) then
								if not NewHoveredData or NewHoveredData.Id ~= Unit.UniqueId then
									SetHoveredData({
										Type = "Unit",
										Id = Unit.UniqueId,
									})
									HoveredDataRef.current = {
										Type = "Unit",
										Id = Unit.UniqueId,
									}
								end
								SetHoveredPos(Position)
								return
							end
						end
						for _, Enemy in pairs(EnemyClient.GetEnemies()) do
							if Enemy:PartIsDescendantOf(Result.Instance) then
								if not NewHoveredData or NewHoveredData.Id ~= Enemy.UniqueId then
									SetHoveredData({
										Type = "Enemy",
										Id = Enemy.UniqueId,
									})
									HoveredDataRef.current = {
										Type = "Enemy",
										Id = Enemy.UniqueId,
									}
								end
								SetHoveredPos(Position)
								return
							end
						end
					end
				end

				SetHoveredData(nil)
				HoveredDataRef.current = nil
			end

			local InputTrove = Trove.new()

			local Disconnect = Input.PreferredInput.Observe(function(Preferred)
				InputTrove:Destroy()
				if Preferred == "MouseKeyboard" then
					local NewMouse = InputTrove:Construct(Mouse)

					NewMouse.LeftUp:Connect(function()
						OnPress(Mouse:GetPosition())
					end)

					InputTrove:Connect(RunService.PostSimulation, function()
						OnFrame(Mouse:GetPosition())
					end)
				elseif Preferred == "Gamepad" then
					local NewGamepad = InputTrove:Construct(Gamepad)
					NewGamepad.ButtonA:Connect(function()
						OnPress(NewGamepad:GetPosition())
					end)
				elseif Preferred == "Touch" then
					local NewTouch = InputTrove:Construct(Touch)

					NewTouch.TouchTapInWorld:Connect(function(TouchPosition: Vector2, Processed: boolean)
						if Processed then
							return
						end

						OnPress(TouchPosition)
					end)

					NewTouch.TouchMoved:Connect(function(InputObject: InputObject, Processed: boolean)
						if Processed then
							return
						end

						OnFrame(Vector2.new(InputObject.Position.X, InputObject.Position.Y))
					end)
				end
			end)

			return function()
				InputTrove:Destroy()
				Disconnect()
			end
		end, {})
	end

	return e(React.Fragment, nil, {
		UpgradeContext = e(UpgradeContext.Provider, {
			UnitId = props.PlacingUnitId,
		}, {
			UpgradeContainer = e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.fromScale(0.4, 0.55),
					AnchorPoint = Vector2.new(0, 0.5),
				},
			}, {
				UpgradeFrame = e(UpgradeFrame, {
					IsVisible = props.PlacingUnitId ~= nil and UnitClient.GetUnit(props.PlacingUnitId) ~= nil,
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
	})
end

local PlayCFrame = CFrame.new(145.5, 7.834, 143.5) * CFrame.Angles(0, math.rad(25), 0)
local SummonCFrame = CFrame.new(-155, 10, -215)

local VisibleFrames = {
	[Constants.INVENTORY_FRAME] = { "Bottom" },
	[Constants.IN_ROLL] = { "Bottom" },
	[Constants.ROLL_FRAME] = { "Bottom" },
	[Constants.STORY_FRAME] = {},
	[Constants.TRADE_MENU] = {},
	[Constants.TRADE_FRAME] = {},
	[Constants.SETTINGS] = {},
	[Constants.STORE] = {},
	[Constants.DAILY_FRAME] = {},
	[Constants.TITLES_FRAME] = {},
	[Constants.QUESTS_FRAME] = {},
	[Constants.STARTER_CHOOSE] = {},
	[Constants.EVOLUTION] = {},
}

local NoBlur = {
	Constants.IN_ROLL,
}

local CharacterConfig = { mass = 1, tension = 500, friction = 40, velocity = 0.01 :: any }

local Params = RaycastParams.new()
Params.CollisionGroup = "PlacedCharacters"

local function Render()
	local VisibleFrame: string?, SetVisibleFrame = React.useState(nil :: string?)
	local Character = Hooks.useCharacter()
	local Camera = Hooks.useCamera()

	local VisibleFrameBinding, SetVisibleFrameBinding = React.useBinding(VisibleFrame)

	React.useEffect(function()
		if VisibleFrame then
			SetVisibleFrameBinding(VisibleFrame)
		end
	end, { VisibleFrame })

	local Styles, API = ReactSpring.useSpring(function()
		return {
			Size = 0,
			Inverted = 0,
			FieldOfView = 70,
			config = { mass = 1, tension = 190, friction = 19, velocity = 0.01 :: any },
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
		if Character and not VisibleFrame then
			Character:PivotTo(PlayCFrame)
		end
	end, { VisibleFrame, Character :: any })

	local OnSummon = React.useCallback(function()
		if Character and not VisibleFrame then
			Character:PivotTo(SummonCFrame)
		end
	end, { VisibleFrame, Character :: any })

	local PlacingUnitId: string?, SetUnitId = React.useState(nil :: string?)

	local OnBottomUnitClick = React.useCallback(function()
		SetUnitId(nil)
	end, { PlacingUnitId })

	local SprintAnim = React.useRef(nil :: AnimationTrack?)

	React.useEffect(function()
		local StopFrame = VisibleFrame and not table.find(NoBlur, VisibleFrame)
		if Character then
			local SprintTrove = Trove.new()

			if not SprintAnim then
				SprintAnim = Character
			end

			if StopFrame then
				Character:SetAttribute("WalkSpeed", 24)
				ClientOnly.ChangeWalk:Fire(false)
			end

			local InSprint = VisibleFrame and not table.find(NoBlur, VisibleFrame)

			local function Start()
				if not StopFrame then
					API.start({
						FieldOfView = 80,
						config = CharacterConfig,
					})
					Character:SetAttribute("WalkSpeed", 40)
					ClientOnly.ChangeWalk:Fire(true)

					InSprint = true
				end
			end

			local function Stop()
				if not StopFrame then
					API.start({
						FieldOfView = 70,
						config = CharacterConfig,
					})
					Character:SetAttribute("WalkSpeed", 24)
					ClientOnly.ChangeWalk:Fire(false)
					InSprint = false
				end
			end

			SprintTrove:Connect(GuiService.MenuOpened, function()
				Stop()
			end)

			local CleanUp = Input.PreferredInput.Observe(function(PreferredInput)
				if PreferredInput == "MouseKeyboard" then
					local Keyboard = SprintTrove:Construct(Input.Keyboard)

					Keyboard.KeyDown:Connect(function(Key: Enum.KeyCode)
						if Key == Enum.KeyCode.LeftShift then
							Start()
						end
					end)

					Keyboard.KeyUp:Connect(function(Key: Enum.KeyCode)
						if Key == Enum.KeyCode.LeftShift then
							Stop()
						end
					end)
				elseif PreferredInput == "Touch" then
					ContextActionUtility:BindAction("Sprint", function(_, input)
						if input == Enum.UserInputState.Begin then
							if InSprint then
								Stop()
							else
								Start()
							end
						end
					end, true)
					ContextActionUtility:SetTitle("Sprint", "Sprint")
				end
			end)

			return function()
				SprintTrove:Destroy()
				CleanUp()
				ContextActionUtility:UnbindAction("Sprint")
			end
		else
			API.start({
				FieldOfView = if VisibleFrame and not table.find(NoBlur, VisibleFrame) then 65 else 70,
				config = CharacterConfig,
			})

			return function() end
		end
	end, { Character, VisibleFrame })

	React.useEffect(function()
		API.start({
			Size = if VisibleFrame and not table.find(NoBlur, VisibleFrame) then 20 else 0,
			Inverted = if VisibleFrame then 1 else 0,
		})
		API.start({
			FieldOfView = if VisibleFrame and not table.find(NoBlur, VisibleFrame) then 65 else 70,
			config = CharacterConfig,
		})
	end, { VisibleFrame })

	return e(
		Hooks.ContextStack,
		{
			providers = {
				WarningContext.Provider,
				CurrencyContext.Provider,
				SettingContext.Provider,
				InventoryContext.Provider,
				EquippedUnitsContext.Provider,
				PurchaseContext.Provider,
				TipsContext.Provider,
				DailyContext.Provider,
				QuestsContext.Provider,
				PromptContext.Provider,
			},
		},
		{
			FieldOfView = e("Folder", {
				Archivable = IsRunning and Styles.FieldOfView:map(function(FieldOfView: number)
					Camera.FieldOfView = FieldOfView
					return true
				end) or true,
			}),
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
						Visible = VisibleFrame == Constants.INVENTORY_FRAME,
						ref = InventoryRef,
						CloseClick = function()
							OnCloseClick(Constants.INVENTORY_FRAME)
						end,
					}),
					[Constants.TRADE_FRAME] = e(RenderTradeFrame, {
						Visible = VisibleFrame == Constants.TRADE_FRAME,
						Toggle = function(Visible)
							SetVisibleInternal(Constants.TRADE_FRAME, Visible)
						end,
					}),
					[Constants.TRADE_MENU] = e(RenderTradeMenu, {
						Visible = VisibleFrame == Constants.TRADE_MENU,
						CloseClick = function()
							OnCloseClick(Constants.TRADE_MENU)
						end,
					}),
					[Constants.STORY_FRAME] = e(RenderStoryFrame, {
						Visible = VisibleFrame == Constants.STORY_FRAME,
						Toggle = function(Visible)
							SetVisibleInternal(Constants.STORY_FRAME, Visible)
						end,
						CloseClick = function()
							OnCloseClick(Constants.STORY_FRAME)
						end,
					}),
					[Constants.STORE] = e(RenderStore, {
						Visible = VisibleFrame == Constants.STORE,
						CloseClick = function()
							OnCloseClick(Constants.STORE)
						end,
					}),
					[Constants.ROLL_FRAME] = e(RenderRollFrame, {
						Visible = VisibleFrame == Constants.ROLL_FRAME,
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
					}),
					[Constants.DAILY_FRAME] = e(RenderDailyFrame, {
						Visible = VisibleFrame == Constants.DAILY_FRAME,
						CloseClick = function()
							OnCloseClick(Constants.DAILY_FRAME)
						end,
					}),
					[Constants.TITLES_FRAME] = e(RenderTitlesFrame, {
						Visible = VisibleFrame == Constants.TITLES_FRAME,
						CloseClick = function()
							OnCloseClick(Constants.TITLES_FRAME)
						end,
					}),
					[Constants.QUESTS_FRAME] = e(RenderQuestsFrame, {
						Visible = VisibleFrame == Constants.QUESTS_FRAME,
						CloseClick = function()
							OnCloseClick(Constants.QUESTS_FRAME)
						end,
					}),
					[Constants.STARTER_CHOOSE] = e(RenderStarterChoose, {
						Visible = VisibleFrame == Constants.STARTER_CHOOSE,
						CloseClick = function()
							OnCloseClick(Constants.STARTER_CHOOSE)
						end,
						SetVisible = function(Visible: boolean)
							SetVisibleInternal(Constants.STARTER_CHOOSE, Visible)
						end,
					}),
					[Constants.EVOLUTION] = e(RenderEvolution, {
						Visible = VisibleFrame == Constants.EVOLUTION,
						CloseClick = function()
							OnCloseClick(Constants.EVOLUTION)
						end,
						SetVisible = function()
							SetVisibleRetricted(Constants.EVOLUTION, true)
						end,
					}),
				} :: { [string]: React.Node }
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
					ToolTips = e(HandleToolTips, {
						PlacingUnitId = PlacingUnitId,
						SetUnitId = SetUnitId,
					}),
				}),
				LobbyOnly = IsLobby and e("Folder", {}, {
					TradePopup = e(TradePopup.Connected),
					WaitingFrame = e(StoryContext.Provider, {}, {
						WaitingFrame = e(WaitingFrame),
					}),
					TipsGui = e(TipsGui),
					ClickedInventory = e(ClickedInventory.Connected),
				}),

				BottomFrame = e(Bottom, {
					SetHovered = SetHovered,
					GetHovered = GetHovered,
					UnitClick = OnBottomUnitClick,
					SetVisible = function(Visible: boolean)
						SetVisibleInternal(Constants.INVENTORY_FRAME, Visible)
					end,
					native = {
						Position = React.joinBindings({ Styles.Inverted :: any, VisibleFrameBinding })
							:map(function(NewData: { any })
								if NewData[2] and table.find(VisibleFrames[NewData[2]], "Bottom") then
									return UDim2.fromScale(0.5, 0.9)
								else
									return UDim2.fromScale(0.5, 0.9):Lerp(UDim2.fromScale(0.5, 1.2), NewData[1])
								end
							end),
					},
				}),
			}),
			LeftButtons = IsLobby and e(Main.Frame, {
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
					IconColor = ColorSequence.new(Color3.fromRGB(255, 200, 50), Color3.fromRGB(180, 120, 0)), -- Bright Yellow to Dark Orange
					BackgroundColor = ColorSequence.new(Color3.fromRGB(120, 90, 30), Color3.fromRGB(90, 60, 15)), -- Orange-Yellow to Dark Orange-Yellow
					OnClick = function()
						OnMainButtonClick(Constants.INVENTORY_FRAME)
					end,
				}),
				PlayButton = e(MainButtonFrame, {
					Position = UDim2.fromScale(0.1, 0.5),
					Size = UDim2.fromScale(0.1, 0.15),
					Name = "Play",
					Icon = "rbxassetid://123087872755553",
					IconColor = ColorSequence.new(Color3.fromRGB(50, 255, 50), Color3.fromRGB(0, 150, 0)), -- Bright Green to Dark Green
					BackgroundColor = ColorSequence.new(Color3.fromRGB(30, 110, 70), Color3.fromRGB(20, 70, 50)), -- Light Green to Medium Green
					OnClick = OnPlay,
				}),
				StoreButton = e(MainButtonFrame, {
					Position = UDim2.fromScale(0.1, 0.5),
					Size = UDim2.fromScale(0.1, 0.15),
					Name = "Store",
					Icon = "rbxassetid://101802087294765",
					IconColor = ColorSequence.new(Color3.fromRGB(255, 100, 255), Color3.fromRGB(150, 0, 150)), -- Bright Magenta to Dark Magenta
					BackgroundColor = ColorSequence.new(Color3.fromRGB(120, 50, 120), Color3.fromRGB(75, 15, 75)), -- Magenta to Dark Magenta
					OnClick = function()
						OnMainButtonClick(Constants.STORE)
					end,
				}),
				SummonButton = e(MainButtonFrame, {
					Position = UDim2.fromScale(0.1, 0.5),
					Size = UDim2.fromScale(0.1, 0.15),
					Name = "Summon",
					Icon = "rbxassetid://103961311594276",
					IconColor = ColorSequence.new(Color3.fromRGB(100, 200, 255), Color3.fromRGB(0, 100, 200)), -- Bright Blue to Dark Blue
					BackgroundColor = ColorSequence.new(Color3.fromRGB(50, 90, 110), Color3.fromRGB(30, 60, 80)), -- Light Blue to Medium Blue
					OnClick = OnSummon,
				}),
				TradeButton = e(MainButtonFrame, {
					Position = UDim2.fromScale(0.1, 0.5),
					Size = UDim2.fromScale(0.1, 0.15),
					Name = "Trade",
					Icon = "rbxassetid://71136210616050",
					IconColor = ColorSequence.new(Color3.fromRGB(255, 150, 50), Color3.fromRGB(200, 80, 0)), -- Bright Orange to Dark Orange
					BackgroundColor = ColorSequence.new(Color3.fromRGB(110, 70, 50), Color3.fromRGB(80, 50, 30)), -- Light Brown to Medium Brown
					OnClick = function()
						OnMainButtonClick(Constants.TRADE_MENU)
					end,
				}),
			}),
			RightButtons = IsLobby and e(Main.Frame, {
				native = {
					Position = Styles.Inverted:map(function(Size: number)
						return UDim2.fromScale(0.9, 0.5):Lerp(UDim2.fromScale(1.1, 0.5), Size)
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
				DailyButton = e(MainButtonFrame, {
					Position = UDim2.fromScale(0.9, 0.5),
					Size = UDim2.fromScale(0.1, 0.15),
					Name = "Daily",
					Icon = "rbxassetid://118717037434015",
					IconColor = ColorSequence.new(Color3.fromRGB(255, 50, 50), Color3.fromRGB(180, 0, 0)), -- Bright Red to Dark Red
					BackgroundColor = ColorSequence.new(Color3.fromRGB(110, 50, 50), Color3.fromRGB(80, 30, 30)), -- Light Red to Medium Red
					OnClick = function()
						OnMainButtonClick(Constants.DAILY_FRAME)
					end,
				}),
				TitlesButton = e(MainButtonFrame, {
					Position = UDim2.fromScale(0.9, 0.5),
					Size = UDim2.fromScale(0.1, 0.15),
					Name = "Titles",
					Icon = "rbxassetid://95049959452468",
					IconColor = ColorSequence.new(Color3.fromRGB(100, 255, 200), Color3.fromRGB(0, 180, 120)), -- Bright Cyan to Dark Teal
					BackgroundColor = ColorSequence.new(Color3.fromRGB(50, 110, 90), Color3.fromRGB(30, 70, 60)), -- Light Teal to Medium Teal
					OnClick = function()
						OnMainButtonClick(Constants.TITLES_FRAME)
					end,
				}),
				QuestsButton = e(MainButtonFrame, {
					Position = UDim2.fromScale(0.9, 0.5),
					Size = UDim2.fromScale(0.1, 0.15),
					Name = "Quests",
					Icon = "rbxassetid://126483259351802",
					IconColor = ColorSequence.new(Color3.fromRGB(200, 100, 255), Color3.fromRGB(120, 0, 200)), -- Bright Purple to Dark Purple
					BackgroundColor = ColorSequence.new(Color3.fromRGB(90, 60, 110), Color3.fromRGB(60, 40, 80)), -- Light Purple to Medium Purple
					OnClick = function()
						OnMainButtonClick(Constants.QUESTS_FRAME)
					end,
				}),
			}),
			SettingButton = e(MainButtonFrame, {
				Position = UDim2.fromScale(0.9, 0.05),
				Size = UDim2.fromScale(0.1, 0.08),
				Name = "Settings",
				Icon = "rbxassetid://133964081103849",
				IconColor = ColorSequence.new(Color3.fromRGB(255, 255, 100), Color3.fromRGB(200, 200, 0)), -- Bright Yellow to Dark Yellow
				BackgroundColor = ColorSequence.new(Color3.fromRGB(110, 110, 50), Color3.fromRGB(80, 80, 30)), -- Light Yellow to Medium Yellow
				OnClick = function()
					OnMainButtonClick(Constants.SETTINGS)
				end,
			}),
			[Constants.SETTINGS] = e(RenderSettings, {
				Visible = if VisibleFrame == Constants.SETTINGS then true else false,
				CloseClick = function()
					OnCloseClick(Constants.SETTINGS)
				end,
			}),
			WarningGui = e(NewGui, {
				DisplayOrder = 1001,
			}, {
				Warnings = e(Warning),
			}),
		} :: { [string]: React.Node }
	)
end

return Render
