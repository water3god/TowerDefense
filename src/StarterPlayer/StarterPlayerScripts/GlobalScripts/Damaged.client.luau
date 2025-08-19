--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local EnemyClient = require(GlobalClient.EnemyClient)

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local UIStroke = require(CoreGame.UIStroke)
local Main = require(CoreGame.Main)

local Particles = workspace.GlobalWorkspace.Particles
local Random = Random.new()

local function CreateDamage(props: { Damage: number })
	local Styles = ReactSpring.useSpring({
		from = { Transparency = 0 },
		to = { Transparency = 1 },
		config = { duration = 0.5 },
	})

	return e(Main.TextLabel, {
		native = {
			Text = tostring(props.Damage),
			TextColor3 = Color3.new(1, 0, 0),
			TextTransparency = Styles.Transparency,
		},
	}, {
		UIStroke = e(UIStroke.UIStrokeAdvanced, {
			Stroke = 0.02,
			native = {
				Transparency = Styles.Transparency,
			},
		}),
	})
end

local function HandleEnemy(Enemy: EnemyClient.Enemy)
	Enemy.Damaged:Connect(function(Damage: number)
		local Part = HelperFunctions.CreateRaw()
		Part.Transparency = 1
		Part.Name = "DamagePart"

		local NewVec =
			Vector3.new(Random:NextNumber(-0.5, 0.5), Random:NextNumber(-0.5, 0.5), Random:NextNumber(-0.5, 0.5))
		local FlattenedVec = Vector3.new(NewVec.X, 0, NewVec.Z)
		local Orig = Enemy.Root.CFrame

		Part.Position = Orig.Position + NewVec + Vector3.yAxis

		local Root = ReactRoblox.createRoot(Part)

		Root:render({
			DamagedGui = e("BillboardGui", {
				Adornee = Part,
				Size = UDim2.fromScale(1, 1),
				AlwaysOnTop = true,
				ResetOnSpawn = false,
			}, {
				DamageLabel = e(CreateDamage, {
					Damage = Damage,
				}),
			}),
		})

		local Up = 2
		local accel = 1
		local Scale = 1

		local Connection = RunService.PreRender:Connect(function(Delta: number)
			accel -= Delta * 4
			Up += accel / 20
			Scale += Delta * 3
			Part.Position = Orig.Position + Vector3.new(0, Up, 0) + Vector3.new(0, NewVec.Y, 0) + FlattenedVec * Scale
		end)

		task.delay(0.5, function()
			Connection:Disconnect()
			Root:unmount()
			Part:Destroy()
		end)

		Part.Parent = Particles
	end)
end

for _, Unit in pairs(EnemyClient.GetEnemies()) do
	HandleEnemy(Unit)
end

EnemyClient.NewEnemy:Connect(HandleEnemy)
