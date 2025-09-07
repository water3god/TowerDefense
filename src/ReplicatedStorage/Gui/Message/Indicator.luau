--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local WaveService = require(GlobalClient.WaveService)

local Shared = ReplicatedStorage.Shared
local IsTutorial = require(Shared.IsTutorial)

export type Properties = {
	Wave: number,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateIndicator(props: Properties)
	local styles = ReactSpring.useSpring({
		from = { size = 1 },
		to = { size = 1.3 },
		loop = true,
	})

	local Parent = React.useRef(nil :: Instance?)

	local Enabled, SetEnabled = React.useState(false)

	React.useEffect(function()
		if not IsTutorial then
			return
		end

		local function HandleWave(Wave: WaveService.WaveData)
			if Wave.Wave == props.Wave then
				SetEnabled(true)
			end
		end

		local Wave = WaveService.GetWaveData()

		if Wave then
			HandleWave(Wave)
		end

		WaveService.Added:Connect(HandleWave)
		WaveService.Passed:Connect(function(Num: number)
			SetEnabled(Num == props.Wave)
		end)
	end, {})

	local OnClick = React.useCallback(function()
		SetEnabled(false)
	end, {})

	return Enabled
		and e(Main.Frame, {
			native = Join({
				ref = Parent,
				Active = false,
				Size = styles.size:map(function(size: number)
					return UDim2.fromScale(size, size)
				end),

				ZIndex = 1000,

				[React.Event.InputEnded] = OnClick,
			}, props.native),
		}, {
			UIStroke = e("UIStroke", {
				Thickness = 5,
				Color = Color3.new(0, 1, 0),
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			}),
		}, props.children)
end

return CreateIndicator
