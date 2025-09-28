--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local ReactSpring = require(Packages.ReactSpring)
local React = require(Packages.React)
local e = React.createElement

local Trove = require(Packages.Trove)
local Input = require(Packages.Input)
local Keyboard = Input.Keyboard
local Gamepad = Input.Gamepad

local Modules = ReplicatedStorage.Modules
local DelayHandler = require(Modules.DelayHandler)
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Events = require(ReplicatedStorage.Network.ClientOnly)
local PlacementFinished = Events.PlacementFinished

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)
local InventoryService = require(GlobalClient.InventoryService)

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)

local UnitFrame = require(Gui.Inventory.UnitFrame)

local GameFrames = Gui.GameFrames
local EquippedUnitsContext = require(GameFrames.EquippedUnitsContext)
local Currency = require(GameFrames.Currency)
local WaveContext = require(GameFrames.WaveContext)

local Message = Gui.Message
local Indicator = require(Message.Indicator)

local Shared = ReplicatedStorage.Shared
local LevelRequirements = require(Shared.LevelRequirements)
local IsLobby = require(Shared.IsLobby)

export type Properties = {
	SetHovered: (HoveredId: string?) -> ()?,
	SetVisible: ((Visible: boolean) -> ())?,
	GetHovered: (() -> string?)?,
	SetPlacingId: ((UniqueId: string?) -> ())?,
	UnitClick: (() -> ())?,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type OtherProps = {
	UniqueId: string?,
	UnitName: string?,
	GlobalLevel: number,
	Level: number?,
	LevelReq: number,
	Trait: string?,

	OnClick: (UniqueId: string) -> (),

	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateBaseFrame(Properties: OtherProps)
	local BelowLevel = Properties.GlobalLevel < Properties.LevelReq
	local IsDisabled = BelowLevel or not Properties.UnitName

	local OnClick = React.useCallback(function()
		if Properties.UniqueId then
			Properties.OnClick(Properties.UniqueId)
		end
	end, { Properties.UniqueId, Properties.OnClick } :: { unknown })

	return e(UnitFrame.CreateUnitFrame, {
		UnitName = if Properties.UnitName and not IsDisabled then Properties.UnitName else "BLANK",
		Disabled = IsDisabled,
		Level = Properties.Level or 1,
		Trait = Properties.Trait,
		native = Properties.native,
		OnClick = OnClick,
		containerChildren = {
			Lock = e(Main.ImageLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.4),
					Size = UDim2.fromScale(0.4, 0.4),
					Visible = BelowLevel,
					Image = "rbxassetid://106849723034867",
					ZIndex = 2,
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 0.83,
				}),
			}),
			LevelLock = e(Main.TextLabel, {
				native = {
					Visible = BelowLevel,
					Position = UDim2.fromScale(0.5, 0.75),
					Size = UDim2.fromScale(0.85, 0.2),
					Text = string.format("Level %u", Properties.LevelReq or 1),
				},
			}),
		},
	}, Properties.children)
end

local UnitFrameSize = UDim2.fromScale(0.25, 0.65)

local Positions = {
	0.15,
	0.325,
	0.5,
	0.675,
	0.85,
}

type PlacementData = {
	Trove: Trove.Trove,
	UniqueId: string,
}

