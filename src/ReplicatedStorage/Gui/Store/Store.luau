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
local Hooks = require(CoreGame.Hooks)

local Inventory = Gui.Inventory
local ProductFrame = require(Inventory.ProductFrame)
local ResourceFrame = require(Inventory.ResourceFrame)

local StoreFolder = Gui.Store
local PurchaseContext = require(StoreFolder.PurchaseContext)

local Components = Gui.Components
local UnitLabel = require(Components.UnitLabel)
local GiftFrame = require(Components.GiftFrame)

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
			CellSize = UDim2.fromScale(0.2, 0.3),
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

	React.useLayoutEffect(function()
		SetHovered(nil)
	end, { OpenFrame })

	local OnFrameButtonClick = React.useCallback(function(OpenFrameInput: string)
		SetOpenFrame(OpenFrameInput)
	end, {})

	local GiftFrameData: { ProductId: number, GiftId: number }?, SetGiftFrameData =
		React.useState(nil :: { ProductId: number, GiftId: number }?)

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
		print("Ran")
		if OpenFrame == "Products" or OpenFrame == "Gamepasses" then
			if GiftId and HoveredProduct then
				SetGiftFrameData({
					ProductId = HoveredProduct,
					GiftId = GiftId,
				})
				--MarketplaceService:PromptProductPurchase(Player, GiftId)
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

	return e(Main.Frame, {
		native = JoinDicts({
			Size = UDim2.fromScale(0.5, 0.6),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
		}, Properties.native),
	}, {
		GiftFrame = GiftFrameData and e(GiftFrame, {
			ProductId = GiftFrameData.ProductId,
			GiftId = GiftFrameData.GiftId,
			CloseClick = function()
				SetGiftFrameData(nil)
			end,
		}),
		UISizeConstraint = e("UISizeConstraint", {
			MinSize = Vector2.new(340, 220),
			MaxSize = Vector2.new(1360, 880),
		}),
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
				Position = UDim2.fromScale(0.825, 0.575),
				Size = UDim2.fromScale(0.225, 0.7),
				Image = "rbxassetid://75971006528952",
				Visible = InfoData.Name ~= "N/A",
			},
		}, {
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
			GiftButton = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.5, 0.92),
					Size = UDim2.fromScale(0.8, 0.125),
					Image = "rbxassetid://80739823452825",
					ImageColor3 = Color3.fromRGB(43, 191, 255),
					[React.Event.MouseButton1Click] = GiftFunc,
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
					Position = UDim2.fromScale(0.78, 0.67),
					Size = UDim2.fromScale(0.21, 0.12),
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
					[React.Event.MouseButton1Click] = BuyFunc,
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
				Position = UDim2.fromScale(0.2, 0.15),
				Size = UDim2.fromScale(0.17, 0.09),
			},
		}),
		Gamepasses = e(BaseButton, {
			Text = "Gamepasses",
			OnClick = function()
				OnFrameButtonClick("Gamepasses")
			end,
			Highlighted = OpenFrame == "Gamepasses",
			native = {
				Position = UDim2.fromScale(0.5, 0.15),
				Size = UDim2.fromScale(0.17, 0.09),
			},
		}),
		Products = e(BaseButton, {
			Text = "Products",
			OnClick = function()
				OnFrameButtonClick("Products")
			end,
			Highlighted = OpenFrame == "Products",
			native = {
				Position = UDim2.fromScale(0.8, 0.15),
				Size = UDim2.fromScale(0.17, 0.09),
			},
		}),
	}, MainFrames, Properties.children)
end

return CreateStoreFrame
