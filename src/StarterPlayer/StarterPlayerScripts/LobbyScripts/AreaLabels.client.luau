--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local ObserveTag = require(Modules.ObserveTag)

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)

ObserveTag.ObserveTag("AreaLabel", function(Part: Instance)
	if Part:IsA("BasePart") then
		local Root = ReactRoblox.createRoot(Part)

		local Size = Part:GetAttribute("Size") :: number? or 40
		local AlwaysOnTop = Part:GetAttribute("AlwaysOnTop") ~= false

		Root:render(e("BillboardGui", {
			ResetOnSpawn = false,
			AlwaysOnTop = AlwaysOnTop,
			Size = UDim2.fromScale(Size, Size),
		}, {
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.2),
					Text = Part.Name,
					TextColor3 = Part.Color,
				},
			}, {
				Stroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.02,
				}),
			}),
		}))

		return function() end
	end

	return function() end
end)
