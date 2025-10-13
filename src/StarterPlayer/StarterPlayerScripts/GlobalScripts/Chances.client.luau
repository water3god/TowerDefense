--!strict

-- By Wa1er_God --

-- Services --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local ReactRoblox = require(Packages.ReactRoblox)
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local ObserveTag = require(Modules.ObserveTag)
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Gui = ReplicatedStorage.Gui
local Roll = Gui.Roll
local Chances = require(Roll.Chances)

ObserveTag.ObserveTag("Chances", function(Part: Instance)
	if Part:IsA("BasePart") then
		local Root = ReactRoblox.createRoot(Instance.new("Folder"))

		Root:render(ReactRoblox.createPortal(
			e("SurfaceGui", {
				Adornee = Part,
				ResetOnSpawn = false,
				Face = Enum.NormalId.Back,
				SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
				PixelsPerStud = 75,
			}, {
				Chances = e(Chances),
			}),
			Part
		))

		return function()
			Root:unmount()
		end
	end

	return function() end
end)
