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

	return e(Main.ImageLabel, {
		native = Join({
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
			Size = UDim2.fromScale(0.7, 0.6),
			Image = "rbxassetid://138837230897413",
		}, props.native),
	}, {
		Title = e(Main.TextLabel, {
			native = {
				Text = "Select Count",
				Position = UDim2.fromScale(0.5, 0.15),
				Size = UDim2.fromScale(0.9, 0.08),
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
			}),
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.3, 0.2),
			OnClick = props.CloseClick,
			native = {
				ZIndex = 2,
			},
		}),
		ImageFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.4),
				Size = UDim2.fromScale(0.5, 0.4),
			},
		}, {
			Item = Item,
		}),
		BoxFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.7),
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
				Position = UDim2.fromScale(0.5, 0.85),
				Size = UDim2.fromScale(0.4, 0.2),
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
					Size = UDim2.fromScale(0.9, 0.6),
					Text = "Enter",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
				}),
			}),
		}),
	})
end

return CreateSelectCount
