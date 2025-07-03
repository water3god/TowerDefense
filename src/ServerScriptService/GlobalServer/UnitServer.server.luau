--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

if require(ReplicatedStorage.Shared.IsLobby) then
	return
end

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local Network = require(ReplicatedStorage.Network.Server)
local SendWarning = Network.SendWarning

local ChangePriority = Network.ChangeUnitPriority
local Placement = Network.PlaceUnit
local Upgrade = Network.UpgradeUnit
local UseAbility = Network.UseUnitAbility
local Sell = Network.SellUnit

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local Constants = require(Shared.Constants)

local GlobalModules = ServerScriptService.GlobalModules
local Unit = require(GlobalModules.Unit)
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

ChangePriority.SetCallback(function(Player: Player, UniqueId: string)
	if typeof(UniqueId) ~= "string" then
		return
	end
	local CurrentUnit = Unit.GetUnit(UniqueId)

	if CurrentUnit then
		if CurrentUnit:IsOwnedBy(Player) then
			CurrentUnit:ChangePriority()
		end
	end
end)

local function CheckPlacement(InputCFrame: CFrame, Info: UnitInfo.UnitInfo): RaycastResult?
	local UnitPos = HelperFunctions.ConvertToVec2(InputCFrame.Position)

	for _, OtherUnit in pairs(Unit.GetUnits()) do
		local Radius = Info.CollisionRadius + OtherUnit.CollisionRadius
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

			local Cylinder = CloneCylinder(Info.CollisionRadius)
			Cylinder.CFrame = CFrame.new(InputCFrame.Position) * Cylinder.CFrame.Rotation
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

	local UnitUnitData = UnitData.UnitData[Data.Unit]

	if not UnitUnitData then
		warn(`No UnitData for '{Data.Unit}`)
	end
	local UnitUnitInfo = UnitInfo.UnitInfo[Data.Unit]
	if not UnitUnitInfo then
		warn(`No UnitData for '{Data.Unit}`)
	end

	if UnitData then
		local Cost = UnitUnitInfo.UnitData[0].Cost
		local PlayerCoins = Wave.Coins[Player.UserId]

		if Wave:HasEnoughCoins(Player.UserId, Cost) then
			local Result = CheckPlacement(InputCFrame, UnitUnitInfo)
			if Result then
				Unit.new({
					CFrame = InputCFrame,
					OwnerId = Player.UserId,
					Level = 0,
				}, UnitUnitData)
				Wave:SubtractCoinsFromUser(Player.UserId, Cost)
			else
				SendWarning.Fire(Player, "Incorrect Placement!")
			end
		else
			SendWarning.Fire(Player, string.format("You are missing %u Coins!", Cost - PlayerCoins))
		end
	end
end

local function OnPlacement(Player: Player, Data: PlacementData)
	local PData = PlayerData.GetPlayerData(Player)

	if PData then
		local Wave = GlobalWave.GetWave()
		if Wave then
			PlaceUnit(Player, Wave, Data)
		end
	end
end

Placement.SetCallback(function(Player: Player, Data: PlacementData)
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

Upgrade.SetCallback(function(Player: Player, UniqueId: string)
	if typeof(UniqueId) ~= "string" then
		return
	end

	local CurrentUnit = Unit.GetUnit(UniqueId)

	if CurrentUnit and CurrentUnit:IsOwnedBy(Player) then
		CurrentUnit:Upgrade()
	end
end)

UseAbility.SetCallback(function(Player: Player, UniqueId: string, Index: number)
	if typeof(UniqueId) ~= "string" or typeof(Index) ~= "number" then
		return
	end

	local CurrentUnit = Unit.GetUnit(UniqueId)

	if CurrentUnit and CurrentUnit:IsOwnedBy(Player) then
		CurrentUnit:UseAbility(Index)
	end
end)

Sell.SetCallback(function(Player: Player, UniqueId: string)
	if typeof(UniqueId) ~= "string" then
		return
	end

	local CurrentUnit = Unit.GetUnit(UniqueId)
	local Wave = GlobalWave.GetWave()

	if Wave and CurrentUnit and CurrentUnit:IsOwnedBy(Player) then
		Wave:AddCoinsToUser(Player.UserId, math.floor(CurrentUnit.TotalCost / Constants.CostDivider))
		CurrentUnit:Delete()
	end
end)
