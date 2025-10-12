--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local PolicyService = game:GetService("PolicyService")

local Packages = ReplicatedStorage.Packages
local Input = require(Packages.Input)
local Promise = require(Packages.Promise)
local Signal = require(Packages.Signal)
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local FindAncestor = require(Modules.FindAncestor)

local Player = Players.LocalPlayer

local Hooks = {}

function Hooks.useClock()
	local clockBinding, setClockBinding = React.useBinding(0)

	React.useEffect(function()
		local stepConnection = RunService.Heartbeat:Connect(function(delta)
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

function Hooks.UseVisible(Props: { ref: React.Ref<GuiObject?> })
	local Visible, SetVisible = React.useState(true)

	React.useEffect(function()
		if typeof(Props.ref) == "table" and typeof(Props.ref.current) == "Instance" then
			local GuiObject = Props.ref.current :: GuiObject

			local function Update()
				if not GuiObject:IsDescendantOf(game) then
					SetVisible(false)
					return
				end

				if not GuiObject.Visible then
					SetVisible(false)
					return
				end

				for _, Ancestor in ipairs(FindAncestor.GetAncestors(GuiObject)) do
					if Ancestor:IsA("GuiObject") then
						if not Ancestor.Visible then
							SetVisible(false)

							Ancestor:GetPropertyChangedSignal("Visible"):Connect(function()
								if Ancestor.Visible then
									Update()
								end
							end)

							return
						end
					elseif Ancestor:IsA("LayerCollector") then
						if not Ancestor.Enabled then
							SetVisible(false)
							return
						end
					end
				end

				SetVisible(true)
			end

			--local Connection = GuiObject.AncestryChanged:Connect(function(Child: Instance, Parent: Instance?) end)
		end
	end, { Props.ref })

	return Visible
end

function Hooks.UseTime()
	local Time, SetTime = React.useBinding(1)
	local TotalTime, SetTotalTime = React.useBinding(1)
	local TimeData, SetTimeData = React.useState({ TotalTime = 0, StartTime = 0, Multiplier = 1 })

	React.useEffect(function()
		SetTotalTime(TimeData.TotalTime)
		local Connection: RBXScriptConnection? = nil
		Connection = RunService.Heartbeat:Connect(function()
			local NewTime = math.clamp(
				TimeData.StartTime - workspace:GetServerTimeNow() + TimeData.TotalTime / TimeData.Multiplier,
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
		function(NewTotalTime: number, StartTime: number, MultiplierInput: number?)
			if TimeData.TotalTime ~= NewTotalTime or TimeData.StartTime ~= StartTime then
				SetTimeData({
					TotalTime = NewTotalTime,
					StartTime = StartTime,
					Multiplier = MultiplierInput or 1,
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

function Hooks.useMemoWithCleanup<T>(compute: () -> T, cleanup: (T) -> (), dependencies: { any }): T
	local value = React.useMemo(compute, dependencies)

	React.useEffect(function()
		return function()
			cleanup(value)
		end
	end, { value })

	return value
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

function Hooks.useZapConnection<T...>(
	Event: { SetCallback: ((T...) -> ()) -> () -> () },
	Callback: (T...) -> (),
	dependencies: { any }
)
	local cachedCallback = React.useMemo(function()
		return Callback
	end, dependencies)

	React.useEffect(function()
		return Event.SetCallback(cachedCallback)
	end, { Event, cachedCallback } :: { unknown })
end

function Hooks.useZapManyConnection<T...>(
	Event: { On: ((T...) -> ()) -> () -> () },
	Callback: (T...) -> (),
	dependencies: { any }
)
	local cachedCallback = React.useMemo(function()
		return Callback
	end, dependencies)

	React.useEffect(function()
		return Event.On(cachedCallback)
	end, { Event, cachedCallback } :: { unknown })
end

function Hooks.usePlayers()
	local PlayersList, SetPlayers = React.useState({})

	React.useEffect(function()
		SetPlayers(Players:GetPlayers())
	end, {})

	Hooks.useEventConnection(Players.PlayerAdded, function(OtherPlayer: Player)
		SetPlayers(function(Table)
			if not table.find(Table, OtherPlayer) then
				table.insert(Table, OtherPlayer)
				Table = table.clone(Table)
			end

			return Table
		end)
	end, {})

	Hooks.useEventConnection(Players.PlayerRemoving, function(OtherPlayer: Player)
		SetPlayers(function(Table)
			local Index = table.find(Table, OtherPlayer)

			if Index then
				table.remove(Table, Index)
				Table = table.clone(Table)
			end

			return Table
		end)
	end, {})

	return PlayersList
end

function Hooks.useCamera()
	return React.useMemo(function()
		return workspace.CurrentCamera
	end, {})
end

function Hooks.useMembership(OtherPlayer: Player)
	local MembershipType, SetMembershipType = React.useState(Enum.MembershipType.None)

	React.useEffect(function()
		SetMembershipType(OtherPlayer.MembershipType)

		local Connection = OtherPlayer:GetPropertyChangedSignal("MembershipType"):Connect(function()
			SetMembershipType(OtherPlayer.MembershipType)
		end)

		return function()
			Connection:Disconnect()
		end
	end, { OtherPlayer })

	return MembershipType
end

function Hooks.useCharacter()
	local Character: typeof(ReplicatedStorage.ModelStorage.Extra.Rig)?, SetCharacter =
		React.useState(nil :: typeof(ReplicatedStorage.ModelStorage.Extra.Rig)?)

	React.useEffect(function()
		SetCharacter(Player.Character)
	end, {})

	Hooks.useEventConnection(Player.CharacterAdded, function()
		SetCharacter(Player.Character)
	end, {})

	Hooks.useEventConnection(Player.CharacterRemoving, function()
		SetCharacter(nil)
	end, {})

	return Character
end

function Hooks.useTranslator()
	local translator, SetTranslator = React.useState(nil :: Translator?)

	React.useEffect(function()
		local TranslatorPromise = Promise.retryWithDelay(function()
			return Promise.try(function()
				if RunService:IsRunning() then
					return LocalizationService:GetTranslatorForPlayerAsync(Players.LocalPlayer)
				else
					error("Cannot get translator in Studio Play mode")
				end
			end):andThen(function(Translator: Translator)
				SetTranslator(Translator)
			end)
		end, 3, 10):catch(function()
			warn("Failed to get translator for player after multiple attempts")
		end)

		return function()
			TranslatorPromise:cancel()
		end
	end, {})

	React.useEffect(function()
		if translator then
			local connection = translator:GetPropertyChangedSignal("LocaleId"):Connect(function()
				SetTranslator(translator)
			end)

			return function()
				connection:Disconnect()
			end
		end
		return function() end
	end, { translator })

	return translator
end

function Hooks.useRaycastParams()
	local raycastParams = React.useState(RaycastParams.new())

	return raycastParams
end

export type PolicyInfo = {
	AreAdsAllowed: boolean,
	ArePaidRandomItemsRestricted: boolean,
	AllowedExternalLinkReferences: { string },
	IsContentSharingAllowed: boolean,
	IsEligibleToPurchaseCommerceProduct: boolean,
	IsEligibleToPurchaseSubscription: boolean,
	IsPaidItemTradingAllowed: boolean,
	IsSubjectToChinaPolicies: boolean,
}

function Hooks.usePolicyInfo()
	local PolicyInfo: PolicyInfo, SetPolicyInfo = React.useState({
		AreAdsAllowed = true,
		ArePaidRandomItemsRestricted = false,
		AllowedExternalLinkReferences = {},
		IsContentSharingAllowed = true,
		IsEligibleToPurchaseCommerceProduct = true,
		IsEligibleToPurchaseSubscription = true,
		IsPaidItemTradingAllowed = true,
		IsSubjectToChinaPolicies = false,
	} :: PolicyInfo)

	React.useEffect(function()
		local PolicyPromise = Promise.try(function()
			return PolicyService:GetPolicyInfoForPlayerAsync(Players.LocalPlayer)
		end):andThen(function(Policy)
			SetPolicyInfo(Policy)
		end)

		return function()
			PolicyPromise:cancel()
		end
	end, {})

	return PolicyInfo
end

export type InputType = "MouseKeyboard" | "Touch" | "Gamepad"

function Hooks.useInput(): InputType?
	local Value, SetValue = React.useState(nil :: InputType?)

	React.useEffect(function()
		local Clean = Input.PreferredInput.Observe(function(NewValue)
			SetValue(NewValue)
		end)

		return Clean
	end, {})

	return Value
end

local useState = React.useState
local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo

-- Design UI at this resolution
local BASE_RESOLUTION = Vector2.new(1280, 832)
local MIN_SCALE = 0.5
local DOMINANT_AXIS = 0.5

--[[
    Rounds and scales a number to the current `px` unit. Includes additional
    methods for edge cases.
]]
type PxWithMethods = ((value: number) -> number) & {
	even: (value: number) -> number,
	scale: (value: number) -> number,
	floor: (value: number) -> number,
	ceil: (value: number) -> number,
}

--[[
    Scales the current `px` unit based on the current viewport size.
]]
function Hooks.usePx(): PxWithMethods
	local scale, setScale = useState(1)

	local camera = workspace.CurrentCamera

	local updateScale = useCallback(function()
		local width = math.log(camera.ViewportSize.X / BASE_RESOLUTION.X, 2)
		local height = math.log(camera.ViewportSize.Y / BASE_RESOLUTION.Y, 2)
		local centered = width + (height - width) * DOMINANT_AXIS

		setScale(math.max(2 ^ centered, MIN_SCALE))
	end, { scale })

	useEffect(function()
		updateScale()

		local connection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

		return function()
			connection:Disconnect()
		end
	end, {})

	local px = useMemo(function()
		return setmetatable({
			even = function(_, value: number)
				return math.round(value * scale * 0.5) * 2
			end,
			scale = function(_, value: number)
				return value * scale
			end,
			floor = function(_, value: number)
				return math.floor(value * scale)
			end,
			ceil = function(_, value: number)
				return math.ceil(value * scale)
			end,
		}, {
			__call = function(_, value: number)
				return math.round(value * scale)
			end,
		})
	end, { scale })

	return px :: any
end

return Hooks
