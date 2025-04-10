--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");

local ReactLua = ReplicatedStorage.Modules.ReactLua;
local React = require(ReactLua.React);
local e = React.createElement;

local Modules = ReplicatedStorage.Modules;
local Join = require(Modules.JoinDicts);

local Hooks = {};

function Hooks.useClock(): React.Binding<number>
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

function Hooks.useEventConnection<T...>(
	event: RBXScriptSignal<T...>, -- Can also include | Signal.Signal<T...> if you're using a custom signal type
	callback: (T...) -> (),
	dependencies: { any }
)
	local cachedCallback = React.useMemo(function()
		return callback
	end, dependencies)

	React.useEffect(function()
		local connection = event:Connect(cachedCallback)

		return function()
			connection:Disconnect()
		end
	end, { event, cachedCallback } :: { unknown })
end

return Hooks;