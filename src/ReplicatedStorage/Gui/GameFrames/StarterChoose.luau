--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local ReactSpring = require(Packages.ReactSpring)
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local DelayHandler = require(Modules.DelayHandler)
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Network = require(ReplicatedStorage.Network.Client)
local ChooseStarter = Network.ChooseStarter
local FirstJoin = Network.FirstJoin

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UnitView = require(CoreGame.UnitView)
local UIStroke = require(CoreGame.UIStroke)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)

export type Properties = {
	SetVisible: ((Visible: boolean) -> ())?,
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type UnitProperties = {
	UnitName: string,
	Position: UDim2,
	Alpha: React.Binding<number>,
	OtherAlpha: React.Binding<number>,
	Index: number,
	ChangeIndex: (Index: number?) -> (),
	SetStrongIndex: (Index: number?) -> (),
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateUnit(Props: UnitProperties)
	local UnitData = React.useMemo(function()
		return UnitInfo.UnitInfo[Props.UnitName]
	end, { Props.UnitName })

	local RarityData = React.useMemo(function()
		return RarityInfo[UnitData.Rarity]
	end, { UnitData.Rarity })

	local RotationCFrame = React.useBinding(CFrame.Angles(math.rad(5), 0, 0))

	return e(Main.Frame, {
		native = Join({
			Position = Props.Position,
			Size = Props.Alpha:map(function(alpha: number)
				return UDim2.fromScale(0.5 + alpha * 0.1, 0.7 + alpha * 0.1)
			end),
		}, Props.native),
	}, {
		UIAspectRatio = e("UIAspectRatioConstraint", {
			AspectRatio = 0.8,
		}),
		BackButton = e(Main.TextButton, {
			native = {
				Size = UDim2.fromScale(0.6, 0.7),
				Text = "",
				[React.Event.MouseEnter] = function()
					Props.ChangeIndex(Props.Index)
				end,
				[React.Event.MouseLeave] = function()
					Props.ChangeIndex(nil)
				end,
				[React.Event.MouseButton1Click] = function()
					Props.SetStrongIndex(Props.Index)
				end,
			},
		}),
		UnitView = e(UnitView, {
			UnitName = Props.UnitName,
			Distance = 4,
			RotationCFrame = RotationCFrame,
			Offset = Vector3.new(0, -0.5, 0),
			native = Join({
				Size = UDim2.fromScale(1.4, 1.1),

				Ambient = Props.OtherAlpha:map(function(otherAlpha: number)
					return Color3.new(1 * otherAlpha, 1 * otherAlpha, 1 * otherAlpha)
				end),
			}, Props.native),
		}),
		Name = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.75),
				Size = UDim2.fromScale(1, 0.15),
				Text = Props.UnitName,
			},
		}, {
			UIGradient = e("UIGradient", {
				Color = RarityData.Color,
			}),
			UIStroke = e(UIStroke.UIStrokeGradient, {
				GradColor = RarityData.StrokeColor,
				Stroke = 0.015,
			}),
		}),
		Rarity = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.9),
				Size = UDim2.fromScale(0.8, 0.1),

				Text = UnitData.Rarity,
			},
		}, {
			UIGradient = e("UIGradient", {
				Color = RarityData.Color,
			}),
			UIStroke = e(UIStroke.UIStrokeGradient, {
				GradColor = RarityData.StrokeColor,
				Stroke = 0.015,
			}),
		}),
	}, Props.children)
end

local Units = {
	"Pyrrhus",
	"Robert the Bruce",
	"Pompey",
}

local function CreateStarterChoose(props: Properties)
	local Highlighted, SetHighlighted = React.useState(nil :: string?)
	local Springs, API = ReactSpring.useSprings(3, function(i)
		return {
			alpha = 0,
			otheralpha = 0,
		}
	end)

	local ChangeIndex = React.useCallback(function(Index: number?)
		API.start(function(OtherIndex: number)
			return {
				alpha = Index == OtherIndex and 1 or 0,
			}
		end)
	end, {})

	local ChangeStrongIndex = React.useCallback(function(Index: number?)
		SetHighlighted(Index)
		API.start(function(OtherIndex: number)
			return {
				otheralpha = Index == OtherIndex and 1 or 0,
			}
		end)
	end, {})

	React.useEffect(function()
		local Disconnect = FirstJoin.SetCallback(function()
			if props.SetVisible then
				props.SetVisible(true)
			end
		end)

		return Disconnect
	end, {})

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(0.7, 0.6),
		}, props.native),
	}, {
		UIAspectRatio = e("UIAspectRatioConstraint", {
			AspectRatio = 1.5,
		}),
		Title = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.05),
				Size = UDim2.fromScale(0.8, 0.1),
				Text = "Choose Your Starter Unit",
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.01,
			}),
		}),
		Unit1 = e(CreateUnit, {
			UnitName = Units[1],
			Position = UDim2.fromScale(0.15, 0.45),
			Alpha = Springs[1].alpha :: any,
			OtherAlpha = Springs[1].otheralpha :: any,
			ChangeIndex = ChangeIndex,
			SetStrongIndex = ChangeStrongIndex,
			Index = 1,
		}),
		Unit2 = e(CreateUnit, {
			UnitName = Units[2],
			Position = UDim2.fromScale(0.5, 0.45),
			Alpha = Springs[2].alpha :: any,
			OtherAlpha = Springs[2].otheralpha :: any,
			ChangeIndex = ChangeIndex,
			SetStrongIndex = ChangeStrongIndex,
			Index = 2,
		}),
		Unit3 = e(CreateUnit, {
			UnitName = Units[3],
			Position = UDim2.fromScale(0.85, 0.45),
			Alpha = Springs[3].alpha :: any,
			OtherAlpha = Springs[3].otheralpha :: any,
			ChangeIndex = ChangeIndex,
			SetStrongIndex = ChangeStrongIndex,
			Index = 3,
		}),
		ConfirmButton = e(Main.Animateables.ImageButton, {
			Position = UDim2.fromScale(0.5, 1.15),

			native = {
				Position = UDim2.fromScale(0.5, 0.95),
				Size = UDim2.fromScale(0.5, 0.1),
				Image = "rbxassetid://80739823452825",
				ImageColor3 = Color3.new(1, 0.12549, 0.12549),
				Visible = Highlighted ~= nil,
				[React.Event.MouseButton1Click] = function()
					if Highlighted and DelayHandler("StarterConfirmButton", 0.5) then
						ChooseStarter.Fire(Units[Highlighted])
						if props.CloseClick then
							props.CloseClick()
						end
					end
				end,
			},
		}, {
			SelectLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.8, 0.5),
					Text = "Select",
					TextColor3 = Color3.new(1, 1, 1),
				},
			}),
			UIAspectRatio = e("UIAspectRatioConstraint", {
				AspectRatio = 3,
			}),
		}),
	}, props.children)
end

return CreateStarterChoose
