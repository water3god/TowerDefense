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

-- Shared animation system
local sharedAnimationSystem = {
	numVal = nil :: NumberValue?,
	tween = nil :: Tween?,
	connections = {} :: { RBXScriptConnection },
	subscribers = {} :: { { callback: (number) -> (), speed: number } },
	isRunning = false,
	currentSpeed = 1,
}

local function updateAnimationSpeed()
	-- Find the fastest speed among all subscribers
	local maxSpeed = 1
	for _, subscriber in ipairs(sharedAnimationSystem.subscribers) do
		if subscriber.speed > maxSpeed then
			maxSpeed = subscriber.speed
		end
	end

	if maxSpeed ~= sharedAnimationSystem.currentSpeed then
		sharedAnimationSystem.currentSpeed = maxSpeed

		-- Restart animation with new speed if running
		if sharedAnimationSystem.isRunning then
			if sharedAnimationSystem.tween then
				sharedAnimationSystem.tween:Cancel()
			end

			local tweenDuration = 2 / maxSpeed
			local info = TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)
			local goal = { Value = 2 }
			local newTween = TweenService:Create(sharedAnimationSystem.numVal, info, goal)
			sharedAnimationSystem.tween = newTween
			newTween:Play()
		end
	end
end

local function startSharedAnimation()
	if sharedAnimationSystem.isRunning then
		return
	end

	-- Create shared NumberValue and tween
	local numVal = Instance.new("NumberValue")
	numVal.Value = 0

	local tweenDuration = 2 / sharedAnimationSystem.currentSpeed
	local info = TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)
	local goal = { Value = 2 }
	local tween = TweenService:Create(numVal, info, goal)

	sharedAnimationSystem.numVal = numVal
	sharedAnimationSystem.tween = tween
	sharedAnimationSystem.isRunning = true

	-- Connect to value changes and notify all subscribers
	local connection = numVal.Changed:Connect(function()
		for _, subscriber in ipairs(sharedAnimationSystem.subscribers) do
			local adjustedProgress = numVal.Value * subscriber.speed / sharedAnimationSystem.currentSpeed
			subscriber.callback(adjustedProgress % 2)
		end
	end)

	table.insert(sharedAnimationSystem.connections, connection)
	tween:Play()
end

local function stopSharedAnimation()
	if not sharedAnimationSystem.isRunning then
		return
	end

	-- Clean up connections
	for _, connection in ipairs(sharedAnimationSystem.connections) do
		connection:Disconnect()
	end
	sharedAnimationSystem.connections = {}

	-- Clean up tween and NumberValue
	if sharedAnimationSystem.tween then
		sharedAnimationSystem.tween:Cancel()
		sharedAnimationSystem.tween = nil
	end

	if sharedAnimationSystem.numVal then
		sharedAnimationSystem.numVal:Destroy()
		sharedAnimationSystem.numVal = nil
	end

	sharedAnimationSystem.isRunning = false
end

local function subscribeToAnimation(callback: (number) -> (), speed: number): () -> ()
	local subscriber = { callback = callback, speed = speed }
	table.insert(sharedAnimationSystem.subscribers, subscriber)

	-- Update animation speed and start if needed
	updateAnimationSpeed()
	if #sharedAnimationSystem.subscribers == 1 then
		startSharedAnimation()
	end

	-- Return unsubscribe function
	return function()
		-- Remove this subscriber
		for i, sub in ipairs(sharedAnimationSystem.subscribers) do
			if sub == subscriber then
				table.remove(sharedAnimationSystem.subscribers, i)
				break
			end
		end

		-- Update speed or stop animation
		if #sharedAnimationSystem.subscribers == 0 then
			stopSharedAnimation()
		else
			updateAnimationSpeed()
		end
	end
end

-- Precomputed helper functions
local function extractColorsFromGradient(gradColor: ColorSequence): { Color3 }
	local colors = {}
	for _, keypoint in ipairs(gradColor.Keypoints) do
		table.insert(colors, keypoint.Value)
	end
	return colors
end

local function isUniformColor(gradColor: ColorSequence): boolean
	if #gradColor.Keypoints <= 1 then
		return true
	end

	local firstColor = gradColor.Keypoints[1].Value
	for i = 2, #gradColor.Keypoints do
		if gradColor.Keypoints[i].Value ~= firstColor then
			return false
		end
	end
	return true
end

local function createAnimatedColorSequence(colors: { Color3 }, progress: number): ColorSequence
	if #colors < 2 then
		-- Fallback for single color - create a uniform gradient
		local singleColor = colors[1] or Color3.new(1, 1, 1)
		return ColorSequence.new(singleColor)
	end

	local c1, c2 = colors[1], colors[2]

	if progress < 1 then
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, c2:Lerp(c1, progress)),
			ColorSequenceKeypoint.new(progress, c2),
			ColorSequenceKeypoint.new(1, c1:Lerp(c2, progress)),
		})
	else
		local adjustedProgress = progress - 1
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, c1:Lerp(c2, adjustedProgress)),
			ColorSequenceKeypoint.new(1, c2:Lerp(c1, adjustedProgress)),
		})
	end
end

local function CreateAnimatedGradient(
	props: Properties & { GradColor: ColorSequence, Animate: boolean?, Speed: number? }
)
	local Color, SetColor = React.useBinding(nil :: ColorSequence?)

	-- Memoize extracted colors to avoid recomputation
	local extractedColors = React.useMemo(function()
		return extractColorsFromGradient(props.GradColor)
	end, { props.GradColor })

	-- Memoize uniform color check
	local isUniform = React.useMemo(function()
		return isUniformColor(props.GradColor)
	end, { props.GradColor })

	React.useEffect(function()
		SetColor(props.GradColor)

		local Animate = if props.Animate == nil then true else props.Animate

		if props.GradColor and Animate and not isUniform then
			-- Subscribe to the shared animation system
			local unsubscribe = subscribeToAnimation(function(progress: number)
				local animatedColor = createAnimatedColorSequence(extractedColors, progress)
				SetColor(animatedColor)
			end, props.Speed or 1)

			return unsubscribe
		end

		return function() end
	end, { props.GradColor, props.Animate, isUniform, extractedColors } :: { unknown })

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