local CreateBottomFrame = React.forwardRef(function(Properties: Properties, ref)
	local UnitsContext = React.useContext(EquippedUnitsContext.Context)
	local CurrencyContext = React.useContext(Currency.Context)
	local WaveData = React.useContext(WaveContext.Context)
	local Units = UnitsContext.Units

	local SizeStyles, API = ReactSpring.useSpring(function()
		return {
			Size = 1,
		}
	end)

	React.useEffect(function()
		API.start({
			Size = 1.2,
			immediate = true,
		}):andThen(function()
			API.start({
				Size = 1,
				config = { mass = 1, tension = 400, friction = 30 },
			})
		end)
	end, { CurrencyContext.Value })

	React.useImperativeHandle(ref, function()
		return {
			Click = function() end,
		}
	end, {})

	local LobbyClick = React.useCallback(function(UniqueId: string)
		if Properties.SetHovered and Properties.GetHovered and Properties.SetVisible then
			if Properties.GetHovered() ~= UniqueId then
				Properties.SetHovered(UniqueId)
			end
			if Properties.SetVisible then
				Properties.SetVisible(true)
			end
		end
	end, { Properties.SetHovered, Properties.SetVisible, Properties.GetHovered } :: { unknown })

	local PlacementData: PlacementData?, SetPlacement = React.useState(nil :: PlacementData?)

	React.useEffect(function()
		if PlacementData and Properties.SetPlacingId then
			Properties.SetPlacingId(PlacementData.UniqueId)
		end
	end, { PlacementData })

	local GameClick = React.useCallback(function(UniqueId: string)
		if not DelayHandler("GameClick", 0.1) then
			return
		end
		local Unit = InventoryService:GetInventory().Units[UniqueId]
		if PlacementData then
			PlacementData.Trove:Destroy()
		end
		if Properties.UnitClick then
			Properties.UnitClick()
		end

		if Unit then
			if PlacementData and PlacementData.UniqueId == UniqueId then
				SetPlacement(nil)
			else
				local InitData = UnitClient.InitPlacement(Unit.Unit)
				SetPlacement({
					Trove = InitData.Trove,
					UniqueId = UniqueId,
				})

				InitData.Clicked:Connect(function()
					SetPlacement(nil)
				end)
			end
		end
	end, { PlacementData })

	if not IsLobby then
		Hooks.useEventConnection(PlacementFinished, function()
			if PlacementData then
				GameClick(PlacementData.UniqueId)
			end
		end, { GameClick, PlacementData })

		React.useEffect(function()
			local InputTrove = Trove.new()

			local Cancel = Input.PreferredInput.Observe(function(Preferred)
				InputTrove:Destroy()
				if Preferred == "MouseKeyboard" then
					local NewKeyboard = InputTrove:Construct(Keyboard)

					NewKeyboard.KeyDown:Connect(function(KeyCode: Enum.KeyCode)
						if KeyCode.Value >= 49 and KeyCode.Value <= 53 then
							local Key = KeyCode.Value - 48

							if Units[Key] then
								GameClick(Units[Key].UniqueId)
							end
						elseif KeyCode == Enum.KeyCode.Q then
							if PlacementData and PlacementData.UniqueId then
								local Index = nil

								for i, Unit in ipairs(Units) do
									if Unit.UniqueId == PlacementData.UniqueId then
										Index = i
										break
									end
								end

								if Index then
									GameClick(Units[Index].UniqueId)
								end
							end
						end
					end)
				elseif Preferred == "Gamepad" then
					local NewGamepad = InputTrove:Construct(Gamepad)

					NewGamepad.ButtonDown:Connect(function(Button: Enum.KeyCode, Processed: boolean)
						if Processed then
							return
						end
						if Button == Enum.KeyCode.ButtonA then
							if PlacementData and PlacementData.UniqueId then
								local Index = nil

								for i, Unit in ipairs(Units) do
									if Unit.UniqueId == PlacementData.UniqueId then
										Index = i
										break
									end
								end

								if Index then
									GameClick(Units[Index].UniqueId)
								end
							end
						end
					end)
				end
			end)

			return function()
				InputTrove:Destroy()
				Cancel()
			end
		end, { Units, GameClick, PlacementData } :: { unknown })
	end

	local Click = IsLobby and LobbyClick or GameClick

	if IsLobby then
		React.useEffect(function()
			if WaveData.StartTime == 0 and WaveData.Time == 0 then
				SetPlacement(nil)
			end
		end, { WaveData })
	end

	local CurrencyValue = React.useMemo(function()
		return HelperFunctions.NumberScaler.ShortenNumber(CurrencyContext.Value)
	end, { CurrencyContext.Value })

	local BarSize = React.useMemo(function()
		return UDim2.fromScale(math.clamp(UnitsContext.XP / UnitsContext.NeededXP, 0, 1), 1)
	end, { UnitsContext.XP, UnitsContext.NeededXP })

	local LevelXP = React.useMemo(function()
		return string.format("Level %u (%u/%u)", UnitsContext.GlobalLevel, UnitsContext.XP, UnitsContext.NeededXP)
	end, { UnitsContext.GlobalLevel, UnitsContext.XP, UnitsContext.NeededXP })

	local FirstFrameIndicator = React.useMemo(function()
		return e(Indicator, {
			Wave = 1,
		})
	end, {})

	local CoreFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for i = 1, 5, 1 do
			Frames["Frame" .. i] = e(CreateBaseFrame, {
				UniqueId = Units[i] and Units[i].UniqueId,
				LevelReq = LevelRequirements.EquippedFrames[i],
				UnitName = Units[i] and Units[i].Unit,
				Level = Units[i] and Units[i].Level,
				Trait = Units[i] and Units[i].Trait,
				GlobalLevel = UnitsContext.GlobalLevel,
				OnClick = Click,
				native = {
					Position = UDim2.fromScale(Positions[i], 0.35),
					Size = UnitFrameSize,
				},
			}, {
				Indicator = i == 1 and FirstFrameIndicator,
			})
		end

		return Frames
	end, { Units, UnitsContext.GlobalLevel, Click } :: { unknown })

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(0.7, 0.2),
		}, Properties.native),
	}, {
		UISizeConstraint = e("UISizeConstraint", {
			MinSize = Vector2.new(320, 90),
			MaxSize = Vector2.new(600, 170),
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 3.555,
		}),

		InPlacementLabel = PlacementData and e(Main.TextLabel, {
			native = {
				Text = "Placing Unit...",
				Size = UDim2.fromScale(0.8, 0.2),
				Position = UDim2.fromScale(0.5, -0.4),
				TextColor3 = Color3.new(0, 1, 0),
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.01,
			}),
		}),

		GoldFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, -0.1),
				Size = SizeStyles.Size:map(function(Size: number)
					return UDim2.fromScale(0.5 * Size, 0.175 * Size)
				end),
			},
		}, {
			Back = e(Main.Frame, {
				native = {
					Size = UDim2.fromScale(0.7, 1),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 0,
					ZIndex = 0,
				},
			}, {
				UIGradient = e("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(225, 228, 12)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(228, 224, 20)),
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.4, 0.5),
						NumberSequenceKeypoint.new(0.6, 0.5),
						NumberSequenceKeypoint.new(1, 1),
					}),
				}),
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.1, 0),
				}),
			}),
			Container = e(Main.Frame, {}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 0),
				}),
				Icon = e(Main.ImageLabel, {
					native = {
						Position = UDim2.fromScale(0.5, 0.5),
						Image = CurrencyContext.Icon,
					},
				}, {
					UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
						AspectRatio = 1,
					}),
				}),
				Label = e(Main.TextLabel, {
					native = {
						Text = CurrencyValue,
						AutomaticSize = Enum.AutomaticSize.X,
						AutoLocalize = false,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.fromScale(0.1, 1),
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.001,
					}),
					UIPadding = e("UIPadding", {
						PaddingLeft = UDim.new(0.05, 0),
					}),
				}),
			}),
		}),
		LevelBar = e(Main.CanvasGroup, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(64, 64, 64),
				Position = UDim2.fromScale(0.5, 0.8),
				Size = UDim2.fromScale(0.9, 0.2),
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.01,
				native = {
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.5, 0),
			}),
			ProgressBar = e(Main.Frame, {
				native = {
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(35, 35, 35),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0, 0.5),
					Size = BarSize,
				},
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.5, 0),
				}),
			}),
			LevelLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.3, 0.8),
					Text = LevelXP,
					ZIndex = 2,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.015,
				}),
			}),
		}),
	}, CoreFrames, Properties.children)
end)

return CreateBottomFrame
