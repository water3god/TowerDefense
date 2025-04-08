--[[
This module can also be ran on the server, if you wanted to do that for whatever reason
also note theres no caching yet

DEFAULT PROPERTIES:
	{
		EasingStyle = Enum.EasingStyle.Quad,
		EasingDirection = Enum.EasingDirection.Out,
		Steps = 0.01, --The increment for the loop, further explanation below
		
		DrawLine = false, --if you want to draw a line between the two cframes
		Width1 = 1, --only used if drawline is true
		Width2 = 2,
		
		Material = Enum.Material.Neon,
		Properties1 = {
			Color = c3n(1), --Color3
			Size = Vector3.one,
			CFrame = startcf, --the start plugged into the .new function
			Transparency = 0,
		},
		Properties2 = {
			Color = c3n(0,0,1), --Color3
			Size = Vector3.one*2,
			CFrame = endcf, --the end plugged into the .new function
			Transparency = 1,
		},
	}

The Steps parameter is both the speed and the lifetime of the effect.
The effect is updated each frame, and the amount is 1 divided by steps.

So if steps is 0.01, then the effect will take 100 frames to finish, and appears slower than
if it were 0.1, which would take 10 frames to finish. hope this makes sense

This devforum post better explains linear interpolation and alphas:
https://devforum.roblox.com/t/linear-interpolation-post-approval-%E2%9C%98/302097

CONTROLS:
Effect Make: local fx = fxv3.new(startcframe, endcframe, part, randomrotation?)
all are required but randomrot

the fromExisting parameter isnt meant for general use and should only used by the new fromExisting command

random rotation is a table describing what you want the rotation range to be:
{360,360,360} would be numbers between -360 and 360 on all axis
{0,180,0} would be numbers between -180 and 180 on only the y axis

part parameter is a string corresponding to a part in ReplicatedStorage.VFX

You can destroy the effect in two ways:
fx.Break = true
fx.Part:Destroy()

Other properties:
fx.Finished is a boolean that describes if the part has finished interpolating
fx.Pause can be set to true or false, and is pretty much self explanatory

fx.LineRotate: if DrawLine is enabled, this property can be enabled if you want the line to spin 180 degrees
fx.LineOffset: you don't really need to worry about this but it's used for the above property

fx.Animate: This is a default function that you can override if you want it to follow a certain path, and code it yourself.
Done like this:

fx.Animate = function(self, inc) --params can be named whatever ofc
	--self is the table for the part, inc is the increment the loop is on
end

Usage Example:
]]
--local fxv3 = require(game.ReplicatedStorage.EffectsV3)

local fxv3 = require(game.ReplicatedStorage.FunctionModules.FX.EffectsV3)

local asdf = fxv3.new(CFrame.new(0,5,0), CFrame.new(math.random(-10,10),20,math.random(-10,10)), "Block", {360,360,360})
asdf.EasingStyle = Enum.EasingStyle.Elastic
asdf.EasingDirection = Enum.EasingDirection.Out
asdf.Overshoot = 10 --You can control the overshoot factor of Elastic(out) and Back(out)
asdf.Steps = 0.01
asdf.Properties2.Transparency = 0
asdf.DrawLine = false

--[[
fx.fromExisting(fx)

Works similar to instance:Clone(), or more accurately, Instance.fromExisting()
This function should make it easier to issue out effects without repasting large blocks of code.

Usage Example:
]]
local asdf = fxv3.new(CFrame.new(-5, 0, 0), CFrame.new(0, 5, 0), "Block", {0, 360, 0})
asdf.Steps = 0.03
asdf.Properties2.Transparency = 0

local asdf2 = fxv3.fromExisting(asdf)
asdf2.Properties1.CFrame = CFrame.new(5,0,0)
asdf2.Properties1.Color = Color3.new(0,1,0)