--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");

local Packages = ReplicatedStorage.Packages;
local React = require(Packages.React);
local e = React.createElement;

local Modules = ReplicatedStorage.Modules;
local Join = require(Modules.JoinDicts);

local Hooks = {};

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

--[[function Hooks.ReactLerp(TotalTime: number, EndValue: number, Binding: React.Binding<number>, SetBinding: React.BindingUpdater<number>)
	React.useEffect(function()
		local StartTime = workspace:GetServerTimeNow();
		local Connection: RBXScriptConnection? = nil;
		local StartValue = Binding:getValue();
		Connection = RunService.PostSimulation:Connect(function(Delta: number)
			local Time = (workspace:GetServerTimeNow() - StartTime) + TotalTime;
			local alpha = (math.clamp(Time / TotalTime, 0, 1));
			local newalpha = TweenService:GetValue(alpha, LERPSTYLE, Enum.EasingDirection.Out);
			SetBinding(math.lerp(StartValue, EndValue, newalpha));

			if alpha == 1 then
				if Connection then
					Connection:Disconnect();
				end
			end
		end)

		return function()
			if Connection then
				Connection:Disconnect();
			end
		end
	end, {})

	return Binding, SetBinding;
end]]

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