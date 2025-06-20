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

local Trade = Gui.Trade
local TradeContext = require(Trade.TradeContext)

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
	return e(Main.Frame, {
		native = {
			Size = UDim2.fromScale(1, 0.25),
		},
		children = {
			Container = e(Main.Frame, {
				native = {
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(50, 8, 66),
					Size = UDim2.fromScale(1, 0.9),
				},
				children = {
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(0.2, 0),
					}),
					PlayerTradeButton = e(Main.Animateables.ImageButton, {
						native = {
							Position = UDim2.fromScale(0.8, 0.5),
							Size = UDim2.fromScale(0.3, 0.6),
						},
						children = {
							UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
								AspectRatio = 4.01,
							}),
							Label = e(Main.TextLabel, {
								native = {
									Size = UDim2.fromScale(0.7, 0.7),
									Text = GetMessageFromStatus(Properties.Status),
								},
								children = {
									UIStroke = e(UIStroke.UIStrokeBasic, {
										Stroke = 0.002,
									}),
								},
							}),
						},
					}),
					PlayerImage = e(Main.ImageLabel, {
						native = {
							Position = UDim2.fromScale(0.1, 0.5),
							Size = UDim2.fromScale(0.122, 0.8),
							Image = "rbxassetid://90997125561155",
						},
						children = {
							UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
								AspectRatio = 1,
							}),
							ThumbnailImage = e(Main.ImageLabel, {
								native = {
									Image = HeleprFunctions.GetThumbnailAsync(Properties.Player),
									Size = UDim2.fromScale(0.95, 0.95),
								},
								children = {
									UICorner = e("UICorner", {
										CornerRadius = UDim.new(0.5, 0),
									}),
								},
							}),
							PlayerLabel = e(Main.TextLabel, {
								Position = UDim2.fromScale(0.41, 0.5),
								Size = UDim2.fromScale(0.45, 0.4),
								Text = Properties.Player.Name,
								TextXAlignment = Enum.TextXAlignment.Left,
							}),
						},
					}),
				},
			}),
		},
	})
end

local function CreateTradeMenu(Properties: Properties)
	local TradeStatuses = React.useContext(TradeContext.Context)
	local Frames, SetFrames = React.useState({})

	React.useEffect(function()
		local NewFrames = {}
		for Player, Status in pairs(TradeStatuses) do
			NewFrames[Player.UserId] = e(CreatePlayerFrame, {
				Player = Player,
				Status = Status,
			})
		end
		SetFrames(NewFrames)
	end, { TradeStatuses })

	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.6, 0.65),
			Image = "rbxassetid://85379476276657",
		}, Properties.native),
		children = {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1.355,
			}),
			MainFrame = e(Main.ScrollingFrame, {
				BarSize = 0.002,
				native = {
					Position = UDim2.fromScale(0.5, 0.525),
					Size = UDim2.fromScale(0.86, 0.8),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
				},
				children = Join({
					UIListLayout = e("UIListLayout", {
						Padding = UDim.new(0, 0),
					}),
					Padding = e("UIPadding", {
						PaddingRight = UDim.new(0.04, 0),
					}),
				}, Frames),
			}),
			NoPlayers = e(Main.Frame, {
				native = {
					Visible = HeleprFunctions.Len(TradeStatuses) == 0,
					Size = UDim2.fromScale(0.4, 0.15),
				},
				children = {
					NoPlayersLabel = e(Main.TextLabel, {
						native = {
							Size = UDim2.fromScale(1, 0.8),
							Text = "No Players",
						},
					}),
				},
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
		},
	})
end

return CreateTradeMenu
