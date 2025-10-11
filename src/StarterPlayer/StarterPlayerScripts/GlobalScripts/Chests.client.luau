--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)
local Trove = require(Packages.Trove)
local RippleLib = require(Packages.Ripple)
local Promise = require(Packages.Promise)
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
local Ripple = require(CoreGame.Ripple)
local UIStroke = require(CoreGame.UIStroke)
local AnimatedGradient = require(CoreGame.AnimatedGradient)

local InventoryFolder = Gui.Inventory
local UnitFrame = require(InventoryFolder.UnitFrame)
local ProductFrame = require(InventoryFolder.ProductFrame)
local ResourceFrame = require(InventoryFolder.ResourceFrame)

local Components = Gui.Components
local Button = require(Components.Button)

local Shared = ReplicatedStorage.Shared
local ChestInfo = require(Shared.ChestInfo)
local RarityInfo = require(Shared.RarityInfo)
local ProductInfo = require(Shared.ProductInfo)
local Variables = require(Shared.Variables)

local Camera = workspace.CurrentCamera

local Colors = {
	["Common"] = "rbxassetid://77645625759735",
	["Rare"] = "rbxassetid://127473759461051",
	["Epic"] = "rbxassetid://81119922691890",
	["Mythic"] = "rbxassetid://100104433181257",
	["Legendary"] = "rbxassetid://129028976352753",
	["Godly"] = "rbxassetid://72363371760692",
}

local OtherColors = {
	Common = "Black",
	Rare = "Green",
	Epic = "Blue",
	Mythic = "Purple",
	Legendary = "Yellow",
	Godly = "Orange",
}

