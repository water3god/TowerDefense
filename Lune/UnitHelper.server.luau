--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Selection = game:GetService("Selection")

if not ReplicatedStorage:FindFirstChild("Shared") or not ReplicatedStorage.Shared:FindFirstChild("IsLobby") then
	error("Not Place File")
	return
end

local IsLobby = require(ReplicatedStorage.Shared.IsLobby)

if IsLobby then
	error("Lobby Place File")
	return
end

local Toolbar = plugin:CreateToolbar("Unit Helper")
local InitButton = Toolbar:CreateButton("UnitHelperInitButton", "Initalizes Unit Helper", "", "Initialize")

local UnitClient = require(ReplicatedStorage.Client.GlobalClient.UnitClient)

InitButton.Click:Connect(function() end)
