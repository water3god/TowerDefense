--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local Timer = require(Packages.Timer)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local NetworkFolder = ReplicatedStorage.Network
local ClientOnly = require(NetworkFolder.ClientOnly)

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local Hooks = require(CoreGame.Hooks)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local WaveService = require(GlobalClient.WaveService)

local Shared = ReplicatedStorage.Shared
local IsTutorial = require(Shared.IsTutorial)

local TutorialContext = require(Gui.MiscContexts.PassedTutorial)

export type Properties = {
	Wave: number?,
	Status: string?,
	Name: string?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateIndicator(props: Properties)
	local PassedTutorial = React.useContext(TutorialContext.Context)

	local styles, API = ReactSpring.useSpring(function()
		return {
			size = 1,
		}
	end)

	local Enabled, SetEnabled = React.useState(false)

	React.useEffect(function()
		if not Enabled then
			return
		end
		local SizeTimer = Timer.new(1)

		SizeTimer:Start()

		API.start({
			from = { size = 1 },
			to = { size = 1.3 },
			reset = true,
		})

		SizeTimer.Tick:Connect(function()
			API.start({
				from = { size = 1 },
				to = { size = 1.3 },
				reset = true,
			})
		end)
	end, { Enabled })

	React.useEffect(function()
		if IsTutorial then
			return
		end
		SetEnabled(props.Status == PassedTutorial.Status)
	end, { props.Status, PassedTutorial.Status })

	Hooks.useEventConnection(ClientOnly.NewNPCTalk, function(NPCName: string)
		if NPCName == props.Name then
			SetEnabled(false)
		end
	end, { props.Name })

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

		local Connection = WaveService.Added:Connect(HandleWave)
		local Connection2 = WaveService.Passed:Connect(function(Num: number)
			SetEnabled(Num == props.Wave)
		end)

		return function()
			Connection:Disconnect()
			Connection2:Disconnect()
		end
	end, { props.Wave })

	local OnClick = React.useCallback(function()
		SetEnabled(false)
	end, {})

	return Enabled
		and e(Main.Frame, {
			native = Join({
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
