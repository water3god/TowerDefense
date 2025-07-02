--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local Timer = require(Packages.Timer)
local React = require(Packages.React)
local e = React.createElement

local Shared = ReplicatedStorage.Shared
local TipsData = require(Shared.Tips)

local TipsContext = React.createContext(TipsData[1])

local function TipsProvider(props: { children: React.ReactNode })
	local currentTip, setCurrentTip = React.useState(TipsData[1])

	React.useEffect(function()
		local TipsTimer = Timer.new(5)
		local function updateTip()
			local randomIndex = math.random(1, #TipsData)
			setCurrentTip(TipsData[randomIndex])
		end

		TipsTimer.Tick:Connect(function()
			updateTip()
		end)

		TipsTimer:Start()
		updateTip()

		return function()
			TipsTimer:Destroy()
		end
	end, {})

	return e(TipsContext.Provider, {
		value = currentTip,
	}, props.children)
end

return {
	Context = TipsContext,
	Provider = TipsProvider,
}
