--!strict

-- By Wa1er_God --

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local HelperFunctions = require(ReplicatedStorage.Modules.HelperFunctions);

local Player = Players.LocalPlayer;
local Camera = workspace.CurrentCamera;
local PlayerGui: typeof(ReplicatedStorage.CloneGui) & typeof(game:GetService("StarterGui")) = Player.PlayerGui;

local SpectateGui: typeof(PlayerGui.SpectateGui) = PlayerGui:WaitForChild("SpectateGui");

local MainFrame = SpectateGui.MainFrame;
local LeftButton = MainFrame.LeftButton;
local RightButton = MainFrame.RightButton;

local GameGui: typeof(PlayerGui.GameGui) = PlayerGui:WaitForChild("GameGui");
local TopFrame = GameGui.TopFrame;

local NameLabel = MainFrame.MiddleFrame.NameLabel;

local Client = ReplicatedStorage.Client;
local WaveService = require(Client.WaveService);

local Remotes = ReplicatedStorage.Remotes; 

local InSpectate = false;
local CurrentWave: WaveService.GetWaveSync? = nil;
local PlayerIndex = 1;
local PlayerConnections = {};

local function ChangeName(Player: Player)
	NameLabel.Text = Player.Name;
end

local function ReturnBack()
	if Camera and Player.Character then
		Camera.CameraSubject = Player.Character:FindFirstChildWhichIsA("Humanoid");
	end
	NameLabel.Text = "No Players";
end

local function GetAblePlayer(PlayerIds: {number}, Index: number, Direction: string): Player?
	if Direction == "Left" then
		for i = Index, #PlayerIds, 1 do
			local Id = PlayerIds[i];
			
			if Id then
				local Player = Players:GetPlayerByUserId(Id);

				if Player then
					PlayerIndex = i;
					return Player;
				end
			end
		end
	elseif Direction == "Right" then
		for i = #PlayerIds, Index, -1 do
			local Id = PlayerIds[i];
			
			if Id then
				local Player = Players:GetPlayerByUserId(Id);

				if Player then
					PlayerIndex = i;
					return Player;
				end
			end
		end
	end

	return;
end

local function SpectatePlayer(Player: Player)
	HelperFunctions.DisconnectAll(PlayerConnections);
	Camera.CameraSubject = Player.Character;
	ChangeName(Player);
	
	local Connection = Player.CharacterAdded:Connect(function(Character: Model)
		Camera.CameraSubject = Character;
	end)
	
	local ConnectionA = Player.Destroying:Once(function()
		if CurrentWave then
			local Player = GetAblePlayer(CurrentWave.PlayerIds, PlayerIndex + 1, "Right");

			if Player then
				SpectatePlayer(Player);
				return;
			end
		end
		
		local Data = WaveService.SpectatePlayer("Right");

		if Data then
			CurrentWave = Data;
			PlayerIndex = 1;
			local Player = GetAblePlayer(Data.PlayerIds, PlayerIndex, "Right");

			if Player then
				SpectatePlayer(Player);
				return;
			end
		end
		
		ReturnBack();
	end)
	
	table.insert(PlayerConnections, Connection);
	table.insert(PlayerConnections, ConnectionA);
end

local function OnLeft()
	if CurrentWave then
		local Player = GetAblePlayer(CurrentWave.PlayerIds, PlayerIndex - 1, "Left");

		if Player then
			SpectatePlayer(Player);
			return;
		end
	end

	local Data = WaveService.SpectatePlayer("Left");

	if Data then
		CurrentWave = Data;
		PlayerIndex = #Data;
		local Player = GetAblePlayer(Data.PlayerIds, PlayerIndex, "Left");

		if Player then
			SpectatePlayer(Player);
		end
	end
end

LeftButton.MouseButton1Click:Connect(OnLeft);

local function OnRight()
	if CurrentWave then
		local Player = GetAblePlayer(CurrentWave.PlayerIds, PlayerIndex + 1, "Right");

		if Player then
			SpectatePlayer(Player);
			return true;
		end
	end

	local Data = WaveService.SpectatePlayer("Right");

	if Data then
		CurrentWave = Data;
		PlayerIndex = 1;
		local Player = GetAblePlayer(Data.PlayerIds, PlayerIndex, "Right");

		if Player then
			SpectatePlayer(Player);
			return true;
		end
	end
	
	return false;
end

local Loading = false;

RightButton.MouseButton1Click:Connect(OnRight);

local function StopSpectating()
	HelperFunctions.DisconnectAll(PlayerConnections);
	InSpectate = false;
	MainFrame.Visible = false;
	
	if not WaveService.CurrentWave then
		TopFrame.Visible = false;
	end
	
	ReturnBack();
	
	WaveService.SpectatePlayer("End");
end

SpectateGui.SpectateButton.MouseButton1Click:Connect(function()
	if InSpectate then
		StopSpectating();
	else
		if Loading then
			return;
		end
		
		InSpectate = true;
		
		Loading = true;
		local Data = WaveService.SpectatePlayer("Start");
		
		if Data then
			CurrentWave = Data;
			PlayerIndex = 1;
			local Player = GetAblePlayer(Data.PlayerIds, PlayerIndex, "Right");
			
			if Player then
				SpectatePlayer(Player);
			end
		else
			NameLabel.Text = "No Players";
		end
		
		MainFrame.Visible = true;
		Loading = false;
	end
end)

Player.CharacterRemoving:Connect(function()
	if InSpectate then
		StopSpectating();
	end
end)

WaveService.SpectateConnections.Ended:Connect(function()
	CurrentWave = nil;
	if InSpectate then
		local Success = OnRight();
		
		if not Success then
			ReturnBack();
		end
	end
end)