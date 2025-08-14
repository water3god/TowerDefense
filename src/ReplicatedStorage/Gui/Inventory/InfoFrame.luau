--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local UIStroke = require(CoreGame.UIStroke)
local Main = require(CoreGame.Main)
local UnitView = require(CoreGame.UnitView)
local AnimatedGradient = require(CoreGame.AnimatedGradient)

local StoreFolder = Gui.Store
local PurchaseContext = require(StoreFolder.PurchaseContext)

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)
local ProductInfo = require(Shared.ProductInfo)
local RarityInfo = require(Shared.RarityInfo)
local Types = require(Shared.Types)

export type InfoType = "Unit" | "Product" | "Resource"

export type UnitData = Types.VisualUnitData

export type Data = UnitData

export type Properties = {
	Visible: boolean,

	Type: InfoType | string,
	Name: string?,
	Rarity: string?,
	IsEquipped: boolean,

	FirstText: string?,

	Data: any,
	RarityInfo: RarityInfo.RarityInfo?,

	OnInfoClick: (() -> ())?,

	OnFirstClick: (() -> ())?,
	OnSellClick: (() -> ())?,
}

local function CreateInfoFrame(Properties: Properties)
	local PurchaseData = React.useContext(PurchaseContext.Context)

	local IsUnit = React.useMemo(function()
		return Properties.Type == "Unit"
	end, { Properties.Type })

	local RotationCFrame = React.useBinding(CFrame.Angles(math.rad(20), 0, 0))

	local BarSize = React.useMemo(function()
		if IsUnit and Properties.Data then
			return UDim2.fromScale(Properties.Data.XP / Properties.Data.NeededXP, 0.9)
		else
			return UDim2.fromScale(0, 0)
		end
	end, { IsUnit, Properties.Data } :: { unknown })

	local XPText = React.useMemo(function()
		if IsUnit and Properties.Data then
			return string.format("%u/%u", Properties.Data.XP, Properties.Data.NeededXP)
		else
			return ""
		end
	end, { IsUnit, Properties.Data } :: { unknown })

	local Icon = React.useMemo(function()
		if Properties.Type == "Resource" then
			local Resource = GameInfo.RewardInfo[Properties.Name :: any]

			if Resource then
				return GameInfo.RewardInfo[Properties.Name :: any].Image
			else
				return ""
			end
		elseif Properties.Type == "Product" then
			if Properties.Data then
				if Properties.Data.IsGamepass then
					return "rbxassetid://"
						.. PurchaseData.GamepassData[Properties.Data.ProductId].ProductInfo.IconImageAssetId
				else
					return "rbxassetid://"
						.. PurchaseData.ProductData[Properties.Data.ProductId].ProductInfo.IconImageAssetId
				end
			else
				return ""
			end
		else
			return ""
		end
	end, { Properties.Type, Properties.Name, Properties.Rarity, PurchaseData.Loaded } :: { unknown })

	local FirstText = React.useMemo(function()
		if Properties.FirstText then
			return Properties.FirstText
		end

		if Properties.Type == "Unit" then
			if Properties.IsEquipped then
				return "Unequip"
			else
				return "Equip"
			end
		elseif Properties.Type == "Product" then
			return "Use"
		else
			return ""
		end
	end, { Properties.Type, Properties.IsEquipped, Properties.FirstText } :: { unknown })

	local UnitName = React.useMemo(function()
		if Properties.Name ~= "" and Properties.Type == "Unit" then
			return Properties.Name
		else
			return nil
		end
	end, { Properties.Name })

	return e(Main.ImageLabel, {
		native = {
			Position = UDim2.fromScale(0.85, 0.6),
			Size = UDim2.fromScale(0.2, 0.7),
			Image = "rbxassetid://75971006528952",
			Visible = Properties.Visible,
		},
	}, {
		ViewportFrame = e(UnitView, {
			UnitName = UnitName,
			Distance = 4,
			RotationCFrame = RotationCFrame,
			Offset = Vector3.new(0, -1, 0),
			native = {
				Position = Properties.OnSellClick and UDim2.fromScale(0.5, 0.55) or UDim2.fromScale(0.5, 0.6),
				Size = UDim2.fromScale(0.9, 0.5),
				Visible = IsUnit,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		IconFrame = e(Main.ImageLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.475),
				Size = UDim2.fromScale(0.9, 0.45),
				Image = Icon,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		FirstButton = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.5, 0.92),
				Size = UDim2.fromScale(0.8, 0.125),
				Image = "rbxassetid://72606508098140",
				Visible = FirstText ~= "",
				[React.Event.MouseButton1Click] = Properties.OnFirstClick,
			},
		}, {
			TextLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.6, 0.6),
					Text = FirstText,
					TextColor3 = Color3.new(1, 1, 1),
				},
			}),
		}),
		InfoButton = Properties.OnInfoClick and e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.78, 0.66),
				Size = UDim2.fromScale(0.21, 0.12),
				Visible = IsUnit,
				Image = "rbxassetid://77078349522524",
				ZIndex = 2,
				[React.Event.MouseButton1Click] = Properties.OnInfoClick,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		SellButton = Properties.OnSellClick and e(Main.Animateables.ImageButton, {
			native = {
				Position = FirstText == "" and UDim2.fromScale(0.5, 0.92) or UDim2.fromScale(0.5, 0.79),
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
			UIStroke = e(UIStroke.UIStrokeGradient, {
				Stroke = 0.02,
				GradColor = Properties.RarityInfo and Properties.RarityInfo.StrokeColor,
			}),
			UIGradient = e(AnimatedGradient, {
				GradColor = Properties.RarityInfo and Properties.RarityInfo.Color
					or ColorSequence.new(Color3.new(1, 1, 1)),
				Animate = true,
				Speed = 1,
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
			UIStroke = e(UIStroke.UIStrokeGradient, {
				Stroke = 0.02,
				GradColor = Properties.RarityInfo and Properties.RarityInfo.StrokeColor,
			}),

			UIGradient = e(AnimatedGradient, {
				GradColor = Properties.RarityInfo and Properties.RarityInfo.Color
					or ColorSequence.new(Color3.new(1, 1, 1)),
				Animate = true,
				Speed = 1,
			}),
		}),
	})
end

return CreateInfoFrame
