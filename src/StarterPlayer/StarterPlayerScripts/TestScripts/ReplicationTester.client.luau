--!strict

-- By Wa1er_God --

local Players = game:GetService("Players");

local Player = Players.LocalPlayer;
local Camera = workspace.Camera;

Camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
	local CameraSubject = Camera.CameraSubject;
	
	if CameraSubject:IsA("BasePart") then
		Player.ReplicationFocus = CameraSubject;
	end
end)