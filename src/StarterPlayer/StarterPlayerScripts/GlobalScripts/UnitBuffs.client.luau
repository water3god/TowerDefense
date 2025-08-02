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
	local Root = ReactRoblox.createRoot(Instance.new("Folder"))

	local function HandleAll()
		Root:unmount()
		Root:render(ReactRoblox.createPortal(
			e("BillboardGui", {
				Adornee = Unit.Root,
				Size = UDim2.fromScale(6, 4),
				AlwaysOnTop = true,
				ExtentsOffsetWorldSpace = Vector3.new(0, -1, 0),
			}, {
				UnitBuffsFrame = e(UnitBuffs.Connected, {
					UniqueId = Unit.UniqueId,
				}),
			}),
			Unit.Root
		))
	end

	HandleAll()
	Unit.Upgraded:Connect(HandleAll)

	Unit.Destroying:Once(function()
		task.defer(Root.unmount, Root)
	end)
end

for _, Unit in pairs(UnitClient.GetUnits()) do
	HandleUnit(Unit)
end

UnitClient.NewUnit:Connect(HandleUnit)
