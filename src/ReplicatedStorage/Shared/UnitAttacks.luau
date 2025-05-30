--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

local ModelStorage = ReplicatedStorage.ModelStorage
local Adornments = ModelStorage.Adornments
local PompeyArrow = Adornments.PompeyArrow

local Shared = ReplicatedStorage.Shared
local Types = require(Shared.Types)

local function FindFirstMiddle(Adornment: Model): BasePart?
	for _, Descendant in ipairs(Adornment:GetDescendants()) do
		if Descendant:IsA("BasePart") and Descendant.Name == "Middle" then
			return Descendant
		end
	end

	return
end

local function ClearWelds(Adornment: Model)
	for _, Limb in ipairs(Adornment:GetChildren()) do
		local Middle = Limb:FindFirstChild("Middle") :: BasePart?

		if Middle then
			for _, Weld in ipairs(Middle:GetChildren()) do
				if Weld:IsA("Motor6D") then
					Weld:Destroy()
				end
			end
		end
	end
end

local function PlayAnimation(Unit, AttackInput, Delay: number)
	local SpeedRatio = AttackInput.SpeedRatio
	Unit:PlayAnimation("Attack", Delay / SpeedRatio, 1 / SpeedRatio, nil)
end

local function DefaultAttack(Unit, AttackInput, Enemy, Delay: number)
	if Enemy then
		Unit:RotateToEnemy(Enemy)
	end
	PlayAnimation(Unit, AttackInput, Delay)
end

local function CalculateDelay(Normal: number, SpeedRatio: number, Delay: number)
	return math.clamp(Normal * SpeedRatio - Delay, 0, math.huge)
end

local function DestroyBeforeTime(Unit: Types.Unit, Model: Model, Delay: number)
	Unit:AddAttackPromise(
		Promise.delay(Delay):finally(function(Status)
			if Status == "Cancelled" then
				Model:Destroy()
			end
		end),
		"DelayPromiseTime"
	)
end

local function TweenBetweenPositions(
	Part: BasePart,
	Start: Vector3,
	End: Vector3,
	Speed: number,
	DistanceCalc: Vector3?
)
	return Promise.new(function(resolve, reject)
		local Distance = (Start - End).Magnitude
		if DistanceCalc then
			Distance = (DistanceCalc - End).Magnitude
		end
		local Inital = CFrame.lookAt(Start, End)
		Part.CFrame = Inital
		local Tween = TweenService:Create(Part, TweenInfo.new(Distance / Speed), {
			CFrame = CFrame.new(End) * Inital.Rotation,
		})

		Tween.Completed:Once(function(PlaybackState)
			if PlaybackState == Enum.PlaybackState.Cancelled then
				reject()
			else
				resolve()
			end
		end)
	end)
end

local function EasyWeld(Part0: BasePart, Part1: BasePart)
	local Weld = Instance.new("Weld")
	Weld.Name = Part0.Name
	Weld.Part0 = Part0
	Weld.Part1 = Part1
	Weld.Parent = Part0
	return Weld
end

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
		["Pompey"] = {
			[0] = {
				function(Unit, AttackInput, Enemy, Delay)
					if not Enemy then
						return
					end
					local SpeedRatio = AttackInput.SpeedRatio
					PlayAnimation(Unit, AttackInput, Delay)
					local Arrow = Unit:WeldAdornment(PompeyArrow)

					local DelayTime = CalculateDelay(0.4, SpeedRatio, Delay)
					DestroyBeforeTime(Unit, Arrow, DelayTime)

					local LastPosition: Vector3? = nil

					Enemy.Destroying:Once(function()
						LastPosition = Enemy.CFrame.Position
						Enemy = nil
					end)

					Unit:AddAttackPromise(
						Promise.delay(DelayTime):andThen(function()
							ClearWelds(Arrow)
							local Middle = FindFirstMiddle(Arrow)
							if Middle then
								if Enemy then
									LastPosition = Enemy.CFrame.Position
								end
								if LastPosition then
									TweenBetweenPositions(
										Middle,
										Middle.CFrame.Position,
										LastPosition,
										10,
										Unit.CFrame.Position
									):andThen(function()
										print("Hit!")
									end)
								end
							end
						end),
						"AttackPompeyArrow"
					)
				end,
			},
		},
		["Alexander The Great"] = {
			[0] = {
				DefaultAttack,
			},
		},
		["Julius Caesar"] = {
			[0] = {
				DefaultAttack,
			},
		},
		["Spartacus"] = {
			[0] = {
				DefaultAttack,
			},
		},
	}

local DefaultRuns: { [string]: { [number]: (Unit: Types.Unit) -> () } } = {
	["Trajan"] = {
		[0] = function(Unit)
			Unit:PlayAnimation("Ability")
		end,
	},
}

local Abilities: { [string]: { [number]: (Unit: Types.Unit) -> () } } = {}

return {
	UnitAttacks = UnitAttacks,
	DefaultRuns = DefaultRuns,
	Abilities = Abilities,
}
