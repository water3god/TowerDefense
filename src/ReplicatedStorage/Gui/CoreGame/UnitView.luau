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

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local RarityInfo = require(Shared.RarityInfo)

export type Properties = {
	UnitName: string?,
	RotationCFrame: React.Binding<CFrame>?,
	Offset: Vector3?,
	Distance: number?,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

local CoreCFrame = CFrame.new(0, 0.5, 0) * CFrame.Angles(0, math.rad(180), 0)
local Distance = 2

local function CreateUnitView(Props: Properties)
	local Container = React.useRef(nil)
	local Camera = React.useRef(nil)

	React.useEffect(function()
		if Props.UnitName then
			local Data = UnitClient.InitCharacter(Props.UnitName, CFrame.new())
			Data.UnitModel.Parent = Container.current

			return Data.Trove:WrapClean()
		end
		return function() end
	end, { Props.UnitName })

	local FixedViewportCFrame = React.useMemo(function()
		if Props.UnitName then
			local UnitData = UnitInfo.UnitInfo[Props.UnitName]
			local ViewportOffset = UnitData.ViewportOffset or Vector3.zero
			local Distance = Props.Distance or Distance
			local DistanceVector = Vector3.new(0, 0, -Distance)

			return (CoreCFrame + DistanceVector :: any) + ViewportOffset
		else
			return CFrame.new()
		end
	end, { Props.UnitName })

	return e(Main.ViewportFrame, {
		native = Join({
			LightDirection = Vector3.new(0, -1, -1),
			LightColor = Color3.new(1, 1, 1),
			Ambient = Color3.new(1, 1, 1),
			CurrentCamera = Camera,
		}, Props.native),
	}, {
		ModelContainer = e("WorldModel", {
			ref = Container,
			WorldPivot = CFrame.new(),
		}),
		Camera = e("Camera", {
			ref = Camera,
			CFrame = Props.RotationCFrame and Props.RotationCFrame:map(function(Rotation: CFrame)
				local Distance = Props.Distance or Distance
				local Offset = Props.Offset or Vector3.zero
				local Default = Vector3.new(0, 0.5, -Distance)

				return CFrame.lookAt(Rotation * Default, CoreCFrame.Position) + Offset
			end) or FixedViewportCFrame,
		}),
	}, Props.children)
end

return CreateUnitView
