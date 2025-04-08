--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Shared = ReplicatedStorage.Shared;
local Types = require(Shared.Types);

local UnitAttacks: {
	[string]: {
		[number]: {
			{(Unit: Types.Unit, AttackInput: Types.UnitAttackInput, Enemy: Types.EnemyClient?, Delay: number) -> ()}
		};
	};
} = {
	
};

return UnitAttacks;