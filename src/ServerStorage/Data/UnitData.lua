--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");

local GlobalModules = ServerScriptService.GlobalModules;
local Unit = require(GlobalModules.Unit);

local Data: {[string]: Unit.UnitInput} = {
	["Scout"] = {
		ModelName = "Scout";
		UpgradeData = {
			[0] = {
				Damage = {5};
				FireRate = 1;
				Range = 50;
				Animations = {};
				Armor = "Armor";
				Cost = 100;
			};
		};
		AttackFuncs = {
			[0] = {function(Unit: Unit.Unit, Damage: number)
				local CurrentEnemy = Unit.CurrentEnemy;

				if CurrentEnemy then
					CurrentEnemy:Damage(Damage);
				end
			end},
		};
		Abilities = {};
		CollisionRadius = 5;
	};
	["Shocker"] = {
		ModelName = "Scout";
		UpgradeData = {
			[0] = {
				Damage = {5};
				FireRate = 1;
				Range = 10;
				Animations = {};
				Armor = "Armor";
				Cost = 100;
			};
		};
		AttackFuncs = {
			[0] = {function(Unit: Unit.Unit, Damage: number)
				local CurrentEnemy = Unit.CurrentEnemy;

				if CurrentEnemy then
					CurrentEnemy:Damage(Damage);
				end
			end},
		};
		Abilities = {};
		CollisionRadius = 5;
	};
	["Sniper"] = {
		ModelName = "Scout";
		UpgradeData = {
			[0] = {
				Damage = {5};
				FireRate = 1;
				Range = 20;
				Animations = {};
				Armor = "Armor";
				Cost = 100;
			};
		};
		AttackFuncs = {
			[0] = {function(Unit: Unit.Unit, Damage: number)
				local CurrentEnemy = Unit.CurrentEnemy;

				if CurrentEnemy then
					CurrentEnemy:Damage(Damage);
				end
			end},
		};
		Abilities = {};
		CollisionRadius = 5;
	};
	["Shotgunner"] = {
		ModelName = "Scout";
		UpgradeData = {
			[0] = {
				Damage = {5};
				FireRate = 1;
				Range = 5;
				Animations = {};
				Armor = "Armor";
				Cost = 100;
			};
		};
		AttackFuncs = {
			[0] = {function(Unit: Unit.Unit, Damage: number)
				local CurrentEnemy = Unit.CurrentEnemy;

				if CurrentEnemy then
					CurrentEnemy:Damage(Damage);
				end
			end},
		};
		Abilities = {};
		CollisionRadius = 5;
	};
	["Minigunner"] = {
		ModelName = "Scout";
		UpgradeData = {
			[0] = {
				Damage = {5};
				FireRate = 1;
				Range = 15;
				Animations = {};
				Armor = "Armor";
				Cost = 100;
			};
		};
		AttackFuncs = {
			[0] = {function(Unit: Unit.Unit, Damage: number)
				local CurrentEnemy = Unit.CurrentEnemy;

				if CurrentEnemy then
					CurrentEnemy:Damage(Damage);
				end
			end},
		};
		Abilities = {};
		CollisionRadius = 5;
	};
};

local Ultimate = {};

Ultimate.UnitData = Data;

function Ultimate.LevelFunc(Level: number): number
	return  1 + (Level / 100);
end

return Ultimate;