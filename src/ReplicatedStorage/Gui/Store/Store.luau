--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local JoinDicts = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local CloseButton = require(CoreGame.CloseButton)
local UIStroke = require(CoreGame.UIStroke)
local Title = require(CoreGame.Title)
local BaseButton = require(CoreGame.BaseButton)
local BaseFrame = require(CoreGame.BaseFrame)

local StoreFolder = Gui.Store
local PurchaseContext = require(StoreFolder.PurchaseContext)

local Shared = ReplicatedStorage.Shared
local RarityInfo = require(Shared.RarityInfo)

export type Properties = {
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type ProductProps = {
	Name: string,
	Image: number,
	Price: number,
	Owned: boolean,
	Hovered: boolean,
	OnClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateProductFrame(props: ProductProps)
	local PriceText = React.useMemo(function()
		return HelperFunctions.NumberScaler.ShortenNumber(props.Price)
	end, { props.Price })

	return e(BaseFrame, {
		LeftText = "",
		RightText = "",
		Image = props.Image,
		Name = props.Name,
		Hovered = props.Hovered,
		OnClick = props.OnClick,
		BackgroundColor = ColorSequence.new(Color3.new(0.188235, 1, 0.282353)),
		containerChildren = {
			RobuxLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.2),
					Size = UDim2.fromScale(0.7, 0.18),
					Text = string.format("\u{E002}%s", PriceText),
					TextColor3 = Color3.new(0.078431, 1, 0.231373),
				},
			}),
			Owned = e(Main.TextLabel, {
				native = {
					Visible = props.Owned,
					Text = "Owned!",
					Size = UDim2.fromScale(0.9, 0.3),
					Rotation = -45,
					ZIndex = 5,
					TextColor3 = Color3.new(0.568627, 0.568627, 0.568627),
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
				}),
			}),
		},
	}, {})
end

local function CreateBasicTable(props: { children: { [any]: any }? })
	return e(Main.ScrollingFrame, {
		BarSize = 0.01,
		native = {
			Size = UDim2.fromScale(0.7, 0.9),
			Position = UDim2.fromScale(0.3, 0.5),
			AutomaticSize = Enum.AutomaticSize.Y,
		},
	}, {
		UIGridLayout = e("UIGridLayout", {
			CellPadding = UDim2.fromScale(0, 0),
			CellSize = UDim2.fromScale(0.2, 0.3),
			StartCorner = Enum.StartCorner.TopLeft,
		}),
	}, props.children)
end

