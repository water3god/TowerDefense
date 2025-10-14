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
local Hooks = require(CoreGame.Hooks)

local Inventory = Gui.Inventory
local ProductFrame = require(Inventory.ProductFrame)
local ResourceFrame = require(Inventory.ResourceFrame)
local StatsFrame = require(Inventory.StatsFrame)

local StoreFolder = Gui.Store
local PurchaseContext = require(StoreFolder.PurchaseContext)

local Components = Gui.Components
local UnitLabel = require(Components.UnitLabel)
local GiftFrame = require(Components.GiftFrame)
local Button = require(Components.Button)

local Shared = ReplicatedStorage.Shared
local ProductInfo = require(Shared.ProductInfo)
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

local function CreateBasicTable(props: { Grid: boolean, Position: UDim2, Size: UDim2, children: { [any]: any }? })
	return e(Main.ScrollingFrame, {
		BarSize = 0.01,
		native = {
			Size = props.Size,
			Position = props.Position,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
		},
	}, {
		UIGridLayout = props.Grid and e("UIGridLayout", {
			CellPadding = UDim2.fromScale(0, 0),
			CellSize = UDim2.fromScale(0.25, 0.3),
			StartCorner = Enum.StartCorner.TopLeft,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}, props.children)
end

export type OfferProps = {
	Name: string,
	Image: string,
	Color: Color3,
	Rewards: { { Type: string, Name: string, Amount: number } },
	ProductId: number,
	GiftId: number?,
	Cost: number,
	GiftClick: () -> (),
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateOffer(props: OfferProps)
	local BuyClick = React.useCallback(function()
		MarketplaceService:PromptProductPurchase(Player, props.ProductId)
	end, { props.ProductId })

	local Rewards = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		local LayoutOrder = Hooks.LayoutOrder()

		for _, Reward in ipairs(props.Rewards) do
			if Reward.Type == "Unit" then
				for i = 1, Reward.Amount, 1 do
					Frames[Reward.Name .. i] = e(UnitLabel, {
						Unit = Reward.Name,
						native = {
							Size = UDim2.fromScale(0.3, 0.8),
							LayoutOrder = LayoutOrder(),
						},
					})
				end
			elseif Reward.Type == "Product" then
				local ProductData, ProductId, IsGamepass = ProductInfo.GetProductFromNameOnly(Reward.Name)
				if ProductData and ProductId and typeof(IsGamepass) == "boolean" then
					Frames[Reward.Name] = e(ProductFrame, {
						ProductId = ProductId,
						IsGamepass = IsGamepass,
						Count = Reward.Amount,
						native = {
							Size = UDim2.fromScale(0.3, 0.6),
							LayoutOrder = LayoutOrder(),
						},
					})
				end
			elseif Reward.Type == "Resource" then
				Frames[Reward.Name] = e(ResourceFrame, {
					Name = Reward.Name,
					Value = Reward.Amount,
					native = {
						Size = UDim2.fromScale(0.3, 0.6),
						LayoutOrder = LayoutOrder(),
					},
				})
			end
		end

		return Frames
	end, { props.Rewards })

	return e(Main.Frame, {
		native = {
			Size = UDim2.fromScale(1, 0.5),
		},
	}, {
		Container = e(Main.ImageLabel, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = props.Color,
				Image = props.Image,
				ImageTransparency = 0,
				Size = UDim2.fromScale(0.9, 0.9),
				ScaleType = Enum.ScaleType.Crop,
			},
		}, {
			Rewards = e(Main.Frame, {
				native = {
					Size = UDim2.fromScale(0.9, 0.9),
					Position = UDim2.fromScale(0.5, 0.375),
				},
			}, {
				UIListLayout = e(Main.UIListLayout, {
					native = {
						FillDirection = Enum.FillDirection.Horizontal,
					},
				}),
			}, Rewards),
			OfferLabel = e(Main.TextLabel, {
				native = {
					Text = props.Name,
					Size = UDim2.fromScale(0.5, 0.2),
					Position = UDim2.fromScale(0.275, 0.825),
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.01,
					Color = Color3.fromRGB(0, 0, 0),
				}),
			}),
			BuyButton = e(Main.Animateables.TextButton, {
				native = {
					BackgroundColor3 = Color3.fromRGB(10, 229, 17),
					BackgroundTransparency = 0,
					Position = UDim2.fromScale(0.7, 0.825),
					Size = UDim2.fromScale(0.3, 0.2),
					Text = "",
					[React.Event.MouseButton1Click] = BuyClick,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
					Color = Color3.fromRGB(6, 106, 10),
					native = {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						LineJoinMode = Enum.LineJoinMode.Round,
					},
				}),
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.4, 0),
				}),
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 3,
				}),
				Label = e(Main.TextLabel, {
					native = {
						Text = string.format("\u{E002}%d", props.Cost),
						Size = UDim2.fromScale(0.9, 0.7),
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeAdvanced, {
						Stroke = 0.03,
					}),
				}),
			}),
			GiftButton = e(Main.Animateables.TextButton, {
				native = {
					BackgroundColor3 = Color3.fromRGB(10, 36, 238),
					BackgroundTransparency = 0,
					Position = UDim2.fromScale(0.89, 0.825),
					Size = UDim2.fromScale(0.3, 0.2),
					Text = "",
					[React.Event.MouseButton1Click] = props.GiftClick,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
					Color = Color3.fromRGB(5, 18, 115),
					native = {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						LineJoinMode = Enum.LineJoinMode.Round,
					},
				}),
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.4, 0),
				}),
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 3,
				}),
				Label = e(Main.TextLabel, {
					native = {
						Text = "Gift",
						Size = UDim2.fromScale(0.9, 0.7),
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeAdvanced, {
						Stroke = 0.03,
					}),
				}),
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.005,
				Color = Color3.fromRGB(255, 255, 255),
				native = {
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
		}),
	}, props.children)
