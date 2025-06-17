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
local React = require(Packages.React)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Trove = require(Packages.Trove)
local Input = require(Packages.Input)
local Promise = require(Packages.Promise)

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

local SettingsContext = require(Gui.Settings.SettingsContext)

local Client = ReplicatedStorage.Client
local LobbyClient = Client.LobbyClient
local RollService = require(LobbyClient.RollService)

local GlobalClient = Client.GlobalClient
local SFXService = require(GlobalClient.SFXService)
local InventoryService = require(GlobalClient.InventoryService)

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

local function ChangeSize(Sequence: NumberSequence, Ratio: number)
	local NewKeypoints = {}
	for Index, Keypoint in ipairs(Sequence.Keypoints) do
		NewKeypoints[Index] = NumberSequenceKeypoint.new(Keypoint.Time, Keypoint.Value * Ratio)
	end
	return NumberSequence.new(NewKeypoints)
end

local function CreateUnitFrame(props: UnitProperties)
	local ViewRef = React.useRef(nil :: ViewportFrame?)

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

	React.useEffect(function()
		if Data.Rarity == "Godly" then
		elseif Data.Rarity == "Mythic" then
		else
			SFXService.PlaySoundGlobal(SummonSound)
		end
	end, { props.UnitName, Data :: any })

	local RotationCFrame = React.useBinding(CFrame.Angles(math.rad(20), 0, 0))

	local IsSold = React.useMemo(function()
		if Data.Rarity ~= "BLANK" and Data.Rarity ~= "Godly" then
			local Setting = SettingsData[Data.Rarity .. "Skip"] :: boolean
			return Setting
		else
			return false
		end
	end, { SettingsData, Data :: any })

	React.useEffect(function()
		if IsSold then
			InventoryService.SellUnits({ props.UniqueId })
		end
	end, { IsSold, props.UniqueId :: any })

	React.useEffect(function()
		if props.Visible then
			local Viewport = ViewRef.current :: ViewportFrame
			local Size = Viewport.AbsoluteSize
			local Part = HelperFunctions.EmitContinous({ SummonParticle }, CFrame.new(), function(Particle)
				Particle.Size = ChangeSize(Particle.Size, Size.X / 400)
				Particle.Color = Data.RarityData.BackgroundColor
				task.defer(function()
					Particle:Emit(1)
				end)
			end)

			local OtherPart = HelperFunctions.EmitParticle({ SummonParticle2 }, CFrame.new(), 12, function(Particle)
				Particle.Size = ChangeSize(Particle.Size, Size.X / 400)
				Particle.Color = Data.RarityData.BackgroundColor
			end)

			local Connection = RunService.PreRender:Connect(function()
				local NewPos = GuiService:GetGuiInset() + Viewport.AbsolutePosition + Size / 2

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
	end, { Data, props.Visible :: any })

	return e(Main.Frame, {
		native = Join({}, props.native),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}),
		Container = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.9, 0.9),
			},
		}, {
			View = e(UnitView, {
				ref = ViewRef,
				UnitName = props.UnitName,
				RotationCFrame = RotationCFrame,
				Distance = 4,
				Size = UDim2.fromScale(1.2, 1.2),
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
					Stroke = 0.03,
					GradColor = Data.RarityData and Data.RarityData.StrokeColor,
				}),
				UIGradient = e("UIGradient", {
					Color = Data.RarityData and Data.RarityData.Color,
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
					Stroke = 0.03,
					GradColor = Data.RarityData and Data.RarityData.StrokeColor,
				}),
				UIGradient = e("UIGradient", {
					Color = Data.RarityData and Data.RarityData.Color,
				}),
			}),
			SoldFrame = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.7, 0.15),
					Position = UDim2.fromScale(0.5, 1.05),
					Visible = IsSold,
					Text = "Sold",
				},
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

	local MainFrames: any = React.useMemo(function()
		local Frames = {}
		local RowCount = math.ceil(#props.UnitNames / MaxPerRow)

		local MaxSize = math.max(math.pow(1 - math.clamp(#props.UnitNames, 0, 4) * 0.12, 1.2), 0.5)

		for i = 1, RowCount, 1 do
			local UnitFrames: any = {}

			for j = 1, MaxPerRow, 1 do
				local Index = MaxPerRow * (i - 1) + j
				local UnitData = props.UnitNames[Index]

				if UnitData then
					UnitFrames["UnitFrame" .. Index] = e(CreateUnitFrame, {
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
	end, { props.UnitNames, Visible :: any })

	React.useEffect(function()
		if HelperFunctions.Len(props.UnitNames) > 0 then
			SetVisible(true)
		end

		local TimeDifference = workspace:GetServerTimeNow() - props.LastFiredTime
		local DelayTime = Constants.ROLLDELAYTIME * 0.9 - TimeDifference
		if props.AutoRoll then
			local NewPromise = Promise.delay(DelayTime):andThen(function()
				SetVisible(false)
			end)

			return function()
				NewPromise:cancel()
			end
		else
			if DelayTime <= 0 then
				SetVisible(false)
			end
		end

		return function() end
	end, { props.UnitNames :: any, props.LastFiredTime :: any, props.AutoRoll :: any })

	React.useEffect(function()
		local InputTrove = Trove.new()
		if not Visible then
			return function() end
		end

		local function CloseClick()
			if
				props.CloseClick
				and workspace:GetServerTimeNow() - props.LastFiredTime > Constants.ROLLDELAYTIME * 0.9
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
			elseif Preferred == "Touch" then
				local Touch = InputTrove:Construct(Input.Touch)

				Touch.TouchTapInWorld:Connect(function(_, Processed: boolean)
					if Processed then
						return
					end
					CloseClick()
				end)
			elseif Preferred == "Gamepad" then
				return
			end
		end)

		return function()
			InputTrove:Destroy()
			Disconnect()
		end
	end, { props.AutoRoll, props.CloseClick :: any, Visible, props.LastFiredTime :: any })

	local CancelAutoRoll = React.useCallback(function()
		if props.AutoRoll then
			RollService.StopAutoRoll()
		end
	end, { props.AutoRoll })

	return e(Main.Frame, {
		native = Join({
			Visible = Visible,
			Position = UDim2.fromScale(0.5, 0.35),
			Size = UDim2.fromScale(0.8, 0.6),
		}, props.native),
	}, {
		StopAutoButton = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.5, 1.1),
				Size = UDim2.fromScale(0.5, 0.2),
				Image = "rbxassetid://80739823452825",
				ImageColor3 = Color3.new(1.000000, 0.125490, 0.125490),
				Visible = props.AutoRoll,
				[React.Event.MouseButton1Click] = CancelAutoRoll,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 3.2,
			}),
			Label = e(Main.TextLabel, {
				native = {
					Text = "Stop Auto Summon",
					Size = UDim2.fromScale(0.7, 0.7),
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
				}),
			}),
		}),
	}, MainFrames, props.children)
end

local function CreateRollConnected(props: ConnectedProperties)
	local LastFiredTime, SetLastFiredTime = React.useState(1)
	local UnitNames, SetUnitNames = React.useState({})
	local InAutoRoll, SetAutoRoll = React.useState(false)

	Hooks.useEventConnection(RollService.Rolled, function(RollData: RollService.RollData)
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
