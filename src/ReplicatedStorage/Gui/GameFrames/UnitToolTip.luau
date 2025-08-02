--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Trove = require(Packages.Trove)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local AnimatedGradient = require(CoreGame.AnimatedGradient)

local TraitFrame = require(Gui.Components.TraitFrame)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)

local Shared = ReplicatedStorage.Shared
local RarityInfo = require(Shared.RarityInfo)
local UnitInfo = require(Shared.UnitInfo)
local Stats = UnitInfo.Stats

export type ConnectedProps = {
	UnitId: string?,

	Position: React.Binding<Vector2>?,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type Props = {
	UnitName: string,
	Level: number,
	Trait: string?,
	OwnerId: number?,
	Data: { [UnitInfo.StatProperty]: number },

	Position: React.Binding<Vector2>?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type StatProps = {
	Type: "Damage" | "FireRate" | "Range",
	Value: number,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateStatFrame(Props: StatProps)
	return e(Main.Frame, {
		native = Join({
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(52, 8, 70),
			LayoutOrder = Stats.Layout[Props.Type],
			Size = UDim2.fromScale(0.3, 1),
		}, Props.native),
	}, {
		UIAspectRatio = e("UIAspectRatioConstraint", {
			AspectRatio = 1.8,
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.3, 0),
		}),
		Icon = e(Main.ImageLabel, {
			native = {
				Position = UDim2.fromScale(0.25, 0.5),
				Size = UDim2.fromScale(0.5, 0.5),
				Image = Stats.Icons[Props.Type],
			},
		}, {
			UIAspectRatio = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		Label = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.7, 0.5),
				Size = UDim2.fromScale(0.5, 0.5),
				Text = HelperFunctions.NumberScaler.ShortenNumber(Props.Value),
				AutoLocalize = false,
				TextColor3 = Stats.Colors[Props.Type],
			},
		}),
	})
end

local function CreateUnitToolTip(Props: Props)
	local Frames, SetFrames = React.useState({})

	React.useEffect(function()
		local Table = {}
		for Property, Value in pairs(Props.Data) do
			Table[Property] = e(CreateStatFrame, {
				Type = Property :: any,
				Value = Value,
			})
		end
		SetFrames(Table)
	end, { Props.Data })

	local UnitData = React.useMemo(function(): UnitInfo.UnitInfo?
		return UnitInfo.UnitInfo[Props.UnitName]
	end, { Props.UnitName })

	local RarityData = React.useMemo(function(): RarityInfo.RarityInfo
		if UnitData then
			return RarityInfo[UnitData.Rarity]
		else
			return RarityInfo["Common" :: "Common"]
		end
	end, { UnitData })

	local OwnerText: string?, SetOwnerText = React.useState(nil :: string?)

	React.useEffect(function()
		if Props.OwnerId then
			HelperFunctions.GetNameFromIdAsync(Props.OwnerId):andThen(SetOwnerText):catch(function()
				SetOwnerText(nil)
			end)
		else
			SetOwnerText(nil)
		end
	end, { Props.OwnerId })

	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.15, 0.1),
			AnchorPoint = Vector2.new(0, 0),
			Position = Props.Position and Props.Position:map(function(PositionInput: Vector2)
				local Position = PositionInput - GuiService:GetGuiInset()

				return UDim2.fromOffset(Position.X, Position.Y)
			end),
			Image = "rbxassetid://103903141717286",
		}, Props.native),
	}, {
		UIAspectRatio = e("UIAspectRatioConstraint", {
			AspectRatio = 2,
		}),
		TraitFrame = e(TraitFrame, {
			Trait = Props.Trait,
			native = {
				Position = UDim2.fromScale(0.9, 0.23),
				Size = UDim2.fromScale(0.12, 0.3),
			},
		}),
		NameLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.225),
				Size = UDim2.fromScale(0.9, 0.18),
				Text = Props.UnitName,
			},
		}, {
			UIGradient = e(AnimatedGradient, {
				GradColor = RarityData.Color,
				Animate = true,
			}),
			UIStroke = e(UIStroke.UIStrokeGradient, {
				GradColor = RarityData.StrokeColor,
				Stroke = 0.01,
			}),
		}),
		LevelLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.25, 0.45),
				Size = UDim2.fromScale(0.45, 0.12),
				Text = string.format("Level: %u", Props.Level),
			},
		}, {
			UIGradient = e(AnimatedGradient, {
				GradColor = RarityData.Color,
				Animate = true,
			}),
			UIStroke = e(UIStroke.UIStrokeGradient, {
				GradColor = RarityData.StrokeColor,
				Stroke = 0.01,
			}),
		}),
		OwnerLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.75, 0.45),
				Size = UDim2.fromScale(0.45, 0.12),
				Text = OwnerText or "No Owner",
				TextXAlignment = Enum.TextXAlignment.Center,
			},
		}, {
			UIGradient = e(AnimatedGradient, {
				GradColor = RarityData.Color,
				Animate = true,
			}),
			UIStroke = e(UIStroke.UIStrokeGradient, {
				GradColor = RarityData.StrokeColor,
				Stroke = 0.01,
			}),
		}),
		Bar = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.75),
				Size = UDim2.fromScale(0.9, 0.4),
			},
		}, {
			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0.05, 0),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		}, Frames),
	}, Props.children)
end

local function UnitConnected(Props: ConnectedProps)
	local Data, SetData = React.useState({
		Level = 1,
		OwnerId = nil :: number?,
		Trait = nil :: string?,
		UnitName = "",
		Data = {},
	})

	React.useEffect(function()
		local NewTrove = Trove.new()
		if Props.UnitId then
			local Unit = UnitClient.GetUnit(Props.UnitId)
			if Unit then
				SetData({
					Level = Unit.Level,
					OwnerId = Unit.OwnerId,
					UnitName = Unit.UnitName,
					Trait = Unit.Trait,
					Data = Unit:GetProperties(),
				})

				NewTrove:Connect(Unit.Upgraded, function()
					SetData({
						Level = Unit.Level,
						UnitName = Unit.UnitName,
						Data = Unit:GetProperties(),
					})
				end)

				NewTrove:Connect(Unit.PropertyChanged, function()
					SetData({
						Level = Unit.Level,
						UnitName = Unit.UnitName,
						Data = Unit:GetProperties(),
					})
				end)

				NewTrove:Connect(Unit.Destroying, NewTrove:WrapClean())
			end
		end

		return NewTrove:WrapClean()
	end, { Props.UnitId })

	return e(CreateUnitToolTip, {
		Level = Data.Level,
		UnitName = Data.UnitName,
		OwnerId = Data.OwnerId,
		Trait = Data.Trait,
		Data = Data.Data,
		Position = Props.Position,
		native = Props.native,
	}, Props.children)
end

return {
	Create = CreateUnitToolTip,
	Connected = UnitConnected,
}
