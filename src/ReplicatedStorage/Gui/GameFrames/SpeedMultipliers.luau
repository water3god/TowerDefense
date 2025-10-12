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

local Network = require(ReplicatedStorage.Network.Client)
local ChangeMultiplier = Network.ChangeMultiplier
local MultiplierChanged = Network.MultiplierChanged

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)

local Store = Gui.Store
local PurchaseContext = require(Store.PurchaseContext)

local Warning = Gui.Warning
local WarningContext = require(Warning.WarningContext)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local WaveService = require(GlobalClient.WaveService)

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateSpeedMultipliers(props: Properties)
	local PurchaseData = React.useContext(PurchaseContext.Context)
	local WarningData = React.useContext(WarningContext.Context)
	local CurrentMultiplier, SetCurrentMultiplier = React.useState(1)

	local SetMultiplier = React.useCallback(function(Multiplier: number)
		ChangeMultiplier.Fire(Multiplier)
	end, {})

	Hooks.useEventConnection(WaveService.Ended, function()
		SetCurrentMultiplier(1)
	end, {})

	Hooks.useZapConnection(MultiplierChanged, function(Multiplier: number)
		SetCurrentMultiplier(Multiplier)
	end, {})

	local Buttons = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for i = 1, 3, 1 do
			Frames["ButtonMultiplier" .. i] = e(Main.Frame, {
				native = {
					LayoutOrder = i,
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
				Button = e(Main.Animateables.ImageButton, {
					native = {
						Image = CurrentMultiplier == i and "rbxassetid://127473759461051"
							or "rbxassetid://72363371760692",
						[React.Event.MouseButton1Click] = function()
							if i == 3 then
								local Data = PurchaseData.GamepassData[1531313673]
								if Data then
									if not Data.Owned then
										WarningData.Add("You do not own the 3x Speed gamepass.")
										MarketplaceService:PromptGamePassPurchase(LocalPlayer, 1531313673)
										return
									end
								end
							end
							SetMultiplier(i)
						end,
						Size = UDim2.fromScale(0.9, 0.9),
					},
				}, {
					Label = e(Main.TextLabel, {
						native = {
							Size = UDim2.fromScale(0.7, 0.6),
							Text = tostring(i) .. "x",
						},
					}, {
						UIStroke = e(UIStroke.UIStrokeAdvanced, {
							Stroke = 0.02,
						}),
					}),
				}),
			})
		end

		return Frames
	end, { CurrentMultiplier, SetMultiplier } :: { unknown })

	return e(Main.Frame, {
		native = Join({
			AnchorPoint = Vector2.new(1, 1),
			Size = UDim2.fromScale(0.15, 0.3),
			Position = UDim2.fromScale(1, 1),
		}, props.native),
	}, {
		Container = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.8, 0.8),
			},
		}, {
			UIListLayout = e(Main.UIListLayout, {
				native = {
					FillDirection = Enum.FillDirection.Vertical,
				},
			}),
		}, Buttons),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 0.4,
		}),
	}, props.children)
end

return CreateSpeedMultipliers
