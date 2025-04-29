--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Trove = require(Packages.Trove)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)

local Shared = ReplicatedStorage.Shared
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
			Size = UDim2.fromScale(0.4, 1),
		}, Props.native),
	}, {
		UIAspectRatio = e("UIAspectRatioConstraint", {
			AspectRatio = 1.3,
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
				Size = UDim2.fromScale(0.5, 0.4),
				Text = HelperFunctions.NumberScaler.ShortenNumber(Props.Value),
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

	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.4, 0.3),
			Position = Props.Position,
			Image = "rbxassetid://103903141717286",
		}, Props.native),
	}, {
		UIAspectRatio = e("UIAspectRatioConstraint", {
			AspectRatio = 2,
		}),
		TextLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.275),
				Size = UDim2.fromScale(0.9, 0.25),
				Text = "Minigunner",
			},
		}),
		Bar = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.7),
				Size = UDim2.fromScale(0.8, 0.4),
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
		UnitName = "",
		Data = {},
	})

	React.useEffect(function()
		local Trove = Trove.new()
		if Props.UnitId then
			local Unit = UnitClient.GetUnit(Props.UnitId)
			if Unit then
				SetData({
					UnitName = Unit.UnitName,
					Data = Unit:GetProperties(),
				})

				Trove:Connect(Unit.Upgraded, function()
					SetData({
						UnitName = Unit.UnitName,
						Data = Unit:GetProperties(),
					})
				end)

				Trove:Connect(Unit.PropertyChanged, function()
					SetData({
						UnitName = Unit.UnitName,
						Data = Unit:GetProperties(),
					})
				end)

				Trove:Connect(Unit.Destroying, Trove:WrapClean())
			end
		end

		return Trove:WrapClean()
	end, { Props.UnitId })

	return e(CreateUnitToolTip, {
		UnitName = Data.UnitName,
		Data = Data.Data,
		Position = Props.Position,
		native = Props.native,
	}, Props.children)
end

return {
	Create = CreateUnitToolTip,
	Connected = UnitConnected,
}
