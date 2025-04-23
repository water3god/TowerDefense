--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
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

local Inventory = Gui.Inventory
local UnitFrame = require(Inventory.UnitFrame)

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)
local InventoryService = require(GlobalClient.InventoryService)
local WaveService = require(GlobalClient.WaveService)

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateUpgradeFrame(Properties: Properties)
	local Container: { current: WorldModel? } = React.useRef(nil :: WorldModel?)
	React.useEffect(function()
		local Data = UnitClient.InitCharacter("Minigunner")
		Data.UnitModel.Parent = Container.current

		return function()
			Data.Trove:Destroy()
		end
	end, {})

	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.8, 0.8),
			Image = "rbxassetid://103903141717286",
		}, Properties.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.5,
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.2, 0.25),
		}),
		UnitName = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.175),
				Size = UDim2.fromScale(0.8, 0.12),
				Text = "Minigunner",
			},
		}, {
			UIListLayout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0),
			}),
		}),
		UnitFrame = e(Main.ViewportFrame, {
			native = {
				Size = UDim2.fromScale(0.45, 0.5),
				Position = UDim2.fromScale(0.275, 0.55),
			},
		}, {
			ModelContainer = e("WorldModel", {
				ref = Container,
			}),
			Camera = e("Camera", {
				CFrame = CFrame.new(),
			}),
			UIStroke = e(UIStroke.UIStrokeBasic, {
				Stroke = 0.001,
				Color = Color3.new(1, 1, 1),
				native = {
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),
		}),
		CurrentData = e(Main.Frame, {
			native = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.207843, 0.031373, 0.274510),
				Position = UDim2.fromScale(0.75, 0.6),
				Size = UDim2.fromScale(0.4, 0.6),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),
			UnitInfo = e(Main.ScrollingFrame, {
				BarSize = 0.002,
			}),
		}),
	}, Properties.children)
end

return CreateUpgradeFrame
