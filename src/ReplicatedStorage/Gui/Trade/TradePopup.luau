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
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local CloseButton = require(CoreGame.CloseButton)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)

local TradeService = require(ReplicatedStorage.Client.LobbyClient.TradeService)

export type Properties = {
	Ids: { number },
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type PopupProps = {
	UserId: number,
	CloseClick: () -> ()?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type ConnectedProps = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function Popup(props: PopupProps)
	local Styles = ReactSpring.useSpring({
		from = { alpha = 0 },
		to = { alpha = 1 },
		config = { mass = 1, tension = 170, friction = 20, clamp = true, velocity = 0.01 } :: any,
	})

	local Username, SetUsername = React.useState("")

	local Accept = React.useCallback(function()
		TradeService.AcceptTrade(props.UserId)
	end, { props.UserId })

	local Reject = React.useCallback(function()
		TradeService.DeclineTrade(props.UserId)
	end, { props.UserId })

	React.useEffect(function()
		HelperFunctions.GetNameFromIdAsync(props.UserId)
			:andThen(function(Name: string)
				SetUsername(Name)
			end)
			:catch(function()
				warn("Failed to get username for UserId: " .. tostring(props.UserId))
			end)
	end, { props.UserId })

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(0.9, 0.3),
		}, props.native),
	}, {
		Container = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
				Size = Styles.alpha:map(function(alpha: number)
					return UDim2.fromScale(0.8, 0.725):Lerp(UDim2.fromScale(0.9, 0.8), alpha)
				end),
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 2,
			}),
			Title = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.225),
					Size = UDim2.fromScale(0.8, 0.15),
					Text = "Trade Request",
				},
			}),
			Description = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.8, 0.25),
					Text = string.format("You have received a trade request from %s", Username),
				},
			}),
			AcceptButton = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.3, 0.8),
					Size = UDim2.fromScale(0.3, 0.2),
					Image = "rbxassetid://80739823452825",
					ImageColor3 = Color3.fromRGB(0, 255, 0),
					[React.Event.MouseButton1Click] = Accept,
				},
			}, {
				Label = e(Main.TextLabel, {
					native = {
						Size = UDim2.fromScale(0.9, 0.7),
						Text = "Accept Trade",
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeAdvanced, {
						Stroke = 0.015,
					}),
				}),
			}),
			RejectButton = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.7, 0.8),
					Size = UDim2.fromScale(0.3, 0.2),
					Image = "rbxassetid://80739823452825",
					ImageColor3 = Color3.fromRGB(255, 0, 0),
					[React.Event.MouseButton1Click] = Reject,
				},
			}, {
				Label = e(Main.TextLabel, {
					native = {
						Size = UDim2.fromScale(0.9, 0.7),
						Text = "Reject Trade",
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeAdvanced, {
						Stroke = 0.015,
					}),
				}),
			}),
			CloseButton = e(CloseButton, {
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromScale(0.3, 0.3),
				OnClick = Reject,
				native = {
					ZIndex = 2,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.03, 0),
			}),
			InnerFrame = e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(0.5, 0.52),
					Size = UDim2.fromScale(0.94, 0.9),
				},
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0.02, 0),
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
		}),
	}, props.children)
end

local function CreateTradePopup(props: Properties)
	local Popups = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}
		local LayoutOrder = Hooks.LayoutOrder()

		for _, UserId in ipairs(props.Ids) do
			Frames["Popup" .. UserId] = e(Popup, {
				UserId = UserId,
				native = {
					LayoutOrder = LayoutOrder(),
				},
			})
		end

		return Frames
	end, { props.Ids })

	return e(Main.Frame, {
		native = Join({
			Position = UDim2.fromScale(0.8, 0.7),
			Size = UDim2.fromScale(0.5, 0.6),
		}, props.native),
	}, {
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
		}),
	}, Popups, props.children)
end

local function TradeConnected(props: ConnectedProps)
	local Ids, SetIds = React.useState({} :: { number })

	React.useEffect(function()
		local NewIds = {}
		for Player, _ in pairs(TradeService.TradeRequests) do
			table.insert(NewIds, Player.UserId)
		end
		SetIds(NewIds)
	end, {})

	Hooks.useEventConnection(TradeService.NewTradeRequest, function(OtherPlayer: Player)
		SetIds(Join(Ids, { OtherPlayer.UserId }))
	end, { Ids })

	Hooks.useEventConnection(TradeService.RequestEnded, function(OtherPlayer: Player)
		local NewIds = table.clone(Ids)
		local Index = table.find(NewIds, OtherPlayer.UserId)
		if Index then
			table.remove(NewIds, Index)
		end
		SetIds(NewIds)
	end, { Ids })

	return e(CreateTradePopup, {
		Ids = Ids,
		native = Join({}, props.native),
	}, {}, props.children)
end

return {
	Create = CreateTradePopup,
	Connected = TradeConnected,
}
