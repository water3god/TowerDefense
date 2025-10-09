--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer

-- Libraries --
local Packages = ReplicatedStorage.Packages
local Input = require(Packages.Input)
local Trove = require(Packages.Trove)
local Promise = require(Packages.Promise)
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local AllEquipped = require(GlobalClient.AllEquipped)

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)

local InventoryFolder = Gui.Inventory
local UnitFrame = require(InventoryFolder.UnitFrame)
local ClickedHover = require(InventoryFolder.ClickHover)

local Shared = ReplicatedStorage.Shared
local LevelRequirements = require(Shared.LevelRequirements)

export type Properties = {
	Loading: boolean,
	Name: string,
	Frames: { AllEquipped.UnitDataSent },
	Level: number,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateClickedInventory(props: Properties)
	local UnitFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for i = 1, 5, 1 do
			local FrameData = props.Frames[i]
			local RequiredLevel = LevelRequirements.EquippedFrames[i]
			if FrameData then
				Frames["Frame" .. i] = e(UnitFrame.CreateUnitFrame, {
					UnitName = FrameData.UnitName,
					Level = FrameData.Level,
					native = {
						LayoutOrder = i,
					},
				})
			elseif LevelRequirements.EquippedFrames[i] <= props.Level then
				Frames["Frame" .. i] = e(UnitFrame.CreateUnitFrame, {
					UnitName = "BLANK",
					Disabled = true,
					Level = 1,
					native = {
						LayoutOrder = i,
					},
				})
			else
				Frames["Frame" .. i] = e(UnitFrame.CreateUnitFrame, {
					UnitName = "BLANK",
					Disabled = true,
					Level = 1,
					native = {
						LayoutOrder = i,
					},
					containerChildren = {
						Lock = e(Main.ImageLabel, {
							native = {
								Position = UDim2.fromScale(0.5, 0.4),
								Size = UDim2.fromScale(0.4, 0.4),

								Image = "rbxassetid://106849723034867",
								ZIndex = 2,
							},
						}, {
							UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
								AspectRatio = 0.83,
							}),
						}),
						LevelLock = e(Main.TextLabel, {
							native = {
								Position = UDim2.fromScale(0.5, 0.75),
								Size = UDim2.fromScale(0.85, 0.2),
								Text = string.format("Level %u", RequiredLevel),
							},
						}),
					},
				})
			end
		end

		return Frames
	end, { props.Loading, props.Frames, props.Level } :: { unknown })

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(0.4, 0.2),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(91, 91, 91),
		}, props.native),
	}, {
		PlayerName = e(Main.TextLabel, {
			native = {
				Text = props.Name,
				Size = UDim2.fromScale(0.8, 0.2),
				Position = UDim2.fromScale(0.5, 0.2),
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.01,
				Color = Color3.new(0, 0, 0),
			}),
		}),
		MainFrame = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.9, 0.6),
				Position = UDim2.fromScale(0.5, 0.65),
			},
		}, {
			UIListLayout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0),
			}),
		}, UnitFrames),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.1, 0),
		}),
		UIStroke = e(UIStroke.UIStrokeAdvanced, {
			Stroke = 0.01,
			native = {
				LineJoinMode = Enum.LineJoinMode.Round,
			},
		}),
		LoadingFrame = props.Loading and e(Main.Frame, {
			native = {
				BackgroundTransparency = 0.5,
				ZIndex = 2,
				BackgroundColor3 = Color3.fromRGB(11, 11, 11),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),
			LoadingLabel = e(Main.TextLabel, {
				native = {
					Text = "Loading...",
					Size = UDim2.fromScale(1, 0.4),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1,
					TextColor3 = Color3.new(1, 1, 1),

					Rotation = 350,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.01,
					Color = Color3.new(0, 0, 0),
				}),
			}),
		}),

		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 3.5,
		}),
	}, props.children)
end