end

local function CreateStoreFrame(Properties: Properties)
	local PurchaseData = React.useContext(PurchaseContext.Context)

	local OpenFrame, SetOpenFrame = React.useState("Offers")
	local HoveredProduct: number?, SetHovered = React.useState(nil :: number?)

	local StatsProduct: string?, SetStatsProduct = React.useState(nil :: string?)

	React.useLayoutEffect(function()
		SetHovered(nil)
	end, { OpenFrame })

	local StatsCloseClick = React.useCallback(function()
		SetStatsProduct(nil)
	end, {})

	local OnFrameButtonClick = React.useCallback(function(OpenFrameInput: string)
		SetOpenFrame(OpenFrameInput)
	end, {})

	local GiftFrameData: { ProductId: number, GiftId: number }?, SetGiftFrameData =
		React.useState(nil :: { ProductId: number, GiftId: number }?)

	local GiftCloseClick = React.useCallback(function()
		SetGiftFrameData(nil)
	end, {})

	local StatsClick = React.useCallback(function()
		if not HoveredProduct then
			return
		end

		local Data = ProductInfo.GetProductFromIdOnly(HoveredProduct)

		if Data then
			SetStatsProduct(Data.Name)
		end
	end, { HoveredProduct, PurchaseData } :: { unknown })

	local MainFrames = React.useMemo(function()
		if not PurchaseData.Loaded then
			return {}
		end

		local Frames: { [string]: React.Node } = {}

		local IsOffer = OpenFrame == "Offers"

		if OpenFrame == "Offers" then
			for Id, Data in pairs(PurchaseData.Offers) do
				local ProductData = PurchaseData.ProductData[Id]

				if ProductData then
					local GiftId = ProductInfo.GetProductIdFromGiftId(Id)

					Frames["Offer" .. Id] = e(CreateOffer, {
						Name = ProductData.ProductInfo.Name,
						Image = Data.Icon or "rbxassetid://3385224877",
						ProductId = Id,
						GiftClick = function()
							if GiftId then
								SetGiftFrameData({
									ProductId = Id,
									GiftId = GiftId,
								})
							end
						end,
						Cost = ProductData.ProductInfo.PriceInRobux,
						Rewards = Data.Rewards,
						Color = Data.Color,
					})
				end
			end
		elseif OpenFrame == "Gamepasses" then
			for Id, Data in pairs(PurchaseData.GamepassData) do
				if PurchaseData.Offers[Id] then
					continue
				end

				Frames["Gamepass" .. Id] = e(ProductFrame, {
					IsGamepass = true,
					ProductId = Id,
					Owned = Data.Owned,
					Purchaseable = true,
					Count = 1,
					Hovered = HoveredProduct == Id,
					OnClick = function()
						SetHovered(Id)
					end,
				})
			end
		elseif OpenFrame == "Products" then
			for Id, _ in pairs(PurchaseData.ProductData) do
				if PurchaseData.Offers[Id] then
					continue
				end

				Frames["Product" .. Id] = e(ProductFrame, {
					IsGamepass = false,
					ProductId = Id,
					Purchaseable = true,
					Count = 1,
					Hovered = HoveredProduct == Id,
					OnClick = function()
						SetHovered(Id)
					end,
				})
			end
		end

		return {
			ProductTable = e(CreateBasicTable, {
				Grid = not IsOffer,
				Position = IsOffer and UDim2.fromScale(0.5, 0.575) or UDim2.fromScale(0.375, 0.575),
				Size = IsOffer and UDim2.fromScale(0.9, 0.75) or UDim2.fromScale(0.6, 0.7),
			}, {
				UIListLayout = IsOffer and e("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top,
				}),
			}, Frames),
		}
	end, { OpenFrame, PurchaseData.Loaded, HoveredProduct } :: { unknown })

	local GiftId = React.useMemo(function()
		if HoveredProduct then
			for GiftKey, ProductId in pairs(PurchaseData.GiftIds) do
				if ProductId == HoveredProduct then
					return GiftKey :: number?
				end
			end
		end

		return nil
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
	end, { HoveredProduct, OpenFrame } :: { unknown })

	local GiftFunc = React.useCallback(function()
		if OpenFrame == "Products" or OpenFrame == "Gamepasses" then
			if GiftId and HoveredProduct then
				SetGiftFrameData({
					ProductId = HoveredProduct,
					GiftId = GiftId,
				})
			end
		elseif OpenFrame == "Offers" then
			return
		end
	end, { HoveredProduct, OpenFrame, GiftId } :: { unknown })

	local InfoData = React.useMemo(function()
		local Default = {
			Name = "N/A",
			Rarity = "Common",
			RarityInfo = RarityInfo["Common" :: any],
			Image = 0,
		}

		if not HoveredProduct then
			return Default
		end
		if OpenFrame == "Products" then
			local Data = PurchaseData.ProductData[HoveredProduct]
			return {
				Name = Data.ProductInfo.Name,
				Rarity = Data.Rarity,
				RarityInfo = RarityInfo[Data.Rarity :: any],
				Image = Data.ProductInfo.IconImageAssetId,
			}
		elseif OpenFrame == "Gamepasses" then
			local Data = PurchaseData.GamepassData[HoveredProduct]
			return {
				Name = Data.ProductInfo.Name,
				Rarity = Data.Rarity,
				RarityInfo = RarityInfo[Data.Rarity :: any],
				Image = Data.ProductInfo.IconImageAssetId,
			}
		elseif OpenFrame == "Offers" then
			return Default
		else
			return Default
		end
	end, { HoveredProduct } :: { unknown })

	return e(Main.ImageLabel, {
		native = JoinDicts({
			Size = UDim2.fromScale(0.5, 0.6),
			Image = "rbxassetid://75477724796723",
		}, Properties.native),
	}, {
		StatsFrame = e(StatsFrame, {
			Type = "Product",
			Level = 1,
			Visible = StatsProduct ~= nil,
			Name = StatsProduct,
			CloseClick = StatsCloseClick,
		}),
		GiftFrame = GiftFrameData and e(GiftFrame, {
			ProductId = GiftFrameData.ProductId,
			GiftId = GiftFrameData.GiftId,
			CloseClick = GiftCloseClick,
		}),
		UISizeConstraint = e("UISizeConstraint", {
			MinSize = Vector2.new(340, 220),
			MaxSize = Vector2.new(1360, 880),
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.4,
		}),
		Title = e(Title, {
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromScale(1, 0.2),
			Title = "STORE",
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.1, 0.2),
			OnClick = Properties.CloseClick,
		}),
		InfoFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.825, 0.575),
				Size = UDim2.fromScale(0.225, 0.7),
				Visible = InfoData.Name ~= "N/A",
			},
		}, {
			Background = e(Main.ImageLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1.1, 1.05),
					Image = "rbxassetid://138957161873862",
					ZIndex = 0,
				},
			}),
			IconFrame = e(Main.ImageLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.45),
					Size = UDim2.fromScale(0.9, 0.45),
					Image = "rbxassetid://" .. InfoData.Image,
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
			}),
			GiftButton = e(Button, {
				Text = "Gift",
				Position = UDim2.fromScale(0.5, 0.9),
				Color = "Blue",
				Size = UDim2.fromScale(1.2, 0.225),
				OnClick = GiftFunc,
			}),
			InfoButton = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.78, 0.6),
					Size = UDim2.fromScale(0.25, 0.15),
					Image = "rbxassetid://77078349522524",
					[React.Event.MouseButton1Click] = StatsClick,
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
			}),
			BuyButton = e(Button, {
				Text = "Buy",
				Color = "Green",
				Position = UDim2.fromScale(0.5, 0.75),
				Size = UDim2.fromScale(1.2, 0.225),
				OnClick = BuyFunc,
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
		Offers = e(Button, {
			Text = "Offers",
			OnClick = function()
				OnFrameButtonClick("Offers")
			end,
			Color = OpenFrame == "Offers" and "Green" or "Black",
			Position = UDim2.fromScale(0.2, 0.14),
			Size = UDim2.fromScale(0.2, 0.15),
			native = {
				ZIndex = 2,
			},
		}),
		Gamepasses = e(Button, {
			Text = "Gamepasses",
			OnClick = function()
				OnFrameButtonClick("Gamepasses")
			end,
			Color = OpenFrame == "Gamepasses" and "Green" or "Black",
			Position = UDim2.fromScale(0.5, 0.14),
			Size = UDim2.fromScale(0.2, 0.15),
			native = {
				ZIndex = 2,
			},
		}),
		Products = e(Button, {
			Text = "Products",
			OnClick = function()
				OnFrameButtonClick("Products")
			end,
			Color = OpenFrame == "Products" and "Green" or "Black",
			Position = UDim2.fromScale(0.8, 0.14),
			Size = UDim2.fromScale(0.2, 0.15),
			native = {
				ZIndex = 2,
			},
		}),
	}, MainFrames, Properties.children)
end

return CreateStoreFrame
