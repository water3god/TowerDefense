--!strict

-- By Wa1er_God --

local DefaultFont =
	Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local JoinDicts = HelperFunctions.joinDicts

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local DefaultScrolling = require(CoreGame.DefaultScrolling)

local SFXService = require(ReplicatedStorage.Client.GlobalClient.SFXService)

local DefaultGui = {}

local DefaultProps = {
	BackgroundTransparency = 1,
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderColor3 = Color3.new(0, 0, 0),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	BorderSizePixel = 0,
}

local DefaultText = {
	Text = "DefaultText",
	FontFace = DefaultFont,
	TextScaled = true,
	RichText = true,
	TextColor3 = Color3.new(1, 1, 1),
}

local DefaultImage = {
	Image = "rbxassetid://113696247140901",
}

local DefaultButton = {
	AutoButtonColor = false,
}

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

function DefaultGui.Frame(Properties: Properties)
	return e("Frame", JoinDicts(DefaultProps, Properties.native), Properties.children)
end

function DefaultGui.ImageLabel(Properties: Properties)
	return e("ImageLabel", JoinDicts(DefaultProps, DefaultImage, {}, Properties.native), Properties.children)
end

function DefaultGui.ImageButton(Properties: Properties)
	return e(
		"ImageButton",
		JoinDicts(DefaultProps, DefaultImage, DefaultButton, {}, Properties.native),
		Properties.children
	)
end

function DefaultGui.TextLabel(Properties: Properties)
	return e("TextLabel", JoinDicts(DefaultProps, DefaultText, {}, Properties.native), Properties.children)
end

function DefaultGui.TextButton(Properties: Properties)
	return e(
		"TextButton",
		JoinDicts(DefaultProps, DefaultText, DefaultButton, {}, Properties.native),
		Properties.children
	)
end

function DefaultGui.TextBox(Properties: Properties)
	return e(
		"TextBox",
		JoinDicts(DefaultProps, DefaultText, {
			PlaceholderText = "Enter Text...",
		}, Properties.native),
		Properties.children
	)
end

function DefaultGui.CanvasGroup(Properties: Properties)
	return e("CanvasGroup", JoinDicts(DefaultProps, Properties.native), Properties.children)
end

function DefaultGui.ScrollingFrame(Properties: Properties & { BarSize: number })
	return e(DefaultScrolling, {
		BarSize = Properties.BarSize,
		native = JoinDicts(DefaultProps, {
			ScrollBarImageColor3 = Color3.new(0.444053, 0.448447, 0.448447),
			CanvasSize = UDim2.fromScale(0, 0),
		}, Properties.native),
	}, Properties.children)
end

function DefaultGui.ViewportFrame(Properties: Properties)
	return e("ViewportFrame", JoinDicts(DefaultProps, Properties.native), Properties.children)
end

local Animateables = {}
DefaultGui.Animateables = Animateables

do
	local function ApplyEffect()
		local Scale, API = ReactSpring.useSpring(function()
			return {
				to = { Scale = 1 },
				config = { mass = 1, tension = 2000, friction = 100 },
			}
		end)

		local Callback = React.useCallback(function(Instance: GuiObject)
			if Instance.GuiState == Enum.GuiState.Hover then
				API.stop()
				API.start({
					Scale = 1.1,
				})
			elseif Instance.GuiState == Enum.GuiState.Press then
				API.stop()
				API.start({
					Scale = 0.95,
				})
				if RunService:IsClient() then
					SFXService.PlaySoundGlobalWithId("rbxassetid://72255888882620", function(Sound: Sound)
						Sound.Volume = 0.1
					end)
				end
			elseif Instance.GuiState == Enum.GuiState.Idle then
				API.stop()
				API.start({
					Scale = 1,
				})
			end
		end, {})

		return Scale, Callback
	end

	function Animateables.ImageButton(Properties: Properties)
		local Scale, Callback = ApplyEffect()

		return e(DefaultGui.ImageButton, {
			native = JoinDicts(Properties.native, {
				[React.Change.GuiState] = Callback,
			}),
		}, {
			AnimateScale = e("UIScale", {
				Scale = Scale.Scale,
			}),
		}, Properties.children)
	end

	function Animateables.TextButton(Properties: Properties)
		local Scale, Callback = ApplyEffect()

		return e(DefaultGui.TextButton, {
			native = JoinDicts(Properties.native, {
				[React.Change.GuiState] = Callback,
			}),
		}, {
			AnimateScale = e("UIScale", {
				Scale = Scale.Scale,
			}),
		}, Properties.children)
	end
end

return DefaultGui
