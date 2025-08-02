--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Trove = require(Packages.Trove)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local EnemyClient = require(GlobalClient.EnemyClient)

export type ConnectedProps = {
	EnemyId: string?,
	Position: React.Binding<Vector2>?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type Props = {
	EnemyName: string,
	Health: number,
	MaxHealth: number,

	Position: React.Binding<Vector2>?,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateEnemyToolTip(Props: Props)
	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.15, 0.1),
			AnchorPoint = Vector2.new(0, 0),
			Position = Props.Position and Props.Position:map(function(PositionInput: Vector2)
				local Position = PositionInput - GuiService:GetGuiInset()

				return UDim2.fromOffset(Position.X, Position.Y)
			end),
			Image = "rbxassetid://103903141717286",
		}, Props.native),
	}, {
		UIAspectRatio = e("UIAspectRatioConstraint", {
			AspectRatio = 2,
		}),
		UnitName = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.275),
				Size = UDim2.fromScale(0.9, 0.25),
				Text = Props.EnemyName,
			},
		}),
		Group = e(Main.CanvasGroup, {
			native = {
				Position = UDim2.fromScale(0.5, 0.7),
				Size = UDim2.fromScale(0.8, 0.3),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.3, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
				native = {
					Color = Color3.fromRGB(127, 32, 165),
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
			Bar = e(Main.Frame, {
				native = {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.fromScale(math.clamp(Props.Health / Props.MaxHealth, 0, 1), 1),
					BackgroundColor3 = Color3.fromRGB(0, 255, 0),
					BackgroundTransparency = 0,
				},
			}),
			HealthLabel = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.9, 0.6),
					Text = string.format("%u / %u", Props.Health, Props.MaxHealth),
					AutoLocalize = false,
					ZIndex = 2,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.015,
				}),
			}),
		}),
	}, Props.children)
end

local function CreateConnected(Props: ConnectedProps)
	local Data, SetData = React.useState({
		EnemyName = "",
		Health = 10,
		MaxHealth = 10,
	})

	React.useEffect(function()
		local NewTrove = Trove.new()
		if Props.EnemyId then
			local Enemy = EnemyClient.GetEnemy(Props.EnemyId)
			if Enemy then
				SetData({
					EnemyName = Enemy.ModelName,
					Health = Enemy.Health,
					MaxHealth = Enemy.MaxHealth,
				})

				NewTrove:Connect(Enemy.HealthChanged, function(Health: number)
					SetData(function(Current)
						return Join(Current, {
							Health = Health,
						}) :: any
					end)
				end)

				NewTrove:Connect(Enemy.MaxHealthChanged, function(MaxHealth: number)
					SetData(function(Current)
						return Join(Current, {
							MaxHealth = MaxHealth,
						}) :: any
					end)
				end)

				NewTrove:Connect(Enemy.Destroying, NewTrove:WrapClean())
			end
		end
		return NewTrove:WrapClean()
	end, { Props.EnemyId })

	return e(CreateEnemyToolTip, {
		EnemyName = Data.EnemyName,
		Health = Data.Health,
		MaxHealth = Data.MaxHealth,
		Position = Props.Position,
		native = Props.native,
	}, Props.children)
end

return {
	Create = CreateEnemyToolTip,
	Connected = CreateConnected,
}
