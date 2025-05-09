--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Trove = require(Packages.Trove)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local CoreGame = ReplicatedStorage.Gui.CoreGame
local Hooks = require(CoreGame.Hooks)

local Camera = workspace.CurrentCamera

local IsRunning = RunService:IsRunning()

export type PropertiesBasic = {
	Stroke: number,
	Color: Color3?,
	StrokeMode: Enum.ApplyStrokeMode?,
	Transparency: number?,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type PropertiesNormal = PropertiesBasic & { GradColor: ColorSequence? }

local function CreateUIGrad(Properties: { Color: ColorSequence? })
	return React.createElement("UIGradient", {
		Color = Properties.Color,
	})
end

local function CalculateRatio(Ratio: number)
	if IsRunning then
		return Ratio * Camera.ViewportSize.X
	else
		return Ratio * Camera.ViewportSize.X / 1
	end
end

local Funcs = {}

function Funcs.UIStrokeBasic(Properties: PropertiesBasic)
	local Size, SetSize = React.useBinding(1)

	React.useEffect(function()
		SetSize(CalculateRatio(Properties.Stroke))

		local Connection = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			SetSize(CalculateRatio(Properties.Stroke))
		end)

		return function()
			Connection:Disconnect()
		end
	end, {})

	--[[Hooks.useEventConnection(Camera:GetPropertyChangedSignal("ViewportSize"), function()
		SetSize(CalculateRatio(Properties.Stroke))
	end, {})]]

	return e(
		"UIStroke",
		Join({
			Thickness = Size,
			Color = Properties.Color or Color3.new(),
			LineJoinMode = Enum.LineJoinMode.Bevel,
			ApplyStrokeMode = Properties.StrokeMode or Enum.ApplyStrokeMode.Contextual,
			Transparency = Properties.Transparency or 0,
		}, Properties.native),
		Properties.children
	)
end

function Funcs.UIStroke(Properties: PropertiesNormal)
	return e(
		Funcs.UIStrokeBasic,
		Join(
			Properties,
			{
				native = Join({
					Color = Color3.new(1, 1, 1),
				}, Properties.native),
			} :: any
		),
		{
			UIGradient = e(CreateUIGrad, {
				Color = Properties.GradColor,
			}),
		},
		Properties.children
	)
end

function Funcs.UIStrokeAdvanced(Properties: PropertiesBasic)
	local Size, SetSize = React.useState(1)

	local Stroke: { current: UIStroke? } = React.useRef(nil)

	React.useEffect(function()
		local Trove = Trove.new()

		if Stroke.current then
			local Stroke = Stroke.current

			if Stroke.Parent and Stroke.Parent:IsA("GuiObject") then
				Trove:Connect(Stroke.Parent:GetPropertyChangedSignal("AbsoluteSize"), function()
					local AbsoluteSize = Stroke.Parent.AbsoluteSize
					local TotalSize = (AbsoluteSize.X + AbsoluteSize.Y) / 2
					SetSize(TotalSize * Properties.Stroke)
				end)
			end
		end

		return Trove:WrapClean()
	end, { Stroke.current, Properties.Stroke :: any })

	return e(
		"UIStroke",
		Join({
			ref = Stroke,
			Thickness = Size,
			Color = Properties.Color or Color3.new(),
			LineJoinMode = Enum.LineJoinMode.Bevel,
			ApplyStrokeMode = Properties.StrokeMode or Enum.ApplyStrokeMode.Contextual,
			Transparency = Properties.Transparency or 0,
		}, Properties.native),
		Properties.children
	)
end

function Funcs.UIStrokeGradient(Properties: PropertiesNormal)
	return e(
		Funcs.UIStrokeAdvanced,
		Join(
			Properties,
			{
				native = Join({
					Color = Color3.new(1, 1, 1),
				}, Properties.native),
			} :: any
		),
		{
			UIGradient = e(CreateUIGrad, {
				Color = Properties.GradColor,
			}),
		},
		Properties.children
	)
end

return Funcs
