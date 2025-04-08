--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TeleportService = game:GetService("TeleportService");

local GlobalClient = ReplicatedStorage.Client.GlobalClient;
local WaveService = require(GlobalClient.WaveService);

local Modules = ReplicatedStorage.Modules;
local DelayHandler = require(Modules.DelayHandler);
local HelperFunctions = require(Modules.HelperFunctions);

local TPGuiSet = ReplicatedStorage.Remotes.Booth.ClientOnly.TPGuiSet;

local GameEndEvents = ReplicatedStorage.Remotes.Waves.GameEnd;
local OnVote = GameEndEvents.OnVote;
local OnEnd = GameEndEvents.OnEnd;
local Vote = GameEndEvents.Vote;

local Player = Players.LocalPlayer;
local PlayerGui: typeof(ReplicatedStorage.CloneGui) & typeof(game.StarterGui) = Player.PlayerGui;
local GlobalGui: typeof(PlayerGui.GlobalGui) = PlayerGui:WaitForChild("GlobalGui");
local GameGui = GlobalGui.GameGui;

local GameEndFrame = GameGui.GameEndFrame;
local Title = GameEndFrame.Title;
local PlayersLabel = GameEndFrame.Players;
local RestartButton = GameEndFrame.RestartButton;
local ReturnButton = GameEndFrame.ReturnButton;

local Count = 0;

local function UpdateCount()
	PlayersLabel.Text = string.format("%u/%u", Count, #Players:GetPlayers());
end

type OnEndData = {
	VotedCount: number;
};

OnEnd.OnClientEvent:Connect(function(Data: OnEndData)
	Count = Data.VotedCount;
	UpdateCount()
	GameEndFrame.Visible = true;
end)

OnVote.OnClientEvent:Connect(function(VoteCount: number)
	Count = VoteCount;
	UpdateCount();
end)
Players.PlayerAdded:Connect(function()
	UpdateCount();
end)

WaveService.Added:Connect(function()
	GameEndFrame.Visible = false;
end)

RestartButton.MouseButton1Click:Connect(function()
	if DelayHandler(RestartButton, 0.5) then
		Vote:FireServer();
	end
end)

ReturnButton.MouseButton1Click:Connect(function()
	if DelayHandler(ReturnButton, 30) then
		TPGuiSet:Fire({MapName = "Lobby", ImageId = "rbxasseid://1"});
		task.delay(3, function()
			HelperFunctions.SafeTeleport(function()
				return TeleportService:TeleportAsync(6695736136, {Player})
			end, 10);
		end)
	end
end)