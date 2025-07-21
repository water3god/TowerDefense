--!strict

-- By Wa1er_God --

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function HandleCharacter(Character: Model)
	local Disabled = Character:GetAttribute("Disabled") or false
	local Humanoid = Character:WaitForChild("Humanoid") :: Humanoid
	Character:SetAttribute("Disabled", Disabled)
	Character:SetAttribute("WalkSpeed", Character:GetAttribute("WalkSpeed") or Humanoid.WalkSpeed)
	Character:SetAttribute("JumpHeight", Character:GetAttribute("JumpHeight") or Humanoid.JumpHeight)
	local function OnDisabled()
		Disabled = Character:GetAttribute("Disabled") :: boolean
		if Disabled then
			Humanoid.WalkSpeed = 0
			Humanoid.JumpHeight = 0
		else
			Humanoid.WalkSpeed = Character:GetAttribute("WalkSpeed") or 16 :: any
			Humanoid.JumpHeight = Character:GetAttribute("JumpHeight") or 50 :: any
		end
	end

	local function OnWalkSpeedChanged()
		local WalkSpeed = Character:GetAttribute("WalkSpeed") :: number
		if not Disabled then
			Humanoid.WalkSpeed = WalkSpeed
		end
	end

	local function OnJumpHeightChanged()
		local JumpHeight = Character:GetAttribute("JumpHeight") :: number
		if not Disabled then
			Humanoid.JumpHeight = JumpHeight
		end
	end

	OnDisabled()

	Character:GetAttributeChangedSignal("WalkSpeed"):Connect(OnWalkSpeedChanged)
	Character:GetAttributeChangedSignal("JumpHeight"):Connect(OnJumpHeightChanged)
	Character:GetAttributeChangedSignal("Disabled"):Connect(OnDisabled)
end

local function HandlePlayer(Player: Player)
	if Player.Character then
		HandleCharacter(Player.Character)
	end
	Player.CharacterAdded:Connect(HandleCharacter)
end

for _, Player in ipairs(Players:GetPlayers()) do
	HandlePlayer(Player)
end

Players.PlayerAdded:Connect(HandlePlayer)
