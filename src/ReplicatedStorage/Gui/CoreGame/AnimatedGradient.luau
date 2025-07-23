--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateAnimatedGradient(
	props: Properties & { GradColor: ColorSequence, Animate: boolean, Speed: number? }
)
	local Color, SetColor = React.useBinding(nil :: ColorSequence?)

	React.useEffect(function()
		SetColor(props.GradColor)

		if props.GradColor and props.Animate then
			local OldColor = props.GradColor.Keypoints[1].Value
			local All = true

			for _, Keypoint in ipairs(props.GradColor.Keypoints) do
				if Keypoint.Value ~= OldColor then
					All = false
				end
			end

			if All then
				return function() end
			end

			-- Extract colors from the gradient keypoints
			local colors = {}
			for _, Keypoint in ipairs(props.GradColor.Keypoints) do
				table.insert(colors, Keypoint.Value)
			end

			-- Create NumberValue for tween animation
			local numVal = Instance.new("NumberValue")
			numVal.Value = 0

			-- Create tween with continuous looping
			local info =
				TweenInfo.new(1 * 2 / (props.Speed or 1), Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)
			local goal = { Value = 2 }
			local tween = TweenService:Create(numVal, info, goal)
			tween:Play()

			-- Connect to value changes
			local connection = numVal.Changed:Connect(function()
				local color
				if #colors >= 2 then
					local c1, c2 = colors[1], colors[2]

					if numVal.Value < 1 then
						color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, c2:Lerp(c1, numVal.Value)),
							ColorSequenceKeypoint.new(numVal.Value, c2),
							ColorSequenceKeypoint.new(1, c1:Lerp(c2, numVal.Value)),
						})
					else
						color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, c1:Lerp(c2, numVal.Value - 1)),
							ColorSequenceKeypoint.new(1, c2:Lerp(c1, numVal.Value - 1)),
						})
					end
				else
					-- Fallback for single color gradients
					color = props.GradColor
				end

				SetColor(color)
			end)

			return function()
				connection:Disconnect()
				tween:Cancel()
				numVal:Destroy()
			end
		end

		return function() end
	end, { props.GradColor, props.Animate } :: { unknown })

	return e(
		"UIGradient",
		Join({
			Color = Color,
		}, props.native),
		{},
		props.children
	)
end

return CreateAnimatedGradient
