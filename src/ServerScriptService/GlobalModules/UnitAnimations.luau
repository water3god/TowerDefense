local NotificationService = game:GetService("NotificationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Animations = ReplicatedStorage.Animations
local UnitFolder = Animations.Units
local ModelStorage = ReplicatedStorage.ModelStorage
local Rig = ModelStorage.Extra.Rig:Clone()
local Animator = Rig.Humanoid.Animator

local OtherLengths: { [string]: number } = {}

local Lengths: { [string]: { [string]: number } } = {}

local function GetAnimationLengths(Unit: string): { [string]: number }
	if Lengths[Unit] then
		return Lengths[Unit]
	else
		local UnitData = {}

		for _, Animation in ipairs(UnitFolder:GetChildren()) do
			UnitData[Animation.Name] = Animator:LoadAnimation(Animation).Length
		end

		if not UnitData.Idle then
			if not OtherLengths.Idle then
				OtherLengths.Idle = Animator:LoadAnimation(UnitFolder.Default).Length
			end
			UnitData.Idle = OtherLengths.Idle
		end

		Lengths[Unit] = UnitData

		return UnitData
	end
end