local function CreateStoreFrame(Properties: Properties)
	local PurchaseData = React.useContext(PurchaseContext.Context)

	local OpenFrame, SetOpenFrame = React.useState("Offers")
	local HoveredProduct: number?, SetHovered = React.useState(nil :: number?)

	React.useEffect(function()
		SetHovered(nil)
	end, { OpenFrame })

	local OnFrameButtonClick = React.useCallback(function(OpenFrameInput: string)
		SetOpenFrame(OpenFrameInput)
	end, {})

	local MainFrames = React.useMemo(function()
		if not PurchaseData.Loaded then
			return {}
		end

		local Frames = {}

		if OpenFrame == "Offers" then
			return Frames
		elseif OpenFrame == "Gamepasses" then
			for Id, Data in pairs(PurchaseData.GamepassData) do
				Frames[Id] = e(CreateProductFrame, {
					Name = Data.ProductInfo.Name,
					Image = Data.ProductInfo.IconImageAssetId,
					Price = Data.ProductInfo.PriceInRobux,
					Owned = Data.Owned,
					Hovered = HoveredProduct == Id,
					OnClick = function()
						SetHovered(Id)
					end,
				})
			end
		elseif OpenFrame == "Products" then
			for Id, Data in pairs(PurchaseData.ProductData) do
				Frames[Id] = e(CreateProductFrame, {
					Name = Data.ProductInfo.Name,
					Image = Data.ProductInfo.IconImageAssetId,
					Price = Data.ProductInfo.PriceInRobux,
					Owned = false,
					Hovered = HoveredProduct == Id,
					OnClick = function()
						SetHovered(Id)
					end,
				})
			end
		end

		return e(CreateBasicTable, {}, Frames)
	end, { OpenFrame, PurchaseData.Loaded :: any, HoveredProduct :: any })

	local GiftId = React.useMemo(function()
		if HoveredProduct then
			return PurchaseData.GiftIds[HoveredProduct] :: number?
		else
			return nil
		end
	end, { HoveredProduct })

	local BuyFunc = React.useCallback(function()
		if not HoveredProduct then
			return
		end
		if OpenFrame == "Products" then
			MarketplaceService:PromptProductPurchase(Player, HoveredProduct)
		elseif OpenFrame == "Gamepasses" then
			MarketplaceService:PromptGamePassPurchase(Player, HoveredProduct)
		elseif OpenFrame == "Offers" then
			return
		end
	end, { HoveredProduct, OpenFrame :: any })

	local GiftFunc = React.useCallback(function()
		if not HoveredProduct then
			return
		end
		if OpenFrame == "Products" then
			if GiftId then
				MarketplaceService:PromptProductPurchase(Player, HoveredProduct)
			end
		elseif OpenFrame == "Gamepasses" then
			if GiftId then
				MarketplaceService:PromptGamePassPurchase(Player, HoveredProduct)
			end
		elseif OpenFrame == "Offers" then
			return
		end
	end, { HoveredProduct, OpenFrame :: any })

	local InfoData = React.useMemo(function()
		local Default = {
			Name = "N/A",
			Rarity = "Common",
			RarityInfo = RarityInfo["Common" :: any],
			BuyFunc = function() end,
			GiftFunc = function() end,
		}

		if not HoveredProduct then
			return Default
		end
		if OpenFrame == "Products" then
			local ProductInfo = PurchaseData.ProductData[HoveredProduct]
			return {
				Name = ProductInfo.ProductInfo.Name,
				Rarity = ProductInfo.Rarity,
				RarityInfo = RarityInfo[ProductInfo.Rarity :: any],
				BuyFunc = BuyFunc,
				GiftFunc = GiftFunc,
			}
		elseif OpenFrame == "Gamepasses" then
			local ProductInfo = PurchaseData.GamepassData[HoveredProduct]
			return {
				Name = ProductInfo.ProductInfo.Name,
				Rarity = ProductInfo.Rarity,
				RarityInfo = RarityInfo[ProductInfo.Rarity :: any],
				BuyFunc = BuyFunc,
				GiftFunc = GiftFunc,
			}
		elseif OpenFrame == "Offers" then
			return Default
		else
			return Default
		end
	end, { HoveredProduct, OpenFrame :: any })

	return e(Main.Frame, {
		native = JoinDicts({
			Size = UDim2.fromScale(0.5, 0.6),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
		}, Properties.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.5,
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
		}),
		Title = e(Title, {
			Position = UDim2.fromScale(0.2, 0),
			Size = UDim2.fromScale(1, 0.18),
			Title = "STORE",
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.1, 0.2),
			OnClick = Properties.CloseClick,
		}),
		InnerFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.52),
				Size = UDim2.fromScale(0.94, 0.87),
				ZIndex = 0,
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.015, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Color = Color3.new(0.388235, 0.101961, 0.486275),
				Stroke = 0.002,
				native = {
					Transparency = 0.1,
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
		}),
		UIStroke = e(UIStroke.UIStrokeAdvanced, {
			Color = Color3.new(0.866667, 0.866667, 0.866667),
			Stroke = 0.002,
			native = {
				LineJoinMode = Enum.LineJoinMode.Round,
			},
		}),
		InfoFrame = e(Main.ImageLabel, {
			native = {
				Position = UDim2.fromScale(0.8, 0.6),
				Size = UDim2.fromScale(0.2, 0.6),
				Image = "rbxassetid://75971006528952",
				Visible = InfoData.Name ~= "N/A",
			},
		}, {
			IconFrame = e(Main.ImageLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.525),
					Size = UDim2.fromScale(0.9, 0.45),
					Image = "",
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
			}),
			GiftButton = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.5, 0.92),
					Size = UDim2.fromScale(0.8, 0.125),
					Image = "rbxassetid://80739823452825",

					ImageColor3 = Color3.fromRGB(43, 191, 255),
				},
			}, {
				TextLabel = e(Main.TextLabel, {
					native = {
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(0.6, 0.6),
						Text = "Gift",
						TextColor3 = Color3.new(1, 1, 1),
					},
				}),
			}),
			InfoButton = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.78, 0.66),
					Size = UDim2.fromScale(0.21, 0.12),
					Visible = true,
					Image = "rbxassetid://77078349522524",
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
			}),
			BuyButton = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.5, 0.79),
					Size = UDim2.fromScale(0.8, 0.125),
					Image = "rbxassetid://72606508098140",
					ImageColor3 = Color3.fromRGB(43, 191, 255),
				},
			}, {
				TextLabel = e(Main.TextLabel, {
					native = {
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(0.6, 0.6),
						Text = "Buy",
						TextColor3 = Color3.new(1, 1, 1),
					},
				}),
			}),
			NameLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.1),
					Size = UDim2.fromScale(0.8, 0.12),
					Text = InfoData.Name,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}, {
				UIStroke = e(UIStroke.UIStroke, {
					Stroke = 0.001,
					GradColor = InfoData.RarityInfo and InfoData.RarityInfo.StrokeColor,
				}),
				UIGradient = e("UIGradient", {
					Color = InfoData.RarityInfo and InfoData.RarityInfo.Color,
				}),
			}),
			RarityLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.19),
					Size = UDim2.fromScale(0.8, 0.05),
					Text = InfoData.Rarity,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}, {
				UIStroke = e(UIStroke.UIStroke, {
					Stroke = 0.0008,
					GradColor = InfoData.RarityInfo and InfoData.RarityInfo.StrokeColor,
				}),
				UIGradient = e("UIGradient", {
					Color = InfoData.RarityInfo and InfoData.RarityInfo.Color,
				}),
			}),
		}),
		Offers = e(BaseButton, {
			Text = "Offers",
			OnClick = function()
				OnFrameButtonClick("Offers")
			end,
			Highlighted = OpenFrame == "Offers",
			native = {
				Position = UDim2.fromScale(0.2, 0.175),
				Size = UDim2.fromScale(0.2, 0.1),
			},
		}),
		Gamepasses = e(BaseButton, {
			Text = "Gamepasses",
			OnClick = function()
				OnFrameButtonClick("Gamepasses")
			end,
			Highlighted = OpenFrame == "Gamepasses",
			native = {
				Position = UDim2.fromScale(0.5, 0.175),
				Size = UDim2.fromScale(0.2, 0.1),
			},
		}),
		Products = e(BaseButton, {
			Text = "Products",
			OnClick = function()
				OnFrameButtonClick("Products")
			end,
			Highlighted = OpenFrame == "Products",
			native = {
				Position = UDim2.fromScale(0.8, 0.175),
				Size = UDim2.fromScale(0.2, 0.1),
			},
		}),
	}, MainFrames, Properties.children)
end

return CreateStoreFrame
