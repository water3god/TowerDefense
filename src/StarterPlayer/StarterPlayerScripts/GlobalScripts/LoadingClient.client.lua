--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TeleportService = game:GetService("TeleportService");
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");

local Player = Players.LocalPlayer;
local PlayerGui = Player.PlayerGui;

local BoothEvents = ReplicatedStorage.Remotes.Booth;
local TPGuiSet = BoothEvents.ServerFires.TPGuiSet;
local TPGuiSetClient = BoothEvents.ClientOnly.TPGuiSet;

local LoadingGui = ReplicatedFirst:WaitForChild("LoadingScript"):WaitForChild("LoadingGui");

local function GuiSet(Data: {MapName: string, ImageId: string})
	local Gui = LoadingGui:Clone();
	local Main = Gui.Main;
	Main.MapImage.Image = Data.ImageId;
	Main.MapInfoLabel.Text = Data.MapName;

	TeleportService:SetTeleportGui(Gui);

	Main.GroupTransparency = 1;
	Gui.Parent = PlayerGui;

	TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play();
end

TPGuiSet.OnClientEvent:Connect(GuiSet);
TPGuiSetClient.Event:Connect(GuiSet);