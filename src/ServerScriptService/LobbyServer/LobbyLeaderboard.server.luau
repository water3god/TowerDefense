--!strict

-- By Wa1er_God --

local Tag = "LobbyLeaderboard"

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Packages = ReplicatedStorage.Packages
local ReactRoblox = require(Packages.ReactRoblox)
local React = require(Packages.React)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local LeaderboardFolder = Gui.Leaderboard
local LobbyLeaderboard = require(LeaderboardFolder.LobbyLeaderboard)

for _, SurfaceGui in ipairs(CollectionService:GetTagged(Tag)) do
	local Root = ReactRoblox.createRoot(SurfaceGui)
	Root:render(e(LobbyLeaderboard.Connected, {
		Type = Gui.Name,
	}))
end
