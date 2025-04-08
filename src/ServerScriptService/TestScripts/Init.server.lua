--!strict

local ServerScriptService = game:GetService("ServerScriptService");
local GlobalModules = ServerScriptService.GlobalModules;

local Enemy = require(GlobalModules.Enemy);
local Unit = require(GlobalModules.Unit);
local Bezier = require(game.ReplicatedStorage.Modules.BezierPath);
local IdGen = require(game.ReplicatedStorage.Modules.GenerateId);
task.wait(1);

--[[task.delay(2, function()
	Unit.new({
		OwnerId = 34315423;
		CFrame = CFrame.new(-30.75, 3.25, -6.25);
	}, {
		ModelName = "Scout";
		UpgradeData = {
			[0] = {
				Damage = {10};
				FireRate = 2;
				Range = 50;
				Animations = {};
				Armor = "Armor";
				FuncData = {{AnimationName = "", AttackId = "Scoutv1.0"}};
			};
		};
		AttackFuncs = {
			[0] = {function(Unit: Unit.Unit, Damage: number)
				local CurrentEnemy = Unit.CurrentEnemy;

				if CurrentEnemy then
					CurrentEnemy:DoDamage(Damage);
				end
			end},
		};
		Abilities = {};
	});
end)]]

local Positions = {};

for _, Child in ipairs(workspace.Nodes:GetChildren()) do
	table.insert(Positions, Child.Position);
end

--[[task.spawn(function()
	while true do
		local Enem = Enemy.new({
			ModelName = "Zombie", Health = 10, Speed = 5, Reverse = false, IsBoss = false, Ally = false
		}, {NodeFolder = workspace.Nodes, BezierPath = Bezier.new(Positions, 5)});
		task.spawn(function()
			task.wait(2);
			--Enem:AdjustSpeed(10);
		end)
		task.wait(2);
	end
end)]]

local Positions = {};

for _, Node: BasePart in ipairs(workspace.Nodes:GetChildren()) do
	table.insert(Positions, Node.CFrame.Position)
end

local bez = Bezier.new(Positions, 5);
local Id = IdGen.GenerateId();

Enemy.AddBezier(Id, bez);

while true do
	local Enem = Enemy.new({
		EnemyInfo = {
			ModelName = "Zombie";
			Health = 10;
			Speed = 5;
			Reverse = false;
			IsBoss = false;
			Ally = false;
		};
		Bezier = bez;
		BezierId = Id;
	})
	task.spawn(function()
		task.wait(2);
		Enem:AdjustSpeed(3);
	end)
	task.wait(1);
end