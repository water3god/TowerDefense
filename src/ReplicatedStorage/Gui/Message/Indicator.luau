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
	local Position, SetPosition = React.useBinding(Vector2.zero)
	local Size, SetSize = React.useBinding(Vector2.zero)

	local styles = ReactSpring.useSpring({
		from = { size = 0.5 },
		to = { size = 1 },
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
			if Num == props.Wave then
				SetEnabled(true)
			end
		end)
	end, {})

	React.useEffect(function()
		local Par = Parent.current
		if Enabled and Par and Par:IsA("GuiObject") then
			SetPosition(Par.AbsolutePosition)
			SetSize(Par.AbsoluteSize)

			local ChangePosition = Par:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
				SetPosition(Par.AbsolutePosition)
			end)

			local ChangeSize = Par:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				SetSize(Par.AbsoluteSize)
			end)

			return function()
				ChangePosition:Disconnect()
				ChangeSize:Disconnect()
			end
		end

		return function() end
	end, { Enabled })

	local OnClick = React.useCallback(function()
		SetEnabled(false)
	end, {})

	return Enabled
		and e(Main.TextButton, {
			native = Join({
				ref = Parent,
				Active = false,
				Position = Position:map(function(pos: Vector2)
					return UDim2.fromOffset(pos.X, pos.Y)
				end),
				Size = React.joinBindings({ styles.size :: any, Size }):map(function(data: any)
					local s: number = data[1]
					local sz: Vector2 = data[2]
					return UDim2.fromOffset(sz.X * s, sz.Y * s)
				end),
				ZIndex = 1000,
				[React.Event.MouseButton1Click] = OnClick,
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
