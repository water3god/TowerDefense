--!strict

-- By Wa1er_God --

-- Services --

local PlusFont =
	Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Title = require(CoreGame.Title)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Client = ReplicatedStorage.Client
local TradeService = require(Client.LobbyClient.TradeService)

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Trove = require(Packages.Trove)

export type Properties = {
	Toggle: (Visible: boolean) -> (),
	native: { [any]: any },
}

local function CreateTradeFrame(Properties: any)
	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.45, 0.5),
			Image = "rbxassetid://120110890373605",
		}, Properties.native),
		children = Join({
			UIGridLayout = e("UIGridLayout", {
				CellPadding = UDim2.fromScale(0, 0),
				CellSize = UDim2.fromScale(0.33, 0.5),
				FillDirection = Enum.FillDirection.Horizontal,
			}),
		}, Properties.children),
	})
end

local function CreateButton(Properties: any)
	return e(Main.Animateables.ImageButton, {
		native = Join({
			Size = UDim2.fromScale(0.2, 0.2),
			Image = Properties.Image,
		}, Properties.native),
		children = {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 3.163,
			}),
			TextLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.8),
					Text = Properties.Text,
				},
				children = {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.004,
					}),
				},
			}),
		},
	})
end

local function TradeMain(Properties: Properties)
	local TradeData: TradeService.TradeData?, SetTradeData = React.useState(nil :: TradeService.TradeData?)
	local YourTrades, SetYourTrades = React.useState({})
	local OtherTrades, SetOtherTrades = React.useState({})

	React.useEffect(function()
		if TradeData then
		else
			SetYourTrades({})
			SetOtherTrades({})
		end
	end, { TradeData })

	React.useEffect(function()
		local Trove = Trove.new()
		Trove:Connect(TradeService.NewTrade, function(TradeData)
			SetTradeData(TradeData)
			Properties.Toggle(true)
		end)

		Trove:Connect(TradeService.Ended, function()
			SetTradeData(nil)
			Properties.Toggle(false)
		end)

		Trove:Connect(TradeService.UnitAdded, function(VisualData: TradeService.VisualUnitData, Player: Player)
			SetTradeData(TradeService.GetTradeData())
		end)

		Trove:Connect(TradeService.UnitRemoving, function(UniqueId: string, Player: Player)
			SetTradeData(TradeService.GetTradeData())
		end)

		return Trove:WrapClean()
	end, {})

	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.6, 0.6),
			Image = "rbxassetid://83575157481281",
		}, Properties.native),
		children = {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1.85,
			}),
			NoButton = e(CreateButton, {
				Image = "rbxassetid://97483072794272",
				Text = "Cancel",
				native = {
					Position = UDim2.fromScale(0.62, 0.85),
				},
			}),
			YesButton = e(CreateButton, {
				Image = "rbxassetid://121336998793729",
				Text = "Accept",
				native = {
					Position = UDim2.fromScale(0.38, 0.85),
				},
			}),
			OtherTrades = e(CreateTradeFrame, {
				native = {
					Position = UDim2.fromScale(0.735, 0.5),
				},
				children = {},
			}),
			YourTrades = e(CreateTradeFrame, {
				native = {
					Position = UDim2.fromScale(0.265, 0.5),
				},
				children = Join({
					AddButton = e(Main.Animateables.ImageButton, {
						native = {
							Image = "",
							LayoutOrder = 1000,
						},
						children = {
							UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
								AspectRatio = 1,
							}),
							BackgroundImage = e(Main.ImageLabel, {
								native = {
									Image = "rbxassetid://122297615155487",
								},
								children = {
									UIGradient = e("UIGradient", {
										Color = ColorSequence.new(
											Color3.new(0.258824, 0.043137, 0.384314),
											Color3.new(0.564706, 0.113725, 0.827451)
										),
									}),
								},
							}),
							Plus = e(Main.TextLabel, {
								native = {
									Text = "+",
									FontFace = PlusFont,
									Size = UDim2.fromScale(0.8, 0.8),
									ZIndex = 2,
								},
							}),
						},
					}),
				}),
			}),
			TradeImage = e(Main.ImageLabel, {
				native = {
					Image = "rbxassetid://71136210616050",
					Size = UDim2.fromScale(0.1, 0.175),
					ZIndex = 3,
				},
				children = {
					UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
						AspectRatio = 1,
					}),
				},
			}),
			OtherName = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.74, 0.15),
					Size = UDim2.fromScale(0.4, 0.1),
					Text = TradeData and TradeData.OtherPlayer.Name or "marchshark",
				},
			}),
			YourName = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.26, 0.15),
					Size = UDim2.fromScale(0.4, 0.1),
					Text = Player.Name,
				},
			}),
			Title = e(Title, {
				Title = "TRADING",
				Position = UDim2.fromScale(0.2, -0.02),
				Size = UDim2.fromScale(0.6, 0.6),
			}),
		},
	})
end

return TradeMain
