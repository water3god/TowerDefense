--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

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
	Position: React.Binding<Vector2>?,
	UnitId: string?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type Props = {
	Position: React.Binding<Vector2>?,

	EnemyName: string,
	Health: number,
	MaxHealth: number,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateEnemyToolTip(Props: Props)
	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.4, 0.3),
			Position = Props.Position,
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
			UIStroke = e(UIStroke.UIStrokeBasic, {
				Stroke = 0.003,
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
					ZIndex = 2,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeBasic, {
					Stroke = 0.002,
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
		if Props.UnitId then
			local Enemy = EnemyClient.GetEnemy(Props.UnitId)
			if Enemy then
				SetData({
					EnemyName = Enemy.ModelName,
					Health = Enemy.Health,
					MaxHealth = Enemy.MaxHealth,
				})

				local Connection = Enemy.HealthChanged:Connect(function(Health: number)
					SetData(Join(Data, {
						MaxHealth = Health,
					}) :: any)
				end)

				local Connection1 = Enemy.MaxHealthChanged:Connect(function(MaxHealth: number)
					SetData(Join(Data, {
						MaxHealth = MaxHealth,
					}) :: any)
				end)

				return function()
					Connection:Disconnect()
					Connection1:Disconnect()
				end
			end
		end
		return function() end
	end, { Props.UnitId })

	return e(CreateEnemyToolTip, {
		EnemyName = Data.EnemyName,
		Health = Data.Health,
		MaxHealth = Data.MaxHealth,
		native = Props.native,
	}, Props.children)
end

return {
	Create = CreateEnemyToolTip,
	Connected = CreateConnected,
}
