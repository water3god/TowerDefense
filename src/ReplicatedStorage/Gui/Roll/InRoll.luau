--!strict

-- By Wa1er_God --

-- Services --
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local GlobalWorkspace = workspace.GlobalWorkspace
local Particles = GlobalWorkspace.Particles
local Camera = workspace.CurrentCamera

local SummonSound = SoundService.SoundEffects.Sounds.SummonEffect

-- Libraries --
local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)
local ReactSpring = require(Packages.ReactSpring)
local React = require(Packages.React)
local e = React.createElement

local Trove = require(Packages.Trove)
local Input = require(Packages.Input)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UnitView = require(CoreGame.UnitView)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)
local AnimatedGradient = require(CoreGame.AnimatedGradient)

local SettingsFolder = Gui.Settings
local SettingsContext = require(SettingsFolder.SettingsContext)

local Components = Gui.Components
local Button = require(Components.Button)

local MiscContexts = Gui.MiscContexts
local CameraShake = require(MiscContexts.CameraShake)

local Client = ReplicatedStorage.Client
local LobbyClient = Client.LobbyClient
local RollService = require(LobbyClient.RollService)

local GlobalClient = Client.GlobalClient
local SFXService = require(GlobalClient.SFXService)
local InventoryService = require(GlobalClient.InventoryService)
local PurchaseService = require(GlobalClient.PurchaseService)

local ModelStorage = ReplicatedStorage.ModelStorage
local Emitters = ModelStorage.Emitters
local SummonParticle = Emitters.SummonParticle
local SummonParticle2 = Emitters.SummonParticle2

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)
local Constants = require(Shared.Constants)

