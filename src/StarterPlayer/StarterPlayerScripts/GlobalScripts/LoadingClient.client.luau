--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local NetworkFolder = ReplicatedStorage:WaitForChild("Network")
local Network = require(NetworkFolder:WaitForChild("Client"))
local ClientOnly = require(NetworkFolder:WaitForChild("ClientOnly"))

local TPGuiSet = Network.TPGuiSet
local TPGuiSetClient = ClientOnly.TPGuiSet

local LoadingGui = ReplicatedFirst:WaitForChild("LoadingScript"):WaitForChild("LoadingGui")

local function GuiSet(Data: { MapName: string, ImageId: string })
	local Gui = LoadingGui:Clone()
	local Main = Gui.Main
	Main.MapImage.Image = Data.ImageId
	Main.MapInfoLabel.Text = Data.MapName

	TeleportService:SetTeleportGui(Gui)

	Main.GroupTransparency = 1
	Gui.Parent = PlayerGui

	local LoadImage = Main.LoadImage

	local Connection = RunService.PostSimulation:Connect(function(Delta: number)
		LoadImage.Rotation += Delta * 100
	end)

	LoadImage.Destroying:Once(function()
		Connection:Disconnect()
	end)

	TweenService
		:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { GroupTransparency = 0 })
		:Play()
end

TPGuiSet.SetCallback(GuiSet)
TPGuiSetClient:Connect(GuiSet)
