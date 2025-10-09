--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local ReactSpring = require(Packages.ReactSpring)
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

local SFXService = require(ReplicatedStorage.Client.GlobalClient.SFXService)

export type Properties = {
	Text: string?,
	Size: UDim2?,
	Color: "Black" | "Blue" | "Green" | "Orange" | "Pink" | "Purple" | "Red" | "Yellow"?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

type ColorSlice = { Left: string, Middle: string, Right: string }
local Colors: { [string]: ColorSlice } = {
	Black = {
		Left = "rbxassetid://138224089446869",
		Middle = "rbxassetid://107909409579626",
		Right = "rbxassetid://138098397177024",
	},
	Blue = {
		Left = "rbxassetid://122856991628758",
		Middle = "rbxassetid://127129201659927",
		Right = "rbxassetid://108136214394498",
	},
	Green = {
		Left = "rbxassetid://99689494579430",
		Middle = "rbxassetid://109715852646066",
		Right = "rbxassetid://120299234789410",
	},
	Orange = {
		Left = "rbxassetid://71165276059344",
		Middle = "rbxassetid://86276659184576",
		Right = "rbxassetid://89543631447050",
	},
	Pink = {
		Left = "rbxassetid://134244707606475",
		Middle = "rbxassetid://78870840497873",
		Right = "rbxassetid://124943324345237",
	},
	Purple = {
		Left = "rbxassetid://95865521005914",
		Middle = "rbxassetid://107753514275405",
		Right = "rbxassetid://100484646210006",
	},
	Red = {
		Left = "rbxassetid://117761782804611",
		Middle = "rbxassetid://135362362632742",
		Right = "rbxassetid://137550455005477",
	},
	Yellow = {
		Left = "rbxassetid://123400832474218",
		Middle = "rbxassetid://104820984358731",
		Right = "rbxassetid://123118389715128",
	},
}

local function CreateButton(props: Properties)
	local ParentFrame = React.useRef(nil :: Frame?)
	local LabelSize, SetLabelSize = React.useBinding(UDim2.fromScale(1.1, 0.3))

	React.useEffect(function()
		if ParentFrame.current then
			local Ratio = ParentFrame.current.AbsoluteSize.X / ParentFrame.current.AbsoluteSize.Y
			local Num = Ratio * 5

			SetLabelSize(UDim2.fromScale(0.2 + 1 / Num, 0.3))
		else
			SetLabelSize(UDim2.fromScale(1.1, 0.3))
		end
	end, { ParentFrame.current, props.Size } :: { unknown })

	local ColorName: string = (props.Color or "Black")
	local ColorSlice: ColorSlice = Colors[ColorName] or Colors.Black

	local function ApplyEffect()
		local Scale, API = ReactSpring.useSpring(function()
			return {
				to = { Scale = 1 },
				config = { mass = 1, tension = 2000, friction = 100 },
			}
		end)

		local List = React.useRef({})
		local current = React.useRef(Enum.GuiState.Idle)

		local function Check()
			local currentState = Enum.GuiState.Idle
			for Instance, State in pairs(List.current) do
				if State == Enum.GuiState.Press then
					currentState = Enum.GuiState.Press
				elseif State == Enum.GuiState.Hover then
					if currentState ~= Enum.GuiState.Press then
						currentState = Enum.GuiState.Hover
					end
				end
			end

			if currentState ~= current.current then
				if currentState == Enum.GuiState.Hover then
					API.stop()
					API.start({
						Scale = 1.1,
					})
				elseif currentState == Enum.GuiState.Press then
					API.stop()
					API.start({
						Scale = 0.95,
					})
					if RunService:IsClient() then
						SFXService.PlaySoundGlobalWithId("rbxassetid://9113873548", function(Sound: Sound)
							Sound.TimePosition = 0.9 * Sound.TimeLength
							Sound.Volume = 0.1
						end)
					end
				elseif currentState == Enum.GuiState.Idle then
					API.stop()
					API.start({
						Scale = 1,
					})
				end
			end
			current.current = currentState
		end

		local Callback = React.useCallback(function(Instance: GuiObject)
			if Instance.GuiState == Enum.GuiState.Hover then
				List.current[Instance] = Enum.GuiState.Hover
			elseif Instance.GuiState == Enum.GuiState.Press then
				List.current[Instance] = Enum.GuiState.Press
			elseif Instance.GuiState == Enum.GuiState.Idle then
				List.current[Instance] = nil
			end
			Check()
		end, {})

		return Scale, Callback
	end

	local Scale, Callback = ApplyEffect()

	return e(Main.TextButton, {
		native = Join({
			Text = "",
			Size = props.Size,
		}, props.native),
	}, {
		Label = props.Text and e(Main.TextLabel, {
			native = {
				Size = LabelSize,
				Text = props.Text,
				ZIndex = 2,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.01,
			}),
		}),
		ButtonMiddle = e(Main.ImageButton, {
			native = {
				Size = UDim2.fromScale(0.2, 1),
				Image = ColorSlice.Middle,
				ref = ParentFrame,
				[React.Change.GuiState] = Callback,
			},
		}),
		ButtonLeft = e(Main.ImageButton, {
			native = {
				Image = ColorSlice.Left,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.4, 0.5),
				AnchorPoint = Vector2.new(1, 0.5),
				[React.Change.GuiState] = Callback,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 0.744,
			}),
		}),
		ButtonRight = e(Main.ImageButton, {
			native = {
				Image = ColorSlice.Right,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.6, 0.5),
				AnchorPoint = Vector2.new(0, 0.5),
				[React.Change.GuiState] = Callback,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 0.744,
			}),
		}),
		AnimateScale = e("UIScale", {
			Scale = Scale.Scale:map(function(t)
				print(t)
				return t
			end),
		}),
	}, props.children)
end

return CreateButton
