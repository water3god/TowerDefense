--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local NewGui = require(CoreGame.NewGui)
local CloseButton = require(CoreGame.CloseButton)
local Main = require(CoreGame.Main)
local Title = require(CoreGame.Title)
local UIStroke = require(CoreGame.UIStroke)

local PurchaseContext = require(Gui.Store.PurchaseContext)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)
local ProductInfo = require(Shared.ProductInfo)
local GameInfo = require(Shared.GameInfo)
local Traits = require(Shared.Traits)

export type Type = "Unit" | "Product" | "Resource" | "Trait"

export type Props = {
	Name: string?,
	Type: string,
	Visible: boolean,
	Level: number,
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateUnitStats(props: { UnitData: UnitInfo.UnitInfo, Level: number })
	local LevelFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		local UsedProperties = {}

		do
			local PropertyFrames: { [string]: React.Node } = {}

			for Layout, Property in ipairs(UnitInfo.Stats.StatProperties) do
				if Property == "Special" then
					continue
				end

				local FirstValue = props.UnitData.UnitData[1][Property]

				if FirstValue == nil then
					continue
				end

				if Property == "Damage" then
					if not FirstValue[1] or FirstValue[1] == 0 then
						continue
					end
				else
					if FirstValue == 0 then
						continue
					end
				end

				local Color = UnitInfo.Stats.Colors[Property :: UnitInfo.StatProperty] or Color3.new(1, 1, 1)

				table.insert(UsedProperties, Property)

				PropertyFrames[Property] = e(Main.TextLabel, {
					native = {
						Text = Property,
						Size = UDim2.fromScale(0.25, 0.6),
						LayoutOrder = Layout,
						TextColor3 = Color,
					},
				})
			end

			Frames["Top"] = e(Main.Frame, {
				native = {
					Size = UDim2.fromScale(1, 0.2),
					LayoutOrder = -1,
				},
			}, {
				MainPropertyFrames = e(Main.Frame, {
					native = {
						Size = UDim2.fromScale(0.8, 0.9),
						Position = UDim2.fromScale(0.6, 0.5),
					},
				}, {
					UIListLayout = e("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					}),
				}, PropertyFrames),
			})
		end

		for Level, Data in pairs(props.UnitData.UnitData) do
			local PropertyFrames: { [string]: React.Node } = {}

			for Layout, Property in ipairs(UnitInfo.Stats.StatProperties) do
				if Property == "Special" then
					continue
				end

				if not table.find(UsedProperties, Property) then
					continue
				end

				local Value = Data[Property]

				if Value == nil then
					continue
				end

				if Property == "Damage" then
					Value = Value[1]
					Value *= GameInfo.XPData.GetDamageMultiplierFromLevel(props.Level)
					Value = math.ceil(Value)
				end

				if Value == 0 then
					continue
				end

				local Color = UnitInfo.Stats.Colors[Property :: UnitInfo.StatProperty] or Color3.new(1, 1, 1)

				PropertyFrames[Property] = e(Main.TextLabel, {
					native = {
						Text = tostring(Value),
						Size = UDim2.fromScale(0.25, 0.6),
						LayoutOrder = Layout,
						TextColor3 = Color,
					},
				})
			end

			Frames["Level" .. Level] = e(Main.Frame, {
				native = {
					Size = UDim2.fromScale(1, 0.2),
					LayoutOrder = Level,
				},
			}, {
				LevelLabel = e(Main.TextLabel, {
					native = {
						Text = "Level " .. Level,
						Size = UDim2.fromScale(0.3, 0.6),
						Position = UDim2.fromScale(0.1, 0.5),
					},
				}),
				MainPropertyFrames = e(Main.Frame, {
					native = {
						Size = UDim2.fromScale(0.8, 0.9),
						Position = UDim2.fromScale(0.6, 0.5),
					},
				}, {
					UIListLayout = e("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					}),
				}, PropertyFrames),
			})
		end

		return Frames
	end, { props.UnitData, props.Level } :: { unknown })

	return e(Main.Frame, {
		native = {
			Position = UDim2.fromScale(0.675, 0.375),
			Size = UDim2.fromScale(0.55, 0.5),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.298039, 0.094118, 0.470588),
		},
	}, {
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.04, 0),
		}),
		MainFrame = e(Main.ScrollingFrame, {
			BarSize = 0.01,
			native = {
				Size = UDim2.fromScale(0.95, 0.95),
				Position = UDim2.fromScale(0.5, 0.48),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
			},
		}, {
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
			}),
		}, LevelFrames),
	})
end

