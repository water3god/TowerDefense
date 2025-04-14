--!strict

-- By Wa1er_God --

local DefaultFont =
	Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local UIStroke = require(CoreGame.UIStroke)
local Main = require(CoreGame.Main)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)
local Types = require(Shared.Types)

local UnitModels = ReplicatedStorage.ModelStorage.Units
local UnitAnimations = ReplicatedStorage.Animations.Units
export type InfoType = "Unit" | "Gamepass"

export type UnitData = {
	UnitData: Types.VisualUnitData,
	UnitInfo: UnitInfo.UnitInfo,
}

export type Data = UnitData | {}

export type Properties = {
	Visible: boolean,

	Type: InfoType | string,
	Name: string?,
	Rarity: string?,

	Data: Data?,
	RarityInfo: RarityInfo.RarityInfo?,

	OnEquipClick: () -> ()?,
	OnSellClick: () -> ()?,
}

local function InitViewport(Viewport: ViewportFrame, Data: UnitData)
	local UnitName = Data.UnitData.Unit
	local Model = UnitModels:FindFirstChild(UnitName):Clone()
	local Humanoid = Model:FindFirstChildWhichIsA("Humanoid")
	local Animator = Humanoid:FindFirstChildWhichIsA("Animator")
	local Animation = UnitAnimations:FindFirstChild(UnitName):FindFirstChild("Idle")

	HelperFunctions.DisableHumanoid(Humanoid)
	local Track = Animator:LoadAnimation(Animation)
	Track:Play()

	return function()
		Model:Destroy()
	end
end

local function CreateInfoFrame(Properties: Properties)
	local ViewportReference = React.useRef(nil :: ViewportFrame?)
	local IsUnit = if Properties.Type == "Unit" then true else false
	local HasValue = if Properties.Data then true else false
	local UnitData: UnitData = Properties.Data :: UnitData

	React.useEffect(function()
		if ViewportReference.current then
			if Properties.Data and IsUnit then
				return InitViewport(ViewportReference.current, Properties.Data :: UnitData)
			end
		else
			warn("No Refference")
		end
		return function() end
	end, { Properties.Name })

	return e(Main.ImageLabel, {
		native = {
			Position = UDim2.fromScale(0.85, 0.525),
			Size = UDim2.fromScale(0.2, 0.85),
			Image = "rbxassetid://75971006528952",
			Visible = Properties.Visible,
		},
		children = {
			ViewportFrame = e(Main.ViewportFrame, {
				native = {
					Position = UDim2.fromScale(0.5, 0.45),
					Size = UDim2.fromScale(0.9, 0.425),
					ref = ViewportReference,
				},
				children = {
					UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
						AspectRatio = 1,
					}),
					Camera = e("Camera", {
						CFrame = CFrame.new(0, 0, 0),
					}),
				},
			}),
			EquipButton = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.5, 0.92),
					Size = UDim2.fromScale(0.9, 0.125),
					Image = "rbxassetid://72606508098140",
					[React.Event.MouseButton1Click] = Properties.OnEquipClick,
				},
				children = {
					TextLabel = e(Main.TextLabel, {
						native = {
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromScale(0.6, 0.6),
							Text = "Equip",
							TextColor3 = Color3.new(1, 1, 1),
						},
					}),
				},
			}),
			InfoButton = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.8, 0.66),
					Size = UDim2.fromScale(0.21, 0.12),
					Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
				},
				children = {
					UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
						AspectRatio = 1,
					}),
				},
			}),
			SellButton = e(Main.Animateables.ImageButton, {
				native = {
					Position = UDim2.fromScale(0.5, 0.79),
					Size = UDim2.fromScale(0.9, 0.125),
					Image = "rbxassetid://135833754402129",
					ImageColor3 = Color3.fromRGB(255, 43, 47),
					[React.Event.MouseButton1Click] = Properties.OnSellClick,
				},
				children = {
					TextLabel = e(Main.TextLabel, {
						native = {
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromScale(0.6, 0.6),
							Text = "Sell",
							TextColor3 = Color3.new(1, 1, 1),
						},
					}),
				},
			}),
			Bar = e(Main.ImageLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.26),
					Size = UDim2.fromScale(0.7, 0.055),
					Image = "rbxassetid://125478192482439",
					Visible = IsUnit,
				},
				children = {
					BarOverlay = e(Main.Frame, {
						native = {
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromScale(0.99, 0.9),
						},
						children = {
							InnerBar = e(Main.Frame, {
								native = {
									BackgroundTransparency = 0,
									BackgroundColor3 = Color3.fromRGB(255, 0, 201),
									Position = UDim2.fromScale(0, 0.05),
									Size = if IsUnit and HasValue
										then UDim2.fromScale(UnitData.UnitData.XP / UnitData.UnitData.NeededXP, 0.9)
										else UDim2.fromScale(0, 0),
								},
								children = {
									UICorner = e("UICorner", {
										CornerRadius = UDim.new(1, 0),
									}),
								},
							}),
						},
					}),
					XPLabel = e(Main.TextLabel, {
						native = {
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromScale(0.99, 0.9),
							Text = if IsUnit and HasValue
								then string.format("%u/%u", UnitData.UnitData.XP, UnitData.UnitData.NeededXP)
								else "",
						},
					}),
				},
			}),
			NameLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.1),
					Size = UDim2.fromScale(0.8, 0.12),
					Text = Properties.Name,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
				children = {
					UIStroke = e(UIStroke.UIStroke, {
						Stroke = 0.002,
						GradColor = Properties.RarityInfo and Properties.RarityInfo.StrokeColor,
					}),
					UIGradient = e("UIGradient", {
						Color = Properties.RarityInfo and Properties.RarityInfo.Color,
					}),
				},
			}),
			RarityLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.19),
					Size = UDim2.fromScale(0.8, 0.05),
					Text = Properties.Rarity,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
				children = {
					UIStroke = e(UIStroke.UIStroke, {
						Stroke = 0.002,
						GradColor = Properties.RarityInfo and Properties.RarityInfo.StrokeColor,
					}),
					UIGradient = e("UIGradient", {
						Color = Properties.RarityInfo and Properties.RarityInfo.Color,
					}),
				},
			}),
		},
	})
end

return CreateInfoFrame
