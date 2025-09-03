--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Conch = require(Packages.Conch)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local GameInfo = require(Shared.GameInfo)
local Traits = require(Shared.Traits)

local EnemyData = {}

for _, Enemy in ipairs(ReplicatedStorage.ModelStorage.Enemies:GetChildren()) do
	if Enemy:IsA("Model") then
		EnemyData[Enemy.Name] = true
	end
end

local UnitType =
	Conch.register_type("unit", Conch.args.enum_map(UnitInfo.UnitInfo, "Unit", "Troops that attack enemies"))

local EnemyType =
	Conch.register_type("enemy", Conch.args.enum_map(EnemyData, "Enemy", "Enemies that players must defeat"))

local TraitType =
	Conch.register_type("trait", Conch.args.enum_map(Traits.Traits, "Trait", "Traits that can be applied to units"))

local ResourceType = Conch.register_type(
	"resource",
	Conch.args.enum_map(GameInfo.RewardInfo, "Resource", "Resources that can be collected")
)

return {
	UnitType = UnitType,
	EnemyType = EnemyType,
	TraitType = TraitType,
	ResourceType = ResourceType,
}