local function CreateStatsFrame(props: Props)
	local PurchaseData = React.useContext(PurchaseContext.Context)

	local UnitData = React.useMemo(function()
		if props.Type == "Unit" and props.Name then
			return UnitInfo.UnitInfo[props.Name]
		else
			return UnitInfo.UnitInfo["Trajan"]
		end
	end, { props.Name, props.Type })

	local ProductData, PurchaseInfo = React.useMemo(function(): (ProductInfo.ProductData?, PurchaseContext.Data?)
		if props.Type == "Product" and props.Name then
			local Product, Id, IsGamepass = ProductInfo.GetProductFromNameOnly(props.Name)

			if Product and Id then
				if IsGamepass then
					return Product, PurchaseData.GamepassData[Id]
				else
					return Product, PurchaseData.ProductData[Id]
				end
			end
		end

		local _, Product = next(ProductInfo.ProductInfo)
		return Product, nil
	end, { props.Name, props.Type, PurchaseData.Loaded } :: { unknown })

	local ResourceData = React.useMemo(function()
		if props.Type == "Resource" and props.Name then
			return GameInfo.RewardInfo[props.Name]
		else
			return GameInfo.RewardInfo["Gold"]
		end
	end, { props.Name, props.Type })

	local TraitData = React.useMemo(function()
		if props.Type == "Trait" and props.Name then
			return Traits.Traits[props.Name]
		else
			local _, Data = next(Traits.Traits)
			return Data
		end
	end, { props.Name, props.Type })

	local RarityData = React.useMemo(function()
		if props.Type == "Unit" then
			return RarityInfo[UnitData.Rarity]
		elseif props.Type == "Product" and ProductData then
			return RarityInfo[ProductData.Rarity :: RarityInfo.Rarity]
		elseif props.Type == "Resource" then
			return RarityInfo[ResourceData.Rarity :: RarityInfo.Rarity]
		elseif props.Type == "Trait" then
			return RarityInfo[TraitData.Rarity :: RarityInfo.Rarity]
		else
			return RarityInfo["Common" :: "Common"]
		end
	end, { UnitData, ProductData, ResourceData, TraitData, props.Type } :: { unknown })

	local Description = React.useMemo(function()
		if props.Type == "Unit" then
			return UnitData.Description
		elseif props.Type == "Product" and PurchaseInfo then
			return PurchaseInfo.ProductInfo.Description
		elseif props.Type == "Resource" then
			return ResourceData.Description
		elseif props.Type == "Trait" then
			return TraitData.Description
		else
			return "No description available."
		end
	end, { UnitData, PurchaseInfo, ResourceData, TraitData, props.Type } :: { unknown })

	local TopRight = React.useMemo(function(): React.Node?
		if props.Type == "Unit" then
			return e(CreateUnitStats, {
				UnitData = UnitData,
				Level = props.Level,
			})
		end

		return
	end, { UnitData, props.Type, props.Level } :: { unknown })

	return e(NewGui, {
		DisplayOrder = 4,
	}, {
		StatsFrame = e(Main.Frame, {
			native = Join({
				Position = UDim2.fromScale(0.5, 0.55),
				Size = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
				Visible = props.Visible,
				ZIndex = 5,
			}, props.native),
		}, {
			UnitLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.225, 0.175),
					Size = UDim2.fromScale(0.3, 0.1),
					Text = props.Name,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}, {
				ColorGradient = e("UIGradient", {
					Color = RarityData.Color,
				}),
				Stroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.02,
					GradColor = RarityData.StrokeColor,
				}),
			}),
			RarityLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.225, 0.3),
					Size = UDim2.fromScale(0.3, 0.08),
					Text = UnitData.Rarity,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}, {
				ColorGradient = e("UIGradient", {
					Color = RarityData.Color,
				}),
				Stroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.02,
					GradColor = RarityData.StrokeColor,
				}),
			}),
			Description = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.2),
					Position = UDim2.fromScale(0.5, 0.75),
					Text = Description,
				},
			}),
			TopRight = TopRight,
			Title = e(Title, {
				Title = "STATS",
				Position = UDim2.fromScale(0.225, -0.04),
				Size = UDim2.fromScale(0.65, 0.3),
			}),
			UIAspectRatio = e("UIAspectRatioConstraint", {
				AspectRatio = 1.7,
			}),
			CloseButton = e(CloseButton, {
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromScale(0.15, 0.2),
				OnClick = props.CloseClick,
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.02, 0),
			}),
			InnerFrame = e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(0.5, 0.52),
					Size = UDim2.fromScale(0.94, 0.9),
				},
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.015, 0),
				}),
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Color = Color3.new(0.388235, 0.101961, 0.486275),
					Stroke = 0.003,
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
		}, props.children),
	})
end

return CreateStatsFrame
