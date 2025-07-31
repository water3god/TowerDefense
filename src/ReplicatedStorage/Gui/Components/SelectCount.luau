--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Title = require(CoreGame.Title)
local CloseButton = require(CoreGame.CloseButton)

local WarningFolder = Gui.Warning
local WarningContext = require(WarningFolder.WarningContext)

export type Properties = {
	OnClick: (Count: number) -> (),
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: any,
}

local function CreateSelectCount(props: Properties)
	local WarningData = React.useContext(WarningContext.Context)

	local Item = React.Children.only(props.children)

	local TextBoxText = React.useRef("")

	local EnterClick = React.useCallback(function()
		local Count = tonumber(TextBoxText.current)
		if Count then
			props.OnClick(Count)
		else
			WarningData.Add("Please enter a valid number.")
		end
	end, {})

	return e(Main.Frame, {
		native = Join({
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
			Size = UDim2.fromScale(0.7, 0.6),
		}, props.native),
	}, {
		Title = e(Main.TextLabel, {
			native = {
				Text = "Select Count",
				Position = UDim2.fromScale(0.5, 0.175),
				Size = UDim2.fromScale(0.9, 0.1),
			},
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 0.7,
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.3, 0.2),
			OnClick = props.CloseClick,
			native = {
				ZIndex = 2,
			},
		}),
		InnerFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.52),
				Size = UDim2.fromScale(0.94, 0.9),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.015, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Color = Color3.new(0.388235, 0.101961, 0.486275),
				Stroke = 0.002,
				native = {
					Transparency = 0.1,
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
		}),
		UIStroke = e(UIStroke.UIStrokeAdvanced, {
			Color = Color3.new(0.866667, 0.866667, 0.866667),
			Stroke = 0.002,
			native = {
				LineJoinMode = Enum.LineJoinMode.Round,
			},
		}),
		ImageFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.45),
				Size = UDim2.fromScale(0.5, 0.4),
			},
		}, {
			Item = Item,
		}),
		BoxFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.725),
				Size = UDim2.fromScale(0.5, 0.1),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
			},
		}, {
			TextBox = e(Main.TextBox, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.9, 0.7),
					PlaceholderText = "Enter Count",
					Text = "",
					[React.Change.Text] = function(rbx: TextBox)
						TextBoxText.current = rbx.Text
					end,
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
			}),
		}),
		EnterButton = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.5, 0.875),
				Size = UDim2.fromScale(0.5, 0.2),
				Image = "rbxassetid://80739823452825",
				ImageColor3 = Color3.fromRGB(135, 1, 203),
				[React.Event.Activated] = EnterClick,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 3.2,
			}),
			TextLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.7),
					Text = "Enter",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.04,
				}),
			}),
		}),
	})
end

return CreateSelectCount
