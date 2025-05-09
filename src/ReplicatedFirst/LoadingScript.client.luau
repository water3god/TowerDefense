--!strict

-- By Wa1er_God --

-- Default Spawn Values

local Id = "rbxassetid://1"
local MapName = "Lobby"

local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TeleportService = game:GetService("TeleportService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui: PlayerGui = Player:WaitForChild("PlayerGui")

local ArrivingGui = TeleportService:GetArrivingTeleportGui()

local Ids = {}

local function PreloadAsync()
	ContentProvider:PreloadAsync({ game, ReplicatedStorage })
	ContentProvider:PreloadAsync(Ids)
	if not Player.Character then
		Player.CharacterAdded:Wait()
	end
	local InventoryService =
		require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("GlobalClient"):WaitForChild("InventoryService"))
	if not InventoryService.IsSynced then
		InventoryService.Synced:Wait()
	end
	task.wait(1)
end

local function HandleNewGui(Gui: typeof(script.LoadingGui))
	local Main = Gui.Main

	Main.MapImage.Image = Id
	Main.MapInfoLabel.Text = MapName
end

local Gui: typeof(script.LoadingGui) = nil

if ArrivingGui then
	ArrivingGui.Parent = PlayerGui
	Gui = ArrivingGui
else
	local LoadingGui = script:WaitForChild("LoadingGui"):Clone()
	HandleNewGui(LoadingGui)
	LoadingGui.Parent = PlayerGui
	Gui = LoadingGui
end

ReplicatedFirst:RemoveDefaultLoadingScreen()
PreloadAsync()

TweenService
	:Create(Gui.Main, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { GroupTransparency = 1 })
	:Play()
