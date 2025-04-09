local sin,cos,pi,round = math.sin,math.cos,math.pi,math.round

local EasingStyleOverrides = { --running these should be faster than getvalue, if it's not here itll default to getvalue
	[Enum.EasingStyle.Linear] = {
		[Enum.EasingDirection.In] = function(x)
			return x
		end,
		[Enum.EasingDirection.InOut] = function(x)
			return x
		end,
		[Enum.EasingDirection.Out] = function(x)
			return x
		end,
	},
	[Enum.EasingStyle.Elastic] = {
		[Enum.EasingDirection.Out] = function(x, w)
			local w = w or 10
			return 1-(1-x)^2*(((2*sin(w*x))/w)+cos(w*x))
		end,
	},
	[Enum.EasingStyle.Back] = {
		[Enum.EasingDirection.Out] = function(x,o)
			local o = o or 1.55
			return (1 - x)^3*0 + 3*(1 - x)^2*x*o + 3*(1 - x)*x^2*1 + x^3*1
		end,
	},
	[Enum.EasingStyle.Sine] = {
		[Enum.EasingDirection.Out] = function(x)
			return sin(pi*x*.5)
		end,
		[Enum.EasingDirection.In] = function(x)
			return cos(pi*x/2)+1
		end,
		[Enum.EasingDirection.InOut] = function(x)
			return sin(pi*x/2)^2
		end,
	},

	[Enum.EasingStyle.Quad] = {
		[Enum.EasingDirection.In] = function(x)
			return x^2
		end,
		[Enum.EasingDirection.Out] = function(x)
			return 1-(1-x)^2
		end,
	},
	[Enum.EasingStyle.Cubic] = {
		[Enum.EasingDirection.In] = function(x)
			return x^3
		end,
		[Enum.EasingDirection.Out] = function(x)
			return 1-(1-x)^3
		end,
	},
	[Enum.EasingStyle.Quart] = {
		[Enum.EasingDirection.In] = function(x)
			return x^4
		end,
		[Enum.EasingDirection.Out] = function(x)
			return 1-(1-x)^4
		end,
	},
	[Enum.EasingStyle.Quint] = {
		[Enum.EasingDirection.In] = function(x)
			return x^5
		end,
		[Enum.EasingDirection.Out] = function(x)
			return 1-(1-x)^5
		end,
	},

	["Step"] = { --custom one i found, put in a string for style and dir to use
		["Step"] = function(x,fps)
			return round(fps*x)/fps
		end,
	}
}

return EasingStyleOverrides
