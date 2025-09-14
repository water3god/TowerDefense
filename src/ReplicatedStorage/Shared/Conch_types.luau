--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Conch = require(Packages.Conch)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local ProductInfo = require(Shared.ProductInfo)
local GameInfo = require(Shared.GameInfo)
local Traits = require(Shared.Traits)

local EnemyData = {}

for _, Enemy in ipairs(ReplicatedStorage.ModelStorage.Enemies:GetChildren()) do
	if Enemy:IsA("Model") then
		table.insert(EnemyData, Enemy.Name)
	end
end

local UnitType = Conch.register_type(
	"unit",
	Conch.args.enum_new(HelperFunctions.ConvertDictToArray(UnitInfo.UnitInfo), "Unit", "Troops that attack enemies")
)

local EnemyType =
	Conch.register_type("enemy", Conch.args.enum_new(EnemyData, "Enemy", "Enemies that players must defeat"))

local TraitType = Conch.register_type(
	"trait",
	Conch.args.enum_new(
		HelperFunctions.ConvertDictToArray(Traits.Traits),
		"Trait",
		"Traits that can be applied to units"
	)
)

local Products = {}

for _, Product in pairs(ProductInfo.ProductInfo) do
	table.insert(Products, Product.Name)
end

for _, Product in pairs(ProductInfo.GamepassInfo) do
	table.insert(Products, Product.Name)
end

local ProductType =
	Conch.register_type("product", Conch.args.enum_new(Products, "Product", "Products that can be purchased"))

local ResourceType = Conch.register_type(
	"resource",
	Conch.args.enum_new(
		HelperFunctions.ConvertDictToArray(GameInfo.RewardInfo),
		"Resource",
		"Resources that can be collected"
	)
)

return {
	UnitType = UnitType,
	EnemyType = EnemyType,
	TraitType = TraitType,
	ProductType = ProductType,
	ResourceType = ResourceType,
}
