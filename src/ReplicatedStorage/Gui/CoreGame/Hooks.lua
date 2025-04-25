--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement
local Signal = require(Packages.Signal)

local Modules = ReplicatedStorage.Modules
local Join = require(Modules.JoinDicts)

local HelperFunctions = require(Modules.HelperFunctions)

local Hooks = {}

function Hooks.useClock()
	local clockBinding, setClockBinding = React.useBinding(0)

	React.useEffect(function()
		local stepConnection = RunService.PostSimulation:Connect(function(delta)
			setClockBinding(clockBinding:getValue() + delta)
		end)

		return function()
			stepConnection:Disconnect()
		end
	end, {})

	return clockBinding
end

function Hooks.ContextStack(props: {
	providers: {
		React.ComponentType<{
			children: React.ReactNode,
		}>
	},

	children: React.ReactNode,
})
	local mostRecent = e(props.providers[#props.providers], {}, props.children)

	for providerIndex = #props.providers - 1, 1, -1 do
		mostRecent = e(props.providers[providerIndex], {}, mostRecent)
	end

	return mostRecent
end

function Hooks.UseTime()
	local Time, SetTime = React.useBinding(1)
	local TotalTime, SetTotalTime = React.useBinding(1)
	local TimeData, SetTimeData = React.useState({ TotalTime = 0, StartTime = 0 })

	React.useEffect(function()
		SetTotalTime(TimeData.TotalTime)
		local Connection: RBXScriptConnection? = nil
		Connection = RunService.PostSimulation:Connect(function()
			local NewTime = math.clamp(
				TimeData.StartTime - workspace:GetServerTimeNow() + TimeData.TotalTime,
				0,
				TimeData.TotalTime
			)
			if NewTime == 0 then
				if Connection then
					Connection:Disconnect()
					Connection = nil
				end
			end
			SetTime(NewTime)
		end)

		return function()
			if Connection then
				Connection:Disconnect()
				Connection = nil
			end
		end
	end, { TimeData })

	return Time,
		TotalTime,
		function(TotalTime: number, StartTime: number)
			if TimeData.TotalTime ~= TotalTime or TimeData.StartTime ~= StartTime then
				SetTimeData({
					TotalTime = TotalTime,
					StartTime = StartTime,
				})
			end
		end
end

function Hooks.LayoutOrder(): () -> number
	local layoutOrder = 0

	return function()
		layoutOrder += 1
		return layoutOrder
	end
end

function Hooks.useEventConnection<T...>(
	event: RBXScriptSignal<T...> | Signal.Signal<T...>, -- Can also include | Signal.Signal<T...> if you're using a custom signal type
	callback: (T...) -> (),
	dependencies: { any }
)
	local cachedCallback = React.useMemo(function()
		return callback
	end, dependencies)

	React.useEffect(function()
		local connection = (event :: any):Connect(cachedCallback)

		return function()
			connection:Disconnect()
		end
	end, { event, cachedCallback } :: { unknown })
end

return Hooks
