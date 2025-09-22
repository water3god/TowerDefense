--!strict

-- By Wa1er_God --

-- Services --
--[[
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Selection = game:GetService("Selection")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

if true then
	return
end

if RunService:IsRunning() then
	error("Unit Helper can only be initialized in Studio")
	return
end

if not ReplicatedStorage:FindFirstChild("Shared") or not ReplicatedStorage.Shared:FindFirstChild("IsLobby") then
	error("Not Place File")
	return
end

local IsLobby = require(ReplicatedStorage.Shared.IsLobby)

if IsLobby then
	error("Lobby Place File")
	return
end

local Packages = ReplicatedStorage.Packages
local StudioComponents = require(Packages.studiocomponents)
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)

local e = React.createElement

local Toolbar = plugin:CreateToolbar("Unit Helper")
local InitButton = Toolbar:CreateButton("UnitHelperInitButton", "Initalizes Unit Helper", "", "Initialize")

local UnitClient = require(ReplicatedStorage.Client.GlobalClient.UnitClient)

local App = require(script.App)
local Root = ReactRoblox.createRoot(Instance.new("Folder"))

local Initalized = false

InitButton.Click:Connect(function()
	if not Initalized then
		Initalized = true
		Root:render(ReactRoblox.createPortal(e(App), CoreGui))
	end
end)
]]