export type Properties = {
	SetVisible: (Visible: boolean) -> ()?,
	CloseClick: () -> ()?,
	LastFiredTime: number,
	AutoRoll: boolean,
	UnitNames: { { Name: string, Id: string } },
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type UnitProperties = {
	UniqueId: string,
	UnitName: string,
	Visible: boolean,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type ConnectedProperties = {
	SetVisible: (Visible: boolean) -> (),
	CloseClick: () -> (),
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CalculateDelayTime()
	if PurchaseService.OwnsGamepass(1502632065) then
		return Constants.ROLLDELAYTIME / 2
	else
		return Constants.ROLLDELAYTIME
	end
end

local function ChangeSize(Sequence: NumberSequence, Ratio: number)
	local NewKeypoints = {}
	for Index, Keypoint in ipairs(Sequence.Keypoints) do
		NewKeypoints[Index] = NumberSequenceKeypoint.new(Keypoint.Time, Keypoint.Value * Ratio)
	end
	return NumberSequence.new(NewKeypoints)
end

local Rendered = 0
local Total = 0
local PlaySignal = Signal.new()

local function CreateUnitFrame(props: UnitProperties)
	local ViewRef = React.useRef(nil :: ViewportFrame?)

	local Styles = ReactSpring.useSpring({
		from = {
			Size = 0.5,
		},
		to = {
			Size = 1,
		},
		config = { mass = 1, tension = 200, friction = 14 },
	})

	React.useEffect(function()
		if Rendered + 1 >= Total then
			Rendered = 0
			Total = 0
			PlaySignal:Fire()
		else
			Rendered += 1
		end
	end, {})

	local SettingsData = React.useContext(SettingsContext.Context)

	local Data = React.useMemo(function()
		if props.UnitName then
			local UnitData = UnitInfo.UnitInfo[props.UnitName]
			local RarityData = RarityInfo[UnitData.Rarity]

			return {
				UnitName = props.UnitName,
				Rarity = UnitData.Rarity,
				RarityData = RarityData,
			}
		else
			return {} :: any
		end
	end, { props.UnitName })

	local RotationCFrame = React.useBinding(CFrame.Angles(math.rad(20), 0, 0))

	local IsSold = React.useMemo(function()
		if Data.Rarity ~= "BLANK" and Data.Rarity ~= "Godly" then
			local Setting = SettingsData[Data.Rarity .. "Skip"] :: boolean
			return Setting
		else
			return false
		end
	end, { SettingsData, Data } :: { unknown })

	React.useEffect(function()
		if IsSold then
			InventoryService.SellUnits({ props.UniqueId })
		end
	end, { IsSold, props.UniqueId } :: { unknown })

	React.useEffect(function()
		if props.Visible and RunService:IsRunning() and false then
			local Viewport = ViewRef.current :: ViewportFrame

			local Part = HelperFunctions.EmitContinous({ SummonParticle }, CFrame.new(), function(Particle)
				Particle.Size = ChangeSize(Particle.Size, Viewport.AbsoluteSize.X / 800)
				Particle.Color = Data.RarityData.BackgroundColor
				task.defer(function()
					Particle:Emit(1)
				end)
			end)

			local OtherPart = HelperFunctions.EmitParticle({ SummonParticle2 }, CFrame.new(), 12, function(Particle)
				Particle.Size = ChangeSize(Particle.Size, Viewport.AbsoluteSize.X / 800)
				Particle.Color = Data.RarityData.BackgroundColor
			end, true)

			local Connection = RunService.PreRender:Connect(function()
				local NewPos = GuiService:GetGuiInset() + Viewport.AbsolutePosition + Viewport.AbsoluteSize / 2

				local Ray = Camera:ViewportPointToRay(NewPos.X, NewPos.Y, 2)
				local NewCFrame = CFrame.new(Ray.Origin + Camera.CFrame.LookVector * 0)
				Part.CFrame = NewCFrame
				OtherPart.CFrame = NewCFrame
			end)

			Part.Parent = Particles
			OtherPart.Parent = Particles

			return function()
				Connection:Disconnect()
				Part:Destroy()
				OtherPart:Destroy()
			end
		else
			return function() end
		end
	end, { Data, props.Visible } :: { unknown })

	return e(Main.Frame, {
		native = Join({}, props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}),
		Container = e(Main.Frame, {
			native = {
				--Size = UDim2.fromScale(0.9, 0.9),
				Size = Styles.Size:map(function(Size: number)
					return UDim2.fromScale(Size * 0.9, Size * 0.9)
				end),
			},
		}, {
			View = e(UnitView, {
				ref = ViewRef,
				UnitName = props.UnitName,
				RotationCFrame = RotationCFrame,
				Distance = 4,

				Offset = Vector3.new(0, -1, 0),
				native = {
					Position = UDim2.fromScale(0.5, 0.6),
				},
			}),
			NameLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.15),
					Position = UDim2.fromScale(0.5, 0.75),
					Text = Data.UnitName or "",
					ZIndex = 2,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.015,
					GradColor = Data.RarityData and Data.RarityData.StrokeColor,
				}),
				UIGradient = e(AnimatedGradient, {
					GradColor = Data.RarityData and Data.RarityData.Color or ColorSequence.new(Color3.new(1, 1, 1)),
					Animate = true,
					Speed = 1,
				}),
			}),
			RarityLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.8, 0.15),
					Position = UDim2.fromScale(0.5, 0.9),
					Text = Data.Rarity or "",
					ZIndex = 2,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.015,
					GradColor = Data.RarityData and Data.RarityData.StrokeColor,
				}),
				UIGradient = e(AnimatedGradient, {
					GradColor = Data.RarityData and Data.RarityData.Color or ColorSequence.new(Color3.new(1, 1, 1)),
					Animate = true,
					Speed = 1,
				}),
			}),
			SoldLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.7, 0.1),
					Position = UDim2.fromScale(0.5, 1.05),
					Visible = IsSold,
					Text = "Sold",
					TextColor3 = Color3.new(0.5, 0.5, 0.5),
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.015,
				}),
			}),
		}),
	}, props.children)
end

local MaxPerRow = 4

