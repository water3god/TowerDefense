--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

if require(ReplicatedStorage.Shared.IsLobby) then
	return
end

local Modules = ReplicatedStorage.Modules
local DelayHandler = require(Modules.DelayHandler)
local HelperFunctions = require(Modules.HelperFunctions)

local Remotes = ReplicatedStorage.Remotes
local UnitClient = Remotes.UnitClient

local ChangePriority = UnitClient.ChangePriority
local Placement = UnitClient.Placement
local Upgrade = UnitClient.Upgrade
local UseAbility = UnitClient.UseAbility
local Sell = UnitClient.Sell

local WarningEvents = Remotes.Core.Warning
local SendWarning = WarningEvents.SendWarning

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local Constants = require(Shared.Constants)

local GlobalModules = ServerScriptService.GlobalModules
local Unit = require(GlobalModules.Unit)
local Enemy = require(GlobalModules.Enemy)
local GlobalWave = require(GlobalModules.GlobalWave)

local PlayerData = require(GlobalModules.PlayerData)

local UnitData = require(ServerStorage.Data.UnitData)

local CylinderCast = ReplicatedStorage.ModelStorage.Extra.CylinderCast

type PlacementData = {
	Unit: string,
	UnitPosition: Vector3,
	RotationIndex: number,
}

local CylinderCache: { [number]: BasePart } = {}

local function CloneCylinder(Radius: number)
	if not CylinderCache[Radius] then
		local Cylinder = CylinderCast:Clone()
		Cylinder.Size = Vector3.new(Radius, Cylinder.Size.Y, Radius)
		CylinderCache[Radius] = Cylinder
	end

	return CylinderCache[Radius]
end

ChangePriority.OnServerEvent:Connect(function(Player: Player, UniqueId: string)
	if typeof(UniqueId) ~= "string" then
		return
	end
	local CurrentUnit = Unit.GetUnit(UniqueId)

	if CurrentUnit then
		if CurrentUnit.Owner == Player then
			CurrentUnit:ChangePriority()
		end
	end
end)

local function CheckPlacement(InputCFrame: CFrame, UnitInfo: UnitInfo.UnitInfo): RaycastResult?
	local UnitPos = HelperFunctions.ConvertToVec2(InputCFrame.Position)

	for UniqueId, OtherUnit in pairs(Unit.GetUnits()) do
		local Radius = UnitInfo.CollisionRadius + OtherUnit.CollisionRadius
		local OtherPos = HelperFunctions.ConvertToVec2(OtherUnit.CFrame.Position)

		if (UnitPos - OtherPos).Magnitude < Radius / 2 then
			return
		end
	end

	local RayParams = RaycastParams.new()
	RayParams.FilterType = Enum.RaycastFilterType.Exclude

	RayParams.CollisionGroup = "PlacementClient"

	local Raycast = workspace:Raycast(InputCFrame.Position + Vector3.new(0, 1, 0), -Vector3.yAxis * 4, RayParams)

	if Raycast and Raycast.Instance then
		if Raycast.Instance:HasTag("CanPlace") then
			local OvParams = OverlapParams.new()
			OvParams.FilterType = Enum.RaycastFilterType.Exclude
			OvParams.CollisionGroup = "PlacementClient"

			local Cylinder = CloneCylinder(UnitInfo.CollisionRadius)
			local Parts = workspace:GetPartsInPart(Cylinder, OvParams)

			for _, BasePart in ipairs(Parts) do
				if not BasePart:HasTag("CanPlace") then
					return
				end
			end
		else
			return
		end
	else
		return
	end

	return Raycast
end

local function PlaceUnit(Player: Player, Wave: GlobalWave.GlobalWave, Data: PlacementData)
	local InputCFrame = CFrame.new(Data.UnitPosition) * CFrame.Angles(0, math.rad(-90 * Data.RotationIndex), 0)

	local UnitData = UnitData.UnitData[Data.Unit]
	local UnitInfo = UnitInfo.UnitInfo[Data.Unit]

	if UnitData then
		local Cost = UnitInfo.UnitData[0].Cost
		local PlayerCoins = Wave.Coins[Player.UserId]

		if Wave:HasEnoughCoins(Player.UserId, Cost) then
			local Result = CheckPlacement(InputCFrame, UnitInfo)
			if Result then
				Unit.new({
					CFrame = InputCFrame,
					OwnerId = Player.UserId,
					Level = 0,
				}, UnitData)
				Wave:SubtractCoinsFromUser(Player.UserId, Cost)
			end
		else
			SendWarning:FireClient(Player, string.format("You are missing %u Coins!", Cost - PlayerCoins))
		end
	end
end

local function OnPlacement(Player: Player, Data: PlacementData)
	local PlayerData = PlayerData.GetPlayerData(Player)

	if PlayerData then
		local Wave = GlobalWave.GetWave()
		if Wave then
			PlaceUnit(Player, Wave, Data)
		end
	end
end

Placement.OnServerEvent:Connect(function(Player: Player, Data: PlacementData)
	if typeof(Data) ~= "table" then
		return
	end
	if
		typeof(Data.Unit) ~= "string"
		or typeof(Data.UnitPosition) ~= "Vector3"
		or typeof(Data.RotationIndex) ~= "number"
	then
		return
	end
	if
		HelperFunctions.IsNan(Data.UnitPosition)
		or HelperFunctions.IsNan(Data.RotationIndex)
		or not HelperFunctions.IsInteger(Data.RotationIndex)
	then
		return
	end
	OnPlacement(Player, Data)
end)

Upgrade.OnServerEvent:Connect(function(Player: Player, UniqueId: string)
	if typeof(UniqueId) ~= "string" then
		return
	end

	local CurrentUnit = Unit.GetUnit(UniqueId)

	if CurrentUnit and CurrentUnit.Owner == Player then
		CurrentUnit:Upgrade()
	end
end)

UseAbility.OnServerEvent:Connect(function(Player: Player, UniqueId: string, Index: number)
	if typeof(UniqueId) ~= "string" or typeof(Index) ~= "number" then
		return
	end

	local CurrentUnit = Unit.GetUnit(UniqueId)

	if CurrentUnit and CurrentUnit.Owner == Player then
		CurrentUnit:UseAbility(Index)
	end
end)

Sell.OnServerEvent:Connect(function(Player: Player, UniqueId: string)
	if typeof(UniqueId) ~= "string" then
		return
	end

	local CurrentUnit = Unit.GetUnit(UniqueId)
	local GlobalWave = GlobalWave.GetWave()

	if GlobalWave and CurrentUnit and CurrentUnit:IsOwnedBy(Player) then
		GlobalWave:AddCoinsToUser(Player.UserId, CurrentUnit.TotalCost / Constants.CostDivider)
		CurrentUnit:Delete()
	end
end)
