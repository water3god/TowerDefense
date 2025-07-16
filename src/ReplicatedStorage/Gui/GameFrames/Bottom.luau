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

local Modules = ReplicatedStorage.Modules
local DelayHandler = require(Modules.DelayHandler)
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local UnitFrame = require(Gui.Inventory.UnitFrame)

local GameFrames = Gui.GameFrames
local EquippedUnitsContext = require(GameFrames.EquippedUnitsContext)
local Currency = require(GameFrames.Currency)
local WaveContext = require(GameFrames.WaveContext)

local Shared = ReplicatedStorage.Shared
local LevelRequirements = require(Shared.LevelRequirements)
local IsLobby = require(Shared.IsLobby)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)
local InventoryService = require(GlobalClient.InventoryService)

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
	end, { Properties.UniqueId :: any, Properties.OnClick :: any })

	return e(UnitFrame.CreateUnitFrame, {
		UnitName = if Properties.UnitName and not IsDisabled then Properties.UnitName else "BLANK",
		Disabled = IsDisabled,
		Level = Properties.Level or 1,
		native = Properties.native,
		children = Properties.children,
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
	})
end

local UnitFrameSize = UDim2.fromScale(0.25, 0.65)

type PlacementData = {
	Trove: Trove.Trove,
	UniqueId: string,
}

local CreateBottomFrame = React.forwardRef(function(Properties: Properties, ref)
	local UnitsContext = React.useContext(EquippedUnitsContext.Context)
	local CurrencyContext = React.useContext(Currency.Context)
	local WaveData = React.useContext(WaveContext.Context)
	local Units = UnitsContext.Units

	local SizeStyles = ReactSpring.useSpring({
		from = {
			Size = 1.2,
		},
		to = {
			Size = 1,
		},
		config = { mass = 1, tension = 100, friction = 20 },
	}, { CurrencyContext.Value })

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
	end, { Properties.SetHovered :: any, Properties.SetVisible :: any, Properties.GetHovered :: any })

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
		React.useEffect(function()
			local InputTrove = Trove.new()
			local NewKeyboard = InputTrove:Construct(Keyboard)

			NewKeyboard.KeyDown:Connect(function(KeyCode: Enum.KeyCode)
				if KeyCode.Value >= 49 and KeyCode.Value <= 53 then
					local Key = KeyCode.Value - 48

					if Units[Key] then
						GameClick(Units[Key].UniqueId)
					end
				end
			end)

			return InputTrove:WrapClean()
		end, { Units, PlacementData :: any })
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

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(0.4, 0.2),
		}, Properties.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 3.555,
		}),
		GoldFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, -0.1),
				Size = SizeStyles.Size:map(function(Size: number)
					return UDim2.fromScale(0.5 * Size, 0.2 * Size)
				end),
			},
		}, {
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 0),
			}),
			Frame = e(Main.Frame, {
				native = {
					Size = UDim2.fromScale(0.45, 1),
				},
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
					AutoLocalize = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.fromScale(0.6, 1),
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.02,
				}),
				UIPadding = e("UIPadding", {
					PaddingLeft = UDim.new(0.05, 0),
				}),
			}),
		}),
		Frame1 = e(CreateBaseFrame, {
			UniqueId = Units[1] and Units[1].UniqueId,
			LevelReq = LevelRequirements.EquippedFrames[1],
			UnitName = Units[1] and Units[1].Unit,
			Level = Units[1] and Units[1].Level,
			GlobalLevel = UnitsContext.GlobalLevel,
			OnClick = Click,
			native = {
				Position = UDim2.fromScale(0.15, 0.35),
				Size = UnitFrameSize,
			},
		}),
		Frame2 = e(CreateBaseFrame, {
			UniqueId = Units[2] and Units[2].UniqueId,
			LevelReq = LevelRequirements.EquippedFrames[2],
			UnitName = Units[2] and Units[2].Unit,
			Level = Units[2] and Units[2].Level,
			GlobalLevel = UnitsContext.GlobalLevel,
			OnClick = Click,
			native = {
				Position = UDim2.fromScale(0.325, 0.35),
				Size = UnitFrameSize,
			},
		}),
		Frame3 = e(CreateBaseFrame, {
			UniqueId = Units[3] and Units[3].UniqueId,
			LevelReq = LevelRequirements.EquippedFrames[3],
			UnitName = Units[3] and Units[3].Unit,
			Level = Units[3] and Units[3].Level,
			GlobalLevel = UnitsContext.GlobalLevel,
			OnClick = Click,
			native = {
				Position = UDim2.fromScale(0.5, 0.35),
				Size = UnitFrameSize,
			},
		}),
		Frame4 = e(CreateBaseFrame, {
			UniqueId = Units[4] and Units[4].UniqueId,
			LevelReq = LevelRequirements.EquippedFrames[4],
			UnitName = Units[4] and Units[4].Unit,
			Level = Units[4] and Units[4].Level,
			GlobalLevel = UnitsContext.GlobalLevel,
			OnClick = Click,
			native = {
				Position = UDim2.fromScale(0.675, 0.35),
				Size = UnitFrameSize,
			},
		}),
		Frame5 = e(CreateBaseFrame, {
			UniqueId = Units[5] and Units[5].UniqueId,
			LevelReq = LevelRequirements.EquippedFrames[5],
			UnitName = Units[5] and Units[5].Unit,
			Level = Units[5] and Units[5].Level,
			GlobalLevel = UnitsContext.GlobalLevel,
			OnClick = Click,
			native = {
				Position = UDim2.fromScale(0.85, 0.35),
				Size = UnitFrameSize,
			},
		}),
		LevelBar = e(Main.ImageLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.8),
				Size = UDim2.fromScale(1, 0.2),
				Image = "rbxassetid://110783523635885",
			},
		}, {
			Container = e(Main.Frame, {
				native = {
					Size = UDim2.fromScale(0.995, 0.92),
				},
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.5, 0),
				}),
				ProgressBar = e(Main.Frame, {
					native = {
						BackgroundTransparency = 0,
						BackgroundColor3 = Color3.fromRGB(104, 36, 132),
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Size = BarSize,
					},
				}, {
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(0.5, 0),
					}),
				}),
			}),
			LevelLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.3, 0.8),
					Text = LevelXP,
					ZIndex = 2,
				},
			}),
		}),
	}, Properties.children)
end)

return CreateBottomFrame
