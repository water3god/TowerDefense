--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local CloseButton = require(CoreGame.CloseButton)
local Title = require(CoreGame.Title)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)

local Trade = Gui.Trade
local TradeContext = require(Trade.TradeContext)

local SettingsFolder = Gui.Settings
local SettingsContext = require(SettingsFolder.SettingsContext)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Client = ReplicatedStorage.Client
local TradeService = require(Client.LobbyClient.TradeService)

export type Properties = {
	CloseClick: () -> ()?,
	native: { [any]: any }?,
}

export type PlayerFrameProps = {
	Player: Player,
	Status: TradeService.TradeStatusMessage,
}

local function GetMessageFromStatus(Status: TradeService.TradeStatusMessage)
	if Status == "CanTrade" then
		return "Trade"
	elseif Status == "Trading" then
		return "Trading"
	elseif Status == "TradeDisabled" then
		return "Trade Disabled"
	else
		return "ERROR"
	end
end

local function CreatePlayerFrame(Properties: PlayerFrameProps)
	local ThumbnailImage, SetThumbnail = React.useState(nil :: string?)
	local SentId, SetSentId = React.useState(false)

	React.useEffect(function()
		local ThumbnailId = HelperFunctions.GetThumbnailIdAsync(Properties.Player.UserId)
		if ThumbnailId then
			SetThumbnail(ThumbnailId)
		end
	end, { Properties.Player })

	local ButtonColor = React.useMemo(function()
		if SentId then
			return Color3.fromRGB(155, 155, 155)
		end
		if Properties.Status == "CanTrade" then
			return Color3.fromRGB(0, 255, 0)
		elseif Properties.Status == "Trading" then
			return Color3.fromRGB(255, 255, 0)
		elseif Properties.Status == "TradeDisabled" then
			return Color3.fromRGB(255, 0, 0)
		else
			return Color3.fromRGB(255, 0, 0) -- Error state
		end
	end, { Properties.Status, SentId } :: { unknown })

	local Status = React.useMemo(function()
		if SentId then
			return "Sent"
		end
		return GetMessageFromStatus(Properties.Status)
	end, { Properties.Status, SentId } :: { unknown })

	local RequestTrade = React.useCallback(function()
		if SentId or Properties.Status ~= "CanTrade" then
			return
		end
		SetSentId(true)

		TradeService.SendTradeRequest(Properties.Player.UserId)
		task.delay(20, function()
			if SentId then
				SetSentId(false)
			end
		end)
	end, { Properties.Player, SentId, Properties.Status } :: { unknown })

	return e(Main.Frame, {
		native = {
			Size = UDim2.fromScale(1, 0.25),
		},
	}, {
		Container = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(50, 8, 66),
				Size = UDim2.fromScale(1, 0.9),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
			}),
			PlayerTradeButton = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.8, 0.5),
					Size = UDim2.fromScale(0.3, 0.6),
					Image = "rbxassetid://80739823452825",
					ImageColor3 = ButtonColor,
					[React.Event.MouseButton1Click] = RequestTrade,
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 3,
				}),
				Label = e(Main.TextLabel, {
					native = {
						Size = UDim2.fromScale(0.7, 0.7),
						Text = Status,
					},
				}, {
					UIStroke = e(UIStroke.UIStrokeAdvanced, {
						Stroke = 0.04,
					}),
				}),
			}),
			PlayerImage = e(Main.ImageLabel, {
				native = {
					Position = UDim2.fromScale(0.1, 0.5),
					Size = UDim2.fromScale(0.122, 0.8),
					Image = "rbxassetid://90997125561155",
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
				ThumbnailImage = e(Main.ImageLabel, {
					native = {
						Image = ThumbnailImage or "",
						Size = UDim2.fromScale(0.95, 0.95),
					},
				}, {
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(0.5, 0),
					}),
				}),
			}),
			PlayerLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.41, 0.5),
					Size = UDim2.fromScale(0.45, 0.4),
					Text = Properties.Player.Name,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}),
		}),
	})
end

local function CreateTradeMenu(Properties: Properties)
	local TradeStatuses = React.useContext(TradeContext.Context)
	local Settings = React.useContext(SettingsContext.Context)

	local PolicyInfo = Hooks.usePolicyInfo()

	local TradeFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}
		for Player, Status in pairs(TradeStatuses) do
			Frames["PlayerFrame" .. Player.UserId] = e(CreatePlayerFrame, {
				Player = Player,
				Status = Status :: any,
			})
		end

		return Frames
	end, { TradeStatuses })

	local Enabled, SetEnabled = React.useState(false)

	React.useEffect(function()
		SetEnabled(PolicyInfo.IsPaidItemTradingAllowed and Settings.CanTrade)
	end, { PolicyInfo, Settings } :: { unknown })

	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.6, 0.65),
			Image = "rbxassetid://85379476276657",
		}, Properties.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.355,
		}),
		MainFrame = Enabled and e(Main.ScrollingFrame, {
			BarSize = 0.002,
			native = {
				Position = UDim2.fromScale(0.52, 0.525),
				Size = UDim2.fromScale(0.9, 0.8),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
			},
		}, {
			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0, 0),
			}),
			Padding = e("UIPadding", {
				PaddingRight = UDim.new(0.04, 0),
			}),
		}, TradeFrames),
		NoPlayers = Enabled and e(Main.Frame, {
			native = {
				Visible = HelperFunctions.Len(TradeStatuses) == 0,
				Size = UDim2.fromScale(0.4, 0.15),
			},
		}, {
			NoPlayersLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(1, 0.8),
					Text = "No Players",
				},
			}),
		}),
		Disabled = not Enabled and e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.4, 0.15),
			},
		}, {
			NoPlayersLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(1, 0.8),
					Text = "Trading Disabled",
				},
			}),
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.12, 0.15),
			OnClick = Properties.CloseClick,
		}),
		Title = e(Title, {
			Title = "TRADING",
			Position = UDim2.fromScale(0.2, -0.02),
			Size = UDim2.fromScale(0.6, 0.6),
		}),
	})
end

return CreateTradeMenu
