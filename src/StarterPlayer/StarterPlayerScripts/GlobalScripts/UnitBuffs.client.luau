--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local GameFrames = Gui.GameFrames
local UnitBuffs = require(GameFrames.UnitBuffs)

local GlobalClient = ReplicatedStorage.Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)

local function HandleUnit(Unit: UnitClient.Unit)
	local RootFolder = Instance.new("Folder")
	RootFolder.Name = "RootFolder"
	RootFolder.Parent = GameFrames

	local Root = ReactRoblox.createRoot(RootFolder)

	Root:render(e("BillboardGui", {
		Adornee = Unit.Root,
		Size = UDim2.fromScale(6, 4),
	}, {
		UnitBuffsFrame = e(UnitBuffs.Connected, {
			UniqueId = Unit.UniqueId,
		}),
	}))

	Unit.Destroying:Once(function()
		Root:unmount()
	end)
end

for _, Unit in pairs(UnitClient.GetUnits()) do
	HandleUnit(Unit)
end

UnitClient.NewUnit:Connect(HandleUnit)
