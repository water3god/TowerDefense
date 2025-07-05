--!strict

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local Gui = ReplicatedStorage.Gui
local GameFrames = Gui.GameFrames
local DisplayTitle = require(GameFrames.DisplayTitle)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local SafePlayerAdded = require(ServerScriptService.Utility.SafePlayer.SafePlayerAdded)

local GlobalWorkspace = workspace.GlobalWorkspace
local CharacterFolder = GlobalWorkspace.Characters

local function HandleChar(Character: Model)
	for _, Descendant in ipairs(Character:GetDescendants()) do
		if Descendant:IsA("BasePart") then
			Descendant.CollisionGroup = "Character"
		end
	end

	Character.DescendantAdded:Connect(function(Descendant: Instance)
		if Descendant:IsA("BasePart") then
			Descendant.CollisionGroup = "Character"
		end
	end)

	Character.Parent = CharacterFolder
end

SafePlayerAdded:Connect(function(Player: Player)
	if Player.Character then
		HandleChar(Player.Character)
	end
	Player.CharacterAdded:Connect(HandleChar)
end, true)

local function DataAdded(Data: PlayerData.PlayerData)
	return
end

for _, Data in pairs(PlayerData.GetDatas()) do
	DataAdded(Data)
end

PlayerData.DataAdded:Connect(DataAdded)
