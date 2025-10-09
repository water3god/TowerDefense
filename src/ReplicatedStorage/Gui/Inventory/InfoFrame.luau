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

local Components = Gui.Components
local Button = require(Components.Button)

local Shared = ReplicatedStorage.Shared
local GameInfo = require(Shared.GameInfo)
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

	local Icon = React.useMemo(function()
		if Properties.Type == "Resource" then
			local Resource = GameInfo.RewardInfo[Properties.Name :: any]

			if Resource then
				return GameInfo.RewardInfo[Properties.Name :: any].Image
			else
				return ""
			end
		elseif Properties.Type == "Product" then
			if Properties.Data and Properties.Data.ProductId then
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

	return e(Main.Frame, {
		native = {
			Position = UDim2.fromScale(0.85, 0.6),
			Size = UDim2.fromScale(0.2, 0.7),
			Visible = Properties.Visible,
		},
	}, {
		Background = e(Main.ImageLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1.05, 1),
				Image = "rbxassetid://138957161873862",
				ZIndex = 0,
			},
		}),
		ViewportFrame = e(UnitView, {
			UnitName = UnitName,
			Distance = 4,
			RotationCFrame = RotationCFrame,
			Offset = Vector3.new(0, -1, 0),
			native = {
				Position = Properties.OnSellClick and UDim2.fromScale(0.5, 0.475) or UDim2.fromScale(0.5, 0.55),
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
		InfoButton = Properties.OnInfoClick and e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.75, 0.58),
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
		FirstButton = e(Button, {
			Text = FirstText,
			Color = FirstText == "Unequip" and "Blue" or "Green",
			Position = UDim2.fromScale(0.5, 0.9),
			Size = UDim2.fromScale(1.4, 0.225),
			OnClick = Properties.OnFirstClick,
			native = {
				Visible = FirstText ~= "",
			},
		}),
		SellButton = Properties.OnSellClick and e(Button, {
			Text = "Sell",
			Color = "Red",
			Position = FirstText == "" and UDim2.fromScale(0.5, 0.9) or UDim2.fromScale(0.5, 0.75),
			Size = UDim2.fromScale(1.4, 0.225),
			OnClick = Properties.OnSellClick,
		}),
		NameLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.125),
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
				Position = UDim2.fromScale(0.5, 0.225),
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
