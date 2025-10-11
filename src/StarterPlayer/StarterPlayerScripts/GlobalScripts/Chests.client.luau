--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)
local Trove = require(Packages.Trove)
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local DelayHandler = require(Modules.DelayHandler)

local NetworkFolder = ReplicatedStorage.Network
local Network = require(NetworkFolder.Client)
local ChestSync = Network.ChestSync
local ChestAdded = Network.ChestAdded
local ChestRedeemed = Network.ChestRedeemed
local RedeemChest = Network.RedeemChest

local ClientOnly = require(NetworkFolder.ClientOnly)
local VFXEmit = ClientOnly.VFXEmit

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local NewGui = require(CoreGame.NewGui)

local Components = Gui.Components
local Button = require(Components.Button)

local Shared = ReplicatedStorage.Shared
local ChestInfo = require(Shared.ChestInfo)
local RarityInfo = require(Shared.RarityInfo)

local Camera = workspace.CurrentCamera

local function RenderChest(props: { Tiers: { string } })
	local CurrentTier, SetCurrentTier = React.useState(1)
	local ButtonEnabled, SetButtonEnabled = React.useState(true)

	React.useEffect(function()
		SetCurrentTier(1)
		SetButtonEnabled(true)
	end, { props.Tiers })

	React.useEffect(function()
		if CurrentTier == 1 then
			return
		end

		local Rarity = props.Tiers[CurrentTier]
		local RarityData = RarityInfo[Rarity :: RarityInfo.Rarity]

		VFXEmit:Fire("ChestOpen", function(Emitter: ParticleEmitter)
			Emitter.Color = RarityData.Color
			Emitter:Emit()
		end)
	end, { CurrentTier })

	local ChancesFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for i = 1, #props.Tiers - (CurrentTier + 1) do
			Frames["Tier" .. i] = e(Main.Frame, {
				native = {
					Size = UDim2.fromScale(0.8, 0.9),
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
				Button = e(Main.ImageLabel, {
					native = {
						Text = "?",
						Size = UDim2.fromScale(1, 1),
						Position = UDim2.fromScale(0.5, 0.5),
						Image = "rbxassetid://72363371760692",
					},
				}),
			})
		end

		return Frames
	end, { CurrentTier })

	return e(Main.Frame, {
		native = {
			Size = UDim2.fromScale(0.7, 0.2),
		},
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 3,
		}),
		NewGui = e(NewGui, {
			DisplayOrder = 2,
		}, {
			HiddenButton = e(Main.TextButton, {
				native = {
					[React.Event.MouseButton1Click] = function()
						SetCurrentTier(function(Tier: number)
							return Tier + 1
						end)
					end,
				},
			}),
		}),
		Button = e(Button, {
			Visible = CurrentTier <= #props.Tiers,
			Text = "Claim",
			Size = UDim2.fromScale(0.6, 0.3),
			Position = UDim2.fromScale(0.5, 0.7),
			OnClick = function()
				if DelayHandler("RedeemChest", 1) and ButtonEnabled then
					SetButtonEnabled(false)
					RedeemChest.Fire(1)
				end
			end,
		}),
		ChancesFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.2),
				Size = UDim2.fromScale(0.9, 0.4),
			},
		}, {
			UIListLayout = e(Main.UIListLayout, {
				native = {
					FillDirection = Enum.FillDirection.Horizontal,
				},
			}),
		}, ChancesFrames),
	})
end

local Cache = {}
local CurrentIndex: number? = nil
local ChestChangedSignal = Signal.new()

local ChestGui = ReactRoblox.createRoot(Instance.new("Folder"))
local ChestTrove = Trove.new()

ChestChangedSignal:Connect(function()
	if CurrentIndex then
		Camera.CameraType = Enum.CameraType.Scriptable
		Camera.CFrame = CFrame.new(Vector3.new(0, -29, -10)) * CFrame.Angles(0, math.rad(180), 0)

		ChestGui:render(e(RenderChest, {
			Tiers = Cache[CurrentIndex].Tiers,
		}))
	else
		Camera.CameraType = Enum.CameraType.Custom
		ChestTrove:Clean()
		ChestGui:unmount()
	end
end)

local function OnChestAdded(Data: ChestInfo.Chest, Index: number?)
	if Index then
		Cache[Index] = Data
	else
		table.insert(Cache, Data)
	end
	if not CurrentIndex then
		CurrentIndex = Index or #Cache
		ChestChangedSignal:Fire()
	end
end

ChestAdded.SetCallback(function(Data: ChestInfo.Chest, Index: number)
	OnChestAdded(Data, Index)
end)

ChestSync.SetCallback(function(Datas: { ChestInfo.Chest })
	for _, Data in ipairs(Datas) do
		OnChestAdded(Data)
	end
end)

ChestRedeemed.SetCallback(function(Index: number)
	table.remove(Cache, Index)
	if Cache[1] then
		CurrentIndex = 1
		ChestChangedSignal:Fire()
	else
		CurrentIndex = nil
		ChestChangedSignal:Fire()
	end
end)
