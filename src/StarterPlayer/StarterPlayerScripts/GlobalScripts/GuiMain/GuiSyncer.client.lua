--!strict

-- By Wa1er_God --

local EnableGui = true;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");

local Player = Players.LocalPlayer;

local PlayerGui = Player.PlayerGui;
local CloneGui = ReplicatedStorage.CloneGui;

local function Inital()
	for _, Child in ipairs(CloneGui:GetChildren()) do
		local Clone = Child:Clone();
		Clone.Parent = PlayerGui;
	end
end

Inital();


