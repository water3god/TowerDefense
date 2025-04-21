--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)

export type Props = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateVoteFrame(Props: Props)
	return e(Main.Frame, {
		native = {
			Position = UDim2.fromScale(0.5, 0.225),
			Size = UDim2.fromScale(0.175, 0.2),
		},
		children = {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 2.15,
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.15, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeBasic, {
				Stroke = 0.002,
				native = {
					Color = Color3.fromRGB(103, 103, 104),
				},
			}),
			NoButton = e(Main.Animateables.TextButton, {
				native = {
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(255, 0, 3),
					Position = UDim2.fromScale(0.75, 0.75),
					Size = UDim2.fromScale(0.4, 0.25),
					Text = "",
				},
				children = {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.002,
						native = {
							Color = Color3.fromRGB(128, 36, 20),
						},
					}),
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(0.4, 0),
					}),
					Label = e(Main.TextLabel, {
						native = {
							Size = UDim2.fromScale(0.9, 0.9),
							Text = "No",
						},
						children = {
							UIStroke = e(UIStroke.UIStrokeBasic, {
								Stroke = 0.004,
							}),
						},
					}),
				},
			}),
			YesButton = e(Main.Animateables.TextButton, {
				native = {
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(0, 255, 19),
					Position = UDim2.fromScale(0.25, 0.75),
					Size = UDim2.fromScale(0.4, 0.25),
					Text = "",
				},
				children = {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.002,
						native = {
							Color = Color3.fromRGB(40, 93, 28),
						},
					}),
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(0.4, 0),
					}),
					Label = e(Main.TextLabel, {
						native = {
							Size = UDim2.fromScale(0.9, 0.9),
							Text = "Yes",
						},
						children = {
							UIStroke = e(UIStroke.UIStrokeBasic, {
								Stroke = 0.004,
							}),
						},
					}),
				},
			}),
			PlayerCount = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.45),
					Size = UDim2.fromScale(0.3, 0.2),
					Text = "0/1",
				},
			}),
			TimeLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 1.15),
					Size = UDim2.fromScale(0.6, 0.2),
					Text = "Starts In 5",
				},
				children = {
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.003,
					}),
				},
			}),
			Title = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.2),
					Size = UDim2.fromScale(0.7, 0.225),
					Text = "0/1",
				},
			}),
		},
	}, {})
end

return CreateVoteFrame
