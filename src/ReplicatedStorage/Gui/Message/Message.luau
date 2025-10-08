--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

-- Libraries -
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local Trove = require(Packages.Trove)
local Input = require(Packages.Input)
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
local Hooks = require(CoreGame.Hooks)

local SFXService = require(ReplicatedStorage.Client.GlobalClient.SFXService)

local SoundEffects = SoundService.SoundEffects
local NPCBeep = SoundEffects.Sounds.Typing2

export type Properties = {
	SpeakerName: string,
	Messages: { string },
	SpeakerImage: string?,
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateMessage(props: Properties)
	local LerpedMessage, SetLerpedMessage = React.useState("")
	local CurrentMessageIndex, SetCurrentMessageIndex = React.useState(1)

	local Translator = Hooks.useTranslator()

	React.useEffect(function()
		SetCurrentMessageIndex(1)
	end, { props.Messages })

	local function GoToLastMessage()
		if CurrentMessageIndex > 1 then
			SetCurrentMessageIndex(CurrentMessageIndex - 1)
		else
			SetCurrentMessageIndex(#props.Messages)
		end
	end

	local function GoToNextMessage()
		if CurrentMessageIndex < #props.Messages then
			SetCurrentMessageIndex(CurrentMessageIndex + 1)
		else
			SetCurrentMessageIndex(1)
		end
	end

	React.useEffect(function()
		local InputTrove = Trove.new()
		local Disconnect = Input.PreferredInput.Observe(function(PreferredInput)
			if PreferredInput == "MouseKeyboard" then
				local Keyboard = InputTrove:Construct(Input.Keyboard)

				Keyboard.KeyUp:Connect(function(Key: Enum.KeyCode)
					if Key == Enum.KeyCode.KeypadEnter then
						GoToNextMessage()
					end
				end)
			end
		end)

		return function()
			Disconnect()
		end
	end, { props.Messages, CurrentMessageIndex } :: { unknown })

	React.useEffect(function()
		SetLerpedMessage("")
		local CurrentMessage = props.Messages[CurrentMessageIndex] or ""
		local MessageTrove = Trove.new()

		if Translator then
			CurrentMessage = Translator:Translate(game, CurrentMessage)
		end

		for i = 1, #CurrentMessage do
			local MessagePromise = Promise.delay(0.02 * i):andThen(function()
				SetLerpedMessage(string.sub(CurrentMessage, 1, i))
				--SFXService.PlaySoundGlobal(NPCBeep)
			end)
			MessageTrove:AddPromise(MessagePromise :: any)
		end
		return function()
			MessageTrove:Destroy()
		end
	end, { CurrentMessageIndex, props.Messages, Translator } :: { unknown })

	return e(Main.Frame, {
		native = Join({
			Position = UDim2.fromScale(0.5, 0.65),
			Size = UDim2.fromScale(0.4, 0.25),
		}, props.native),
	}, {
		Image = e(Main.ImageLabel, {
			native = {
				Size = UDim2.fromScale(1.1, 1.25),
				Image = "rbxassetid://91626238417472",
			},
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 2.9,
		}),
		UISizeConstraint = e("UISizeConstraint", {
			MinSize = Vector2.new(300, 75),
			MaxSize = Vector2.new(1200, 300),
		}),
		CloseButton = e(CloseButton, {
			OnClick = props.CloseClick,
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.4, 0.4),
		}),
		SpeakerImage = props.SpeakerImage and e(Main.ImageLabel, {
			native = {
				Position = UDim2.fromScale(-0.15, 0.4),
				Size = UDim2.fromScale(0.4, 0.8),
				Image = props.SpeakerImage,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
		SpeakerLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.16),
				Size = UDim2.fromScale(0.9, 0.15),
				Text = props.SpeakerName,
				TextXAlignment = Enum.TextXAlignment.Left,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.01,
			}),
		}),
		LeftArrow = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(-0.08, 0.5),
				Size = UDim2.fromScale(0.1, 0.25),
				Image = "rbxassetid://73864431143188",
				Rotation = 180,
				Visible = CurrentMessageIndex > 1,
				[React.Event.MouseButton1Click] = GoToLastMessage,
			},
		}),
		RightArrow = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(1.08, 0.5),
				Size = UDim2.fromScale(0.1, 0.25),
				Image = "rbxassetid://73864431143188",
				Visible = CurrentMessageIndex < #props.Messages,
				[React.Event.MouseButton1Click] = GoToNextMessage,
			},
		}),
		MessageLabel = e(Main.TextLabel, {
			native = {
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0.3),
				Size = UDim2.fromScale(0.9, 0.625),
				Text = LerpedMessage,
				AutoLocalize = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.005,
			}),
			UITextSizeConstraint = e("UITextSizeConstraint", {
				MaxTextSize = 16,
			}),
		}),
	}, props.children)
end

return CreateMessage
