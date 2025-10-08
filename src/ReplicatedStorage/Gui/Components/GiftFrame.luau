--!strict

-- By Wa1er_God --

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Network = require(ReplicatedStorage.Network.Client)
local SendGift = Network.SendGift

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local Hooks = require(CoreGame.Hooks)
local UIStroke = require(CoreGame.UIStroke)
local CloseButton = require(CoreGame.CloseButton)
local NewGui = require(CoreGame.NewGui)

export type PlayerProps = {
	Name: string,
	OnClick: () -> (),
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type Properties = {
	ProductId: number,
	GiftId: number,
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreatePlayerFrame(props: PlayerProps)
	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(0.9, 0.12),
		}, props.native),
	}, {
		Container = e(Main.Animateables.TextButton, {
			native = {
				Text = "",
				Size = UDim2.fromScale(0.9, 0.8),
				BackgroundColor3 = Color3.new(0.313725, 0.313725, 0.313725),
				BackgroundTransparency = 0,
				[React.Event.MouseButton1Click] = props.OnClick,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.01,
				native = {
					LineJoinMode = Enum.LineJoinMode.Round,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),
			Label = e(Main.TextLabel, {
				native = {
					Text = props.Name,
					Size = UDim2.fromScale(0.9, 0.8),
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.01,
				}),
			}),
		}),
	}, props.children)
end

local function CreateGiftFrame(props: Properties)
	local PlayerList = Hooks.usePlayers()

	local PlayerClick = React.useCallback(function(Player: Player?)
		SendGift.Fire(Player)
		MarketplaceService:PromptProductPurchase(LocalPlayer, props.GiftId)
	end, { props.GiftId } :: { unknown })

	local PlayerFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for Index, Player in ipairs(PlayerList) do
			if Player ~= LocalPlayer then
				Frames["Player" .. Player.UserId] = e(CreatePlayerFrame, {
					Name = Player.Name,
					OnClick = function()
						PlayerClick(Player)
					end,
					native = {
						LayoutOrder = Index,
					},
				})
			end
		end

		return Frames
	end, { PlayerList, PlayerClick } :: { unknown })

	return e(NewGui, {}, {
		Container = e(Main.ImageLabel, {
			native = Join({
				Size = UDim2.fromScale(0.4, 0.8),
				Image = "rbxassetid://138837230897413",
			}, props.native),
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 0.8,
			}),
			UISizeConstraint = e("UISizeConstraint", {
				MinSize = Vector2.new(210, 230),
				MaxSize = Vector2.new(840, 920),
			}),
			Title = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.15),
					Size = UDim2.fromScale(0.8, 0.1),
					Text = "Select a Friend to Send Gift",
				},
			}),
			MainFrame = e(
				Main.ScrollingFrame,
				{
					BarSize = 0.01,
					native = {
						Position = UDim2.fromScale(0.5, 0.6),
						Size = UDim2.fromScale(0.95, 0.75),
						ZIndex = 2,
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
					},
				},
				{
					UIListLayout = e("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 0),
						FillDirection = Enum.FillDirection.Vertical,
					}),
				},
				PlayerFrames,
				{
					SaveFrame = e(CreatePlayerFrame, {
						Name = "Save Product",
						OnClick = function()
							PlayerClick(nil)
						end,
						native = {
							LayoutOrder = 100,
						},
					}),
				}
			),
			CloseButton = e(CloseButton, {
				Position = UDim2.fromScale(0.98, 0.02),
				Size = UDim2.fromScale(0.2, 0.25),
				OnClick = props.CloseClick,
			}),
		}, props.children),
	})
end

return CreateGiftFrame
