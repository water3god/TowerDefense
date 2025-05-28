--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local Types = require(Shared.Types)

local UnitAttacks: {
	[string]: {
		[number --[[Level]]]: {
			--[[Index]]
			(
				Unit: Types.Unit,
				AttackInput: Types.UnitAttackInput,
				Enemy: Types.EnemyClient?,
				Delay: number
			) -> ()
		},
	},
} =
	{
		--[[["Pompey"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					local AttackAnim = Unit:PlayAnimation("Attack", Delay, AttackInput.SpeedRatio, nil)
					if AttackAnim then
						Unit:Watch(AttackAnim, {
							Func = function()
								print("Hello")
							end,
							PlayAfter = false,
							TimeRatio = 0.5,
						})
					end
				end,
			},
		},]]
		["Alexander The Great"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					if Enemy then
						Unit:RotateToEnemy(Enemy)
					end

					local AttackAnim = Unit:PlayAnimation("Attack", Delay, AttackInput.SpeedRatio, nil)
					if AttackAnim then
						--[[Unit:Watch(AttackAnim, {
							Func = function()
								print("Hello")
							end,
							PlayAfter = false,
							TimeRatio = 0.5,
						})]]
					end
				end,
			},
		},
	}

return UnitAttacks