local function RenderChest(props: { Reward: ChestInfo.Reward, Tiers: { string } })
	local CurrentTier, SetCurrentTier = React.useState(1)
	local RewardEnabled, SetRewardEnabled = React.useState(false)
	local ButtonVisible, SetButtonVisible = React.useState(false)
	local LastClickEnabled = React.useRef(false)
	local ButtonEnabled, SetButtonEnabled = React.useState(false)

	React.useLayoutEffect(function()
		SetCurrentTier(1)
		LastClickEnabled.current = false
		SetButtonEnabled(false)
	end, { props.Tiers })

	React.useEffect(function()
		if ButtonVisible then
			local task = Promise.delay(1):andThen(function()
				SetButtonEnabled(true)
			end)

			return function()
				task:cancel()
			end
		end

		return function() end
	end, { ButtonVisible })

	local RewardStyle, Motion = Ripple.useMotion(0.2)

	React.useEffect(function()
		if RewardEnabled then
			Motion:set(0.2)
			Motion:spring(1, { tension = 600, friction = 34, mass = 0.7 })
		end
	end, { RewardEnabled })

	React.useEffect(function()
		if CurrentTier ~= 1 then
			local Rarity = props.Tiers[CurrentTier]
			local RarityData = RarityInfo[Rarity :: RarityInfo.Rarity]

			VFXEmit:Fire("ChestOpen", function(Emitter: ParticleEmitter)
				Emitter.Color = RarityData.Color
				Emitter:Emit()
			end)
		end

		if CurrentTier == #props.Tiers then
			local task = Promise.delay(0.5):andThen(function()
				LastClickEnabled.current = true
			end)

			return function()
				task:cancel()
			end
		else
			SetRewardEnabled(false)
			SetButtonVisible(false)
		end

		return function() end
	end, { CurrentTier })

	local RewardFrame = React.useMemo(function(): React.Node
		if props.Reward.Type == "Unit" then
			return e(UnitFrame.CreateUnitFrame, {
				UnitName = props.Reward.Name,
				Level = 1,
				native = {
					Size = RewardStyle:map(function(Number: number)
						return UDim2.fromScale(0, 0):Lerp(UDim2.fromScale(0.3, 0.3), Number)
					end),
				},
			})
		elseif props.Reward.Type == "Product" then
			local Data, ProductId, IsGamepass = ProductInfo.GetProductFromNameOnly(props.Reward.Name)
			if Data and ProductId and typeof(IsGamepass) == "boolean" then
				return e(ProductFrame, {
					ProductId = ProductId,
					IsGamepass = IsGamepass,
					Count = 1,
					native = {
						Size = RewardStyle:map(function(Number: number)
							return UDim2.fromScale(0, 0):Lerp(UDim2.fromScale(0.3, 0.3), Number)
						end),
					},
				})
			else
				return e(Main.Frame)
			end
		elseif props.Reward.Type == "Resource" then
			return e(ResourceFrame, {
				Name = props.Reward.Name,
				Value = props.Reward.Count,
				native = {
					Size = RewardStyle:map(function(Number: number)
						return UDim2.fromScale(0, 0):Lerp(UDim2.fromScale(0.3, 0.3), Number)
					end),
				},
			})
		else
			return e(Main.Frame)
		end
	end, { CurrentTier, props.Reward } :: { unknown })

	local Rarity = props.Tiers[CurrentTier]
	local RarityData = Rarity and RarityInfo[Rarity :: RarityInfo.Rarity] or RarityInfo["Common" :: RarityInfo.Rarity]

	local ChancesFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for i = 1, #props.Tiers - CurrentTier do
			Frames["Tier" .. i] = e(Main.Frame, {
				native = {
					Size = UDim2.fromScale(0.9, 0.9),
				},
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
				Button = e(Main.ImageLabel, {
					native = {
						Size = UDim2.fromScale(0.9, 0.9),
						Position = UDim2.fromScale(0.5, 0.5),
						Image = Colors[Rarity],
					},
				}, {
					Label = e(Main.TextLabel, {
						native = {
							Text = "?",
							Size = UDim2.fromScale(0.8, 0.5),
							ZIndex = 2,
						},
					}, {
						UIStroke = e(UIStroke.UIStrokeAdvanced, {
							Stroke = 0.02,
						}),
					}),
				}),
			})
		end

		return Frames
	end, { CurrentTier })

	return e(React.Fragment, nil, {
		Reward = RewardEnabled and RewardFrame,
		Main = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.8),
				Size = UDim2.fromScale(0.7, 0.4),
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
								if CurrentTier == #props.Tiers and LastClickEnabled.current then
									SetRewardEnabled(true)
									SetButtonVisible(true)
								end
								return math.min(Tier + 1, #props.Tiers)
							end)
						end,
					},
				}),
			}),
			RarityLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.3),
					Size = UDim2.fromScale(0.9, 0.3),
					Text = props.Tiers[CurrentTier] :: string,
				},
			}, {
				AnimatedGradient = e(AnimatedGradient, {
					GradColor = RarityData.Color,
				}),
				UIStroke = e(UIStroke.UIStrokeGradient, {
					Stroke = 0.01,
					GradColor = RarityData.StrokeColor,
				}),
			}),
			Button = e(Button, {
				Text = "Claim",
				Color = OtherColors[Rarity] or "Black",
				Size = UDim2.fromScale(0.6, 0.4),
				Position = UDim2.fromScale(0.5, 0.75),
				OnClick = function()
					if DelayHandler("RedeemChest", 1) then
						SetRewardEnabled(false)
						SetButtonVisible(false)
						RedeemChest.Fire(1)
					end
				end,
				native = {
					Visible = ButtonVisible and ButtonEnabled,
				},
			}),
			ChancesFrame = e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(0.5, 0.75),
					Size = UDim2.fromScale(0.9, 0.4),
				},
			}, {
				UIListLayout = e(Main.UIListLayout, {
					native = {
						FillDirection = Enum.FillDirection.Horizontal,
					},
				}),
			}, ChancesFrames),
		}),
	})
end

local Cache = {}
local CurrentIndex: number? = nil
local ChestChangedSignal = Signal.new()

local ChestGui = ReactRoblox.createRoot(Instance.new("Folder"))
local ChestTrove = Trove.new()

ChestChangedSignal:Connect(function()
	if CurrentIndex then
		if Variables.GuiEnabled then
			Variables.GuiEnabled = false
			ClientOnly.GuiEnabled:Fire(false)
		end
		Camera.CameraType = Enum.CameraType.Scriptable
		Camera.CFrame = CFrame.new(Vector3.new(0, -29, -10)) * CFrame.Angles(0, math.rad(180), 0)

		local Data = Cache[CurrentIndex]

		ChestGui:render(e(NewGui, {
			DisplayOrder = 3,
		}, {
			Chest = e(RenderChest, {
				Reward = Data.Reward,
				Tiers = Data.Tiers,
			}),
		}))
	else
		Camera.CameraType = Enum.CameraType.Custom
		ChestTrove:Clean()
		ChestGui:unmount()
		if not Variables.GuiEnabled then
			Variables.GuiEnabled = true
			ClientOnly.GuiEnabled:Fire(true)
		end
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