local function Connected(props)
	local Data, SetData: any = React.useState(nil :: { AllEquipped.UnitDataSent }?)
	local Camera = Hooks.useCamera()
	local OtherCharacter, SetOtherCharacter: any = React.useState(nil :: Model?)
	local ClickedPlayer, SetClickedPlayer = React.useState(nil :: Player?)
	local RaycastParams = Hooks.useRaycastParams()
	local HoveredPosition, SetHoveredPosition = React.useBinding(UDim2.new())
	local ClickedPosition, SetClickedPosition = React.useBinding(UDim2.new())
	local Hovered, SetHovered = React.useState(false)

	local Highlight = React.useMemo(function()
		if not OtherCharacter then
			return nil :: React.Node?
		end

		return e("Highlight", {
			Adornee = OtherCharacter,
			FillColor = Color3.fromRGB(255, 255, 255),
			FillTransparency = 0.5,
			OutlineColor = Color3.new(1, 1, 1),
			OutlineTransparency = 0.5,
		})
	end, { OtherCharacter })

	React.useEffect(function()
		local ClickedTrove = Trove.new()

		local function UpdatePosition(Position: Vector2)
			local NewPosition = Position - GuiService:GetGuiInset()
			SetHoveredPosition(UDim2.fromOffset(NewPosition.X, NewPosition.Y))
			local Raycast = HelperFunctions.Raycast(Position, RaycastParams)

			if Raycast and Raycast.Instance then
				local Character = Raycast.Instance:FindFirstAncestorWhichIsA("Model")

				if Character then
					local Player = Players:GetPlayerFromCharacter(Character)
					if Player and Player ~= LocalPlayer then
						SetHovered(true)
						SetOtherCharacter(Character)
						return
					end
				end
			end

			SetHovered(false)
			SetOtherCharacter(nil)
		end

		local function OnClick(Position: Vector2)
			local Raycast = HelperFunctions.Raycast(Position, RaycastParams)

			if Raycast and Raycast.Instance then
				local Character = Raycast.Instance:FindFirstAncestorWhichIsA("Model")
				if Character then
					local Player = Players:GetPlayerFromCharacter(Character)
					if Player and Player ~= LocalPlayer then
						SetClickedPlayer(Player)
						return
					end
				end
			end

			SetClickedPlayer(nil)
			SetData(nil)
		end

		local Disconnect = Input.PreferredInput.Observe(function(PreferredInput)
			if PreferredInput == "Touch" then
				local Touch = ClickedTrove:Construct(Input.Touch)

				Touch.TouchTapInWorld:Connect(function(TouchPosition: Vector2, Processed: boolean)
					if Processed then
						return
					end

					OnClick(TouchPosition)
				end)

				Touch.TouchMoved:Connect(function(InputObject: InputObject, Processed: boolean)
					if Processed then
						return
					end
					UpdatePosition(Vector2.new(InputObject.Position.X, InputObject.Position.Y))
				end)
			elseif PreferredInput == "MouseKeyboard" then
				local Mouse = ClickedTrove:Construct(Input.Mouse)

				Mouse.LeftUp:Connect(function()
					OnClick(Mouse:GetPosition())
				end)

				ClickedTrove:Connect(RunService.Heartbeat, function()
					UpdatePosition(Mouse:GetPosition())
				end)
			elseif PreferredInput == "Gamepad" then
				local Gamepad = ClickedTrove:Construct(Input.Gamepad)

				Gamepad.ButtonUp:Connect(function()
					OnClick(Gamepad:GetThumbstick(Enum.KeyCode.Thumbstick2))
				end)

				ClickedTrove:Connect(RunService.Heartbeat, function()
					UpdatePosition(Gamepad:GetThumbstick(Enum.KeyCode.Thumbstick2))
				end)
			end
		end)

		return function()
			ClickedTrove:Destroy()
			Disconnect()
		end
	end, {})

	React.useEffect(function()
		if ClickedPlayer then
			local ClickedCharacter = ClickedPlayer.Character

			if ClickedCharacter then
				local Connection = nil :: RBXScriptConnection?
				local WorldPromise = Promise.try(function()
					return ClickedCharacter
				end):andThen(function(Model: Model)
					Connection = RunService.Heartbeat:Connect(function()
						local Position = Camera:WorldToScreenPoint(Model:GetPivot().Position)
						SetClickedPosition(UDim2.fromOffset(Position.X, Position.Y))
					end)
				end)

				local ClickedPromise = Promise.new(function(resolve: (...any) -> ())
					SetClickedPosition(UDim2.fromScale(-1, -1))
					local Equipped = AllEquipped.Equipped[ClickedPlayer]
					if not Equipped then
						SetData({
							Loading = true,
							Name = "",
							Frames = {},
							Level = 1,
						})
						local Value = AllEquipped.GetChangedSignal(ClickedPlayer):Wait()
						resolve(Value)
					end
					resolve(Equipped)
				end):andThen(function(Value: AllEquipped.DataSent)
					SetData({
						Loading = false,
						Name = ClickedPlayer.Name,
						Frames = Value.EquippedUnits,
						Level = Value.Level,
					})
				end)

				return function()
					ClickedPromise:cancel()
					WorldPromise:cancel()
					if Connection then
						Connection:Disconnect()
					end
				end
			end
		end

		return function() end
	end, { ClickedPlayer })

	return e(React.Fragment, nil, {
		Highlight = Highlight,
		ClickedInventory = Data and e(
			CreateClickedInventory,
			Join(Data, {
				native = {
					Position = ClickedPosition,
				},
			}),
			props.children
		),
		ClickedHover = e(ClickedHover, {
			native = {
				Position = HoveredPosition,
				Visible = Hovered,
			},
		}),
	})
end

return {
	Create = CreateClickedInventory,
	Connected = Connected,
}
