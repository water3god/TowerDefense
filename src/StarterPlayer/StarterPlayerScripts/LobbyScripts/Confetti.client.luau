--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local ReactRoblox = require(Packages.ReactRoblox)
local React = require(Packages.React)
local e = React.createElement

local ClientOnly = require(ReplicatedStorage.Network.ClientOnly)
local SendWarning = ClientOnly.Warning

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local PurchaseService = require(GlobalClient.PurchaseService)

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)

local Shared = ReplicatedStorage.Shared
local ProductInfo = require(Shared.ProductInfo)

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local ConfettiGui = Instance.new("ScreenGui")
ConfettiGui.Name = "ConfettiGui"
ConfettiGui.ResetOnSpawn = false
ConfettiGui.DisplayOrder = 1000
ConfettiGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ConfettiGui.Parent = PlayerGui

local function CreateConfetti(props: { Color: Color3? })
	local BackgroundColor = React.useMemo(function()
		return props.Color or Color3.fromHSV(math.random(), 0.75, 1)
	end, { props.Color })

	local Rotation = React.useBinding(math.random(0, 360))
	local Position, SetPosition = React.useBinding(UDim2.fromScale(math.random(), math.random() * 2 - 2.3))

	React.useEffect(function()
		local Connection = RunService.Heartbeat:Connect(function(Delta: number)
			local OldPosition = Position:getValue()
			SetPosition(UDim2.fromScale(OldPosition.X.Scale, OldPosition.Y.Scale + Delta * 2))
		end)

		return function()
			Connection:Disconnect()
		end
	end, {})

	return e(Main.Frame, {
		native = {
			BackgroundTransparency = 0,
			BackgroundColor3 = BackgroundColor,
			Rotation = Rotation,
			Position = Position,
			Size = UDim2.fromScale(0.05, 0.03),
		},
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 3,
		}),
	})
end

local function Confetti(props: { RobuxSpent: number })
	local ConfettiElements = React.useMemo(function()
		local Color = nil

		if props.RobuxSpent >= 1000 then
			Color = Color3.fromRGB(255, 215, 0)
		end

		local elements: { [string]: React.Node } = {}
		for i = 1, 100, 1 do
			elements["Confetti" .. i] = e(CreateConfetti, { Color = Color })
		end
		return elements
	end, { props.RobuxSpent })

	return e(React.Fragment, nil, ConfettiElements)
end

local function OnPurchase(RobuxSpent: number)
	local Root = ReactRoblox.createRoot(Instance.new("Folder"))
	Root:render(ReactRoblox.createPortal(e(Confetti, { RobuxSpent = RobuxSpent }), ConfettiGui))

	task.delay(5, function()
		Root:unmount()
	end)
end

PurchaseService.GiftPurchased:Connect(function(ProductId: number)
	local ProductData, IsGamepass = ProductInfo.GetProductFromIdOnly(ProductId)
	if ProductData then
		SendWarning:Fire(string.format("Successfully purchased gift: %s", ProductData.Name), Color3.new(0, 1, 0))
	end
	if IsGamepass then
		OnPurchase(PurchaseService.GamepassData[ProductId].ProductInfo.PriceInRobux)
	else
		OnPurchase(PurchaseService.ProductData[ProductId].ProductInfo.PriceInRobux)
	end
end)

PurchaseService.ProductPurchased:Connect(function(ProductId: number)
	local ProductData, _ = ProductInfo.GetProductFromIdOnly(ProductId)
	if ProductData then
		SendWarning:Fire(string.format("Successfully purchased product: %s", ProductData.Name), Color3.new(0, 1, 0))
	end
	OnPurchase(PurchaseService.ProductData[ProductId].ProductInfo.PriceInRobux)
end)

PurchaseService.GamepassPurchased:Connect(function(ProductId: number)
	local ProductData, _ = ProductInfo.GetProductFromIdOnly(ProductId)
	if ProductData then
		SendWarning:Fire(string.format("Successfully purchased gamepass: %s", ProductData.Name), Color3.new(0, 1, 0))
	end
	OnPurchase(PurchaseService.GamepassData[ProductId].ProductInfo.PriceInRobux)
end)