local function CreateInRoll(props: Properties)
	local Visible, SetVisible = React.useState(false)

	React.useEffect(function()
		if props.SetVisible then
			props.SetVisible(Visible)
		end
	end, { Visible })

	local MainFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		local RowCount = math.ceil(#props.UnitNames / MaxPerRow)

		local MaxSize = math.max(math.pow(1 - math.clamp(#props.UnitNames, 0, 4) * 0.12, 1.2), 0.5)
		if Visible == false or Visible == nil then
			return {}
		end
		for i = 1, RowCount, 1 do
			local UnitFrames: { [string]: React.Node } = {}

			for j = 1, MaxPerRow, 1 do
				local Index = MaxPerRow * (i - 1) + j
				local UnitData = props.UnitNames[Index]

				if UnitData then
					UnitFrames["UnitFrame" .. Index .. tick()] = e(CreateUnitFrame, {
						UnitName = UnitData.Name,
						UniqueId = UnitData.Id,
						Visible = Visible,
						native = {
							LayoutOrder = j,
						},
					})
				end
			end

			Frames["CoverFrame" .. i] = e(Main.Frame, {
				native = {
					Size = UDim2.fromScale(1, math.min(1 / RowCount, MaxSize)),
					Position = UDim2.fromScale(0.5, (i - 0.5) * (1 / RowCount)),
					LayoutOrder = i,
				},
			}, {
				UIListLayout = e("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
			}, UnitFrames)
		end
		return Frames
	end, { props.UnitNames, Visible } :: { unknown })

	React.useEffect(function()
		if HelperFunctions.Len(props.UnitNames) > 0 then
			SetVisible(true)
		end

		local TimeDifference = workspace:GetServerTimeNow() - props.LastFiredTime
		local DelayTime = CalculateDelayTime() * Constants.ROLLPERCENT - TimeDifference
		if not props.AutoRoll then
			if DelayTime <= 0 then
				SetVisible(false)
			end
		end

		return function() end
	end, { props.UnitNames, props.LastFiredTime, props.AutoRoll } :: { unknown })

	React.useEffect(function()
		local InputTrove = Trove.new()
		if not Visible then
			return function() end
		end

		local function CloseClick()
			if
				props.CloseClick
				and workspace:GetServerTimeNow() - props.LastFiredTime
					> CalculateDelayTime() * Constants.ROLLPERCENT
			then
				if not props.AutoRoll then
					SetVisible(false)
					props.CloseClick()
				end
			end
		end

		local Disconnect = Input.PreferredInput.Observe(function(Preferred)
			InputTrove:Destroy()
			if Preferred == "MouseKeyboard" then
				local Mouse = InputTrove:Construct(Input.Mouse)

				Mouse.LeftUp:Connect(function()
					CloseClick()
				end)
			elseif Preferred == "Gamepad" then
				local Gamepad = InputTrove:Construct(Input.Gamepad)

				Gamepad.ButtonPressed:Connect(function(ButtonCode: Enum.KeyCode, Processed: boolean)
					if Processed then
						return
					end
					if ButtonCode == Enum.KeyCode.ButtonA then
						CloseClick()
					end
				end)
			elseif Preferred == "Touch" then
				local Touch = InputTrove:Construct(Input.Touch)

				Touch.TouchTapInWorld:Connect(function(_, Processed: boolean)
					if Processed then
						return
					end
					CloseClick()
				end)
			end
		end)

		return function()
			InputTrove:Destroy()
			Disconnect()
		end
	end, { props.AutoRoll, props.CloseClick, Visible, props.LastFiredTime } :: { unknown })

	local CancelAutoRoll = React.useCallback(function()
		if props.AutoRoll then
			RollService.StopAutoRoll()
		end
	end, { props.AutoRoll })

	return e(Main.Frame, {
		native = Join({
			Visible = Visible,
			Position = UDim2.fromScale(0.5, 0.3),
			Size = UDim2.fromScale(0.8, 0.6),
		}, props.native),
	}, {
		StopSummonButton = e(Button, {
			Color = "Red",
			Position = UDim2.fromScale(0.5, 1.15),
			Size = UDim2.fromScale(0.4, 0.25),
			Text = "Stop Summoning",
			OnClick = CancelAutoRoll,
			native = {
				Visible = props.AutoRoll,
			},
		}),
	}, MainFrames, props.children)
end

local function CreateRollConnected(props: ConnectedProperties)
	local LastFiredTime, SetLastFiredTime = React.useState(1)
	local UnitNames, SetUnitNames = React.useState({})
	local InAutoRoll, SetAutoRoll = React.useState(false)
	local Shake = React.useContext(CameraShake.Context)

	local Length = React.useRef(0)

	Hooks.useEventConnection(PlaySignal, function()
		SFXService.PlaySoundGlobal(SummonSound, function(Sound: Sound)
			Sound.Volume = 0.05 + (0.15 * math.log(Length.current + 1) / math.log(11))
		end)
		Shake.Shake()
	end, {})

	Hooks.useEventConnection(RollService.Rolled, function(RollData: RollService.RollData)
		Rendered = 0
		Total = HelperFunctions.Len(RollData.Data)
		Length.current = Total

		SetLastFiredTime(RollData.SentTime)
		SetUnitNames(RollData.Data)
		SetAutoRoll(RollData.AutoRoll)
	end, {})

	Hooks.useEventConnection(RollService.AutoRollStopped, function()
		SetAutoRoll(false)
	end, {})

	return e(CreateInRoll, {
		SetVisible = props.SetVisible,
		CloseClick = props.CloseClick,
		LastFiredTime = LastFiredTime,
		UnitNames = UnitNames,
		AutoRoll = InAutoRoll,
		native = props.native,
	}, props.children)
end

return {
	Create = CreateInRoll,
	Connected = CreateRollConnected,
}
