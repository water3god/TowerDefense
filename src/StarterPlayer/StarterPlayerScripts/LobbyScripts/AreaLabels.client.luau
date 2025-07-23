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
		Root:render(e("BillboardGui", {
			ResetOnSpawn = false,
			AlwaysOnTop = true,
			Size = UDim2.fromScale(40, 40),
		}, {
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.3),
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
