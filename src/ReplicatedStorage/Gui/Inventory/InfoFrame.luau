--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local UIStroke = require(CoreGame.UIStroke)
local Main = require(CoreGame.Main)
local UnitView = require(CoreGame.UnitView)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)
local Types = require(Shared.Types)

local UnitModels = ReplicatedStorage.ModelStorage.Units
local UnitAnimations = ReplicatedStorage.Animations.Units
export type InfoType = "Unit" | "Gamepass"

export type UnitData = Types.VisualUnitData

export type Data = UnitData

export type Properties = {
	Visible: boolean,

	Type: InfoType | string,
	Name: string?,
	Rarity: string?,
	IsEquipped: boolean,

	Data: Data?,
	RarityInfo: RarityInfo.RarityInfo?,

	OnEquipClick: () -> ()?,
	OnSellClick: () -> ()?,
}

local function CreateInfoFrame(Properties: Properties)
	local IsUnit = React.useMemo(function()
		return Properties.Type == "Unit"
	end, { Properties.Type })

	local HasValue = React.useMemo(function()
		if Properties.Data then
			return true
		else
			return false
		end
	end, { Properties.Data })

	local RotationCFrame = React.useBinding(CFrame.Angles(math.rad(20), 0, 0))

	local BarSize = React.useMemo(function()
		if IsUnit and Properties.Data then
			return UDim2.fromScale(Properties.Data.XP / Properties.Data.NeededXP, 0.9)
		else
			return UDim2.fromScale(0, 0)
		end
	end, { IsUnit, HasValue })

	local XPText = React.useMemo(function()
		if IsUnit and Properties.Data then
			return string.format("%u/%u", Properties.Data.XP, Properties.Data.NeededXP)
		else
			return ""
		end
	end, { IsUnit, HasValue })

	return e(Main.ImageLabel, {
		native = {
			Position = UDim2.fromScale(0.85, 0.6),
			Size = UDim2.fromScale(0.2, 0.7),
			Image = "rbxassetid://75971006528952",
			Visible = Properties.Visible,
		},
	}, {
		ViewportFrame = e(UnitView, {
			UnitName = Properties.Name,
			Distance = 4,
			RotationCFrame = RotationCFrame,
			Offset = Vector3.new(0, -1, 0),
			native = {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.9, 0.45),
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
			Camera = e("Camera", {
				CFrame = CFrame.new(0, 0, 0),
			}),
		}),
		EquipButton = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.5, 0.92),
				Size = UDim2.fromScale(0.8, 0.125),
				Image = "rbxassetid://72606508098140",
				[React.Event.MouseButton1Click] = Properties.OnEquipClick,
			},
		}, {
			TextLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.6, 0.6),
					Text = Properties.IsEquipped and "Unequip" or "Equip",
					TextColor3 = Color3.new(1, 1, 1),
				},
			}),
		}),
		InfoButton = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.8, 0.66),
				Size = UDim2.fromScale(0.21, 0.12),
				Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		SellButton = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.5, 0.79),
				Size = UDim2.fromScale(0.8, 0.125),
				Image = "rbxassetid://135833754402129",
				ImageColor3 = Color3.fromRGB(255, 43, 47),
				[React.Event.MouseButton1Click] = Properties.OnSellClick,
			},
		}, {
			TextLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.6, 0.6),
					Text = "Sell",
					TextColor3 = Color3.new(1, 1, 1),
				},
			}),
		}),
		Bar = e(Main.CanvasGroup, {
			native = {
				BackgroundColor3 = Color3.new(0.588235, 0.109804, 0.843137),
				BackgroundTransparency = 0,
				Position = UDim2.fromScale(0.5, 0.28),
				Size = UDim2.fromScale(0.7, 0.055),
				Visible = IsUnit,
			},
		}, {
			BarOverlay = e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.99, 0.9),
				},
			}, {
				InnerBar = e(Main.Frame, {
					native = {
						BackgroundTransparency = 0,
						BackgroundColor3 = Color3.fromRGB(255, 0, 201),
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Size = BarSize,
					},
				}, {
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),
			}),
			XPLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.99, 0.9),
					Text = XPText,
					ZIndex = 2,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
		}),
		NameLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.1),
				Size = UDim2.fromScale(0.8, 0.12),
				Text = Properties.Name,
				TextXAlignment = Enum.TextXAlignment.Left,
			},
		}, {
			UIStroke = e(UIStroke.UIStroke, {
				Stroke = 0.002,
				GradColor = Properties.RarityInfo and Properties.RarityInfo.StrokeColor,
			}),
			UIGradient = e("UIGradient", {
				Color = Properties.RarityInfo and Properties.RarityInfo.Color,
			}),
		}),
		RarityLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.19),
				Size = UDim2.fromScale(0.8, 0.05),
				Text = Properties.Rarity,
				TextXAlignment = Enum.TextXAlignment.Left,
			},
		}, {
			UIStroke = e(UIStroke.UIStroke, {
				Stroke = 0.002,
				GradColor = Properties.RarityInfo and Properties.RarityInfo.StrokeColor,
			}),
			UIGradient = e("UIGradient", {
				Color = Properties.RarityInfo and Properties.RarityInfo.Color,
			}),
		}),
	})
end

return CreateInfoFrame
